---
title: "sshfs 指令备忘"
date: 2019-02-14 19:42:00 +0800
last_modified_at: 2019-02-14 19:53:08 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

> 以下所有指令基于 $macOS$ ，$Linux$ 类似。

### 挂载远程目录到本地

```bash
sshfs -p <port> -C -o reconnect <user>@<hostname>:<remote_dir> <local_dir>
## <port> 端口号
## <user> 用户名
## <hostname> 远程地址
## <remote_dir> 远程路径
## <local_dir> 本地挂载路径
```

### 取消挂载

```bash
umount -f <local_dir>
```

有时候会因为一些特殊原因，比如说电脑进入睡眠，导致链接断开，这个时候就会出现无法取消挂载的情况，考虑强制取消或杀掉进程。

#### 强制取消

```bash
diskutil umount force <local_dir>
```

#### 杀掉进程

```bash
pgrep -lf sshfs
pkill -9 sshfs
```