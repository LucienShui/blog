---
title: "git 显示中文"
date: 2022-04-25 00:57:07 +0800
last_modified_at: 2022-04-25 00:57:07 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "git"]
tags: ["git"]
description: "默认情况下，git 会对中文进行转译，执行一行命令即可。"
---

## git 显示中文

> 本文地址：[blog.lucien.ink/archives/524][this]

默认情况下，git 会对中文进行转译，具体表现如下：

```bash
$ git status

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	"\346\265\213\350\257\225\346\226\207\344\273\266"
```

### 解决方案

执行 `git config --global core.quotepath false` 即可。

```bash
$ git status

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	测试文件
```

[this]: https://blog.lucien.ink/archives/524/
