---
title: "Docker 入门手记"
date: 2018-06-20 15:41:00 +0800
last_modified_at: 2020-11-03 11:18:32 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["linux", "其它", "docker"]
---

## 前言

本人是参照于：[https://yeasy.gitbooks.io/docker_practice/content/](https://www.lucien.ink/go/docker_practice_gitbook/) 学习`Docker`，因每次翻查略有不便，把部分认为对于我比较重要的内容写在这里以作记录。

本文保持不定时更新：https://www.lucien.ink/archives/301/

## 安装Docker

安装完成 docker 之后需执行 `sudo usermod -aG docker $(whoami)` 来将当前用户加至 docker 的用户组下。

### 国内用户

#### 阿里云镜像

```bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

#### DaoCloud 镜像

```bash
sudo curl -sSL https://get.daocloud.io/docker | sh
```

### 国外用户

```bash
sudo curl -sSL get.docker.com | sh
```

## 镜像加速

从`Docker Hub`直接获取镜像实在是太慢了，类似于`Linux`里的换软件源，`Docker`也可以自定义镜像的来源，这里采用官方提供的国内加速服务。

### 配置镜像

#### Ubuntu 14.04、Debian 7 Wheezy

编辑`/etc/default/docker`文件，在其中的`DOCKER_OPTS`中配置加速器地址：
```
DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com"
```

#### Ubuntu 16.04+、Debian 8+、CentOS 7

在`/etc/docker/daemon.json`中写入如下内容（如果文件不存在的话新建该文件，一定要保证该文件符合 json 规范，否则 Docker 将不能启动）

```
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
```

### 重启服务使镜像生效

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 获取镜像

从 Docker 镜像仓库获取镜像的命令是`docker pull`，其命令格式为：

`docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]`

具体的选项可以通过`docker pull --help`看到。

对于`Docker Hub`，如果不给出用户名，则默认为官方镜像。

```bash
docker pull ubuntu:16.04
```

上面的命令中没有给出`Docker`镜像仓库地址，因此将会从`Docker Hub`获取镜像。而镜像名称是`ubuntu:16.04`，因此将会获取官方镜像`library/ubuntu`仓库中标签为`16.04`的镜像。

## 容器

### 创建/运行容器

有了镜像之后，就可以创建或运行容器了。

据我目前的认知，如果本地没有指定的映像的时候`Docker`会自动下载镜像，在运行容器时如果没有指定容器则会自动创建一个容器。

```bash
docker run -dit -p 8080:80 ubuntu:16.04
```
执行这条命令来以守护态（保持在后台）运行那个我们刚才下载的镜像，其中`-dit`是守护态，`-p 8080:80`是将本地的`8080`端口映射至容器的`80`端口，`ubuntu:16.04`是镜像的名称。

```bash
$ docker run -dit -p 8080:80 ubuntu:16.04
229125e81ab57b10a4129c7b592bf10e353e7baaf4a33d16201b49139f701624
```

我们可以通过`docker container ls`来查看后台的所有容器。

```bash
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
229125e81ab5        ubuntu:16.04        "/bin/bash"         18 seconds ago      Up 17 seconds       0.0.0.0:8080->80/tcp   focused_lamarr
```

### 进入容器

执行`docker exec -it <容器ID> bash`就可以进入容器内部，看到熟悉的`bash`界面。

```bash
[root@CentOS-Server ~]$ docker run -dit -p 8080:80 ubuntu:16.04
229125e81ab57b10a4129c7b592bf10e353e7baaf4a33d16201b49139f701624

[root@CentOS-Server ~]$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
229125e81ab5        ubuntu:16.04        "/bin/bash"         18 seconds ago      Up 17 seconds       0.0.0.0:8080->80/tcp   focused_lamarr

[root@CentOS-Server ~]$ docker exec -it 229125e81ab5 bash

root@229125e81ab5:/$ cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.5 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.5 LTS"
VERSION_ID="16.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
```

然后就可以开始随意瞎搞了。

### 终止容器

```bash
docker kill <容器ID>
```
可以终止一个运行中的容器。需要注意的是，除非你将更改应用至镜像，否则对每个容器的更改都是临时的（据我观察是这样的）。

### 容器快照的导入/导出

#### 导出快照

如果要导出本地某个容器，可以使用`docker export <容器ID> > <导出后的名字>.tar`命令，通常称导出后的`tar`为`快照`。
```bash
[root@CentOS-Server ~]$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
afa433a465e7        ubuntu:16.04        "/bin/bash"         3 minutes ago       Up 3 minutes                            silly_pike

[root@CentOS-Server ~]$ docker export afa433a465e7 > test.tar

[root@CentOS-Server ~]$ ls
test.tar
```

这样一来容器就被导出到本地的`test.tar`中了。

#### 导入快照

`cat <快照名>.tar | docker import - <镜像名>[:标签]`

```bash
[root@CentOS-Server ~]$ cat test.tar | docker import - test/ubuntu:1.0
sha256:6fa4015b56ca246babc800ed6420d4b3af08921e8e7ce64f0899fbacc8b2a390

[root@CentOS-Server ~]$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test/ubuntu         1.0                 6fa4015b56ca        9 seconds ago       183 MB
docker.io/ubuntu    16.04               578c3e61a98c        2 weeks ago         223 MB
```

这样一来我们刚才对容器做出的改变就被保存成了一个镜像。

## 镜像

### 通过 Dockerfile 构建镜像

#### Dockerfile 基本命令

| 命令 | 解释 |
| --- | --- |
| 坑 | 坑 |

### 导出镜像

`docker save [options] images [images...]`

#### Example

```bash
docker save -o nginx.tar nginx:latest
```

其中：

`-o` 表示输出到文件，`nginx.tar` 为目标文件，`nginx:latest` 是源镜像名（name:tag）。

### 导入镜像

`docker load [options]`

#### Example

```bash
docker load -i nginx.tar
```

其中：

`-i` 表示从文件输入，`nginx.tar` 为目标文件。

### 重命名镜像

```bash
docker tag <old_image_tag | image_id> <new_image_tag>
```

### 删除镜像

```bash
docker rmi <image_tag | image_id>
```

删除 `tag` 的时候如果有其它的引用则只会删除 `tag`，如果没有引用会连同镜像一起删除。 

## 其它命令集

```bash
$ docker ps // 查看所有正在运行容器
$ docker stop <容器ID>

$ docker ps -a // 查看所有容器
$ docker ps -a -q // 查看所有容器ID

$ docker stop $(docker ps -a -q) //  stop停止所有容器
$ docker rm $(docker ps -a -q) //   remove删除所有容器
```