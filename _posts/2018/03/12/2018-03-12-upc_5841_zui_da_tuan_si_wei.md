---
title: "UPC-5841 - 最大团 - 思维"
date: 2018-03-12 22:48:31 +0800
last_modified_at: 2018-03-12 22:48:31 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5841

---
### 题目：

#### 题目描述
数轴上有n个点，第i个点的坐标为xi，权值为wi。两个点i,j之间存在一条边当且仅当abs(xi-xj)>=wi+wj。
你需要求出这张图的最大团的点数。
（团就是两两之间有边的顶点集合）
#### 输入
第一行一个整数n，接下来n行每行两个整数xi,wi。

#### 输出
输出一行一个整数，表示最大团的点数。
#### 样例输入
```
4
2 3
3 1
6 1
0 2
```
#### 样例输出
```
3
```
#### 提示
对于20%的数据，n<=10。
对于60%的数据，n<=1000。
对于100%的数据，n<=200000，0<=|xi|,wi<=10^9。

---
### 思路：

&emsp;&emsp;两点之间满足$|x_i - x_j| \geq w_i + w_j$时存在边，不妨设：$x_i \geq x_j$，则有：$x_i - x_j \geq w_i + w_j$，移项得：$x_i - w_i \geq x_j + w_j$。

&emsp;&emsp;我们发现对于每个点的$x_i$，$w_i$，可以转化为一条线段：$[x_i - w_i, w_i + w_i]$，之后根据上面推出的不等式，可以得出：如果两个点之间存在边，那么这两个点对应的两条线段不相交或者是只有端点重合。那么问题就转化为经典线段覆盖问题：求坐标轴上最多有多少条线段不相交，复杂度为$O(n)$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
struct Node {
    int l, r;
    bool operator < (const Node &tmp) const { return r < tmp.r; }
} a[200007];
int main() {
    int n; scanf("%d", &n);
    for (int i = 0, x, w; i < n; i++) scanf("%d%d", &x, &w), a[i].l = x - w, a[i].r = x + w;
    std::sort(a, a + n);
    int max = a[0].r, ans = 1;
    for (int i = 1; i < n; i++) if (a[i].l >= max) ans++, max = a[i].r;
    printf("%d\n", ans);
    return 0;
}
```