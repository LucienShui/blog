---
title: "Debian 下 CUDA 生产环境配置笔记"
date: 2022-12-29 16:11:00 +0800
last_modified_at: 2022-12-29 17:30:49 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "docker"]
description: "最近整了张 Tesla P4，由于是半高卡，索性就直接将其塞进了我的 NAS 里，试图将原来用 onnx 跑在 CPU 上的模型迁移至 GPU 上，遇到了些许问题，在此记录下。"
---

最近整了张 Tesla P4，由于是半高卡，索性就直接将其塞进了我的 NAS 里，试图将原来用 onnx 跑在 CPU 上的模型迁移至 GPU 上，遇到了些许问题，在此记录下。

> 本文地址：[blog.lucien.ink/archives/534][this]

## 0. 前言

由于是用于生产环境，我的所有服务（包含本次要迁移的模型）都是容器化运行的，所以我这次也是考虑用 NVIDIA Docker 2 来进行生产部署。

我的操作系统是 Debian 11 x64，运行在 i3-12100 上。

对本篇文章的读者，我在这里假定你已装好 Docker，若没有，可以参考 [Docker 入门手记][docker_installation]。

## 1. 环境部署

### 1.1 下载驱动

前往 [Official Drivers | NVIDIA][download_driver] 下载 Tesla P4 的驱动，CUDA Toolkit 记得不要选 `Any`，否则会给你一个十分旧的驱动，会影响 nvidia docker (CUDA >= 11.6) 的安装。

由于实际运行是在 docker 内，所以在稳定的前提下，宿主机的 CUDA 版本是越新越好，在这里我选择 CUDA 12.0 版本。

### 1.2 系统准备

#### 1.2.1 禁用 Nouveau

这一步是必要的，因为 Nouveau 也是 NVIDIA GPU 的驱动程序，参考 [nouveau - 維基百科][nouveau_wiki]。

1. 创建文件

```bash
touch /etc/modprobe.d/blacklist-nouveau.conf
```

2. 在文件中写入以下内容：

```conf
blacklist nouveau
options nouveau modeset=0
```

3. 重新生成 kernel initramfs

```bash
update-initramfs -u
```

4. 重启

```bash
reboot
```

#### 1.2.2 安装编译环境

> 参考 [Nvidia unable to find kernel source tree][debian_forum]

```bash
apt install linux-headers-`uname -r` build-essential
```

### 1.3 安装驱动

直接 `chmod +x` 然后运行驱动安装程序即可，不赘述。

### 1.4 安装 NVIDIA Docker

据我观察，NVIDIA Docker 2 类似是 Docker 的一个插件，让原生的 Docker 可以调用 NVIDIA Driver。

#### 1.4.1 添加源

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

#### 1.4.2 安装

```bash
apt update
apt install -y nvidia-docker2
systemctl restart docker
```

#### 1.4.3 测试

```bash
docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

如果能看到 `nvidia-smi` 的内容，则代表安装成功了。

## 3. 参考文档

+ [Installation Guide - NVIDIA Cloud Native Technologies][nvidia_doc]

[this]: https://blog.lucien.ink/archives/534/
[download_driver]: https://www.nvidia.com/download/index.aspx
[nouveau_wiki]: https://zh.wikipedia.org/zh-tw/Nouveau
[disable_nouveau]: https://askubuntu.com/questions/841876/how-to-disable-nouveau-kernel-driver
[debian_forum]: https://forums.debian.net/viewtopic.php?p=433044
[nvidia_doc]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#install-guide
[docker_installation]: https://blog.lucien.ink/archives/301/