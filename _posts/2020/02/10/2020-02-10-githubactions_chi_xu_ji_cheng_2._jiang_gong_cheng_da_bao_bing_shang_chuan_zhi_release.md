---
title: "GitHub Actions 持续集成 - 2. 将工程打包并上传至 Release"
date: 2020-02-10 11:36:00 +0800
last_modified_at: 2020-02-10 11:39:38 +0800
math: true
render_with_liquid: false
categories: ["工程", "持续集成"]
tags: ["持续集成", "工程"]
description: "上篇文章介绍了如何自动生成 Release 的内容，本文章旨在介绍如何借助 GitHub Actions 在 Release 时自动上传打包好的工程。本文地址：blog.lucien.ink/archives/493"
---

## GitHub Actions 持续集成 - 2. 将工程打包并上传至 Release

> 本文地址：[blog.lucien.ink/archives/493][this]

### 0. 摘要

之前挖了一个[坑][keng]，慢慢补上。

上篇文章介绍了如何自动生成 Release 的内容，本文章旨在介绍如何借助 GitHub Actions 在 Release 时自动上传打包好的工程。

### 1. 现成的轮子

使用此 Action 可以将特定的文件上传至 release 中。

[github.com/JasonEtco/upload-to-release][upload_to_release]

### 2. GitHub Actions YML 文件

[.github/workflows/upload-to-release.yml][yml_file]

```yml
name: Go Release

on:
  release:
    types: [published]

jobs:

  release:
    if: github.repository == 'PasteUs/HelloCI'
    name: Build with go ${{ matrix.go_version }} on ${{ matrix.os }} and upload
    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        go_version: [1.13]
        os: [ubuntu-latest]

    steps:

      - name: Set up Go ${{ matrix.go_version }}
        uses: actions/setup-go@v1
        with:
          go-version: ${{ matrix.go_version }}
        id: go

      - name: Check out code into the Go module directory
        uses: actions/checkout@v1

      - name: Get dependencies
        run: |
          go get -v -t -d ./...
          if [ -f Gopkg.toml ]; then
              curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
              dep ensure
          fi

      - name: Build
        run: |
          go build -v -o main .

      - name: Gzip
        run: |
          mkdir hello-word-${{ matrix.os }}
          cp main hello-word-${{ matrix.os }}
          tar -czvf hello-word-${{ matrix.os }}.tar.gz hello-word-${{ matrix.os }}

      - name: Upload to release
        uses: JasonEtco/upload-to-release@master
        with:
          args: hello-word-${{ matrix.os }}.tar.gz application/octet-stream
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

[this]: https://blog.lucien.ink/archives/493/
[keng]: https://blog.lucien.ink/archives/464/
[upload_to_release]: https://github.com/JasonEtco/upload-to-release
[yml_file]: https://github.com/LucienShui/HelloCI/blob/b933d59047f34084b16f31ab12361a37f15e3d2d/.github/workflows/upload-to-release.yml
