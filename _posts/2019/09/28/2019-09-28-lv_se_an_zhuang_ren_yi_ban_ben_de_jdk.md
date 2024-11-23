---
title: "绿色安装任意版本的 JDK"
date: 2019-09-28 13:57:00 +0800
last_modified_at: 2021-09-25 15:24:10 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "macOS"]
tags: ["linux", "java", "jdk"]
description: "很多小白在安装 JDK 的时候，总会遇到各种各样的问题，在这里推荐一种不容易出错的 “安装” 方法：二进制。总的来说只有两步：1. 下载并解压 2. 配置环境变量"
---

## 绿色安装任意版本的 JDK

本文地址：https://blog.lucien.ink/archives/466/

> 这是一篇面向 0 基础小白的教程，可安心食用。

很多小白在安装 JDK 的时候，总会遇到各种各样的问题，在这里推荐一种不容易出错的 “安装” 方法：二进制。

说是安装，其实并不涉及到任何向导程序，总的来说只有两步：

1. 下载并解压
2. 配置环境变量

### 0. OpenJDK 与 Oracle JDK 的区别

直接说结论好了，基本上可以认为 OpenJDK 在性能、功能和执行逻辑上都和官方的 Oracle JDK 是一致的。感兴趣的小伙伴们可以自行了解一下。

### 1. 以 Linux 下安装 JDK 11 为例

> 安装 JDK 任意版本都同理

#### 1.1 下载并解压

去 [jdk.java.net/archive](https://jdk.java.net/archive/) 下载你想要的版本，这里下载并解压 `Linux` 平台 `11.0.2` 版本。

```bash
$ wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
$ tar -xzvf openjdk-11.0.2_linux-x64_bin.tar.gz
$ rm openjdk-11.0.2_linux-x64_bin.tar.gz
```

#### 1.2 配置环境变量

上一步完成之后得到了一个名为 `jdk-11.0.2` 的文件夹，我们将其加入环境变量中。

先将二进制文件移动至 `/usr/local/` 目录下。

```bash
mv jdk-11.0.2 /usr/local/
```

然后在 `～/.bashrc` 的末尾追加两行：

```bash
export JAVA_HOME=/usr/local/jdk-11.0.2
export PATH="${JAVA_HOME}/bin:${PATH}"
```

然后执行 `exit` 退出登陆，重新登陆进去后会生效。
