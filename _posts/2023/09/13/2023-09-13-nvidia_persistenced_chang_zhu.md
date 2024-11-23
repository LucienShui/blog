---
title: "nvidia-persistenced 常驻"
date: 2023-09-13 01:30:21 +0800
last_modified_at: 2023-09-13 01:30:21 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "运维"]
tags: ["linux", "cuda"]
description: "发现每次执行 nvidia-smi 都特别慢，发现是需要 nvidia-persistenced 常驻才可以，这个并不会在安装完驱动之后自动配置，需要手动设置一个自启。"
---

> 本文地址：[blog.lucien.ink/archives/542][this]

发现每次执行 `nvidia-smi` 都特别慢，发现是需要 `nvidia-persistenced` 常驻才可以，这个并不会在安装完驱动之后自动配置，需要手动设置一个自启。

```shell
cat <<EOF >> /etc/systemd/system/nvidia-persistenced.service
[Unit]
Description=NVIDIA Persistence Daemon
Wants=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/nvidia-persistenced
ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start nvidia-persistenced
systemctl enable nvidia-persistenced
```

[this]: https://blog.lucien.ink/archives/542/
