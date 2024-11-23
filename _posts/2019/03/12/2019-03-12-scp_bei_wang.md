---
title: "SCP 备忘"
date: 2019-03-12 11:14:00 +0800
last_modified_at: 2019-03-12 11:16:31 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

https://pasteme.cn/4452

```bash
scp -P <port> <local_file_path> <username>@<remote>:<remote_file_path> # 本地向远端拷贝
scp -P <port> <username>@<remote>:<remote_file_path> <local_file_path> # 远端向本地
## <port>                端口号，默认 22
## <local_file_path>     本地文件路径
## <username>            远端用户名
## <remote>              远端地址，IP 或 域名。
## <remote_file_path>    远端文件路径，最好是绝对路径
```