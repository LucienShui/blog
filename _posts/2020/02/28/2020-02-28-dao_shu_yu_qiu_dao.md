---
title: "导数与求导"
date: 2020-02-28 17:08:00 +0800
last_modified_at: 2020-02-28 17:21:58 +0800
math: true
render_with_liquid: false
categories: ["数学"]
tags: ["数学"]
description: "太久没有求过导数，发现关于导数的知识忘得一干二净，遂学习并记录之。本文地址：blog.lucien.ink/archives/499"
---

## 导数与求导

> 本文地址：[blog.lucien.ink/archives/499][this]

### 0. 摘要

太久没有求过导数，发现关于导数的知识忘得一干二净，遂学习并记录之。

### 1. 导数

> [导数][wiki]（英语：Derivative）是微积分学中重要的基础概念。一个函数在某一点的导数描述了这个函数在这一点附近的变化率。导数的本质是通过极限的概念对函数进行局部的线性逼近。当函数 $f$ 的自变量在一点 $x_{0}$ 上产生一个增量 $h$ 时，函数输出值的增量与自变量增量 $h$ 的比值在 $h$ 趋于0时的极限如果存在，即为 $f$ 在 $x_{0}$ 处的导数，记作 $f'(x_0)$ 、$\frac{\mathrm{d}f}{\mathrm{d}x}(x_0)$ 或 $\left.\frac{\mathrm{d}f}{\mathrm{d}x}\right|_{x=x_0}$。例如在运动学中，物体的位移对于时间的导数就是物体的瞬时速度。
>
> 导数是函数的局部性质。不是所有的函数都有导数，一个函数也不一定在所有的点上都有导数。若某函数在某一点导数存在，则称其在这一点可导，否则称为不可导。如果函数的自变量和取值都是实数的话，那么函数在某一点的导数就是该函数所代表的曲线在这一点上的切线斜率。
>
> 对于可导的函数 $f$，$x \mapsto f'(x)$ 也是一个函数，称作 $f$ 的导函数。寻找已知的函数在某点的导数或其导函数的过程称为求导。反之，已知导函数也可以倒过来求原来的函数，即不定积分。微积分基本定理说明了求原函数与积分是等价的。求导和积分是一对互逆的操作，它们都是微积分学中最为基础的概念。

### 2. 导数表

| $f(x)$ | $f'(x)$ |
| :---: | :---: |
| $C$ | $0$ |
| $n ^ x$ | $n ^ x \ln n$ |
| $\log_a x$ | $\frac{ 1 }{ x \ln a }$ |
| $\ln x$ | $\frac{ 1 }{ x }$ |
| $x ^ n$ | $n x ^ { n - 1 }$ |
| $\sqrt[ n ]{ x }$ | $\frac{ x ^ { - \frac{ n - 1 }{ n } } }{ n }$ |
| $\frac{ 1 }{ x ^ n }$ | $- \frac{ n }{ x ^ { n + 1 } }$ |
| $\sin x$ | $\cos x$ |
| $\cos x$ | $- \sin x$ |
| $\tan x$ | $\frac{ 1 }{ \cos ^ 2 x }$ |

### 3. 求导法则
$$[ f(x) \pm g(x) ]' = f'(x) \pm g'(x)$$$$[ f(x) \cdot g(x) ]' = f'(x) \cdot g(x) + f(x) \cdot g'(x)$$$$[ \frac{ f(x) }{ g(x) } ]' = \frac{ f'(x) \cdot g(x) - g'(x) \cdot f(x) }{ g ^ 2(x) }$$$$[ f(g(x)) ]' = f'(g(x)) \cdot g'(x)$$

#### 3.1 $[ f(g(x)) ]'$ 和 $f'(g(x))$ 的区别

$$[ f(g(x)) ]' = \frac{ df(g(x)) }{ dx }$$$$f'(g(x)) = \frac{ df(g(x)) }{ dg(x) }$$

[this]: https://blog.lucien.ink/archives/499/
[wiki]: https://en.wikipedia.org/wiki/Derivative