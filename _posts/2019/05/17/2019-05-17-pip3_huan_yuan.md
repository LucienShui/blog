---
title: "pip3 换源"
date: 2019-05-17 18:23:00 +0800
last_modified_at: 2019-12-03 22:30:28 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["程序人生"]
---

## 原文链接

https://www.lucien.ink/archives/429/

## 起因

`pip` 是很强大的模块安装工具，但是由于某些原因国外官方 `pypi` 经常连接不上，所以我们最好是更换 `pip` 源，这样就能解决各种装不上库的问题。

### 镜像

#### 阿里巴巴

##### 设为默认

```bash
pip install -i https://mirrors.aliyun.com/pypi/simple/ pip -U # 将 pip 升级到最新版本
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
```

##### 临时使用

```bash
pip install -i https://mirrors.aliyun.com/pypi/simple/ some-package
```

#### 清华大学

##### 设为默认

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U # 将 pip 升级到最新版本
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

##### 临时使用

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
```

注意，`simple` 不能少, 是 `https` 而不是 `http`
