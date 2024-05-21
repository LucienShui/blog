---
title: "Nginx在域名301的情况下SSL"
date: 2018-06-16 16:09:00 +0800
last_modified_at: 2018-06-16 16:11:38 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站", "其它"]
---

&emsp;&emsp;前几天突然发现一件事，就是访问Google和Baidu的根域名都会跳转到`www`的域名下，没有搜到为什么要这样做，但还是效仿着搞一搞吧。

&emsp;&emsp;对我个人来说，`301`跳转之后存在一个历史问题，就是以前我在很多地方留的链接地址都是[https://lucien.ink](https://www.lucien.ink)，这样的话在我开了`301`跳转之后，通过`80`端口验证的时候申请/续期不了`Let's Encrypt`的证书，通过`443`端口验证的话又要暂停一下`Nginx`以解决端口占用的问题，很麻烦。而不开`443`的时候`https`又访问不了，开了`443`却不搞`ssl`就会被浏览器拦截，很无语。

&emsp;&emsp;所以说要么我每次手动搞一搞，要么想一个办法让网站可以在`301`的情况下搞一搞`Let's Encrypt`。

&emsp;&emsp;百度谷歌无果，自己尝试着写了一下，大体思路就是如果当前请求的链接里含有`.well-known`的话就不`301`跳转，比想象中要简单得多。

```
server
{
    listen 80;
	listen 443 ssl http2;
    server_name www.lucien.ink;
    index 主页;
    root 网站路径;
}

server
{
    listen 80;
	listen 443 ssl http2;
    server_name lucien.ink;
    root 网站路径;
	if ($request_uri !~* [^\s]*/.well-known/[^\s]*)
    {
    	rewrite ^(/.*)$ https://www.lucien.ink$1 permanent;
    }
}
```