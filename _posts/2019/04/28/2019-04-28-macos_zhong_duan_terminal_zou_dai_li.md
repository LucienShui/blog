---
title: "macOS 终端 Terminal 走代理"
date: 2019-04-28 13:00:00 +0800
last_modified_at: 2020-06-03 14:56:42 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["macos", "代理"]
---

## 设置 Http 代理

```bash
echo "alias proxy='export all_proxy=https://${proxy_addr}:${port}'" >> ~/.bash_profile && source ~/.bash_profile
```

## 设置 Socks5 代理

```bash
echo "alias proxy='export all_proxy=socks5://${proxy_addr}:${port}'" >> ~/.bash_profile && source ~/.bash_profile
```

## 取消代理

```bash
echo "alias unproxy='unset all_proxy'" >> ~/.bash_profile && source ~/.bash_profile
```

## 使用方法

```bash
proxy  # 开始使用代理
unproxy  # 停止使用代理
```