---
title: "树莓派安装 OMV"
date: 2020-12-09 16:56:00 +0800
last_modified_at: 2020-12-09 20:49:59 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "树莓派"]
tags: ["树莓派"]
description: "终究还是忍住了，没有出手买 x86 的 NAS，选择自己折腾树莓派。（因为实在是太穷了）"
---

## 树莓派安装 OMV

> 本文地址：[blog.lucien.ink/archives/517][this]

终究还是忍住了，没有出手买 x86 的 NAS，选择自己折腾树莓派。（因为实在是太穷了）

### 1. 初始化树莓派

参考 [树莓派初始化备忘][init] 对树莓派做初始化。

### 2. 安装 OMV

```bash
sudo apt update
sudo apt upgrade -y
sudo rm -f /etc/systemd/network/99-default.link
sudo reboot
```

重启完成之后执行以下代码即可。

```bash
wget -O - https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/install | sudo bash
```

### Reference

1. [Adden-B-Installing_OMV5_on_an R-PI.pdf][github-doc]
2. [树莓派 配置 OMV 搭建 NAS（二） 配置 OMV 5][cnblogs]

[this]: https://blog.lucien.ink/archives/517/
[init]: https://blog.lucien.ink/archives/515/
[github-doc]: https://github.com/OpenMediaVault-Plugin-Developers/docs/blob/master/Adden-B-Installing_OMV5_on_an%20R-PI.pdf
[cnblogs]: https://www.cnblogs.com/Yogile/p/12577269.html
