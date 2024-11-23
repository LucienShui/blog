---
title: "在 CentOS 8 中使用 KVM 安装 Windows 10"
date: 2020-11-07 12:44:00 +0800
last_modified_at: 2020-11-07 12:46:50 +0800
math: false
render_with_liquid: false
categories: ["操作系统", "Linux"]
description: "使用 esxi 的话总觉得有些别扭？故尝试 KVM，本文使用 CentOS 8 minimal 作为基础环境。"
---

## 在 CentOS 8 中使用 KVM 安装 Windows 10

> 本文地址：[blog.lucien.ink/archives/514/][this]

使用 esxi 的话总觉得有些别扭？故尝试 KVM，本文使用 CentOS 8 minimal 作为基础环境。~~因为懒得截图，所以就决定不上图了。~~

### 使用阿里云镜像

```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
yum makecache
```

### 安装 cockpit 和 qemu

```bash
dnf install cockpit cockpit-machines
```

#### 启用 cockpit

```bash
systemctl enable --now cockpit.socket
```

### 安装 Winodws 依赖的驱动

```bash
dnf install virtio-win
```

### 配置虚拟机网络

略

### 创建 Windows 虚拟机并配置 CDROM

随便使用一个 Windows ISO 都可以，系统里没有 Windows，随便选择一个都可以，我在这里选的是 Fedora 31，创建完系统后不要开机，紧接着需要挂载驱动 ISO 为 CDROM。

挂载 CDROM 在 cockpit 网页端并不支持，详见 [Option to add/remove CD-ROM device and load/eject ISO][github]。

需要手动编辑，假设创建的虚拟机名称为 win10，则可以通过执行 `virsh edit win10` 来进行编辑。

在 `<disk>` 标签所在的组中新增一个 `<disk>`

```xml
<disk type='file' device='cdrom'>
    <driver name='qemu' type='raw'/>
    <source file='/usr/share/virtio-win/virtio-win.iso'/>
    <backingStore/>
    <target dev='sda' bus='sata'/>
    <readonly/>
    <alias name='sata-cdrom'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
```

### 安装 Windows

到了选择磁盘的那一步会发现没有磁盘可选，这个时候需要安装我们挂载的驱动，64 位的话选择 amd64/win10 就 OK 了。

[this]: https://blog.lucien.ink/archives/514/
[github]: https://github.com/cockpit-project/cockpit/issues/13454
