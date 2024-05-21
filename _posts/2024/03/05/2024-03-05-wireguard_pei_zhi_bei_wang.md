---
title: "WireGuard 配置备忘"
date: 2024-03-05 00:23:00 +0800
last_modified_at: 2024-03-05 00:27:47 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux", "vpn"]
description: "最近学会了用 WireGuard 来打洞，在此记录一下以备忘。"
---

> 本文地址：[blog.lucien.ink/archives/545][this]

最近学会了用 WireGuard 来打洞，在此记录一下以备忘。

### 概述

```shell
cd /etc/wireguard
wg genkey > private && chmod 600 private
wg pubkey < private > public && chmod 600 public
```

将配置文件写在 `/etc/wireguard/${name}.conf` 中，可全局通过 `wg-quick [up/down] ${name}` 来进行启停，配置文档详见：[Quick Start - WireGuard][doc]。

如果需要作为常驻服务，更推荐使用 `systemctl [enable/disable/start/stop] wg-quick@${name}.service` 来进行管理。

### 懒人脚本

在服务端，我们执行：

```shell
## !/usr/bin/env sh
CONFIG_NAME="wg"

SERVER_PRIVATE_KEY="$(cat private)"
SERVER_INTERNAL_IP="192.168.1.2"
SERVER_PORT="10086"

CLIENT_PUBLIC_KEY="this_is_a_public_key_copy_from_your_client"
CLIENT_INTERNAL_IP="192.168.1.3"

cat << EOF > "/etc/wireguard/${CONFIG_NAME}.conf"
[Interface]
PrivateKey = ${SERVER_PRIVATE_KEY}
Address = ${SERVER_INTERNAL_IP}/24
ListenPort = ${SERVER_PORT}

[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = ${CLIENT_INTERNAL_IP}/24
PersistentKeepalive = 25
EOF

systemctl enable "wg-quick@${CONFIG_NAME}.service"
systemctl start "wg-quick@${CONFIG_NAME}.service"
```

在客户端，我们执行：

```shell
## !/usr/bin/env sh
CONFIG_NAME="wg"

SERVER_PUBLIC_IP="server_public_ip_or_domain"
SERVER_PORT="10086"
SERVER_PUBLIC_KEY="this_is_a_public_key_copy_from_your_server"
SERVER_INTERNAL_IP="192.168.1.2"

CLIENT_PRIVATE_KEY="$(cat private)"
CLIENT_INTERNAL_IP="192.168.1.3"

cat << EOF > "/etc/wireguard/${CONFIG_NAME}.conf"
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = ${CLIENT_INTERNAL_IP}/24

## aliyun
[Peer]
Endpoint = ${SERVER_PUBLIC_IP}:${SERVER_PORT}
PublicKey = ${SERVER_PUBLIC_KEY}
AllowedIPs = ${SERVER_INTERNAL_IP}/24
PersistentKeepalive = 25
EOF

systemctl enable "wg-quick@${CONFIG_NAME}.service"
systemctl start "wg-quick@${CONFIG_NAME}.service"
```

### Reference

+ [Quick Start - WireGuard][doc]
+ [WireGuard 教程：WireGuard 的搭建使用与配置详解][reference]

[this]: https://blog.lucien.ink/archives/545/
[reference]: https://icloudnative.io/posts/wireguard-docs-practice/
[doc]: https://www.wireguard.com/quickstart/