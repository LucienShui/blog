---
title: "网站部署概述"
date: 2019-10-26 20:38:00 +0800
last_modified_at: 2022-04-24 02:26:43 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站", "建站"]
description: "前些日子一位小伙伴留言说可不可以出一个部署网站的教程，鸽了许久才开始动笔这篇没什么干货的入门教程。"
img_path: /assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/
---

## 网站部署概述

本文地址：[https://blog.lucien.ink/archives/469/][this]

### -2. 前言的前言的前言

> 本文建立在 **已有服务器和域名可被访问** 的假设之上，如果没有的话学生可以购买[阿里云学生机](https://promotion.aliyun.com/ntms/act/campus2018.html)，已经毕业的小伙伴可以使用我的[推广链接](https://promotion.aliyun.com/ntms/yunparter/invite.html?userCode=30tfqka6)获取优惠。没有域名的小伙伴可以去[万网](https://wanwang.aliyun.com)购买域名

> **如果服务器在国外的话域名是不需要备案的**

前些日子一位小伙伴留言说可不可以出一个部署网站的教程，鸽了许久才开始动笔这篇没什么干货的入门教程。

### -1. 前言的前言

越来越多的小伙伴想要部署一个属于自己的博客网站，我也比较推荐自己动手，原因有三：

1. **在实践中学习**
  很多同学都是从部署博客起手的（比如我），然后再慢慢修补、魔改，在这个过程中莫名其妙就知道了各种知识
2. **可塑性强**
  自己的博客可以 99.99% 由自己把控（剩下那 0.01% 交给党和国家），一定程度上不受约束
3. **装\***
  有一个自己搭的博客，吹起牛 B 比较牛 B

但是相比 CSDN、博客园之类的博客平台，自己搭建的博客也有很多*劣势*：

> 以下问题是我在建站过程中印象比较深刻的几个问题，欢迎小伙伴们留言补充

1. **SEO**
  这是一个永恒不变的话题，简而言之就是有了一个自己的博客之后，发现在百度、谷歌等搜索引擎中压根搜不到自己写的文章
2. **访问速度**
  大部分的小伙伴还是比较不是那么富有的，我目前还是用着 ¥10/月 的阿里云学生机，带宽只有 2MB ，服务器在深圳机房，距离稍微远一点的话访问速度就会非常非常非常的慢
3. **垃圾评论**
  有些时候会有一些垃圾评论，虽然没有实质性的影响，但心里还是会多少有一些不快
4. **邮件通知**
  如果有人在博客中评论了你写的文章，或者是你在博客中回复了别人的评论，一般通过邮件来告知对方，但有的时候通知邮件会被视作垃圾邮件
5. **相对永久的 HTTPS**
  我被这个问题困扰过一段时间，之前写过 [让网站永久拥有HTTPS - 申请免费SSL证书并自动续期](https://blog.lucien.ink/archives/81/) 来介绍如何解决这个问题，但后来热心小伙伴又提供了一个更好的方法，我一直没有写出来，后面再补上好了

如何解决这些问题并不是本文的主旨，旨在告诫小伙伴们建立网站之后可能会遇到的一些问题，以可以比较全面地考虑投入产出比。

我也会在以后（挖坑）详细介绍一下我是如何应对这些问题的。

### 0. 前言

本文从一个纯净的 Linux 开始（以 Debian 发行版为例），借助宝塔面板进行 LNMP 环境的安装以及网站（以 Typecho 博客为例）的部署。

### 1. 更新系统的各种组件

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install wget -y
```

### 2. 安装宝塔面板

> 我觉得免费功能就已经非常够用了，有意付费的小伙伴可以到我的[推广链接](https://www.bt.cn/?invite_code=MV9ibGZqbWs=)里领取优惠券

宝塔的官网很好记：[bt.cn](https://www.bt.cn)，可以在[这里](https://www.bt.cn/bbs/thread-19376-1-1.html)找到各种 Linux 发行版一键安装的命令，我的服务器用的是 Debian，所以执行以下语句：

```bash
wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh
```

![installBt.png][installBt.png]

这里输入 `y` 然后回车，走完流程之后宝塔面板就安装好了。

![installBtFinished.png][installBtFinished.png]

安装完成之后会告诉你进入面板的地址、 `username` 和 `password` 用来登陆面板，用户名和密码可以进入面板之后再进行更改，也可以在命令行下执行 `bt` 进行更改。

![bt.png][bt.png]

### 3. 打开各种端口

一些云服务商（比如阿里、腾讯、华为）默认只开放 `22` 、`80`、`443` 这三个端口，剩下的端口需要手动打开，否则无法访问面板。

宝塔面板需要打开的端口在显示初始用户名密码的时候也显示出来了，我在上上张图中也一并圈了出来。

#### 3.1 宝塔提供的开端口教程

1. 阿里云 [https://www.bt.cn/bbs/thread-2897-1-1.html][aliyun]
2. 腾讯云 [https://www.bt.cn/bbs/thread-1229-1-1.html][tencent_cloud]
3. 华为云 [https://www.bt.cn/bbs/thread-3923-1-1.html][huawei_cloud]

### 4. 在宝塔面板中安装 LNMP

![lnmp.png][lnmp.png]

初次进入面板时，会提示你安装环境，在这里我们选择 `LNMP`，PHP 版本选择 7.2，然后点 **一键安装** 就可以。

![lnmpInstalling.png][lnmpInstalling.png]

等待上图完成之后 LNMP 环境就安装完成了。

### 5. 部署网站

#### 5.1 创建网站

![webCreation.png][webCreation.png]

在这里选择数据库的字符集为 `utf8mb4`，创建成功之后将数据库名以及用户名和密码记下来，后面配置博客的时候要用到。

#### 5.2 设置伪静态

![webSetting.png][webSetting.png]

打开为静态，保存。

#### 5.3 下载 Typecho

![download.png][download.png]

Typecho 的官网：[typecho.org][typecho]

将 Tpyecho 的压缩包下载至网站根目录，然后解压，会得到一个名为 `build` 的文件夹。

#### 5.4 更改运行目录

![changeFolder.png][changeFolder.png]

将网站的运行目录指向 `build` 文件夹。

> 也可以直接将 `build` 中的所有文件移动至网站根目录

### 6. 安装 Typecho

在完成了上述步骤之后，你的网站应该就已经可以访问了。访问你的域名，会进入到 Typecho 的初始化设置页面。

#### 6.1 配置 MySQL

![changeMysql.png][changeMysql.png]

在第二步的时候选择 `MySQL`。

![configMySQL.png][configMySQL.png]

在这里填入之前记下来的数据库名以及账号密码。

#### 6.2 设置管理员账户及密码

填入用户名和密码之后，点击下一步即可完成 Typecho 的安装

### 7. 配置 Typecho

安装完成之后，就可以通过域名来访问自己的网站啦，但是会发现 `URL` 中包含一个 `index.php` ，这是因为在 Typecho 中没有配置伪静态的原因。

访问 `<your domain>/admin`，使用刚才设置的用户名和密码登陆，这是 Typecho 的后台管理界面。

#### 7.1 在 Typecho 中设置伪静态

![typechoRewrite.png][typechoRewrite.png]

“是否使用地址重写功能” 被挡住了，选择启用之后保存即可。

### 8. 写在最后

到这里所有的步骤就结束啦，快去访问一下自己的网站看看吧。

搭建完博客并不是结束，仅仅是一个开始。

如有什么疑问的话欢迎留言。

  [this]: https://blog.lucien.ink/archives/469/
  [aliyun]: https://www.bt.cn/bbs/thread-2897-1-1.html
  [tencent_cloud]: https://www.bt.cn/bbs/thread-1229-1-1.html
  [huawei_cloud]: https://www.bt.cn/bbs/thread-3923-1-1.html
  [typecho]: https://typecho.org

  [installBt.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/installbt.png
  [installBtFinished.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/installbtfinished.png
  [bt.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/bt.png
  [lnmp.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/lnmp.png
  [lnmpInstalling.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/lnmpinstalling.png
  [webCreation.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/webcreation.png
  [webSetting.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/websetting.png
  [download.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/download.png
  [changeFolder.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/changefolder.png
  [changeMysql.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/changemysql.png
  [configMySQL.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/configmysql.png
  [typechoRewrite.png]: assets/img/posts/2019/10/26/2019-10-26-wang_zhan_bu_shu_gai_shu/typechorewrite.png