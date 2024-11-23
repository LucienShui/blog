---
title: "ETCD 从入门到放弃"
date: 2019-05-05 17:32:00 +0800
last_modified_at: 2022-04-24 02:22:26 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["程序人生", "其他", "分布式数据库"]
---

## 前言

本文采用两台虚拟机为 sample 来演示 etcd 集群的一些行为。

| IP | HOSTNAME |
| :---: | :---: |
| 10.211.55.106 | etcd0 |
| 10.211.55.108 | etcd1 |

## 什么是 ETCD

ETCD 是用于共享配置和服务发现的分布式，一致性的 KV 数据库。具体信息请参考 [项目首页](https://coreos.com/etcd/) 和 [Github](https://github.com/etcd-io/etcd) ，而 ETCD 的一致性、原子性则依赖于 `Raft` 协议。

## 对比 ZooKeeper

### 一致性协议

ETCD 使用 Raft 协议， ZK 使用 ZAB（类 PAXOS 协议），前者容易理解，方便工程实现。

### 运维方面

ETCD 方便运维，ZK 难以运维。

### API

ETCD 提供 HTTP & JSON，以及 gRPC 接口，跨平台跨语言，ZK 需要使用其客户端。

### 访问安全

ETCD 支持 HTTPS 访问，ZK 在这方面缺失。

## 一些概念

### Raft

对于集群而言最核心内容就是保证数据一致性，在业界有很多算法、协议，例如 Paxos 和 Raft。

Raft 协议相比 Paxos 等，算是年轻的协议，而且 Raft 协议比较简单，容易实现。

至于 Raft 的通信逻辑可以参考：https://thesecretlivesofdata.com/raft/ ，十分简洁易懂。

### API v2 与 API v3

API 版本与 etcd 的客户端发行版本无关，详情见下文提到的 `查看 etcd 的版本号` 。

API v2 存储的数据与 API v3 存储的数据不互通，相互独立。

支持 API v3 的 etcd 也支持 API v2 ，但两者数据独立。

## 启动一个单节点的 ETCD 集群

（虽然直接无参数执行 etcd 即可，但为了能够通适在这里还是写完整）

### /etc/etcd/etcd.conf

https://pasteme.cn/7128

```bash
LOCAL_IP="CHANGE_THIS"
ETCD_DATA_DIR="/var/lib/etcd/data"
ETCD_LISTEN_PEER_URLS="https://${LOCAL_IP}:2380"
ETCD_LISTEN_CLIENT_URLS="https://${LOCAL_IP}:2379,https://127.0.0.1:2379"
ETCD_ADVERTISE_CLIENT_URLS="https://${LOCAL_IP}:2379"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"

ETCD_NAME="CHANGE_THIS"
ETCD_INITIAL_CLUSTER="${ETCD_NAME}=https://${LOCAL_IP}:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${LOCAL_IP}:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
```

### /lib/systemd/system/etcd.service

https://pasteme.cn/7126

```bash
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd
EnvironmentFile=/etc/etcd/etcd.conf
User=root
## set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c \
    "GOMAXPROCS=$(nproc) \
    /usr/local/etcd/etcd \
    --name=${ETCD_NAME} \
    --data-dir=${ETCD_DATA_DIR} \
    --listen-peer-urls=${ETCD_LISTEN_PEER_URLS} \
    --listen-client-urls=${ETCD_LISTEN_CLIENT_URLS} \
    --initial-advertise-peer-urls=${ETCD_INITIAL_ADVERTISE_PEER_URLS} \
    --advertise-client-urls=${ETCD_ADVERTISE_CLIENT_URLS} \
    --initial-cluster-state=${ETCD_INITIAL_CLUSTER_STATE} \
    --initial-cluster-token=${ETCD_INITIAL_CLUSTER_TOKEN} \
    --initial-cluster=${ETCD_INITIAL_CLUSTER}"
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

### 加载并启动服务

```bash
$ systemctl daemon-reload  # 刷新
$ systemctl enable etcd  # 开机自启
$ systemctl start etcd
```

### 查看 etcd 的版本号

```bash
$ etcd --version
etcd Version: 3.3.12
Git SHA: d57e8b8
Go Version: go1.10.8
Go OS/Arch: linux/amd64
```

需要注意的是，当启动一个集群时，集群会向下兼容，所以集群运行时采用的协议版本等于集群中版本最低的 etcd 节点采用的协议版本。

比如集群中有 2 个节点的 version 为 3.3.12 ，但是另一个节点为 2.7.3 ，那么这个集群最终是以 2.7.3 为统一基准运行的，推荐集群中的所有节点版本都保持一致，避免兼容性问题。 

若要查看最终集群采用的协议版本，可以通过 etcd 的启动 log 查看。

## 操作集群

### etcdctl

一般通过 `etcdctl` 对集群进行一些操作，在操作时需要指明节点的地址，不指明 `--endpoints` 参数的话默认是 `https://localhost:2379`，同时操作多个节点时通过英文 `,` 分隔。

还有一点需要注意的是，`etcdctl` 会读取环境变量 `${ETCDCTL_API}` 的值，默认 `ETCDCTL_API=2` ，而 `API v2` 早在几年前就停止支持了，所以以下的所有操作均建立在 `ETCDCTL_API=3` 的基础上。

小伙伴们可以通过以下两条命令将 `etcdctl` 的 API 版本默认设为 3 。

```bash
$ echo 'export ETCDCTL_API=3' >> ~/.bash_profile
$ source ~/.bash_profile
```

如果需要临时用 `API2` 的话使用 `ETCDCTL_API=2 etcdctl` 来执行命令就可以啦，也可以用以下方法用 `etcdctlv2` 来代表 `API v2` 的 `etcdctl` 。

```bash
$ echo "alias etcdctlv2='ETCDCTL_API=2 etcdctl'" >> ~/.bash_profile
$ source ~/.bash_profile
```

#### 查看 etcdctl 的版本号

`API v3` 通过 `version` 来查看版本号，`API v2` 通过 `--version` 来查看版本号。

```bash
$ ETCDCTL_API=3 etcdctl version
etcdctl version: 3.3.12
API version: 3.3
$ ETCDCTL_API=2 etcdctl --version
etcdctl version: 3.3.12
API version: 2
```

需要注意的是 `API v2` 和 `API v3` 的操作、数据皆不互通。

```bash
$ ETCDCTL_API=3 etcdctl --version
Error: unknown flag: --version
$ ETCDCTL_API=2 etcdctl version
No help topic for 'version'
```

### 添加节点

在启动完毕一个集群（包括单节点）之后，可以通过 `member add` 加入新的节点，加入的新节点会自动与旧节点进行数据同步，一般很快就能数据一致。

```bash
$ ETCDCTL_API=3 etcdctl \
--endpoints=https://localhost:2379 \
member add ${node_name} \
--peer-urls=https://${node_ip}:2380
```

现在我们将 `etcd1` 加入刚才 `etcd0` 创建的单节点集群中：

```bash
$ ETCDCTL_API=3 etcdctl member add etcd1 --peer-urls=https://10.211.55.108:2380
Member ff81e3e0ba901ae3 added to cluster 24462beb7ff6e3a2

ETCD_NAME="etcd1"
ETCD_INITIAL_CLUSTER="etcd1=https://10.211.55.108:2380,etcd0=https://10.211.55.106:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.211.55.108:2380"
ETCD_INITIAL_CLUSTER_STATE="existing"
```

将得到的：

```bash
ETCD_NAME="etcd1"
ETCD_INITIAL_CLUSTER="etcd1=https://10.211.55.108:2380,etcd0=https://10.211.55.106:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.211.55.108:2380"
ETCD_INITIAL_CLUSTER_STATE="existing"
```

复制进 `etcd1` 的 `/etc/etcd/etcd.conf` 中，然后在 `etcd1` 中执行 `systemctl start etcd` 启动节点 `etcd1` 即可。

### 移除节点

有的时候可能会产生节点故障，此时需要通过 `member remove` 来将节点移除。

1. 查询节点 ID

假设我们要移除节点 `etcd0` ，我们先查询要移除的节点的 `ID` ：

```bash
etcdctl -w=table member list
+------------------+---------+-------+---------------------------+---------------------------+
|        ID        | STATUS  | NAME  |        PEER ADDRS         |       CLIENT ADDRS        |
+------------------+---------+-------+---------------------------+---------------------------+
| 2ccace8809ee70c2 | started | etcd0 | https://10.211.55.106:2380 | https://10.211.55.106:2379 |
| ff81e3e0ba901ae3 | started | etcd1 | https://10.211.55.108:2380 | https://10.211.55.108:2379 |
+------------------+---------+-------+---------------------------+---------------------------+
```

2. 执行 `member remove`

可以看到 `etcd0` 的 `ID` 为 `ff81e3e0ba901ae3` ，我们删除这个节点：

```bash
$ etcdctl member remove ff81e3e0ba901ae3
Member ff81e3e0ba901ae3 removed from cluster 24462beb7ff6e3a2
```

3. 查看集群成员以确保删除成功

```bash
etcdctl --endpoints=https://etcd1:2379 member list
ff81e3e0ba901ae3, started, etcd1, https://10.211.55.108:2380, https://10.211.55.108:2379
```

需要注意的是我们已经把 `etcd0` 从集群中移除了，如果继续在 `etcd0` 所在的宿主机上执行 `etcdctl` 的话默认会请求 `https://localhost:2379` ，所以我们需要指定我们需要请求的节点。

### 节点迁移

有时候可能需要将集群从一个机群迁移到另一个机群，可以在线上进行热迁移。

定义当前集群中的三个节点为 a、b、c，新节点为 A、B、C 。

1. 将 A、B、C 节点添加至集群中

```bash
$ ETCDCTL_API=3 etcdctl --endpoints=${endpoints} member add ${etcd_name} --peer-urls=${url}
```

2. 等待同步

```bash
$ ETCDCTL_API=3 etcdctl --endpoints=${endpoints} endpoint status | awk '{ print $8 }'
```

3. 移除 a、b、c 节点

```bash
$ ETCDCTL_API=3 etcdctl --endpoints=${endpoints} member remove ${node_id}
```

### 升级 etcd 客户端版本

虽然升级过程无毒无害，绿色环保，但仍然建议进行一次 [数据备份](https://www.jianshu.com/p/c60c08effaaa)。

1. 停止 etcd 节点

```bash
$ systemctl stop etcd
```

2. 替换 etcd 客户端
3. 启动 etcd 节点

```bash
$ systemctl start etcd
```