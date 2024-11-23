---
title: "docker 连接宿主机的 MySQL"
date: 2020-06-03 10:15:00 +0800
last_modified_at: 2021-10-17 17:06:16 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "MySQL"]
tags: ["程序人生", "docker", "mysql"]
description: "在实际生产过程中，docker 内的服务有时需要连接宿主机的 MySQL，在这里记录一下踩过的坑。"
---

## docker 连接宿主机的 MySQL

> 本文地址：[https://blog.lucien.ink/archives/505][this]

在实际生产过程中，docker 内的服务有时需要连接宿主机的 MySQL，在这里记录一下踩过的坑。

### 0. 本文环境

| Name | Version |
| --- | --- |
| Docker | `19.03.4, build 9013bf583a` |
| OS | `Debian GNU/Linux 9` |

### 1. 宿主机的 IP

在容器内执行 `ip route` 命令，`default via` 后面跟着的 IP 就是宿主机的 IP。

```bash
root@debian: docker run --rm busybox ip route
default via 172.18.0.1 dev eth0
172.18.0.0/16 dev eth0 scope link  src 172.18.0.2
```

可以看到，此容器的本机 IP 为 `172.18.0.2`，宿主机的 IP 是 `172.18.0.1`。

#### 1.1 docker network 对 IP 的影响

在宿主机中运行 `docker run --rm busybox ip route` 获得的宿主机 IP 为 `172.18.0.1`，在指定了 `network` 的容器内 `ping` 不通。后来发现在不同的 `network` 下，容器的 IP 段是不一样的，在这里复现一下。

```bash
root@debian: docker network create test # 创建新的 network
d5c1f383ee4c397112660b18087c42fe8f3e000ced2949778b4adb4925e6882d
root@debian: docker run --rm --network test busybox ip route
default via 192.168.192.1 dev eth0
192.168.192.0/20 dev eth0 scope link  src 192.168.192.2
```

可以看到，在指定了 `network` 后，IP 段就从 `172.18.0.0/16` 变成了 `192.168.192.0/20`。

#### 1.2 查看 network 的信息

可以通过 `docker network inspect <network name>` 的命令来查看 network 的信息。

其中 Gateway 字段代表宿主机的地址。

```bash
root@debian: docker network inspect test
[
    {
        "Name": "test",
        "Id": "d5c1f383ee4c397112660b18087c42fe8f3e000ced2949778b4adb4925e6882d",
        "Created": "2020-08-25T23:44:15.827765119+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.192.0/20",
                    "Gateway": "192.168.192.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
        },
        "Options": {},
        "Labels": {}
    }
]
```

### 2. 宿主机的防火墙

在能 `ping` 通宿主机的前提下，尝试通过 `mysql -h 192.168.192.1 -u root -p` 命令登录宿主机的 MySQL，结果 Timeout 了。

但是在容器内执行 `curl 192.168.192.1` 是有 `response` 的，证明是宿主机的 `3306` 端口没有放开，放开 `3306` 端口即可。

> 一般云服务器厂商自身还有一个防火墙，只要云服务器控制面板里的防火墙不放开 `3306` 端口的话，外界依然访问不了服务器的 `3306` 端口，所以可以大胆在服务器内放开 `3306` 端口，不必担心安全问题。

### 3. MySQL 的白名单

解决了防火墙的问题之后，在容器内再次尝试通过 `mysql -h 192.168.192.1 -u root -p` 连接宿主机的 MySQL，收到了来自 MySQL 的报错 `Host '192.168.192.2' is not allowed to connect to this MySQL server`，直接在 MySQL 中将 `192.168.192.2` 加入白名单即可。

如果是多个容器都需要连接宿主机的 MySQL 的话，可以参考 [MySQL IP 白名单使用通配符][ref] 将 B 类子网 `192.168.0.0` 全都加入白名单，这样一来就一劳永逸了。

[this]: https://blog.lucien.ink/archives/505/
[ref]: https://blog.lucien.ink/archives/503/
