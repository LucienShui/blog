---
title: "Debian 使用 systemd 自动挂载 Samba"
date: 2023-08-29 01:11:00 +0800
last_modified_at: 2023-09-23 17:12:49 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "运维"]
tags: ["linux"]
description: "本文介绍了如何使用 systemd 实现开机自动挂载 samba 共享"
---

> 本文地址：[blog.lucien.ink/archives/540][this]

写成了一键脚本，直接执行即可。

需要注意的是，挂载的路径和 systemd service 的名字要对应上，比如挂载的路径为 `/mnt/nas` 那 service 的文件名应为 `mnt-nas.service`。

```shell
## !/usr/bin/env bash

SERVER="nas.local"
USERNAME="foo"
PASSWORD="bar"

apt install cifs-utils -y

groupadd -g 17510 nas

cat <<EOF > /etc/systemd/system/dns-ready.service
[Unit]
Description=Wait for DNS to come up using 'host'
After=nss-lookup.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "until host ${SERVER}; do sleep 1; done"

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/mnt-nas.mount
[Unit]
Description=Mount NAS
Requires=network-online.target
After=network-online.target dns-ready.service

[Mount]
What=//${SERVER}/Data
Where=/mnt/nas
Type=cifs
Options=username=${USERNAME},password=${PASSWORD},dir_mode=0775,gid=nas,rw,file_mode=0664

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl start dns-ready.service
systemctl enable dns-ready.service

systemctl start mnt-nas.mount
systemctl enable mnt-nas.mount
```

[this]: https://blog.lucien.ink/archives/540/