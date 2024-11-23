---
title: "Windows 删除恢复分区"
date: 2022-12-02 00:57:03 +0800
last_modified_at: 2022-12-02 00:57:03 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Windows"]
tags: ["windows"]
description: "目前不论是 Windows 10 还是 Windows 11，在安装完成后在 C 盘的后面都会有一个恢复分区，在虚拟机场景下，需要对硬盘进行扩容时，这个恢复分区会使得分区不连续，导致无法直接将容量扩展至 C 盘中，所以需要在扩容前删掉这个分区。"
---

## Windows 删除恢复分区

> 本文地址：[blog.lucien.ink/archives/533][this]

目前不论是 Windows 10 还是 Windows 11，在安装完成后在 C 盘的后面都会有一个恢复分区，在虚拟机场景下，需要对硬盘进行扩容时，这个恢复分区会使得分区不连续，导致无法直接将容量扩展至 C 盘中，所以需要在扩容前删掉这个分区。

### 什么是恢复分区

在查看了一些资料后，用一句话来讲，就是个 Windows PE，可被 Windows 引导镜像所代替。

以及在查询了 [微软社区][microsoft-community] 的后，我得出的结论是：“删除这个分区不会有任何影响”。

### 怎么删除

很多小伙伴进入到系统自带的 **磁盘管理** 中会发现这个恢复分区是受保护的，没有办法直接用 GUI 的形式删除。

在查阅了资料后，按照 [这篇文章][how-to-delete] 可以成功地删掉这个分区，步骤如下：

1. 右键点击 **开始** 菜单，并选择 **Windows Powershell（管理员）**
2. 输入 `diskpart`，然后输入 `list disk`
3. 输入 `select disk #`（`#` 是恢复分区所在硬盘的编号）
4. 输入 `list partition`
5. 输入 `select partition #`（`#` 是恢复分区所在分区的编号）
6. 输入 `delete partition override`

执行完以上步骤之后，回到 **磁盘管理** 中，你会发现恢复分区已经被成功删除。

[this]: https://blog.lucien.ink/archives/533/
[microsoft-community]: https://learn.microsoft.com/en-us/answers/questions/616561/i-deleted-my-windows-10-recovery-partition-will-it.html
[how-to-delete]: https://www.lifewire.com/delete-windows-recovery-partition-4128723
