---
title: "点到直线的距离公式推导"
date: 2020-02-13 18:12:00 +0800
last_modified_at: 2020-03-29 16:55:18 +0800
math: true
render_with_liquid: false
categories: ["数学"]
tags: ["数学"]
description: "今天在 PPT 里看到一个点到超平面的距离公式，看了半天没看懂为什么这样算，遂去问学霸，答曰“平面情况下就是点到直线的距离公式”。本文地址：blog.lucien.ink/archives/495"
img_path: /assets/img/posts/2020/02/13/2020-02-13-dian_dao_zhi_xian_de_ju_li_gong_shi_tui_dao/
---

## 点到直线的距离公式推导

> 本文地址：[blog.lucien.ink/archives/495][this]

摘自 [点到直线距离公式的几种推导 - 三横先生的文章 - 知乎][zhihu] 的三角形面积法，稍作修改并更正书写错误。

### 起因

今天在 PPT 里看到一个点到超平面的距离公式 $d = \frac{ 1 }{ \left\| \boldsymbol w \right\| }| \boldsymbol w \cdot \boldsymbol x_0 + \boldsymbol b |$，看了半天没看懂为什么这样算，遂去问学霸，答曰“平面情况下就是点到直线的距离公式”。

万分惭愧，我连初中数学都忘了。

### 三角形面积法

![图片来自知乎][pic]

> 直线 $l$ 方程为 $Ax + By + C = 0$，$A$、$B$ 均不为 $0$，点 $P(x_0, y_0)$，设点 $P$ 到 $l$ 的距离为 $d$。

设点 $R(x_R, y_0)$，点 $S(x_0, y_S)$。

由 $R, S$ 在直线 $l$ 上，得到

$$Ax_R + By_0 + C = 0$$$$Ax_0 + By_S + C = 0$$

所以

$$x_R = \frac{ -By_0 - C }{ A }$$$$y_S = \frac{ -Ax_0 - C }{ B }$$

即

$$| PR | = | x_0 - x_R | = | x_0 - \frac{ -By_0 - C }{ A } | = | \frac{ Ax_0 + By_0 + C }{ A } |$$$$| PS | = | y_0 - y_S | = | y_0 - \frac{ -Ax_0 - C }{ B } | = | \frac{ Ax_0 + By_0 + C }{ B } |$$

于是

$$| RS | = \sqrt{ { PR }^2 + { PS }^2 } = \frac{ \sqrt{ A^2 + B^2 } }{ AB } \cdot | Ax_0 + By_0 + C |$$

由 $\Delta_{PSR}$ 得

$$d \cdot | RS | = | PR | \cdot | PS |$$

即

$$d = \frac{ | PR | \cdot | PS | }{ | RS | } = \frac{ | \frac{ Ax_0 + By_0 + C }{ A } | \cdot | \frac{ Ax_0 + By_0 + C }{ B } | }{ \frac{ \sqrt{ A^2 + B^2 } }{ AB } \cdot | Ax_0 + By_0 + C | } = \frac{ | Ax_0 + By_0 + C | }{ \sqrt{ A^2 + B^2 } }$$

### 另一种形式

设函数 $f(x, y) = Ax + By + C$，直线 $l: Ax + By + C = 0$ 的法向量为 $\boldsymbol v(A, B)$。

则点 $P(x_0, y_0)$ 到直线 $l$ 的距离 $d$ 为

$$d = \frac{ | Ax_0 + By_0 + C | }{ \sqrt{ A^2 + B^2 } } = \frac{ f(x_0, y_0) }{ \left\| \boldsymbol v \right\| }$$

> 注：$\left\| \boldsymbol v \right\|$ 为向量 $\boldsymbol v$ 的 2-范数

[this]: https://blog.lucien.ink/archives/495/
[zhihu]: https://zhuanlan.zhihu.com/p/26307123
[pic]: assets/img/posts/2020/02/13/2020-02-13-dian_dao_zhi_xian_de_ju_li_gong_shi_tui_dao/pic.png