---
title: "树莓派初始化备忘"
date: 2020-12-07 23:04:00 +0800
last_modified_at: 2021-12-03 21:45:00 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux", "树莓派"]
description: "最近又开始折腾树莓派了，记录一下初始化一个树莓派需要做的一些操作。本次操作以 64 位 Raspberry Pi OS（目测其实是 Debian 11）为目标系统。"
---

## 树莓派初始化备忘

> 本文地址：[blog.lucien.ink/archives/515][this]

最近又开始折腾树莓派了，记录一下初始化一个树莓派需要做的一些操作。

本次操作以 64 位 Raspberry Pi OS（目测其实是 Debian 11）为目标系统。

### 1. 下载系统

#### 1.1 32 位系统

前往 [Operating system images][download_image] 下载需要的操作系统。

#### 1.2 64 位系统

官方并没有直接将 64 位系统放在下载页面，不过通过搜索引擎可以搜到。

1. [Raspberry Pi OS Lite][raspios_lite_arm64]
2. [Raspberry Pi OS with desktop][raspios_arm64]

### 2. 开机前的配置

> 参考 [无屏幕和键盘配置树莓派WiFi和SSH][shumeipai.nxez]

把上一步写好的 SD 卡插到电脑里，会有一个名为 `boot` 的磁盘，通过在这个磁盘根目录下创建一些文件可以实现对 `raspbian` 的初始化配置。

#### 2.1 开启 SSH

在磁盘根目录创建一个名为 `ssh` 的空文件即可。

#### 2.2 配置 Wi-Fi

需要注意的是，Raspberry Zero W 不支持 5 GHz 的 Wi-Fi。

在磁盘根目录创建一个名为 `wpa_supplicant.conf` 的文件，内容如下。

```conf
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
 
network={
    ssid="WiFi-A"
    psk="12345678"
    key_mgmt=WPA-PSK
    priority=1
}
```

### 3. 软件源

`/etc/apt/sources.list` 与 `/etc/apt/sources.list.d/raspi.list` 都包含软件源，我个人认为阿里云比较快，奈何阿里云好像没有 `archive.raspberrypi.org` 的镜像，所以一部分用阿里云镜像，一部分用中科大镜像。

**注意**，实测杭州电信存在缓存劫持，会导致中科大的域名无法正常访问，建议使用 `https` 替换 `http`。

1. `/etc/apt/sources.list`

    ```bash
    deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
    # deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
    deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
    # deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main
    deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
    # deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
    ```

2. `/etc/apt/sources.list.d/raspi.list`

    ```bash
    deb https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ bullseye main
    # deb-src https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ bullseye main
    ```

### 4. 治好强迫症

#### 4.1 locale

> [How do I fix my locale issue?][locale_issue]

执行 `raspi-config`，选择 `Localisation Options -> Locale`，用空格将你需要的语言勾选上，我在这里选择 `en_US.UTF-8`，然后应用。

然后编辑 `/etc/environment`，写入如下内容（将 `en_US.UTF-8` 替换成你自己的选择）

```shell
LANGUAGE="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
```

#### 4.2 时区

执行 `raspi-config`，选择 `Localisation Options -> Timezone -> Asia -> Shanghai` 即可。

[this]: https://blog.lucien.ink/archives/515/
[download_image]: https://www.raspberrypi.org/software/operating-systems/
[shumeipai.nxez]: https://shumeipai.nxez.com/2017/09/13/raspberry-pi-network-configuration-before-boot.html
[raspios_lite_arm64]: https://downloads.raspberrypi.org/raspios_lite_arm64/images/
[raspios_arm64]: https://downloads.raspberrypi.org/raspios_arm64/images/
[locale_issue]: https://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue