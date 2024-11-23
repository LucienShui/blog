---
title: "DNSPod 查看域名的 domain_id 和 record_id"
date: 2019-01-07 09:59:04 +0800
last_modified_at: 2019-01-07 09:59:04 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

## DNSPod 查看域名的 domain_id 和 record_id

### 获取 `login_token`
[DNSPOD / 用户中心 / 安全设置 / API Token](https://www.dnspod.cn/console/user/security)

使用英文 `,` 将 `ID` 和 `Token` 连接起来即为下文提到的参数 `your_login_token`。

举个例子，比如你的 `ID` 是 `12345` ，`Token` 是 `abcd` ，那么你的 `your_login_token` 就是 `12345,abcd`。

随后请求一下官方提供的 `api` 就可以了。

### 获取 `domain_id`

`curl 'https://dnsapi.cn/Domain.List' -d 'login_token=<your_login_token>&format=json'`

根据响应的 `json` 中的 `domains` 得到域名对应的 `domain_id`。

### 获取 `record_id`

`curl 'https://dnsapi.cn/Record.List' -d 'login_token=<your_login_token>&format=json&domain_id=<your_domain_id>'`

根据响应 `json` 中的 `records` 得到记录对应的 `record_id`。

### 获取 `sub_domain`

`sub_domain` 是你要进行动态解析的子域名，其实就是你自己在 [控制台](https://www.dnspod.cn/console/dns) 设定的 `主机记录`，详见获取 `record_id` 时从官网得到的 `json` 中的 `name` 参数。
