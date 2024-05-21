---
title: "GitHub Actions 持续集成 - 1. 自动生成 Release 内容"
date: 2020-02-09 20:24:00 +0800
last_modified_at: 2020-02-09 20:36:42 +0800
math: true
render_with_liquid: false
categories: ["工程", "持续集成"]
tags: ["持续集成", "工程"]
description: "本文章旨在介绍如何借助 GitHub Actions 来生成 Release 的内容，以避免每次进行 Release 的时候都要写各种各样的变更日志。本文地址：blog.lucien.ink/archives/490"
---

## GitHub Actions 持续集成 - 1. 自动生成 Release 内容

本文地址：[blog.lucien.ink/archives/490][this]

### 0. 摘要

之前挖了一个[坑][keng]，慢慢补上。

本文章旨在介绍如何借助 GitHub Actions 来生成 Release 的内容，以避免每次进行 Release 的时候都要写各种各样的变更日志。

### 1. 原理

通过 [github.com/release-drafter/release-drafter][release_drafter]，将 [.github/release-drafter.yml][.github/release-drafter.yml] 作为模版文件，借助 pull reqeust 时标注的 tag 来进行 Release 内容的生成。

效果见：[github.com/LucienShui/HelloCI/releases][github.com/LucienShui/HelloCI/releases]

一些其它更高级的用法见 release-drafter 的[项目主页][release_drafter]。

### 2. 配置

#### 2.1 GitHub Actions 文件

[.github/workflows/release-drafter.yml][.github/workflows/release-drafter.yml]

```yml
name: Release Drafter

on:
  push:
    branches:
      - master # 在 master 分支发生更新时执行此 action

jobs:
  draft_release:
    name: Draft release
    runs-on: ubuntu-latest
    steps:
      - uses: toolmantim/release-drafter@v5.2.0
        name: Draft
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

##### 2020 年 2 月 9 日更新

在我写这篇博客的时候此项目名为 `toolmantim/release-drafter`，现在已更新为 `release-drafter/release-drafter`，最新版本号见：[这里][here]

#### 2.2. Release Drafter 配置文件

[.github/release-drafter.yml][.github/release-drafter.yml]

```yml
name-template: 'release-v$NEXT_PATCH_VERSION'
tag-template: 'release-v$NEXT_PATCH_VERSION'
categories:
  - title: 'Features'
    labels:
      - 'feature'
      - 'enhancement'
  - title: 'Bug Fixes'
    labels:
      - 'fix'
      - 'bugfix'
      - 'bug'
  - title: 'Maintenance'
    labels:
      - 'chore'
      - 'documentation'
change-template: '- $TITLE (#$NUMBER) @$AUTHOR'
template: |
  # Changes

  $CHANGES
```

[this]: https://blog.lucien.ink/archives/490/
[keng]: https://blog.lucien.ink/archives/464/
[release_drafter]: https://github.com/release-drafter/release-drafter
[.github/release-drafter.yml]: https://github.com/LucienShui/HelloCI/blob/b933d59047f34084b16f31ab12361a37f15e3d2d/.github/release-drafter.yml
[github.com/LucienShui/HelloCI/releases]: https://github.com/LucienShui/HelloCI/releases
[.github/workflows/release-drafter.yml]: https://github.com/LucienShui/HelloCI/blob/b933d59047f34084b16f31ab12361a37f15e3d2d/.github/workflows/release-drafter.yml
[here]: https://github.com/release-drafter/release-drafter/releases
