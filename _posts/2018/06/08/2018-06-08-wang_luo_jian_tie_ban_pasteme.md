---
title: "网络剪贴板 PasteMe"
date: 2018-06-08 01:37:00 +0800
last_modified_at: 2019-05-22 10:57:49 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站", "其它"]
---

## GitHub项目主页

https://github.com/LucienShui/PasteMe

PasteMe 是一个无需注册的文本分享平台，针对代码提供了额外的高亮功能。

+ 在存储内容时，**设置密码**和**阅后即焚**可以高度保证用户内容的安全性和私密性。

+ 在将自己的内容分享给别人时，提供了一键复制链接和二维码分享等多种途径。

+ 在查看别人的内容时，可以一键复制所有文本。如果查看的是阅后即焚的内容，那么在网页加载完成之前，实体数据就已经不存在了。

性能方面，PasteMe 2.0 采用了喜闻乐见的前后端分离，由于历史原因，目前后端是 PHP + MySQL ，前端是 Vue + Bootstrap ，主站点 https://pasteme.cn 已开启了全站 CDN 和 gzip 压缩传输。

下一步的计划是用 `golang` 重构后端之后采用 `Docker` 进行打包/发布。

各位老板 Star 、Issue 、PR 好不啦。**Orz**

### 一些场景

+ 如果你要发布一个脚本，可以把 `Bash` 或者 `Python` 等脚本上传至 `PasteMe` ，然后通过 `curl` 和管道机制来进行优雅的发布，比如：`curl api.pasteme.cn?token=8219 | python3`

+ 如果你要发给某人一些私密的信息，但是通过 QQ 、微信等聊天工具可能会被查水表，你可以将私密信息以阅后即焚形式上传至 `PasteMe` ，将产生的一次性链接分享给别人，别人查看一次之后这个链接就会失效。

+ 阅后即焚的链接是可以自定义的，比如 https://pasteme.cn/Hello ，更多详情请查看 [GitHub 项目主页](https://github.com/LucienShui/PasteMe)。

### 截图

![homePage](https://github.com/LucienShui/gitcdn/blob/master/pasteme_home2.0.png?raw=true)

![homePageEN](https://github.com/LucienShui/gitcdn/blob/master/pasteme_home_en2.0.png?raw=true)

![chat](https://github.com/LucienShui/gitcdn/blob/master/pasteme_chat2.0.png?raw=true)

![read_once](https://github.com/LucienShui/gitcdn/blob/master/pasteme_read_once2.0.png?raw=true)

![hello_world](https://github.com/LucienShui/gitcdn/blob/master/pasteme_hello_world2.0.png?raw=true)

![success](https://github.com/LucienShui/gitcdn/blob/master/pasteme_success2.0.png?raw=true)

![success_qrcode](https://github.com/LucienShui/gitcdn/blob/master/pasteme_success_qrcode2.0.png?raw=true)
