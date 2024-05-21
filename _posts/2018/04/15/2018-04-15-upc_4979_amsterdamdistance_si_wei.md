---
title: "UPC-4979 - Amsterdam Distance - 思维"
date: 2018-04-15 11:29:00 +0800
last_modified_at: 2018-05-23 18:15:31 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
img_path: /assets/img/posts/2018/04/15/2018-04-15-upc_4979_amsterdamdistance_si_wei/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=4979

---
### 题目：

#### 题目描述
Your friend from Manhattan is visiting you in Amsterdam. Because she can only stay for a short while, she wants to see as many tourist attractions in Amsterdam in as little time as possible. To do that, she needs to be able to ﬁgure out how long it takes her to walk from one landmark to another. In her hometown, that is easy: to walk from point m = (mx, my) to point n = (nx, ny) in Manhattan you need to walk a distance |nx − mx | + |ny − my |, since Manhattan looks like a rectangular grid of city blocks. However, Amsterdam is not well approximated by a rectangular grid. Therefore, you have taken it upon yourself to ﬁgure out the shortest distances between attractions in Amsterdam. With its canals, Amsterdam looks much more like a half-disc, with streets radiating at regular angles from the center, and with canals running the arc of the circle at equally spaced intervals. A street corner is given by the intersection of a circular canal and a street which radiates from the city center.

![20171125181030_18836.jpg][1]

Depending on how accurately you want to model the street plan of Amsterdam, you can split the city into more or fewer half rings, and into more or fewer segments. Also, to avoid conversion problems, you want your program to work with any unit, given as the radius of the half circle. Can you help your friend by writing a program which computes the distance between any two street corners in Amsterdam, for a particular approximation?
#### 输入
The input consists of
• One line with two integers M, N and a ﬂoating point number R.
– 1 ≤ M ≤ 100 is the number of segments (or ‘pie slices’) the model of the city is split into.
– 1 ≤ N ≤ 100 is the number of half rings the model of the city is split into.
– 1 ≤ R ≤ 1000 is the radius of the city.
• One line with four integers, ax, ay, bx, by, with 0 ≤ ax, bx ≤ M, and 0 ≤ ay, by ≤ N, the coordinates of two corners in the model of Amsterdam.
#### 输出
Output a single line containing a single ﬂoating point number, the least distance needed to travel from point a to point b following only the streets in the model. The result should have an absolute or relative error of at most 10−6.
#### 样例输入
```
6 5 2.0
1 3 4 2
```
#### 样例输出
```
1.65663706143592
```

---
### 题意：

&emsp;&emsp;求半个极角坐标系上两点之间的最短曼哈顿距离。

---
### 思路：

&emsp;&emsp;从一个点走到另一个点有两种最优方案，一种是先走半径小的那个内圈圆，然后走直线，还有一种是走直线到原点，再走直线到另一个点。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int main() {
//    freopen("in.txt", "r", stdin);
    int m, n, x[2], y[2];
    long double R, r, ans[2];
    scanf("%d%d%Lf%d%d%d%d", &m, &n, &R, x, y, x + 1, y + 1);
    r = R / n;
    ans[0] = r * (fabs(y[0] - y[1])) + acos(-1) * r * std::min(y[0], y[1]) * fabs(x[0] - x[1]) / m;
    ans[1] = (y[0] + y[1]) * r;
    printf("%.14Lf\n", std::min(ans[0], ans[1]));
    return 0;
}

```


  [1]: assets/img/posts/2018/04/15/2018-04-15-upc_4979_amsterdamdistance_si_wei/20171125181030_18836.jpg