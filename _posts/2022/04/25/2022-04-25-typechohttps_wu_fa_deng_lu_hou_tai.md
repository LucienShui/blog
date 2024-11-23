---
title: "Typecho HTTPS 无法登陆后台"
date: 2022-04-25 00:25:19 +0800
last_modified_at: 2022-04-25 00:25:19 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站"]
description: "因为百度云加速的 HTTPS 证书各种难用，最近将博客的 CDN 解决方案整体迁移至 Cloud Flare，慢一点就慢一点吧。随即我便发现一个问题，Typecho 的后台登录不上去了，具体的表现是登陆跳转之后，仍然停留在登录界面。"
---

## Typecho HTTPS 无法登陆后台

> 本文地址：[blog.lucien.ink/archives/523][this]

### 背景

因为百度云加速的 HTTPS 证书各种难用，最近将博客的 CDN 解决方案整体迁移至 Cloud Flare，慢一点就慢一点吧。

加上宝塔的 SSL 续签从某一版本之后各种鬼畜，为了方便，我就直接选择了半程加密，即 `[用户] -- HTTPS --> [Cloud Flare] -- HTTP --> [Server]`。

随即我便发现一个问题，Typecho 的后台登录不上去了，具体的表现是登陆跳转之后，仍然停留在登录界面。

### 解决方案

在 [GitHub][github] 上搜到了对应的解决方案，编辑 Typecho 站点根目录下的文件 `config.inc.php`，在最后添加一行 `define('__TYPECHO_SECURE__',true);` 即可。

问题的成因我猜测是因为用户与浏览器之间是 HTTPS 交互，但实际上 PHP 接收到的是来自 Cloud Flare 的 HTTP 交互，所以 PHP 使用了 HTTP 进行响应，结合 Typecho 的一些特性形成了这个问题。

[this]: https://blog.lucien.ink/archives/523/
[github]: https://github.com/typecho/typecho/issues/797#issuecomment-701284604
