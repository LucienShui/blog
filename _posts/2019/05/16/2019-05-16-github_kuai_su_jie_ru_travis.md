---
title: "GitHub 快速接入 Travis"
date: 2019-05-16 00:26:00 +0800
last_modified_at: 2019-07-24 23:25:40 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "自动化", "懒人"]
---

### 原文地址

https://www.lucien.ink/archives/428/

### 简介

最近挖了一个 Vue 的坑，每更新一次 Master 分支之前还得先把项目编译一遍并进行一定的打包，略繁琐，搜索之，发现可以把编译/打包的过程交给 [Travis](https://www.travis-ci.com) 来做。

需要注意的是，https://www.travis-ci.com 和 https://www.travis-ci.org 的账号数据库是完全独立的，`org` 将被整合至 `com` ，所以在此推荐使用 https://www.travis-ci.com ，以及目前 Travis 支持且仅支持 GitHub ，所以 GitLab、Gitee 的小伙伴们得另寻途径了。

### 过程

#### GitHub

1. 进入 [https://github.com/settings/tokens](https://github.com/settings/tokens)，创建一个 `Token` ，后面要用到，名字随意，权限的话除了 `delete_repo` 其它都可以钩上

#### Travis

1. 用 GitHub 账号登陆 Travis
2. 在 Travis 中选择要 Active 的项目
3. 然后点右上角的 More options -> settings
4. 找到 Environment Variables 一栏，`Name` 处填入 `GH_TOKEN` ，`Value` 处填在 [https://github.com/settings/tokens](https://github.com/settings/tokens) 获得的 `Token` ，然后点击右边的 `Add`

#### Project

> 以 Vue 项目为例

随后在项目的根目录中创建一个名为 `.travis.yml` 的文件，内容如下

```yaml
language: node_js # 语言
node_js:
  - "11" # 版本

install:
  - npm install # 默认的初始目录为 repo 的根目录

script:
  - npm run build # 如果只是要检测项目是否可以成功 build 的话到这一步就够了

after_success: # 这一步是将编译好的项目 push 到另一个分支上
  - cd dist # 进入编译好的目录
  - git init # 初始化
  - git config --global user.name "${U_NAME}" # 设置用户名
  - git config --global user.email "${U_EMAIL}" # 设置邮箱
  - git add .
  - git commit -m "Automatically build from travis-ci"
  - git push --quiet --force  "https://${GH_TOKEN}@${GH_REF}" master:${P_BRANCH}

branches:
  only:
    - master # 只响应 master 分支，可以自行更改

notifications:
  email:
    - <your_email> # 如果条件被触发会往邮箱发邮件
  on_failure: always # 这里的条件就是 script 失败的时候

## Note: you should set Environment Variables here or 'Settings' on travis-ci.org
env:
  global:
    - GH_REF: github.com/<your_account>/<your_repo>.git
    - P_BRANCH: <your_branch>
    - U_NAME: <your_account>
    - U_EMAIL: <your_main_email_in_github>
```

### 举个栗子

实际的例子可以参考 [.travis.yml in PasteMe](https://github.com/LucienShui/PasteMe/blob/master/.travis.yml)

### 参考

其它语言、用法请参考 [持续集成服务 Travis CI 教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2017/12/travis_ci_tutorial.html)