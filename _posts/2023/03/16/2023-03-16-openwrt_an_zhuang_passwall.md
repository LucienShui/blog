---
title: "OpenWRT 安装 PassWall"
date: 2023-03-16 20:12:00 +0800
last_modified_at: 2023-04-02 20:14:02 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "软路由"]
tags: ["软路由"]
---

> 本文地址：[blog.lucien.ink/archives/537][this]

[this]: https://blog.lucien.ink/archives/537/

访问 [OpenWRT Download Server][packges]，找到自己的架构，以 `x86_64` 为例：
1. 在 `/etc/opkg/customfeeds.conf` 中添加 `src/gz openwrt_kiddin9 https://op.supes.top/packages/x86_64`
2. 注释或删掉 `/etc/opkg.conf` 中的 `option check_signature`
3. 执行 `opkg update`
4. 执行 `opkg install luci-app-passwall`

[packages]: https://op.supes.top/packages/

