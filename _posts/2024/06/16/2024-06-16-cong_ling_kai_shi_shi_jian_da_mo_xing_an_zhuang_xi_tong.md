---
title: "从零开始实践大模型 - 安装系统"
date: 2024-06-16 23:29:00 +0800
last_modified_at: 2024-06-23 22:48:23 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
tags: ["linux"]
description: "该文建议安装无图形界面的 Debian Linux 作为深度学习系统，推荐使用 Debian 因其精简和可控性。文中详细介绍了从下载安装包到选择安装选项的步骤，强调了选择英文、UTF-8 编码、国内 apt 镜像和不安装图形化界面等关键点。"
---

> 本文地址：[blog.lucien.ink/archives/548][this]

本章节将介绍在面向深度学习时，推荐安装的系统以及对应的安装选项。

## 系统选择

目前主流操作系统有 Linux、macOS、Winodws，如果不考虑日常当作个人电脑来使用的话，强烈建议使用 **无图形化界面** 的 Linux，因为图形化界面会占用一定的显存（虽然也有不占用显存且同样拥有图形化的方法，这不在本文的讨论范围）。

接下来就是 Linux 发行版的选择，大部分企业（包括 NVIDIA 自己）会选择 Ubuntu，因为内置的东西多，笔者在这里不选择 Ubuntu，也是因为它内置的东西太多了，比如 snap 和 systemd-resolved。

基于笔者的实践经验，推荐使用 Debian 作为操作系统，因为它足够精简，而基于这般精简，也不会在后续使用上产生任何额外的复杂，且行为都足够可控，故在本文包括后续的一系列文章中，都会使用 Debian 作为演示操作系统。

## 下载安装包

在这里特意注明下 Debian 的下载地址，以免大家被百度的广告误导：[Installing Debian via the Internet][download_url]。

## 安装系统

### 启动页面

![Installer menu][install_method]

### 语言

在这里 **强烈不推荐** 选择中文，除非你准备好应对各种因中文字符而产生的问题。

![Select a language][language]

### 地区

美国或中国都可以，这会影响到安装完成后的时区：
+ 可以在这里先选择 `United States` 然后进入系统后再更改。
+ 也可以直接去 `other` 里找 `Asia` 然后 `China`。

![Select location other][location_other]
![Select Region][location_aisa]
![Select territory or area][location_china]

### 编码

一律选 `en_US.UTF-8`，可以规避很多潜在的问题。

![Configure locales][locales]

### 键盘布局

![Configure the keyboard][keymap]

### 主机名 & 域名

如果只是单台服务器的话，这里随便填就好。
如果打算组建集群，这里就直接起个 node-0 之类的遍于自己区分的名字就好。

![The hostname for this system][hostname]
![Domain name][domain]

### 设定用户 & 密码

![Set up root password][root_pass]
![Set up normal user][normal_user]

### 硬盘分区

推荐直接用一整块硬盘，不启用 LVM 和加密。

![Partition disks][partition_disk]
![Select disk][select_disk]
![Partition Scheme][partition_scheme]
![Disk_part Checkout][disk_part_checkout]
![Verify disk part][verify_disk_part]

### 配置 apt

在这里选择国内的镜像，否则会很慢。

![Extra media][extra_media]
![APT China][apt_china]
![APT Tuna mirror][apt_tuna]
![APT HTTP Proxy][apt_proxy]

### 是否参与数据采集

![Survey][survey]

### 选择预装软件

在这里只选择 SSH 和基础工具就好，没有特殊需求不建议勾选图形化界面（Debian desktop environment）。

![Software Selection][software_selection]

### 安装引导

![GRUB][grub]
![Choose Grub Device][choose_grub_device]

### 重启进入系统

![Complete][complete]
![Bootloader][bootloader]

[this]: https://blog.lucien.ink/archives/548/
[download_url]: https://www.debian.org/distrib/netinst
[install_method]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eoeo.png
[language]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eojw.png
[location_other]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eonw.png
[location_aisa]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eoqt.png
[location_china]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eoso.png
[locales]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eouf.png
[keymap]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epas.png
[hostname]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eyxo.png
[domain]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eyyg.png
[root_pass]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epmm.png
[normal_user]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epnr.png
[partition_disk]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eprx.png
[select_disk]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eptx.png
[partition_scheme]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epuv.png
[disk_part_checkout]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epvv.png
[verify_disk_part]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-epxd.png
[extra_media]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eqee.png
[apt_china]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eqfj.png
[apt_tuna]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eqgq.png
[apt_proxy]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-eqht.png
[survey]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-evra.png
[software_selection]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-evta.png
[grub]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-fanp.png
[choose_grub_device]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-faor.png
[complete]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-ewec.png
[bootloader]: https://cdn.jsdelivr.net/gh/LucienShui/assets@main/img/2024/06/16/SCR-20240616-favu.png