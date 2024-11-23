---
title: "GitHub Actions 持续集成 - 3. 构建 Docker 镜像并推至 Docker Hub"
date: 2020-02-14 15:09:00 +0800
last_modified_at: 2020-02-14 15:13:00 +0800
math: true
render_with_liquid: false
categories: ["工程", "持续集成"]
tags: ["持续集成", "工程"]
description: "上篇文章介绍了如何借助 GitHub Actions 在 Release 时自动上传打包好的工程。本篇文章旨在介绍将 Dockerfile 构建出来的镜像上传至 Docker Hub。本文地址：blog.lucien.ink/archives/498"
---

## GitHub Actions 持续集成 - 3. 构建 Docker 镜像并推至 Docker Hub

> 本文地址：[blog.lucien.ink/archives/498][this]

### 0. 摘要

之前挖了一个[坑][keng]，慢慢补上。

上篇文章介绍了如何借助 GitHub Actions 在 Release 时自动上传打包好的工程。本篇文章旨在介绍将 Dockerfile 构建出来的镜像上传至 Docker Hub。

### 1. 现成的轮子

使用此 Action 可以将通过 `Dockerfile` 生成的镜像上传至 Docker Hub。

[github.com/elgohr/Publish-Docker-Github-Action][publish_docker]

#### 1.1 稍作修改

原作支持将 release 的 tag 当作 docker image 的 tag。

但是我之前都是使用的阿里云的命名规则，假设 release 的 tag 为 `release-v3.1`，那么 docker image 的 tag 就会是 `3.1`。

为了保持命名风格的统一，我对原作进行了[修改][modify]。

### 2. GitHub Actions 配置

[.github/workflows/upload-to-release.yml][upload_to_release]

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

      - name: Publish Docker
        uses: LucienShui/Publish-Docker-Github-Action@2.7.1
        with:
          name: registry.cn-hangzhou.aliyuncs.com/pasteus/hello-ci # docker image 的名字
          username: ${{ secrets.DOCKER_USERNAME }} # 用户名
          password: ${{ secrets.DOCKER_PASSWORD }} # 密码
          registry: registry.cn-hangzhou.aliyuncs.com # 阿里巴巴的 Docker Hub
          dockerfile: Dockerfile # 指定 Dockerfile 的位置
          tag_names: true # 是否将 release 的 tag 作为 docker image 的 tag
```

#### 2.1 Dockerfile

[Dockerfile][dockerfile]

```dockerfile
FROM alpine:3
LABEL maintainer="Lucien Shui" \
      email="lucien@lucien.ink"
WORKDIR /root/
COPY main ./app
CMD ["./app"]
```

[this]: https://blog.lucien.ink/archives/498/
[keng]: https://blog.lucien.ink/archives/464/
[publish_docker]: https://github.com/elgohr/Publish-Docker-Github-Action
[upload_to_release]: https://github.com/LucienShui/HelloCI/blob/master/.github/workflows/upload-to-release.yml
[modify]: https://github.com/LucienShui/Publish-Docker-Github-Action/commit/ff95ce0e5c53c13a41831d4e6a509f0c7b697417
[dockerfile]: https://github.com/LucienShui/HelloCI/blob/master/Dockerfile
