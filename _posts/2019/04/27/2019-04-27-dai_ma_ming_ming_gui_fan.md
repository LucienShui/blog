---
title: "代码命名规范"
date: 2019-04-27 14:07:00 +0800
last_modified_at: 2019-04-27 14:07:37 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
---

原文地址：https://www.lucien.ink/archives/424/

> 只是我个人决定用这种写法，仅供参考，欢迎提建议。

## 对象名

### 常量

```cpp
const std::string BLOG_ADDR = "https://lucien.ink";
const int MAX_LENGTH = 200;
```

### 变量

小驼峰式命名法

```cpp
int maxCount = 10;
std::string tableTitle = "LoginTable";
```

### 全局变量

`g` + 变量名

```cpp
int gMax = int(1e9) + 7;
```

### 私有变量

双下划线 + 变量名

```cpp
std::string __name = "Lucien Shui";
```

## 函数名

待填坑