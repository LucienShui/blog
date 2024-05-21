---
title: "MySQL IP 白名单使用通配符"
date: 2020-05-31 15:59:00 +0800
last_modified_at: 2020-05-31 16:00:19 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "MySQL"]
tags: ["程序人生", "mysql"]
description: "在设置 MySQL 的 IP 白名单要指定子网时，应使用子网掩码，而不是通配符。"
---

## MySQL IP 白名单使用通配符

> 本文地址：[https://blog.lucien.ink/archives/503][this]

今天在操作中想要让 MySQL 将形如 `192.168.*.*` 这样的 IP 加入白名单。

当我使用 `192.168.%.%` 时，MySQL 报错 `Error: 192.168.%.% is not a valid remote host`，而如果使用 `192.168.0.1` 之类确定的 IP 则不会报错。

查阅了一番，正确的写法应该是加上子网掩码 `192.168.0.0/255.255.0.0`，这样就可以允许从整个 B 类子网访问。

[this]: https://blog.lucien.ink/archives/503/