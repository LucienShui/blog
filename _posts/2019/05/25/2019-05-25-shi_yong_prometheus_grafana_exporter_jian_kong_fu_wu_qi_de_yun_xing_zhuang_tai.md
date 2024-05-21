---
title: "使用 Prometheus + Grafana + Exporter 监控服务器的运行状态"
date: 2019-05-25 16:24:00 +0800
last_modified_at: 2022-04-24 02:24:50 +0800
math: true
render_with_liquid: false
categories: ["操作系统", "运维"]
tags: ["其它", "程序人生", "服务器"]
img_path: /assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/
---

## 使用 Prometheus + Grafana + Exporter 监控服务器的运行状态

原文地址：https://www.lucien.ink/archives/449/

### 1. 摘要

本文主要介绍如何使用 `node_exporter` 采集 `Linux` 系统的信息，借助 `Prometheus` 最终以仪表盘的形式显示在 `Grafana` 中。

### 2. 效果展示

![image.jpg][1]

### 3. 介绍

`Grafana`、`Prometheus`、`Exporter` 这三个组件的背景资料我就不介绍了，搜一下就会有很多。这里主要说一下他们三者之间的关系。

#### 3.1 前置知识

在编写应用程序的时候，通常会记录 `Log` 以便事后分析，在很多情况下是产生了问题之后，再去查看 `Log` ，是一种事后的静态分析。在很多时候，我们可能需要了解整个系统在当前，或者某一时刻运行的情况，比如当前系统中对外提供了多少次服务，这些服务的响应时间是多少，随时间变化的情况是什么样的，系统出错的频率是多少。这些动态的准实时信息对于监控整个系统的运行健康状况来说很重要。

于是就产生了 `metrics` 这种数据，它长这样 [https://monitor.lucien.ink/metrics](https://www.lucien.ink/go/grafana_metrics/) 。

#### 3.2 关系

+ `Exporter` 的主要任务是提供 `metrics` 信息。
+ 而 `metrics` 大多数人是看不懂的，所以 `Prometheus` 为这种格式的信息提供了 `Prometheus Query Language (PromQL)` ，可以进行一些类似数据库那样的联合查询、过滤等操作，这样一来就能提炼出我们想要的东西，类似于内存占用、负载等。大致的流程就是：从远端（可以有多个）采集 `metrics` 信息到本地 $\rightarrow$ 通过各种 `QL` 提炼信息。
+ 虽然 `PromQL` 非常的强大，但是对于大部分人来说是有很高的学习成本的，所以 `Grafana` 就将各种 `PromQL` 封装起来，并将 `PromQL` 的结果以图表的形式展示出来。

大概就是 `生产` $\rightarrow$ `加工` $\rightarrow$ `二次加工` 这样一种流程。

当然了，`Prometheus` 和 `Grafana` 的功能远不止如此，更强大的是报警功能，但这不是本文的主题。

#### 3.3 Exporter

值得一提的是，`Exporter` 组件是一类组件，它们的主要作用就是提供 `metrics` 信息以供加工提炼。

有的组件会自行提供 `metrics` 信息，比如 `Grafana`、`Prometheus`、`Etcd` 等等，在本文的 $3.1$ 中给出的 `metrics` 就是 `Grafana` 本身产生的。

有的组件不会提供 `metrics` 信息，比如说我们自己写的一些程序。

而有的甚至不是组件，比如 `Linux` 系统本身。

### 4. 部署

本文采用的安装方式皆为二进制 + `systemd` 托管的安装方式，因为 `OpenVZ` 等架构的 `VPS` 不能运行 `docker`，所以选择更普适一些的方法。

#### 4.1 下载

+ `node_exporter`：https://github.com/prometheus/node_exporter/releases
+ `Prometheus`：https://github.com/prometheus/prometheus/releases
+ `Grafana`（选择 `Standalone Linux Binaries` 版本）：https://grafana.com/grafana/download

#### 4.2 解压、安装

**新建一个空文件夹**，并将下载的 `tar.gz` 移动至这个空文件夹中。

请保证以下目录结构：

```bash
dir
├── grafana-x.x.x.linux-amd64.tar.gz
├── node_exporter-x.x.x.linux-amd64.tar.gz
└── prometheus-x.x.x.linux-amd64.tar.gz
```

然后在文件夹中执行：

```bash
curl api.pasteme.cn/8413 | bash
```

可以在 https://pasteme.cn/8413 中查看命令详情。

至此，所有安装已经完成了，三个组件对应的 `systemd` 服务名称分别是：`grafana-server`、`prometheus`、`node_exporter`。



#### 4.3 验证

##### 4.3.1 systemctl status xxx

可以用 `systemctl status` 命令来查看各个组件的运行状态。

```bash
systemctl status node_exporter
systemctl status prometheus
systemctl status grafana-server
```

##### 4.3.2 查看 metrics

`node_exporter`、`Prometheus`、`Grafana` 的默认端口分别是 `9100`、`9090`、`3000` ，我们可以通过以下命令来查看 `metrics` 信息，有输出就代表正在运行。

```bash
curl localhost:9100/metrics
curl localhost:9090/metrics
curl localhost:3000/metrics
```

#### 4.4 开机自启

这是 `systemd` 老生常谈的一个话题了。

```bash
systemctl enable node_exporter
systemctl enable prometheus
systemctl enable grafana-server
```

#### 4.5 卸载

```bash
curl api.pasteme.cn/8414 | bash
```

可以在 https://pasteme.cn/8414 中查看命令详情。

### 5. 配置

虽然我们已经完成了三个组件的安装，但此时它们都还是互相独立的三个组件，我们需要对其进行一些配置。

#### 5.1 prometheus

编辑 `/usr/local/prometheus/prometheus.yml`

我们会看到如下内容：

```yaml
## my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

## Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

## Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

## A scrape configuration containing exactly one endpoint to scrape:
## Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090'] # 我们需要修改这里
```

将 `targets` 所在的那一行修改为以下内容，注意空格缩进，`yaml` 的格式检查很严格。 

```yml
    - targets: ['localhost:9100']
```

这个修改会让 `Prometheus` 从 `localhost:9100/metrics` 进行 `metrics` 信息的读取，默认的 `9090` 是 `Prometheus` 本身的 `metrics` 信息。

保存修改过的文件之后重启一下 `prometheus` 服务即可。

```bash
systemctl restart prometheus
```

可以用本文 $4.3$ 提到的方法验证是否启动成功，如果没有的话请检查 `yml` 文件的格式。

#### 5.2 Grafana

```bash
cd /usr/local/grafana/bin
chmod +x grafana-cli
./grafana-cli plugins install grafana-piechart-panel
systemctl restart grafana-server
```

这里是为了安装一个 `饼图` 的插件。

然后访问 `https://<YOUR_IP>:3000` ，默认的账号密码都是 `admin`。

![默认的账号密码都是 admin](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.38.23.png)

点击 `Add data source`。

![点击 Add data source](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.39.14.png)

选择 `Prometheus`。

![选择 Prometheus](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.39.24.png)

`Http` $\rightarrow$ `URL` 中填入 `https://localhost:9090` ，也就是 `prometheus` 提供的接口。

然后点击 `Save & Test`。

![填入 https://localhost:9090](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.40.57.png)

然后把鼠标挪到左上角的 `+` 上，注意是挪上去，然后在弹出的菜单中点击 `Import`。

![然后把鼠标挪到左上角的 + 上，然后在弹出的菜单中点击 Import](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.41.07.png)

然后我们在这里可以引入各种大神为各种 `Exporter` 写好的 `Dashboard` ，可以去 https://grafana.com/dashboards 自行搜寻，在这里我们用一名国人为 `node_exporter` 写的 `Dashboard` ，对应的主页为 https://grafana.com/dashboards/8919 。

我们在 `Grafana.com Dashboard` 一栏中填入 `8919` ，然后点击一下旁边的空白处。

![在 Grafana.com Dashboard 一栏中填入 8919 ，然后点击一下旁边的空白处](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.41.53.png)

点击空白处之后会自动导入对应的 `Dashboard` ，此时会让你设置数据来源，在 `Options` $\rightarrow$ `prometheus_111` 这里选择我们刚才添加的 `Prometheus` ，然后点击 `Import` 就可以了。

![prometheus_111 这里选择我们刚才添加的 Prometheus ，然后点击 Import](assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/ping_mu_kuai_zhao_2019_05_2515.42.39.png)

#### 5.2.3 配置完成

至此，我们就成功地将 `Grafana`、`Prometheus`、`node_exporter` 关联起来了。

### 6. 监控多个节点

在完成了本文的 $5$、$6$ 部分之后，仅仅是完成了监控本机的过程，如果要监控其它的节点，需在被监控的节点上安装相应的 `Exporter`，下面以本文中提到的 `node_exporter` 为例，介绍如何添加节点。

#### 6.1 部署

##### 6.1.1 下载 Exporter

+ `node_exporter`：https://github.com/prometheus/node_exporter/releases

##### 6.1.2 解压、安装

**新建一个空文件夹**，并将下载的 `tar.gz` 移动至这个空文件夹中。

请保证以下目录结构：

```bash
dir
└── node_exporter-x.x.x.linux-amd64.tar.gz
```

然后在文件夹中执行：

```bash
curl api.pasteme.cn/8416 | bash
```

可以在 https://pasteme.cn/8416 中查看命令详情。

至此，`node_exporter` 安装已经完成了，对应的 `systemd` 服务名称分别是 `node_exporter`。

##### 6.1.3 验证

参考本文 $4.3$ ，不再赘述。

##### 6.1.4 开机自启

```bash
systemctl enable node_exporter
```

##### 6.1.5 卸载

```bash
systemctl disable node_exporter
systemctl stop node_exporter
rm -f /lib/systemd/system/node_exporter.service
rm -rf /usr/local/node_exporter
```

#### 6.2 配置 Prometheus

在监控节点上编辑 `Prometheus` 的配置文件 `/usr/local/prometheus/prometheus.yml`。

将 `targets` 所在的那一行修改为以下内容，注意空格缩进，`yaml` 的格式检查很严格。 

```yml
    - targets: ['localhost:9100', 'addr:9100']
```

其中 `addr` 是被监控节点的 IP 或域名。

然后重启 `Prometheus`，在 `Grafana` 的 `Dashboard` 中就可以看到新的节点了。

```bash
systemctl restart prometheus
```

##### 6.2.1 关于 targets 的说明

可以观察到，`targets` 传入的是一个数组，`Prometheus` 会收集数组中的每个元素的 `metrics` ，然后 `Grafana` 再处理这些数据。


  [1]: assets/img/posts/2019/05/25/2019-05-25-shi_yong_prometheus_grafana_exporter_jian_kong_fu_wu_qi_de_yun_xing_zhuang_tai/image.jpg