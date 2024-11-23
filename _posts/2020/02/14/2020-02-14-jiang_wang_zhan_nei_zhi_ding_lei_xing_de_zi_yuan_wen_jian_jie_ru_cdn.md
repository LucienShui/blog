---
title: "将网站内指定类型的资源文件接入 CDN"
date: 2020-02-14 14:46:00 +0800
last_modified_at: 2022-04-24 02:26:01 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "网站"]
description: "网站变得花里胡哨了之后，打开速度变得越来越慢。看了一下之后发现是 .js 文件和 .css 文件加载速度太慢了，于是想把所有的 .js 和 .css 文件通过 CDN 进行加载。本文地址：blog.lucien.ink/archives/497"
---

## 将网站内指定类型的资源文件接入 CDN

> 本文地址：[blog.lucien.ink/archives/497][this]

### 0. 摘要

网站变得花里胡哨了之后，打开速度变得越来越慢。看了一下之后发现是 `.js` 文件和 `.css` 文件加载速度太慢了，于是想把所有的 `.js` 和 `.css` 文件通过 CDN 进行加载。

### 1. 难点

#### 1.1 支持动态页面

众所周知，静态页面的话可以直接使用全站 CDN，但是动态页面的话（比如世界上最好的语言）就需要改源码。

希望能够在不更改动态语言源码的情况下就能进行静态文件的 CDN 接入。

#### 1.2 文件同步

对于传统的 CDN 服务，通常文件需要进行更新时，需要手动再将新的文件一个一个上传至 CDN 服务提供方，才能完成文件的更新。

对于这个问题，希望能够自动将网站里需要 CDN 的文件上传至 CDN 服务提供方。

#### 1.3 特定类型的文件才 CDN

对于我来说，我只想将 `.js` 和 `.css` 文件放至 CDN，但是阿里云和腾讯云提供的解决方案会一并把所有的静态文件都 CDN 掉，比如 `.jpeg`、`.png` 等等，此时流量的费用就会变得非常的多了（我的钱包在滴血）。

### 2. 解决方案

我所采用的解决方案就是专门开设一个用来承载 CDN 资源的网站 `cdn.lucien.ink`，对于 `blog.lucien.ink` 来说，对应的资源路径就是 `cdn.lucien.ink/blog.lucien.ink`。

具体的做法就是在 `cdn.lucien.ink` 的网站目录下，通过 `ln -s` 命令将 `blog.lucien.ink` 的文件根目录链接过去，然后再通过阿里云 CDN 服务将 `cdn.lucien.ink` 全站进行 CDN。

这样一来就解决了 CDN 资源同步的问题。

随后在 `blog.lucien.ink` 的 Nginx 配置文件中，加入以下代码：

```conf
location ~ .*\.(js|css)?$
{
    expires      12h;
    error_log off;
    access_log /dev/null;
    rewrite ^(/.*)$ https://cdn.lucien.ink/blog.lucien.ink$1 permanent;
}
```

至此，就可以在不变更源码的情况下，将 `blog.lucien.ink` 全站的 `.css` 和 `.js` 文件都指向 `cdn.lucien.ink` 啦。

### 3. 访问速度

一些小朋友可能会觉得这种方案相比于直接修改源码来说多了一次 Nginx 端的跳转，速度可能会慢。

速度会慢，的确不假。但我觉得跳转一次对访问速度的影响小到可以忽略，而且这么做的性价比更高，原因有三：

1. 跳转记录会被浏览器缓存，所以只有第一次访问时会有速度差异
2. 对网站的侵入性低
3. 对维护者的精力消耗少

### 4. 缓存问题

对网站来说，这一直都是个问题，有很多种解决方案，比如在资源文件的名字中加入 Hash Code，个人认为这种方法最优雅。

我比较懒，对于 `blog.lucien.ink` 来说，每次都是直接暴力刷新一下 `cdn.lucien.ink` 的 `/` 目录。

[this]: https://blog.lucien.ink/archives/497/