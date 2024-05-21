---
title: "PVE 下解决 iKuai 断流、重启问题"
date: 2023-02-01 01:24:00 +0800
last_modified_at: 2023-02-27 01:30:08 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "软路由"]
tags: ["软路由", "pve"]
description: "之前入手了 N5105 + i225-V，收到后装了 PVE 7.2 作为底层系统，虚拟化 iKuai + OpenWRT 来做软路由。 随着 iKuai 系统的升级，逐渐发现一些问题，比如断流、频繁重启等。OpenWRT 也时不时会毫无征兆的宕机，只是不频繁。 上网搜索了很多资料，很多都是基于经验的尝试，比如说换用 32 位的 iKuai，关掉 ASPM 、ROM-Bar、NUMA，更改 MTU 等等。也有的说换用 ESXi 之后就不重启了等等。在这里就不一一列举了。 下面提供两种解决方案，一种是治标，另一种是治本。"
---

> 本文地址：[blog.lucien.ink/archives/536][this]

## 0. 前言

> 懒得看过程可直接移步第 2 部分

之前入手了 N5105 + i225-V，收到后装了 PVE 7.2 作为底层系统，虚拟化 iKuai + OpenWRT 来做软路由。

随着 iKuai 系统的升级，逐渐发现一些问题，比如断流、频繁重启等。OpenWRT 也时不时会毫无征兆的宕机，只是不频繁。

上网搜索了很多资料，很多都是基于经验的尝试，比如说换用 32 位的 iKuai，关掉 ASPM 、ROM-Bar、NUMA，更改 MTU 等等。也有的说换用 ESXi 之后就不重启了等等。在这里就不一一列举了。

下面提供两种解决方案，一种是治标，另一种是治本。

## 1. 更换旧版本的 iKuai

最开始我的策略是换用低版本的 iKuai，经过实测，3.4.9 版本是很稳定的，可以前往 [iKuai 历史版本下载][firmware] 进行下载。

但这样的问题是，新的一些特性都没有办法享受，比如静态 DHCP 指定网关、DNS。

再加上，即便 iKuai 不崩了，OpenWRT 也还处于摇摇欲坠的状态，于是我便开始尝试治本。

## 2. 打补丁

我注意到当连接数增多，譬如进行 PT 下载时，iKuai 崩溃、重启的概率会大大增加，加之我在 iKuai 的更新日志里看到了关于内核的升级，于是大胆猜测本质上应该是更底层的原因，与设置无关。

费尽九牛二虎之力，终于是搜到了一位大佬的文章：[PVE详细安装op、ikuai教程，含修改国内源、直通、更新内核][installation_guide]，里面讲了很多内容，也包含了关于虚拟机重启的解决方案，在这里作个提炼。

1. 更新内核、安装微代码更新套件

```shell
apt update
apt install pve-kernel-6.1 iucode-tool
```

2. 重启
3. 安装微代码补丁

```shell
wget https://http.us.debian.org/debian/pool/non-free/i/intel-microcode/intel-microcode_3.20221108.1_amd64.deb
dpkg -i intel-microcode/intel-microcode_3.20221108.1_amd64.deb
update-initramfs -u -k all
```

4. 再次重启

执行完上述 4 个步骤，经历 2 次重启之后，补丁就算是打完了。经过实测，连接数到达 3200 时 iKuai 3.6.13 也能稳定运行，OpenWRT 也暂时没有出现重启的情况。

## 3. 参考资料

1. [关于 N5105/N6005+i225/i226 系列软路由搭配 OpenWrt 在高连接数条件下崩溃/软重启的问题和解决思路汇总][v2ex]
2. [进阶 - 解决 PVE 下虚拟机自动重启][mbrjun]
3. [爱快在PVE下不定时反复重启死机的解决方法][fusionhex]
4. [PVE详细安装op、ikuai教程，含修改国内源、直通、更新内核][installation_guide]
5. [iKuai 历史版本下载][firmware]

[this]: https://blog.lucien.ink/archives/536/
[firmware]: https://lucienshui.github.io/ikuai-firmware/
[installation_guide]: https://www.right.com.cn/forum/thread-8106799-1-1.html
[v2ex]: https://www.v2ex.com/t/879368
[mbrjun]: https://www.mbrjun.cn/archives/417/
[fusionhex]: https://www.cnblogs.com/fusionhex/p/16201651.html