---
title: "Raspberry Pi Raspbian 使用 USTC 的 apt 镜像"
date: 2019-10-07 20:54:00 +0800
last_modified_at: 2019-10-07 20:55:36 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux", "raspberry"]
---

## Raspberry Pi Raspbian 使用 USTC 的 apt 镜像

> 本文地址：https://blog.lucien.ink/archives/467/

在 [Raspberrypi 源使用帮助 - USTC Mirror Help 文档](https://mirrors.ustc.edu.cn/help/archive.raspberrypi.org.html) 只找到 `/etc/apt/sources.list.d/raspi.list` 这个文件的应该替换为什么，并没有找到 `/etc/apt/sources.list` 的。

遂去 [Raspbian Mirrors - Raspbian](https://www.raspbian.org/RaspbianMirrors) ，搜寻了一番，由于最近可能会再入手一个新的树莓派，所以在这里记录一下。

### USTC

1. `/etc/apt/sources.list.d/raspi.list`

    ```conf
    deb https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ buster main
    # Uncomment line below then 'apt-get update' to enable 'apt-get source'
    #deb-src https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ buster main
    ```

2. `/etc/apt/sources.list`

    ```conf
    deb https://mirrors.ustc.edu.cn/raspbian/raspbian/ buster main contrib non-free rpi
    # Uncomment line below then 'apt-get update' to enable 'apt-get source'
    #deb-src https://mirrors.ustc.edu.cn/raspbian/raspbian/ buster main contrib non-free rpi
    ```

### TUNA

2019 年 10 月 7 日这一天表示并不能使用，但还是附上 [Raspbian 镜像使用帮助 - Tsinghua Open Source Mirror](https://mirror.tuna.tsinghua.edu.cn/help/raspbian/)

1. `/etc/apt/sources.list.d/raspi.list`

    ```conf
    deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
    ```

2. `/etc/apt/sources.list`

    ```conf
    deb https://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main non-free contrib
    deb-src https://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main non-free contrib
    ```

### 其它

最新的 `Raspbian` 都已基于 `Debian 10` 进行构建，可通过 `cat /etc/os-release` 来查看一些详细信息。
