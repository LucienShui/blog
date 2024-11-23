---
title: "OpenWrt 安装 OpenClash"
date: 2022-05-05 23:11:59 +0800
last_modified_at: 2022-05-05 23:11:59 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "软路由"]
description: "截止 2022 年 5 月 5 日，OpenWrt 的最新版本为 21.02.3，OpenClash 的最新版本为 v0.45.12-beta，在安装的过程中，遇到一些小问题，于是将安装过程写在这里记录一下。"
---

## OpenWrt 安装 OpenClash

> 本文地址：[blog.lucien.ink/archives/528][this]

截止 2022 年 5 月 5 日，OpenWrt 的最新版本为 `21.02.3`，OpenClash 的最新版本为 `v0.45.12-beta`，在安装的过程中，遇到一些小问题，于是将安装过程写在这里记录一下。

### 1. 安装依赖

1. 卸载 dnsmasq

```bash
opkg remove dnsmasq
mv /etc/config/dhcp /etc/config/dhcp.bak
```

2. 安装依赖（除了 luci-compat）

```bash
opkg install luci luci-base iptables dnsmasq-full coreutils coreutils-nohup bash curl jsonfilter ca-certificates ipset ip-full iptables-mod-tproxy kmod-tun
```

3. 安装 luci-compat

在 `21.02.3` 版本的 OpenWrt 中，执行 `opkg install luci-compat` 只会提示找不到匹配的软件包，所以需要手动安装。

从 [Luci-compat Download for Linux (ipk)][download_page] 将 IPK 下载至 `/tmp` 后，执行 `opkg install` 即可。

### 2. 安装 OpenClash

参考 [OpenClash Wiki][github_wiki]，从 [Release][github_release] 页面下载最新的 IPK 后，安装即可。

### 3. 参考文章

1. [OpenClash Wiki][github_wiki]
2. [缺失依赖项 luci-compat #2229][github_issue]

[this]: https://blog.lucien.ink/archives/528/
[github_issue]: https://github.com/vernesong/OpenClash/issues/2229
[github_wiki]: https://github.com/vernesong/OpenClash/wiki/%E5%AE%89%E8%A3%85
[github_release]: https://github.com/vernesong/OpenClash/releases
[download_page]: https://pkgs.org/download/luci-compat