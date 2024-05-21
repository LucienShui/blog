---
title: "macOS 更改 Terminal 语言"
date: 2019-07-29 11:27:00 +0800
last_modified_at: 2019-07-31 10:38:50 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "macOS"]
tags: ["macos", "terminal"]
---

## macOS 更改 Terminal 语言

本文地址：https://blog.lucien.ink/archives/460/

### 起因

今天用 brew 装了一个 wget, 装完之后发现提示是中文的

```bash
$ wget
wget：未指定 URL
用法： wget [选项]... [URL]...

请尝试使用“wget --help”查看更多的选项。
```

### 解决

应该是因为 Homebrew 里的 wget 是有多语言支持的版本，遂改之

```bash
$ echo $LANG # 查看当前 Terminal 的语言设定，发现是中文
zh_CN.UTF-8
```

遂更改变量 `LANG`

```bash
$ echo 'export LANG="en_US.UTF-8"' >> ~/.bash_profile # 默认将 LANG 修改为英文_美国.UTF-8 编码
$ source ~/.bash_profile # 使文件生效
$ wget
wget: missing URL
Usage: wget [OPTION]... [URL]...

Try `wget --help' for more options.
```