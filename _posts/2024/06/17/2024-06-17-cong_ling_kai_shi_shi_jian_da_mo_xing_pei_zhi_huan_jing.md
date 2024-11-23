---
title: "从零开始实践大模型 - 配置环境"
date: 2024-06-17 14:45:00 +0800
last_modified_at: 2024-11-23 22:38:12 +0800
math: true
render_with_liquid: false
categories: ["机器学习"]
tags: ["linux", "机器学习", "llm"]
description: "本文详细介绍了在 Linux 系统上配置深度学习环境的步骤，包括配置 SSH 登录、安装显卡驱动及禁用 Nouveau、安装并配置 Docker 以支持 GPU 以及切换至普通用户并安装 Miniconda。此外，文章还提供了如何配置 conda 和 PyPI 镜像的方法，并给出了若干实用建议，以避免常见问题和潜在风险，提高配置效率和安全性。"
---

> 本文地址：[blog.lucien.ink/archives/549][this]

本文将介绍在面向深度学习时，推荐的环境配置以及一些使用 Linux 的习惯。

> 本文的部分内容与 [Debian 下 CUDA 生产环境配置笔记][debian_cuda] 有所重叠，但也有些许的不一样，在正文中不额外注明。

## 前言

本文将主要分 4 部分：

1. 配置 SSH 登陆
2. 安装显卡驱动
3. 安装 Docker 并配置“Docker 显卡驱动”
4. 切换至普通用户并安装 miniconda

## 配置 SSH 登陆

在安装完系统并重启之后，首先看到的是一个登陆界面，在这里输入我们在安装阶段设定好的 root 用户及密码即可。请注意，在输入密码的时候，是看不见自己输了什么、输了几个字符的。

### 配置用户登陆

登陆进 root 之后，在这里我们先什么都不做，先配置 root 用户的 ssh 登陆权限。在大部分的教程中都会直接在 `/etc/ssh/sshd_config` 中添加一行 `PermitRootLogin yes`，在这里笔者是及其不推荐的。

对于 root 用户来说，推荐的方式是密钥登陆，在本地用 `ssh-keygen` 生成一个公私钥对，将本地生成的 `~/.ssh/id_rsa.pub` 拷贝至服务器的 `~/.ssh/authorized_keys` 中（如果服务器中提示 `~/.ssh` 不存在则执行 `mkdir ~/.ssh` 创建一个就好）。

在这里给出简单的命令：

```shell
mkdir -p ~/.ssh
echo 'content of your id_rsa.pub' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

有些小伙伴会遇到如何把本地的 `~/.ssh/id_rsa.pub` 弄到服务器中的问题，在这里提供 3 个解决方案：

1. 先临时打开 `PermitRootLogin yes`，用 ssh 拷过去后再关掉
2. 本地在 `~/.ssh` 目录下用 `python3 -m http.server 3000` 起一个 HTTP 文件服务，然后去服务器上执行 `wget`
3. 使用 [PasteMe][pasteme] 来传输，在这里不赘述

## 基础软件

在这里使用 [TUNA 的 Debian 软件源][tuna_debian] 作为 APT mirror：

```shell
cat << EOF > /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
apt update  # 更新索引
apt install curl wget screen git -y  # 常用软件
```

## 安装显卡驱动

### 软件依赖

```shell
apt update
apt install linux-headers-`uname -r` build-essential  # CUDA 驱动的依赖
```

### 禁用 Nouveau

这一步是必要的，因为 Nouveau 也是 NVIDIA GPU 的驱动程序，参考 [nouveau - 维基百科][nouveau_wiki]。

```shell
cat << EOF > /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF
update-initramfs -u
reboot
```

### 下载驱动

前往 [Official Drivers | NVIDIA][download_driver] 下载显卡驱动，请注意，CUDA Toolkit 不要选 `Any`，否则会获得一个十分旧的驱动，会影响 nvidia docker (CUDA >= 11.6) 的安装。

对于大部分服务器来说，操作系统选 `Linux 64-bit`，语言推荐选 `English (US)`。CUDA Toolkit 笔者在这里选择 `12.4` 版本，得到的下载链接为：[NVIDIA-Linux-x86_64-550.90.07.run][driver_link]，下载到服务器上即可。

> 在这里我额外测试了一下，对于 `Linux 64-bit` 来说，不论是消费卡（RTX 4090、RTX 3090），还是面向数据中心的卡（H100、A100、V100、P4），驱动是一模一样的。

```shell
wget 'https://us.download.nvidia.com/tesla/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run'
```

### 安装驱动

```shell
chmod +x NVIDIA-Linux-x86_64-550.90.07.run
./NVIDIA-Linux-x86_64-550.90.07.run -s --no-questions --accept-license --disable-nouveau --no-drm
```

在这之后，执行 `nvidia-smi -L` 应该能看到如下内容：

```shell
$ nvidia-smi -L
GPU 0: Tesla P4 (UUID: GPU-***)
GPU 1: Tesla P4 (UUID: GPU-***)
```

### 显卡常驻

> [nvidia-persistenced 常驻][persistence_mode_blog]

默认情况下，`nvidia-smi` 执行起来会很慢，它的等待时长会随着显卡数量的增加而增加。这是因为常驻模式（Persistence Mode）没有打开，对于服务器来说，强烈建议打开这一选项。

可以通过添加一个 启动项来保持常驻模式打开：

```
cat <<EOF >> /etc/systemd/system/nvidia-persistenced.service
[Unit]
Description=NVIDIA Persistence Daemon
Before=docker.service
Wants=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/nvidia-persistenced
ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start nvidia-persistenced
systemctl enable nvidia-persistenced
```

可以通过 `nvidia-smi -q -i 0 | grep Persistence` 来检查某张显卡该模式的状态。

### 安装 NVSwtich 驱动

> 如果读者使用的不是 SXM 的卡，请跳过这一步，如果不明白这里是在说什么，也可以先跳过

对于 `H100 SXM`、`A100 SXM` 等拥有 `NVSwitch` 的整机来说，需要额外安装 `nvidia-fabricmanager` 来启用对 NVSwitch 的支持。

前往 [Index of cuda][debian_12_nv_fabric] 搜索关键词 `nvidia-fabricmanager` 找到对应版本进行下载。

```shell
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/nvidia-fabricmanager-550_550.90.07-1_amd64.deb
dpkg -i nvidia-fabricmanager-550_550.90.07-1_amd64.deb
systemctl start nvidia-fabricmanager.service
systemctl enable nvidia-fabricmanager.service
```

请注意，这里的 `nvidia-fabricmanager` 需要与 CUDA Driver 版本匹配。

通过执行 `nvidia-smi -q -i 0 | grep -i -A 2 Fabric` 来验证 `nvidia-fabricmanager` 是否安装成功，看到 `Success` 代表成功。（参考资料：[fabric-manager-user-guide.pdf][fabric_manager_user_guide]，第 11 页）

```shell
$ nvidia-smi -q -i 0 | grep -i -A 2 Fabric
    Fabric
        State                             : Completed
        Status                            : Success
```

#### 特殊情况处理

笔者曾经遇到过下载的 CUDA 驱动版本并未被 APT 中的 `nvidia-fabricmanager` 支持的情况，比如通过执行 `apt-cache madison nvidia-fabricmanager-550` 可以发现，`nvidia-fabricmanager-550` 只支持 `550.90.07-1`、`550.54.15-1`、`550.54.14-1` 三个版本，这种时候可通过执行 `./NVIDIA-Linux-x86_64-550.90.07.run --uninstall` 来卸载 CUDA 驱动，然后重新下载支持的驱动版本。

```shell
$ apt-cache madison nvidia-fabricmanager-550
nvidia-fabricmanager-550 | 550.90.07-1 | https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64  Packages
nvidia-fabricmanager-550 | 550.54.15-1 | https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64  Packages
nvidia-fabricmanager-550 | 550.54.14-1 | https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64  Packages
```

## 安装 Docker

> [Docker CE 软件仓库][docker_tuna]

```shell
export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
wget -O- https://get.docker.com/ | sh
```

### 令 Docker 能够调用显卡

> [Installing the NVIDIA Container Toolkit][nv_container_toolkit]

```shell
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt update
apt install -y nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker  # 这一步会修改 /etc/docker/daemon.json
systemctl restart docker
```

测试：

> 如果网络不通的话，在镜像名前面添加 `hub.uuuadc.top` 以使用代理：`hub.uuuadc.top/nvidia/cuda:11.6.2-base-ubuntu20.04`

```shell
docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

如果能看到 `nvidia-smi` 的内容，则代表安装成功了。

### 赋予普通用户权限

让普通用户使用 docker 有两种方案：
1. rootless: 新建一个隔离的 docker 环境（类似 conda 的多环境）
2. root: 赋予直接操作 root docker 的权限

### Docker rootless mode

> [Rootless mode | Docker Docs][docker_rootless_mode]

在这里假设我们要用的用户名为 foo。对于 rootless 而言，需要先用 root 做一些配置：

```shell
apt-get install uidmap -y  # 依赖
loginctl enable-linger foo  # 允许 docker 在 foo 用户退出登录后继续运行
nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place  # 避免潜在的权限问题，经过实测这条不是必要的
```

随后切换到 foo 用户，执行以下命令：

```shell
dockerd-rootless-setuptool.sh install  # 配置
echo "export DOCKER_HOST=unix:///run/user/${UID}/docker.sock" >> ~/.bashrc  # 添加环境变量
nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json  # 给予 CUDA 权限
systemctl --user restart docker
```

到此，foo 这个用户就能开始使用 docker 了。值得注意的是，rootless 模式下的镜像、容器都是独立的，**即便是 root 用户也看不到 foo 究竟有哪些镜像与容器**。

### Docker root mode

直接用 root 用户执行：

```shell
usermod -aG docker foo
```

然后重新登陆 foo 用户，就能开始使用 docker 了。值得注意的是，此时在 docker 内部创建的所有文件都归属于 root 用户。除非显式指定 docker 中的文件权限归属。

## 普通用户安装 conda 环境

首先登陆 foo 用户，随后我们从 [Miniconda][conda_page] 下载 Miniconda: [Miniconda3 Linux 64-bit][conda_dl_link]

```shell
wget 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'
bash Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/.local/miniconda3
${HOME}/.local/miniconda3/bin/conda init
```

### 配置 conda 镜像

> [Anaconda 镜像使用帮助][tuna_conda_mirror]

```shell
conda config --set show_channel_urls yes 
cat << EOF >> ~/.condarc
channels:
  - defaults
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
EOF
```

### 配置 pypi 镜像

> [PyPI 镜像使用帮助][tuna_pypi_mirror]

```shell
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 config set global.trusted-host pypi.tuna.tsinghua.edu.cn  # 当使用 http 或自签证书时需要这个配置
```

### 验证 Python 对 CUDA 的调用

在这里笔者也不推荐直接使用 base 环境，我们新建一个环境：

```shell
conda create -n python3 python=3.12
conda config --set auto_activate_base false  # 默认不激活 base 环境
echo 'conda activate python3' >> ~/.bashrc  # 默认激活 python3 环境
```

重新登录后可看到 python3 已经作为默认环境了。

我们简单下载一个 `torch` 来验证环境安装的正确性：

```shell
pip3 install torch numpy
python3 -c 'import torch; print(torch.tensor(0).cuda())'
```

## 尾声

### 建议

在这里再多啰嗦几句，希望能让后辈们少走些弯路：

1. 任何行为，不论是安装软件、配环境、写代码还是一些系统操作，都应该将影响降低至 **最小范围**。比如将 nvcc、gcc 装至用户、环境级别而不是直接用 root 安装。
2. 除了本章节的内容，在任何情况下，都不建议直接使用 root 账户进行操作，除非读者是一位对 Linux 非常熟悉的专家并且明白自己在做什么，否则会面临各种潜在的权限问题、崩溃、挖矿病毒、数据丢失等风险。
3. 在任何情况下，都不应该操作 Linux 本身的 Python 环境，**请使用 venv 或 conda**。
4. 在任何情况下，都不应该随意变更宿主机的 CUDA 版本，**请使用 docker**。
5. 不建议在宿主机中安装 nvcc、TensoRT 等内容，据笔者观察，至少 90% 的用户他们并不明白自己在做什么，所以 **请使用 conda 或 docker**。

### 备忘

1. 安装 cudnn
    ```shell
    conda install conda-forge::cudnn
    ```

2. 安装 nvcc
    ```shell
    conda install nvidia::cuda-nvcc
    ```

3. 安装 gcc
    ```shell
    conda install conda-forge::gcc
    ```

## Reference

+ [Debian 下 CUDA 生产环境配置笔记][debian_cuda]
+ [Debian 软件源 - 清华大学开源软件镜像站][tuna_debian]
+ [Debian 下 CUDA 生产环境配置笔记 - Lucien's Blog][debian_cuda]
+ [nouveau - 维基百科][nouveau_wiki]
+ [Official Drivers | NVIDIA][download_driver]
+ [fabric-manager-user-guide.pdf][fabric_manager_user_guide]
+ [Download Installer for Linux Debian 12 x86_64][debian_deb_driver]
+ [nvidia-persistenced 常驻][persistence_mode_blog]
+ [Docker CE 软件仓库 - 清华大学开源软件镜像站][docker_tuna]
+ [Installing the NVIDIA Container Toolkit][nv_container_toolkit]
+ [Miniconda - Anaconda document][conda_page]
+ [Anaconda 镜像使用帮助 - 清华大学开源软件镜像站][tuna_conda_mirror]
+ [PyPI 镜像使用帮助 - 清华大学开源软件镜像站][tuna_pypi_mirror]
+ [Rootless mode | Docker Docs][docker_rootless_mode]

[this]: https://blog.lucien.ink/archives/549/
[pasteme]: https://pasteme.cn
[tuna_debian]: https://mirrors.tuna.tsinghua.edu.cn/help/debian/
[debian_cuda]: https://blog.lucien.ink/archives/534/
[nouveau_wiki]: https://zh.wikipedia.org/zh-cn/Nouveau
[download_driver]: https://www.nvidia.com/download/index.aspx
[driver_link]: https://us.download.nvidia.com/tesla/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
[fabric_issue]: https://github.com/NVIDIA/apt-packaging-fabric-manager/issues/2
[debian_deb_driver]: https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Debian&target_version=12&target_type=deb_network
[fabric_manager_user_guide]: https://docs.nvidia.com/datacenter/tesla/pdf/fabric-manager-user-guide.pdf
[persistence_mode_blog]: https://blog.lucien.ink/archives/542/
[docker_tuna]: https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/
[nv_container_toolkit]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
[conda_page]: https://docs.anaconda.com/miniconda/
[conda_dl_link]: https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
[tuna_conda_mirror]: https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/
[tuna_pypi_mirror]: https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
[debian_12_nv_fabric]: https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/
[docker_rootless_mode]: https://docs.docker.com/engine/security/rootless/
