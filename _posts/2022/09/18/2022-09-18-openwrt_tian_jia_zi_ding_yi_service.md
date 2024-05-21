---
title: "OpenWrt 添加自定义 Service"
date: 2022-09-18 14:16:43 +0800
last_modified_at: 2022-09-18 14:16:43 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "软路由"]
tags: ["软路由"]
---

## OpenWrt 添加自定义 Service

> 本文地址：[blog.lucien.ink/archives/530][this]

```shell
## !/bin/sh /etc/rc.common
## "new" style init script
## Look at /lib/functions/service.sh on a running system for explanations of what other SERVICE_
## options you can use, and when you might want them.

START=80
APP=node_exporter
SERVICE_WRITE_PID=1
SERVICE_DAEMONIZE=1

start() {
        service_start /etc/usr/local/node_exporter/${APP}
}

stop() {
        service_stop /etc/usr/local/node_exporter/${APP}
}
```

[this]: https://blog.lucien.ink/archives/530/
