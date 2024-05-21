---
title: "在线二维码生成API"
date: 2018-06-20 03:00:00 +0800
last_modified_at: 2018-06-20 03:05:16 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "网站"]
---

### 前言

&emsp;&emsp;上周的时候需要实现一个生成在线二维码的功能，鉴于网上的大部分API都会在二维码生成的后面加上若干奇奇怪怪的东西，比如说用来商业SEO的特征码，看起来很不舒服，于是就自己写了一个。

### 项目地址

[https://github.com/LucienShui/QRCode-Generator](https://www.lucien.ink/go/qrcode-github/)

## QRCode Generator

在线生成二维码，支持GET调用。

## 调用方法

生成一个内容为**example**的二维码：`qrcode.lucien.ink/?text=example`

生成一个内容为**example**且带有标签**something**的二维码：`qrcode.lucien.ink/?text=example&tag=something`

## 鸣谢

javascript脚本来自: [davidshimjs](https://github.com/davidshimjs/qrcodejs)
