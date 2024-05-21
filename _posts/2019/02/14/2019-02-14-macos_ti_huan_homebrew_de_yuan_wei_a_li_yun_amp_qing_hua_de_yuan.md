---
title: "macOS 替换 Homebrew 的源为阿里云 &amp; 清华的源"
date: 2019-02-14 11:52:00 +0800
last_modified_at: 2020-08-09 02:35:15 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "macOS"]
tags: ["程序人生", "macos"]
description: "很多小伙伴在使用 Homebrew 的时候发现速度很慢，可通过使用国内的镜像来解决。"
---

## macOS 替换 Homebrew 的源为阿里云 & 清华的源

> 本文地址：[https://blog.lucien.ink/archives/397/](https://blog.lucien.ink/archives/397/)

很多小伙伴在使用 Homebrew 的时候发现速度很慢，可通过使用国内的镜像来解决。

**需要注意的是**，新版 macOS 使用 zsh 作为默认 Terminal，须将命令中的 `~/.bash_profile` 替换为 `~/.zshrc`

> *推荐使用清华大学的镜像，原因见文末*

### 清华大学

```bash
## 替换brew.git:
git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
## 替换homebrew-core.git:
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
## 应用生效
brew update
## 替换homebrew-bottles:
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile
```

#### 清华大学开源软件镜像站

[https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)
[https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/)

### 阿里云

```bash
## 替换brew.git:
cd "$(brew --repo)"
git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git
## 替换homebrew-core.git:
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git
## 应用生效
brew update
## 替换homebrew-bottles:
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile
```

#### 阿里巴巴开源镜像站

[https://developer.aliyun.com/mirror/homebrew](https://developer.aliyun.com/mirror/homebrew)

> 2019 年 7 月 13 日更新
> 很多小伙伴反应阿里云的源 `brew update` 没反应，不知道是不是教育网的问题，阿里云镜像站的官网在 **[这里](https://opsx.alibaba.com/mirror?lang=zh-CN)**，小伙伴们可以去自行确认一下

> 2020 年 8 月 9 日更新
> 上面的链接失效了，这个是最新链接：[developer.aliyun.com/mirror/homebrew](https://developer.aliyun.com/mirror/homebrew)
