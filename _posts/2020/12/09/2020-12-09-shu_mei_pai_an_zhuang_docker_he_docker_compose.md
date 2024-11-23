---
title: "树莓派安装 docker 和 docker-compose"
date: 2020-12-09 20:48:00 +0800
last_modified_at: 2021-09-18 11:06:50 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "树莓派"]
tags: ["树莓派"]
description: "因为总是频繁地初始化树莓派，所以把安装 docker 的过程也记录下来。"
---

## 树莓派安装 docker 和 docker-compose

> 本文地址：[blog.lucien.ink/archives/518][this]

因为总是频繁地初始化树莓派，所以把安装 docker 的过程也记录下来。

### 1. 安装 docker

因为某些不可抗因素，强烈建议在安装 docker 之前先重启一下系统。

```bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 2. 安装 docker-compose

为了不破坏系统的 python interpreter，这里选择将 docker-compose 装在 venv 里。

当然了，对此不介意的小伙伴可以跳过 venv 的安装，直接看 2.2 节。

#### 2.1 创建并使用 venv

##### 2.1.1 安装 venv 依赖

```bash
apt install python3-venv -y
```

##### 2.1.2 创建 venv

执行以下代码，会在 `/venv` 处创建一个 Python 3 的虚拟环境。

```bash
python3 -m venv /venv
```

##### 2.1.3 将 venv 作为默认解释器

把以下代码追加到 `~/.bashrc` 的末尾。

```bash
source /venv/bin/activate
```

下次登录将会生效。

#### 2.2 安装

可参考 [pip3 换源][pip-mirror] 令 pip 使用国内镜像。

```bash
pip install docker-compose
```

[this]: https://blog.lucien.ink/archives/518/
[pip-mirror]: https://blog.lucien.ink/archives/429/