---
title: "Linux 删除 N 天前的文件"
date: 2019-05-26 13:04:00 +0800
last_modified_at: 2019-07-24 23:25:18 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "运维"]
tags: ["linux", "其它", "程序人生"]
---

## Linux 删除 N 天前的文件

原文地址：https://www.lucien.ink/archives/452/

### 1. 起因

我在使用宝塔面板的定时备份的过程中，发现在备份文件目录的时候无法成功清理旧的备份，导致 `OSS` 的体积暴增 `120G` ，然而连续额外扣费 4 个月之后我才发现这一问题。钱包表示它瘦了。

在宝塔的官方交流群里反馈这个问题，并没有人鸟我，遂自行想办法解决这个问题。

### 2. 解决

先将 `OSS` 挂载到本地，使其成为本地文件系统的一部分，然后用 `find` 命令找出 `N` 天前的文件，删除之。

比如我每天备份一次，保留近 $7$ 次备份，`OSS` 的挂载目录是 `/oss`，于是我添加了一个定时命令：

```bash
find /oss/bt_backup -mtime +6 -name "*.tar.gz" | xargs -I {} rm -rf {}
```

意思就是删除 `/oss/bt_backup` 目录下所有最近更改时间超过 $6$ 天的文件。 