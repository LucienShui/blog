---
title: "Docker 打开 TCP 端口"
date: 2019-05-23 23:15:00 +0800
last_modified_at: 2019-07-24 23:25:07 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "docker"]
tags: ["其它", "程序人生", "docker"]
---

## Docker 打开 TCP 端口

原文链接：https://www.lucien.ink/archives/440/

### 1. 开启 TCP 端口

#### 1.1 创建目录/文件

```bash
mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/tcp.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375
EOF
```

#### 1.2 重启 docker 进程

```bash
systemctl daemon-reload
systemctl restart docker
```

#### 1.4 查看端口是否打开

```bash
ps aux | grep dockerd | grep -v grep
```

### 2. 关闭 TCP 端口

```
rm -f /etc/systemd/system/docker.service.d/tcp.conf
systemctl daemon-reload
systemctl restart docker
ps aux | grep dockerd | grep -v grep
```