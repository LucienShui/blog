---
title: "在 PVE 中安装 OpenWrt"
date: 2022-05-05 22:36:00 +0800
last_modified_at: 2022-05-05 23:01:08 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "软路由"]
tags: ["软路由"]
description: "最近在捣腾 x86 软路由，入门方案一般是底层采用 ESXi 或 PVE，虚拟层使用 iKuai + OpenWrt 的形式。由于我更喜欢开源软件，所以我选择了 PVE，在这里记录一下 PVE 安装 OpenWrt 的步骤。"
---

## 在 PVE 中安装 OpenWrt

> 本文地址：[blog.lucien.ink/archives/525][this]

最近在捣腾 x86 软路由，入门方案一般是底层采用 [ESXi][esxi_homepage] 或 [PVE][pve_homepage]，虚拟层使用 iKuai + OpenWrt 的形式。

由于我更喜欢开源软件，所以我选择了 PVE，在这里记录一下 PVE 安装 OpenWrt 的步骤。

### 1. 创建虚拟机

创建一个空的虚拟机，“不使用任何介质”，“客户机操作系统” 选择 Linux。剩下的在默认的基础上加上一些个人理解就好，我一般会将 CPU 选为 `host`，其它维持默认。

### 2. 刷写 OpenWrt

删除这个虚拟机的现有硬盘，随后进入 PVE 的命令行。

#### 2.1 下载镜像

在 OpenWrt 的 [下载页面][download_page] 找到最新的系统镜像，写下本段文字时，最新版本号为 `21.02.3`，对应的路径为：[releases/21.02.3/targets/x86/64/][download_link]，选择 `generic-squashfs-combined-efi.img.gz` 这个镜像。

```bash
wget https://downloads.openwrt.org/releases/21.02.3/targets/x86/64/openwrt-21.02.3-x86-64-generic-squashfs-combined-efi.img.gz
```

#### 2.2 解压镜像

首先解压镜像，需要用到 `gunzip` 命令，如果提示找不到的话，需要安装 `gzip`

```bash
apt install gzip
gunzip openwrt-21.02.3-x86-64-generic-squashfs-combined-efi.img.gz
```

#### 2.3 导入镜像

然后我们需要将解压好的镜像变成一个 VM 的磁盘。

假设在第 1 步中创建好的虚拟机 ID 为 100，那么执行：

```bash
qm importdisk 100 openwrt-21.02.3-x86-64-generic-squashfs-combined-efi.img local-lvm
```

随后在网页中挂载这个新磁盘就好了，图片很多，不赘述。

### 3. 参考文章

1. [HOW TO INSTALL OPENWRT IN PROXMOX VE AS A VM][install_guide]
2. [Convert OpenWrt Image to ESXi VMDK][conver]

[this]: https://blog.lucien.ink/archives/525/
[esxi_homepage]: https://www.vmware.com/products/esxi-and-esx.html
[pve_homepage]: https://www.proxmox.com/en/
[download_page]: https://downloads.openwrt.org/
[conver]: https://wi1dcard.dev/posts/convert-openwrt-image-to-esxi-vmdk/
[install_guide]: https://www.jwtechtips.top/how-to-install-openwrt-in-proxmox/
[download_link]: https://downloads.openwrt.org/releases/21.02.3/targets/x86/64/