---
title: "使用 vlmcsd 搭建微软 KMS 激活服务器"
date: 2019-05-20 11:27:00 +0800
last_modified_at: 2022-04-24 02:25:24 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生", "系统"]
description: "身在天朝，很多人都会使用一些 KMS 激活软件来激活 Windows 或者是 Office ，其实 KMS 的本质就是让系统连接上一个认证服务器，通过认证服务器来验证当前用户是否有使用系统全部功能的权限。但事实上，网上搜到软件并不是很能让人放心，因为软件本身通常会需要一些系统权限，而且会被杀毒软件认为是病毒，而直接通过 CMD 来进行 KMS 认证显然是一种绿色无毒无害的方式。"
---

## 使用 vlmcsd 搭建微软 KMS 激活服务器

> 本文地址：[blog.lucien.ink/archives/435](https://blog.lucien.ink/archives/435)

如果你是一名无心学习的伸手党，可以直接看文章底部章节 8 的 "伸手党福利" 部分。

如果你是一名无心学习又懒得自己部署的伸手党，可参考 [Windows & Office KMS 激活](https://blog.lucien.ink/archives/462/)

### 2. 声明

文章本着学习 `systemd` 的目的，探究如何使用 `systemd` 来托管 `vlmcsd` 这样的原生后台进程，仅供学习交流，仅代表个人言论，与任何组织无关，严禁商用。

本文中的 `vlmscd` 来自 [github.com/kkkgo/vlmcsd](https://github.com/kkkgo/vlmcsd) ，另附上可执行文件的 [下载地址](https://github.com/kkkgo/vlmcsd/releases)。

### 3. 介绍

身在天朝，很多人都会使用一些 KMS 激活软件来激活 Windows 或者是 Office ，其实 KMS 的本质就是让系统连接上一个认证服务器，通过认证服务器来验证当前用户是否有使用系统全部功能的权限。

但事实上，网上搜到软件并不是很能让人放心，因为软件本身通常会需要一些系统权限，而且会被杀毒软件认为是病毒，而直接通过 CMD 来进行 KMS 认证显然是一种绿色无毒无害的方式。

值得注意的是，KMS 激活的有效期只有 180 天，到期之后会自动连接 KMS 服务器进行激活，所以推荐将 `vlmcsd` 部署成服务器中的常驻服务。

### 4. 缓存

防止和谐，我将截止 **2019 年 5 月 20 日** 的最新版本缓存至我的[个人资源服务器](https://mirrors.lucien.ink/vlmcsd/)，里面有 `1112` 版本的 `vlmscd` ，如果担心我动手脚可以去 `GitHub` 自行下载。

### 5. 版本选择

一般来说：
+ 树莓派等 arm 设备 `Linux` 用户下载 [Linux-arm-1112.zip](https://mirrors.lucien.ink/vlmcsd/Linux-arm-1112.zip)
+ VPS、虚拟机等 `Linux` 用户下载 [Linux-intel-1112.zip](https://mirrors.lucien.ink/vlmcsd/Linux-intel-1112.zip)
+ `Windows` 用户下载 [Windows-intel-1112.zip](https://mirrors.lucien.ink/vlmcsd/Windows-intel-1112.zip)

### 6. 部署

需要注意的是，`vlmcsd` 需要使用 `1688` 端口，所以请保证这个端口没被占用，且系统的 `1688` 端口需开启外部访问的权限。

#### 6.1 Linux

##### 6.1.1 安装

下载对应版本的 `zip` 文件之后，将其解压至 `/usr/local/vlmcsd` 下。

在 `/usr/local/vlmcsd` 下新建一个文件 `vlmcsd.service` ，填入以下内容并保存：

```service
[Unit]
Description=Microsoft KMS Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/vlmcsd/static/vlmcsd-x64-musl-static
RemainAfterExit=yes
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

执行到这一步，文件目录应该是这样的：

```plain
/usr/local/vlmcsd
├── glibc
│   └── ...
├── musl
│   └── ...
├── static
│   ├── vlmcsd-x64-musl-static
│   └── ...
├── uclibc
│   └── ...
└── vlmcsd.service
```

然后执行：

```bash
chmod +x /usr/local/vlmcsd/static/vlmcsd-x64-musl-static # 赋予执行权限
ln -s /usr/local/vlmcsd/vlmcsd.service /lib/systemd/system/ # 添加系统服务单元
systemctl daemon-reload # 重载系统服务单元
```

到这里，我们就已经完成了 `vlmcsd` 的安装。

##### 6.1.2 启动/停止/查看状态

```bash
systemctl start vlmcsd # 启动 vlmcsd
systemctl stop vlmcsd # 停止 vlmcsd
systemctl status vlmcsd # 查看运行状态
```

##### 6.1.3 开机自启/取消开机自启

```bash
systemctl enable vlmcsd # 设置开机自启
systemctl disable vlmcsd # 取消开机自启
```

##### 6.1.4 卸载

```bash
systemctl stop vlmcsd # 停止 vlmscd
systemctl disable vlmcsd # 取消开机自启
rm -f /lib/systemd/system/vlmcsd.service # 删除系统服务单元
systemctl daemon-reload # 重载系统服务单元
rm -rf /usr/local/vlmcsd # 删除源文件
```

> 执行完上述命令之后没有任何 vlmcsd 相关文件残留

#### 6.2 Windows

应该没人用 `Windows` 当服务器系统吧，鸽。

### 7. 激活

#### 7.1 Windows

以管理员身份打开 `cmd` 窗口，执行以下命令：

```bat
slmgr /skms <部署了 vlmcsd 的 Server 的 IP 或域名>
slmgr /ato
```

#### 7.2 Office

以管理员身份打开 `cmd` 窗口，执行以下命令：

```bat
cscript ospp.vbs /sethst:<部署了 vlmcsd 的 Server 的 IP 或域名>
cscript ospp.vbs /act
```

### 8. 伸手党福利

如果你是一名伸手党，觉得上述过程过于详细，看起来很麻烦，那么你可以尝试一下我写好的一键脚本：

详细的脚本内容可以通过访问 `https://pasteme.cn/<id>` 查看对应的内容。

#### 8.1 安装

```bash
curl api.pasteme.cn/8217 | bash
```

#### 8.2 卸载

```bash
curl api.pasteme.cn/8218 | bash
```