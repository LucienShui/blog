---
title: "PVE 虚拟机心跳检测并重启"
date: 2022-09-18 14:21:00 +0800
last_modified_at: 2022-12-24 14:35:06 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "软路由"]
tags: ["软路由"]
---

## PVE 虚拟机心跳检测并重启

> 本文地址：[blog.lucien.ink/archives/531][this]

不知为何，PVE 中的 OpenWrt 时不时会宕机，这是背景。秉承着能用就行的思想，写了一个脚本，每隔一分钟检测一次虚拟机是否有心跳，如果没有心跳，就强制重启虚拟机，记录在这里。

```shell
## !/usr/bin/env bash
function check_and_restart() {
    vm_id="${1}"
    vm_ip="${2}"
    # curl --connect-timeout 5 -sSL "${vm_ip}" > /dev/null
    ping -c 1 "${vm_ip}" > /dev/null
    if [[ $? != 0 ]]; then
        now=`timedatectl status | grep 'Local time' | awk -F"Local time: " '{ print $2 }'`
        echo "[${now}] [NO] id = ${vm_id}, ip = ${vm_ip}"
        /usr/sbin/qm stop "${vm_id}"
        /usr/sbin/qm start "${vm_id}"
    fi
}

function main() {
    vm_list=${1}
    for each in ${vm_list}; do
        vm_id=`echo "${each}" | awk -F: '{ print $1 }'`
        vm_ip=`echo "${each}" | awk -F: '{ print $2 }'`
        check_and_restart "${vm_id}" "${vm_ip}"
    done
}

## 需要检查的虚拟机列表，格式为 vm_id:vm_ip
vm_list="
100:10.0.0.1
101:10.0.0.2
"

## 打印时间
## timedatectl status | grep 'Local time' | awk -F"Local time: " '{ print $2 }'

main "${vm_list}"
```

以我自己为例，将以上文件保存至 `/root/check_and_restart/check_and_restart.sh`，然后在 `crontab` 里写入：

```shell
*/1 * * * * bash /root/check_and_restart/check_and_restart.sh >> /root/check_and_restart/log.txt
```

随后执行 `systemctl restart cron` 即可。

[this]: https://blog.lucien.ink/archives/531/
