---
title: "Debian 10 apt 使用阿里云镜像"
date: 2020-11-03 23:23:00 +0800
last_modified_at: 2020-11-03 23:23:34 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux"]
description: "最近打算在 Debian 上折腾 KVM，在阿里云官网的教程里没找到 Debian 10 的源，遂自己动手。"
---

## Debian 10 apt 使用阿里云镜像

> 本文地址：[blog.lucien.ink/archives/513][this]

### 正文

最近打算在 Debian 上折腾 KVM，在阿里云官网的教程里没找到 Debian 10 的源，遂自己动手。

```python
## 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.aliyun.com/debian/ buster main contrib non-free
## deb-src https://mirrors.aliyun.com/debian/ buster main contrib non-free
deb https://mirrors.aliyun.com/debian/ buster-updates main contrib non-free
## deb-src https://mirrors.aliyun.com/debian/ buster-updates main contrib non-free
deb https://mirrors.aliyun.com/debian/ buster-backports main contrib non-free
## deb-src https://mirrors.aliyun.com/debian/ buster-backports main contrib non-free
deb https://mirrors.aliyun.com/debian-security buster/updates main contrib non-free
## deb-src https://mirrors.aliyun.com/debian-security buster/updates main contrib non-free
```

### 参考

+ [Debian 镜像 - 阿里云][aliyun]
+ [Debian 镜像使用帮助][tuna]

[this]: https://blog.lucien.ink/archives/513/
[aliyun]: https://developer.aliyun.com/mirror/debian
[tuna]: https://mirrors.tuna.tsinghua.edu.cn/help/debian/