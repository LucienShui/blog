---
title: "使用 SSH 进行端口转发"
date: 2019-11-16 20:57:00 +0800
last_modified_at: 2019-11-16 20:59:35 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["ssh", "端口转发"]
description: "假定 client 是本地主机，remote_0 是远程主机。由于种种原因，这两台主机之间无法连通。但是，另外还有一台 remote_1，可以同时连通前面两台主机。因此，很自然的想法就是，通过 remote_1，使得 client 可以访问 remote_0。"
---

## 使用 SSH 进行端口转发

本文地址：https://blog.lucien.ink/archives/484/

### 0. 背景

有时，在软件开发、测试的时候需要连接数据库，于是就会在数据库配置文件中填入测试服务器的地址等信息，一不小心就会连同测试服务器的信息一起上传至 GitHub。

为了避免这种情况，我更青睐于将测试服务器的地址伪装起来，通过修改 `/etc/hosts` 来用一个不存在的域名指向测试服务器。

但在 GitHub Actions 里并不能修改 `hosts` 文件，所以我在想能不能在本地搭建一个 MySQL 服务器，可这样无论如何都不是一个非常好的办法。

好在还有一种方法，能通过 SSH 使得本机和服务器之间建立一个隧道，访问本机的时候就等价于访问服务器，这样一来可以直接通过访问本机的某个端口来访问远端的端口啦。

### 1. 命令

命令格式为：

```bash
ssh -L <local port>:<remote_0 host>:<remote_0 port> <remote_1 username>@<remote_1 host>
```

假定 client 是本地主机，remote_0 是远程主机。由于种种原因，这两台主机之间无法连通。但是，另外还有一台 remote_1，可以同时连通前面两台主机。因此，很自然的想法就是，通过 remote_1，使得 client 可以访问 remote_0。

执行完上面的命令之后，访问 `localhost:<local port>` 就等价于访问 `<remote_0 host>:<remote_0 port>`。

假如我们要用本机的 `3306` 端口代理 `192.168.123.123` 的 `3306` 端口，执行命令：`ssh -L 3306:192.168.123.123:3306 username@192.168.123.123` 即可。
