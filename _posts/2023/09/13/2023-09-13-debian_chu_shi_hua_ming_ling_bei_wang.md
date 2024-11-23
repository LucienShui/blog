---
title: "Debian 初始化命令备忘"
date: 2023-09-13 01:21:21 +0800
last_modified_at: 2023-09-13 01:21:21 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "运维"]
tags: ["linux"]
description: "一些 Debian 初始化过程中命令的备忘"
---

> 本文地址：[blog.lucien.ink/archives/541][this]

以 Debian 11 为例，主要用于备忘。

```plain
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
```

```shell
apt update && apt install vim curl wget git cifs-utils -y

export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
curl -fsSL https://get.docker.com/ | sh

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

hostnamectl set-hostname your_host
hostname your_host
/etc/hosts

timedatectl set-timezone Asia/Shanghai

groupmod -g 3000 foo  # 添加用户组
adduser  # 添加用户
usermod -aG group_name user_name  # 将用户添加至组
```

[this]: https://blog.lucien.ink/archives/541/
