---
title: "PasteMe 技术栈梳理"
date: 2019-08-17 03:16:00 +0800
last_modified_at: 2020-02-14 15:15:58 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站", "程序人生", "pasteme"]
description: "开发 PasteMe 也有一年多了，从刚开始的只有我一个人用到现在的日活上万，即便是一个十分简单的系统，一个人做产品 & 全栈 & 运维 & 客服很不容易，感慨万千，准备在此之后梳理一下用到的一些所谓的技术，以及踩过的一些坑，以供借鉴。本文地址：blog.lucien.ink/archives/464"
---

## PasteMe 技术栈梳理

本文地址：[blog.lucien.ink/archives/464][this]

### 0. 序言

开发 PasteMe 也有一年多了，从刚开始的只有我一个人用到现在的日活上万，即便是一个十分简单的系统，一个人做产品 & 全栈 & 运维 & 客服很不容易，感慨万千，准备在此之后梳理一下用到的一些所谓的技术，以及踩过的一些坑，以供借鉴。

以及，今天也迎来了一位我期盼已久的前端小伙伴，来自阿里巴巴的 [@ryanlee][ryanlee2014]，前端的一些问题会主要甩锅给他啦～

另外，还需要一位 Go 后端的小伙伴，有意向可以发邮件给我哟～

### 1. 运维

1. PasteMe 父项目的更新策略
2. 自动备份网站、数据库

#### 1.1 持续集成

1. [GitHub Actions 持续集成 - 0. 入门][github_actions_0]
2. [GitHub Actions 持续集成 - 1. 自动生成 Release 内容][github_actions_1]
3. [GitHub Actions 持续集成 - 2. 将工程打包并上传至 Release][github_actions_2]
4. [GitHub Actions 持续集成 - 3. 构建 Docker 镜像并推至 Docker Hub][github_actions_3]
5. GitHub Actions 持续集成 - 4. 配合 Webhook 实现服务端同步更新

### 2. 前端

1. [highlight.js 添加行号][highlight.js_line_number]
2. [解决 DOM 更新时 highlight.js 高亮或行号消失][dom_update]

#### 2.1 CDN

1. [将网站内指定类型的资源文件接入 CDN][web_cdn]
2. PasteMe 前端借助持续集成使用 jsDelivr 作为 CDN

#### 2.2 懒加载

1. 图片懒加载
2. i18n 懒加载

### 3. 后端

1. golang sqlite 编译问题
2. Mybatis 指定 xml 位置

### 4. 部署

1. 解决跨域问题
2. Nginx 反向代理子目录

[this]: https://blog.lucien.ink/archives/464/
[ryanlee2014]: https://github.com/ryanlee2014
[github_actions_0]: https://blog.lucien.ink/archives/468/
[github_actions_1]: https://blog.lucien.ink/archives/490/
[github_actions_2]: https://blog.lucien.ink/archives/493/
[github_actions_3]: https://blog.lucien.ink/archives/498/
[highlight.js_line_number]: https://blog.lucien.ink/archives/491/
[dom_update]: https://blog.lucien.ink/archives/492/
[web_cdn]: https://blog.lucien.ink/archives/497/
