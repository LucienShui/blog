---
title: "WSL2 安装、配置 Cuda、pytorch 记录"
date: 2022-11-16 20:42:00 +0800
last_modified_at: 2022-11-16 20:44:46 +0800
math: false
render_with_liquid: false
categories: ["机器学习"]
tags: ["深度学习"]
description: "最近整了张矿卡，为了这盘醋，包了盘饺子。虽然我已经预料到买前深度学习，买后电子竞技，但还是象征性的先配下环境。"
---

## WSL2 安装、配置 Cuda、pytorch 记录

> 本文地址：[blog.lucien.ink/archives/532][this]

最近整了张矿卡，为了这碟醋，包了盘饺子。虽然我已经预料到买前深度学习，买后电子竞技，但还是象征性的先配下环境。

### 安装过程

> 我使用的是 Windows 11，所以相比 Windows 10，有些命令可能不太适用。

#### 安装显卡驱动

直接去 [NVIDIA 官网][nvidia-driver] 下载 Game Ready 驱动即可。

#### 安装 WSL2

> 个人比较喜欢 Debian，比较轻量级。

```powershell
wsl --install -d Debian
```

安装完成之后执行 `wsl` 进入 Linux，在 Linux 下执行一下 `nvidia-smi`，输出显卡信息即没有问题。

#### 安装 Miniconda

> 个人不是很推荐 Anaconda，不赘述。

前往 [Miniconda 官网][miniconda] 下载 `Miniconda3 Linux 64-bit` 版本安装即可。

#### 安装 pytorch-gpu

根据 [PyTorch 官网][torch-doc] 的提示，执行命令即可。

```bash
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
```

### QA

Q: 为什么选择 Windows
A: 目前 Windows 是地球上最好的 Linux 发行版之一，其次它也是能同时满足学习、娱乐的唯一选择。

### 参考文档

1. [Install Linux on Windows with WSL][wsl-docs]
2. [CUDA on WSL User Guide][nvidia-docs]

[this]: https://blog.lucien.ink/archives/532/
[nvidia-docs]: https://docs.nvidia.com/cuda/wsl-user-guide/index.html
[wsl-docs]: https://learn.microsoft.com/en-us/windows/wsl/install
[nvidia-driver]: https://www.nvidia.cn/Download/index.aspx
[miniconda]: https://docs.conda.io/en/latest/miniconda.html
[torch-doc]: https://pytorch.org/get-started/locally/