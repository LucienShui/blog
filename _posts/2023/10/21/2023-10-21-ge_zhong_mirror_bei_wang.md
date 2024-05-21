---
title: "各种 mirror 备忘"
date: 2023-10-21 17:54:20 +0800
last_modified_at: 2023-10-21 17:54:20 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux"]
description: "最近配环境比较多，存在这里备忘"
---

> 本文地址：[blog.lucien.ink/archives/544][this]

## Pip

```shell
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## Conda

```shell
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
```

## brew

过于复杂，参考 [Homebrew / Linuxbrew 镜像使用帮助][homebrew] 与 [Homebrew-bottles 镜像使用帮助][homebrew-bottles]。

## APT

### Debian

[Debian 软件仓库镜像使用帮助][debian]

### Ubuntu

[Ubuntu 软件仓库镜像使用帮助][ubuntu]

## docker

```shell
export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
wget -O- https://get.docker.com/ | bash
```

## Proxmox

[Proxmox 软件仓库镜像使用帮助][proxmox]

[this]: https://blog.lucien.ink/archives/544/
[homebrew]: https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
[homebrew-bottles]: https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/
[debian]: https://mirrors.tuna.tsinghua.edu.cn/help/debian/
[ubuntu]: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
[proxmox]: https://mirrors.tuna.tsinghua.edu.cn/help/proxmox/