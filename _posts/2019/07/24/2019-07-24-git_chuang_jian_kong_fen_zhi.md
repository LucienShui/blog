---
title: "Git 创建空分支"
date: 2019-07-24 23:19:00 +0800
last_modified_at: 2019-07-24 23:20:13 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "git"]
tags: ["git"]
---

## Git 创建空分支

1. 创建一个没有父节点的分支

    ```bash
    git checkout --orphan <branch name>
    ```

2. 清除暂存区的文件

    ```bash
    git rm --cached -r .
    ```