---
title: "OpenWRT 扩容"
date: 2022-12-29 16:15:26 +0800
last_modified_at: 2022-12-29 16:15:26 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "软路由"]
description: "官网原生的 overlay 只有 100M，不够用。本文只讨论新安装的情形，已安装扩容的场景在本文不涉及。"
---

> 本文地址：[blog.lucien.ink/archives/535][this]

官网原生的 overlay 只有 100M，不够用。本文只讨论新安装的情形，已安装扩容的场景在本文不涉及。

## 步骤

假设从官网下载的文件名为 `openwrt-22.03.2-x86-64-generic-squashfs-combined.img.gz`。

```bash
## 解压
gzip -kd openwrt-22.03.2-x86-64-generic-squashfs-combined.img.gz
## 重命名，方便操作
mv openwrt-22.03.2-x86-64-generic-squashfs-combined.img op.img
## 在尾部增加 4096M
dd if=/dev/zero bs=1M count=4096 >> op.img
## 进入分区工具
parted op.img
```

在 `parted` 的 console 里执行：

```bash
print # 打印当前分区
resizepart 2 100% # 将剩余空间分配给分区 2
print # 再次打印分区
qiut # 退出
```

## 参考文章

1. [软路由探索之旅 篇三：给openwrt扩容overlay 3月30日更新][ref]

[this]: https://blog.lucien.ink/archives/535/
[ref]: https://dickies.myds.me:56789/st/routeos/1024/