---
title: "GitHub Actions 持续集成 - 0. 入门"
date: 2019-10-26 09:01:00 +0800
last_modified_at: 2019-10-26 23:34:46 +0800
math: true
render_with_liquid: false
categories: ["工程", "持续集成"]
tags: ["项目", "持续集成", "github", "工程"]
---

## GitHub Actions 持续集成 - 0. 入门教程

本文地址：https://blog.lucien.ink/archives/468/

### 0. 前言

之前挖了一个[坑](https://blog.lucien.ink/archives/464/)，今天开始抽空来补上。

以前也写过一篇关于持续集成的文：[GitHub 快速接入 Travis](https://blog.lucien.ink/archives/428/) ，随后拿到了 GitHub Actions 的内测资格，鉴于使用 GitHub 自家的 CI 整合度会更高，而且 GitHub Actions 本身也足够好用，遂决定将所有项目逐渐从 travis 和 drone 迁移至 GitHub Actions。

经过几天的尝试，PasteMe 从提交 commits, pull request 时的自动测试，到自动 release，配合  [webhook](https://github.com/LucienShui/Webhook) 实现自动 deploy，真正意义上实现了持续集成与持续交付，我将这一实战过程复现并记录下来，以备不时之需。

本文章旨在介绍 GitHub Actions 的基础操作，随后通过一个项目来演示 GitHub Actions 的实际效果。

本篇文章参考了阮一峰老师的 [GitHub Actions 入门教程](https://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)，感谢阮一峰老师 Orz。

### 1. 什么是 GitHub Actions

持续集成由很多操作组成，比如抓取代码、运行测试、登录远程服务器，发布到第三方服务等等。GitHub 把这些操作就称为 actions。

GitHub 允许开发者把每个 Actions 写成独立的脚本文件，存放到代码仓库，使其他开发者可以在自己的 Actions 中引用，这样一来就可以产生许多奇妙的效应。

#### 1.1 一些官方文档

+ [GitHub Actions 介绍](https://help.github.com/en/articles/about-actions)
+ [语法说明](https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions)
+ [内置变量和语法](https://help.github.com/en/github/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions)
+ [可以触发 workflow 的事件](https://help.github.com/en/github/automating-your-workflow-with-github-actions/events-that-trigger-workflows)

### 2. 基本概念

1. **workflow**
  一个 `.yml` 文件对应一个 workflow，也就是一次持续集成。一个 GitHub 仓库可以包含多个 workflow，只要是在 `.github/workflow` 中的 `.yml` 文件都会被 GitHub 执行。
2. **job**
  一个 workflow 可以包含多个 job，每个 job 代表一个持续集成任务
3. **step**
  一个 job 可以包含多个 step，每个 step 代表 job 中的一个步骤
4. **on**
  一个 workflow 的触发条件，决定了当前的 workflow 在什么时候被执行

更多关于格式、参数、含义的信息我就不赘述了，请参考：[GitHub Actions 语法说明](https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions)

### 3. 一个简单的例子

项目地址：https://github.com/LucienShui/HelloCI

#### 3.1 项目代码

在这个项目中，我创建了一个 `main.go` 文件，输出 `Hello World!`。

```go
package main

import "fmt"

func main() {
	fmt.Println("version 1.0.8")
}
```

https://github.com/LucienShui/HelloCI/tree/b407172f5c32857718368b2444d66c62516db69e

#### 3.2 创建一个 workflow

在 `.github/workflow` 中创建了一个 `test.yml` 的文件，作用是在每一次提交时在不同的系统中使用不同版本的 go 去编译应用，以确保代码在不同场景下均能被正常编译。

```yaml
name: Go Test # workflow 的名字

on: [push, pull_request] # 在发生 push 或者是 pull request 事件时执行此 workflow

jobs:

  test:
    strategy:
      matrix: # 这个我也不知道怎么翻译了，大致实现的功能是把每个变量的每种取值都遍历一遍
        go_version: [1.12, 1.13] # key: valueSet
        os: [ubuntu-latest, windows-latest, macOS-latest]

    name: Test with go ${{ matrix.go_version }} on ${{ matrix.os }} # 在 job.<job_id>.strategy.matrix 中定义的变量在整个 job 下都有效
    runs-on: ${{ matrix.os }} # 使用的 OS

    steps: # 步骤

      - name: Set up Go ${{ matrix.go_version }} # 每一步的名字
        uses: actions/setup-go@v1 # 要引用的 actions，这里用 setup-go 来进行 go 环境的安装
        with: # 指定 actions 的入参
          go-version: ${{ matrix.go_version }}
        id: go # 参考 https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobsjob_idstepsid ，不知道怎么解释 Orz

      - name: Check out code into the Go module directory
        uses: actions/checkout@v1

      - name: Get dependencies # 安装项目依赖
        run: | # 用来执行 shell 语句
          go get -v -t -d ./...
          if [ -f Gopkg.toml ]; then
              curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
              dep ensure
          fi

      - name: Test # 进行编译测试
        run: |
          go build -v -o main .
```

https://github.com/LucienShui/HelloCI/tree/76ef897436b95b6e53d8d7ef758fc8d15da271a5

### 3.3 执行结果

在将 workflow 提交上去之后，由于触发条件里包含 `push` 事件，所以会被立即触发。

执行结果如下：

https://github.com/LucienShui/HelloCI/commit/76ef897436b95b6e53d8d7ef758fc8d15da271a5/checks?check_suite_id=275199394

由于我配置了 `matrix`，所以可以看到在 `Go Test` 这个 workflow 下产生了 6 个 job ，是由 `go_version` 和 `os` 依次组合出来的结果。可以注意到，[Windows & go 1.12](https://github.com/LucienShui/HelloCI/runs/269288726) 和 [Windows & go 1.13](https://github.com/LucienShui/HelloCI/runs/269288755) 运行出错了，看了下报错貌似是因为 `Windows` 不支持完整的 `shell` 语句所以运行不了最后一步，在下一次更新将 `Windows` 从 `matrix.os` 里去掉好了。