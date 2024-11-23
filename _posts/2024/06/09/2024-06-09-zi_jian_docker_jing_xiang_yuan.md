---
title: "自建 Docker 镜像源"
date: 2024-06-09 22:12:47 +0800
last_modified_at: 2024-06-09 22:12:47 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "docker"]
tags: ["docker", "mirror"]
description: "本文介绍了在 Docker Hub 被禁后，通过 Cloudflare 和自建 Docker Registry 两种方法加速和恢复访问 Docker Hub 的镜像。包括在 Cloudflare 上创建 Worker 代理请求和配置自定义域名，以及在本地机器上搭建 Docker Registry 并设置上游源。"
---

> 本文地址：[blog.lucien.ink/archives/547][this]
> 本文主要参考自：[自建Docker 镜像/源加速的方法][nadph]

## 1. 简介

最近 Docker Hub 被禁一事引起了不小的波动，在这里简单讲下在这之后应该如何访问公开的 Docker Hub。

## 2. Cloudflare

### 2.1 搭建

搭建的前提是有一个在 Cloudflare 中被管理的域名，此处不展开介绍，在这里假设这个域名是 `your-domain.com`。

#### 2.1.1 创建 Worker

点击页面左侧的 `Workers & Pages`，创建一个 Worker，填入以下内容。请注意将 `your-domain.com` 替换为你自己的域名。

```js
'use strict'

const hub_host = 'registry-1.docker.io'
const auth_url = 'https://auth.docker.io'
const workers_url = 'https://your-domain.com'
/**
 * static files (404.html, sw.js, conf.js)
 */

/** @type {RequestInit} */
const PREFLIGHT_INIT = {
    status: 204,
    headers: new Headers({
        'access-control-allow-origin': '*',
        'access-control-allow-methods': 'GET,POST,PUT,PATCH,TRACE,DELETE,HEAD,OPTIONS',
        'access-control-max-age': '1728000',
    }),
}

/**
 * @param {any} body
 * @param {number} status
 * @param {Object<string, string>} headers
 */
function makeRes(body, status = 200, headers = {}) {
    headers['access-control-allow-origin'] = '*'
    return new Response(body, {status, headers})
}


/**
 * @param {string} urlStr
 */
function newUrl(urlStr) {
    try {
        return new URL(urlStr)
    } catch (err) {
        return null
    }
}


addEventListener('fetch', e => {
    const ret = fetchHandler(e)
        .catch(err => makeRes('cfworker error:\n' + err.stack, 502))
    e.respondWith(ret)
})


/**
 * @param {FetchEvent} e
 */
async function fetchHandler(e) {
    const getReqHeader = (key) => e.request.headers.get(key);
    let url = new URL(e.request.url);
    if (url.pathname === '/token') {
        let token_parameter = {
            headers: {
                'Host': 'auth.docker.io',
                'User-Agent': getReqHeader("User-Agent"),
                'Accept': getReqHeader("Accept"),
                'Accept-Language': getReqHeader("Accept-Language"),
                'Accept-Encoding': getReqHeader("Accept-Encoding"),
                'Connection': 'keep-alive',
                'Cache-Control': 'max-age=0'
            }
        };
        let token_url = auth_url + url.pathname + url.search
        return fetch(new Request(token_url, e.request), token_parameter)
    }

    url.hostname = hub_host;

    let parameter = {
        headers: {
            'Host': hub_host,
            'User-Agent': getReqHeader("User-Agent"),
            'Accept': getReqHeader("Accept"),
            'Accept-Language': getReqHeader("Accept-Language"),
            'Accept-Encoding': getReqHeader("Accept-Encoding"),
            'Connection': 'keep-alive',
            'Cache-Control': 'max-age=0'
        },
        cacheTtl: 3600
    };

    if (e.request.headers.has("Authorization")) {
        parameter.headers.Authorization = getReqHeader("Authorization");
    }

    let original_response = await fetch(new Request(url, e.request), parameter)
    let original_response_clone = original_response.clone();
    let original_text = original_response_clone.body;
    let response_headers = original_response.headers;
    let new_response_headers = new Headers(response_headers);
    let status = original_response.status;

    if (new_response_headers.get("Www-Authenticate")) {
        let auth = new_response_headers.get("Www-Authenticate");
        let re = new RegExp(auth_url, 'g');
        new_response_headers.set("Www-Authenticate", response_headers.get("Www-Authenticate").replace(re, workers_url));
    }

    if (new_response_headers.get("Location")) {
        return httpHandler(e.request, new_response_headers.get("Location"))
    }

    return new Response(original_text, {
        status,
        headers: new_response_headers
    })
}

/**
 * @param {Request} req
 * @param {string} pathname
 */
function httpHandler(req, pathname) {
    const reqHdrRaw = req.headers
    // preflight
    if (req.method === 'OPTIONS' &&
        reqHdrRaw.has('access-control-request-headers')
    ) {
        return new Response(null, PREFLIGHT_INIT)
    }
    let rawLen = ''
    const reqHdrNew = new Headers(reqHdrRaw)
    const refer = reqHdrNew.get('referer')
    let urlStr = pathname
    const urlObj = newUrl(urlStr)
    /** @type {RequestInit} */
    const reqInit = {
        method: req.method,
        headers: reqHdrNew,
        redirect: 'follow',
        body: req.body
    }
    return proxy(urlObj, reqInit, rawLen, 0)
}


/**
 *
 * @param {URL} urlObj
 * @param {RequestInit} reqInit
 */
async function proxy(urlObj, reqInit, rawLen) {
    const res = await fetch(urlObj.href, reqInit)
    const resHdrOld = res.headers
    const resHdrNew = new Headers(resHdrOld)

    // verify
    if (rawLen) {
        const newLen = resHdrOld.get('content-length') || ''
        const badLen = (rawLen !== newLen)

        if (badLen) {
            return makeRes(res.body, 400, {
                '--error': `bad len: ${newLen}, except: ${rawLen}`,
                'access-control-expose-headers': '--error',
            })
        }
    }
    const status = res.status
    resHdrNew.set('access-control-expose-headers', '*')
    resHdrNew.set('access-control-allow-origin', '*')
    resHdrNew.set('Cache-Control', 'max-age=1500')

    resHdrNew.delete('content-security-policy')
    resHdrNew.delete('content-security-policy-report-only')
    resHdrNew.delete('clear-site-data')

    return new Response(res.body, {
        status,
        headers: resHdrNew
    })
}
```

#### 2.1.2 添加域名

进入创建好的 Worker 的配置页面，在 `Settings` Tab 中选择 `Triggers`，点击 `Add Custom Domain`，添加 `your-domain.com`。

### 2.2 使用

#### 2.2.1 配置为镜像

在 `/etc/docker/daemon.json` 加入以下内容：

```json
{
  "registry-mirrors": [
    "https://your-domain.com"
  ]
}
```

然后重启 docker：`systemctl restart docker`

随后就能像往常一样直接 `pull` 了：

```shell
docker pull busybox:latest
docker pull mysql/mysql-server:latest
```

#### 2.2.2 直接使用

```shell
docker pull your-domain.com/library/busybox:latest
docker pull your-domain.com/mysql/mysql-server:latest
```

## 3. 使用 registry

> 

首先你需要一个能正常访问 Docker Hub 的机器，并在那台机器上正常安装 Docker。

### 3.1 搭建

找一个文件夹，编辑 `compose.yml` 文件，填入以下内容：

```yaml
services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    environment:
      REGISTRY_PROXY_REMOTEURL: https://registry-1.docker.io  # 上游源
      REGISTRY_STORAGE_CACHE_BLOBDESCRIPTOR: inmemory # 内存缓存，去掉本行以直接使用硬盘
    volumes:
      - ./data:/var/lib/registry
```

然后执行 `docker compose up -d` 即可。

### 3.2 使用

使用方法同上。

[this]: https://blog.lucien.ink/archives/547/
[nadph]: https://www.nadph.net/2024/06/docker-registry-build/
[registry]: https://hub.docker.com/_/registry
