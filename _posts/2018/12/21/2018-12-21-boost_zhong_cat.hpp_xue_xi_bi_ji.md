---
title: "boost 中 cat.hpp 学习笔记"
date: 2018-12-21 19:49:29 +0800
last_modified_at: 2018-12-21 19:49:29 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["程序人生"]
---

## boost 中 cat.hpp 学习笔记

## 文章地址

https://www.lucien.ink

## 引入

`Linux` 需要 `install` 一下 `libboost-dev` 这个库，`macOS` 没有测，`Windows` 日常不在考虑范围内。

`BOOST_PP_CAT` 宏包含于 `boost/preprocessor/cat.hpp` 中。

## 用法

`BOOST_PP_CAT(a, b)`

这个宏会将 `a` 和 `b` 从文本上连接在一起形成 `ab`。

## 例子

https://pasteme.cn/2715

```cpp
## include <bits/stdc++.h>
## include <boost/preprocessor/cat.hpp>

## define MY_CAT(a, b) a##b
## define c1 BOOST_PP_CAT(a, b)
## define c2 MY_CAT(a, b)

int main() {
    int ab = 512, a1 = 1024;
## define b 1
    printf("%d\n", c1);
    printf("%d\n", c2);
    return 0;
}
```

输出结果为：

```
1024
512
```

## 行为分析

最原始的字符连接仅仅是对于填入括号中的字符本身进行连接，而 `BOOST_PP_CAT` 会先进行宏转译然后再进行连接。

如有不对烦请指正。