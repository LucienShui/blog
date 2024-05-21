---
title: "boost 中 for_each.hpp 学习笔记"
date: 2018-12-21 19:34:00 +0800
last_modified_at: 2018-12-22 15:38:33 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["程序人生"]
---

## boost 中 for_each.hpp 学习笔记

## 文章地址

https://www.lucien.ink

## 引入

`Linux` 需要 `install` 一下 `libboost-dev` 这个库，`macOS` 没有测，`Windows` 日常不在考虑范围内。

`BOOST_PP_SEQ_FOR_EACH` 宏包含于 `boost/preprocessor/seq/for_each.hpp` 中。

## 用法

`BOOST_PP_SEQ_FOR_EACH(func, data, seq)` ，其中：

+ `func` 为自己定义的一个宏
+ `data` 为一个常量
+ `seq` 为一个序列

这个宏会将序列中的参数依次按照指定的宏 `func` 展开。

## 例子

https://pasteme.cn/2714

```cpp
## include <bits/stdc++.h>
## include <boost/preprocessor/seq/for_each.hpp>
## define seq (a)(b)(c)
## define func(r, data, elem) printf("%d %d %d\n", r, data, elem);

## define seq_ (a, 2)(b, 1008)(c, 100) // this is not correct, using STL instead.
int main() {
    int a = 1, b = 2, c = 3, d = 4;
## define a d
    BOOST_PP_SEQ_FOR_EACH(func, 1008611, seq)
    /*
     * expand to:
     * printf("%d %d %d\n", r, data, a);
     * printf("%d %d %d\n", r, data, b);
     * printf("%d %d %d\n", r, data, c);
     * for every element in macro seq will replace the elem in func.
     */
    return 0;
}
```

输出结果为：

```
2 1008611 4
3 1008611 2
4 1008611 3
```

## 行为分析

在代码里我有注释一些，比较值得注意的就是代码中第 `9` 行的 `trick` ，再就是 `seq` 只能定义为单个变量，不能视作完全的宏定义。

至于 `r` 的值为什么从 $2$ 开始，看了一下源代码，好像是指向 `seq` 中的下一个位置？

如有不对烦请指正。