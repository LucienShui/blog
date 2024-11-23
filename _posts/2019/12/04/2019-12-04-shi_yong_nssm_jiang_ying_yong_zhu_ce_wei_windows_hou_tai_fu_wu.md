---
title: "使用 nssm 将应用注册为 Windows 后台服务"
date: 2019-12-04 23:46:00 +0800
last_modified_at: 2019-12-04 23:48:51 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Windows"]
tags: ["windows", "操作系统"]
---

## 使用 nssm 将应用注册为 Windows 后台服务

本文地址：[blog.lucien.ink/archives/485](https://blog.lucien.ink/archives/485/)

### 起因

一直放在学校的 Linux 服务器被撤了，以前是通过这台 Linux 服务器上的 `frpc` 将另一台 Windows 电脑的 `3389` 端口代理到云服务器上，现在没了这台 Linux 服务器的话，就只能将 `frpc` 开在 Windows 里了，于是如何让 `frpc` 稳定、安静地在后台常驻便成了一个问题。

尝试过使用最高权限通过 `任务计划程序` 将 `frpc` 设置为系统启动时一并启动，但是不是很稳定，有时候还是会掉，又搜了搜，发现了 `nssm` 这个大宝贝，官网地址为 [nssm.cc](https://nssm.cc) 。

### 使用方法

使用起来很简单，在这里就只是简单记录一下命令。

```bash
nssm install <servicename>
nssm remove <servicename>
nssm start <servicename>
nssm stop <servicename>
nssm restart <servicename>
nssm edit <servicename>
```

分别对应注册服务、删除服务、启动服务、停止服务、重启服务、编辑服务。
