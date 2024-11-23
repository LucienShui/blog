---
title: "BZOJ-3505 - 数三角形 - 思维"
date: 2018-03-20 16:09:34 +0800
last_modified_at: 2018-03-20 16:09:34 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://www.lydsy.com/JudgeOnline/problem.php?id=3505

---
### 题目：

#### Description

给定一个nxm的网格，请计算三点都在格点上的三角形共有多少个。下图为4x4的网格上的一个三角形。

注意三角形的三点不能共线。

#### Input

输入一行，包含两个空格分隔的正整数m和n。

#### Output


输出一个正整数，为所求三角形数量。

#### Sample Input
```
2 2
```
#### Sample Output
```
76
```

#### 数据范围

1<=m,n<=1000

---
### 思路：

&emsp;&emsp;先计算出所有点中任意选三个点的方案数，再减去三点共线的三角形数就可以。

&emsp;&emsp;可以注意到，当选定$(0, 0)$为起点时，和终点$(i, j)$所形成的向量上就会有$gcd(i,j)$个整数点。设点$(x, y)$为点$P$，当某个向量的终点变为点$P$时，就可以和之前的$gcd(x,y) - 1$个点以及零点形成$gcd(x,y)-1$个三点共线的三角形。此时，线段$(0,0)\to (x,y)$的贡献就为$gcd(x,y)-1$，由于其还可以向右和向下平移，故这条向量的贡献还要再乘以$(n-x) \times (m-y)$，此外，以$(0,0)$为起点的向量的斜率的范围为$[\frac {\pi}{2}, -\frac {\pi}{2}]$，为了补全左半边，还要乘以$2$，所以一条不垂直且不水平的向量对答案产生的负贡献为$(gcd(x,y)-1)\times (n-x) \times (m-y) \times 2$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll C(ll tmp) { return tmp * (tmp - 1) * (tmp - 2) / 6; }
ll gcd(ll p, ll q) { return q ? gcd (q, p % q) : p; }
ll n, m;
int main() {
    scanf("%lld%lld", &n, &m); n++, m++;
    ll ans = C(n * m);
    for (int i = 0; i < n; i++) for (int j = 0; j < m; j++) {
            if (i == 0 && j == 0) continue ;
            ans -= (gcd(i, j) - 1) * (n - i) * (m - j) * (1 + (i != 0 && j != 0));
        }
    printf("%lld\n", ans);
    return 0;
}
```