---
title: "树莓派禁用 Wi-Fi 和蓝牙"
date: 2020-12-09 16:34:00 +0800
last_modified_at: 2020-12-09 20:50:08 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "树莓派"]
tags: ["树莓派"]
description: "因为我的树莓派是直接通过网线连接的，并没有启用 Wi-Fi，所以在每次 SSH 连进去之后 Raspbian 都会给我一个大意为 “你没有配置 Wi-Fi，如果想要启用，可执行 xxx” 的提示，略烦人，故禁用之。"
---

## 树莓派禁用 Wi-Fi 和蓝牙

> 本文地址：[blog.lucien.ink/archives/516][this]

因为我的树莓派是直接通过网线连接的，并没有启用 Wi-Fi，所以在每次 SSH 连进去之后 Raspbian 都会给我一个大意为 “你没有配置 Wi-Fi，如果想要启用，可执行 xxx” 的提示，略烦人，故禁用之。

### 1. 步骤

> 参考 [Disable WiFi (wlan0) on Pi 3][disable-wifi]

因为我也用不到蓝牙，索性也一起禁用了。

编辑 `/boot/config.txt`，在末尾添加两行之后重启即可。

```conf
dtoverlay=disable-wifi
dtoverlay=disable-bt
```

[this]: https://blog.lucien.ink/archives/516/
[disable-wifi]: https://raspberrypi.stackexchange.com/questions/43720/disable-wifi-wlan0-on-pi-3