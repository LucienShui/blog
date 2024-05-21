---
title: "ubuntu 扩容逻辑卷"
date: 2023-10-14 00:53:53 +0800
last_modified_at: 2023-10-14 00:53:53 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "运维"]
description: "`Ubuntu 22.04 LTS` 在安装过程中默认只使用 100G 的硬盘，执行以下命令即可扩容"
---

> 本文地址：[blog.lucien.ink/archives/543][this]

`Ubuntu 22.04 LTS` 在安装过程中默认只使用 100G 的硬盘，执行以下命令即可扩容：

```shell
$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  100G   11G  89G   11% /

$ lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-10-11 10:53:11 +0000
  LV Status              available
  # open                 1
  LV Size                100 GB
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     512
  Block device           253:0

$ lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

$ resize2fs /dev/ubuntu-vg/ubuntu-lv

$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  3.5T   11G  3.3T   1% /
```

[this]: https://blog.lucien.ink/archives/543/
