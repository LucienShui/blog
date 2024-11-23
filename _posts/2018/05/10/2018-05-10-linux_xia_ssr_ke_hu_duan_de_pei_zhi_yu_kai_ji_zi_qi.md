---
title: "Linux下SSR客户端的配置与开机自启"
date: 2018-05-10 19:21:00 +0800
last_modified_at: 2019-10-28 15:02:44 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["linux", "其它"]
img_path: /assets/img/posts/2018/05/10/2018-05-10-linux_xia_ssr_ke_hu_duan_de_pei_zhi_yu_kai_ji_zi_qi/
---

## 本文永久链接

https://www.lucien.ink/archives/208/

## 环境

&emsp;&emsp;需要有`git`、`python3`，如果没有的话：

### Ubuntu
```
sudo apt install git python3 -y
```

### CentOS
```
sudo yum install git python3 -y
```

## 配置SSR

### 下载安装

```bash
sudo git clone https://github.com/LucienShui/shadowsocksr.git -b manyuser --depth=1 ~/shadowsocksr
echo "python3 ~/shadowsocksr/shadowsocks/server.py -c ~/shadowsocksr/config.json -d start" > ~/ssr.sh
```


### 编辑SSR的配置文件

&emsp;&emsp;把上面的命令拷到控制台里，运行结束后，执行`sudo gedit ~/shadowsocksr/config.json`来编辑你的连接信息，具体的服务器地址，端口，密码，加密方式，协议插件，混淆插件从SSR帐号提供商那里获取。

&emsp;&emsp;主要用到的是以下这几个选项：

```json
"server": "0.0.0.0",         # 服务器地址
"server_port": 80890,        # 端口
"password": " ",             # 密码
"method": "chacha20",        # 加密方式
"protocol": "auth_sha1_v4",  # 协议插件
"obfs": "http_simple",       # 混淆插件
```

### 启动SSR客户端

&emsp;&emsp;在`~`目录下有一个`ssr.sh`，输入`~/ssr.sh`就可以启动客户端。

## 配置开机自启动

&emsp;&emsp;`GNOME`和`Unity`桌面环境可以直接打开`Startup Applications Preferences`，然后在里面添加一个`~/ssr.sh`的启动项即可，`KDE`同理。

![Screenshot from 2018-06-18 00-15-23.png][1]

## 关闭SSR

执行以下命令：
`python3 ~/shadowsocksr/shadowsocks/server.py -c ~/shadowsocksr/config.json -d stop`

## 配置浏览器

---

&emsp;&emsp;因为某些原因（我不是很清楚），在大多数Linux下只成功启动ssr客户端的话会发现并没有什么作用，该进不去的仍然进不去，在这里就直接讲在Chrome内自动代理（国内走直连，特定网站走ssr）的解决方案吧。

### 安装SwitchyOmega

---

#### Chrome

&emsp;&emsp;进入https://file.lucien.ink/SwitchyOmega，下载
```
SwitchyOmega.crx
```
&emsp;&emsp;然后在`Chrome`里打开[chrome://extensions](chrome://extensions)，把`SwitchyOmega.crx`文件拖放到扩展程序页面，点击添加扩展程序进行安装。

#### Firefox

&emsp;&emsp;进入https://addons.mozilla.org/zh-CN/firefox/addon/switchyomega/，点击添加即可。

### 配置SwitchyOmega

&emsp;&emsp;打开`SwitchyOmega`的设置页面，跳过设置向导，点击导入/导出、在线恢复，填入`https://file.lucien.ink/SwitchyOmega/OmegaOptions.bak`，恢复完成后点击应用选项。


  [1]: assets/img/posts/2018/05/10/2018-05-10-linux_xia_ssr_ke_hu_duan_de_pei_zhi_yu_kai_ji_zi_qi/screenshotfrom2018_06_1800_15_23.png