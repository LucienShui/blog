---
title: "洛谷P1855 - 榨取kkksc03 - 动态规划"
date: 2018-05-16 15:54:24 +0800
last_modified_at: 2018-05-16 15:54:35 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://www.luogu.org/problemnew/show/P1855

---
### 题目

洛谷的运营组决定，如果一名oier向他的教练推荐洛谷，并能够成功的使用（成功使用的定义是：该团队有20个或以上的成员，上传10道以上的私有题目，布置过一次作业并成功举办过一次公开比赛），那么他可以浪费掉kkksc03的一些时间的同时消耗掉kkksc03的一些金钱以满足自己的一个愿望。

Kkksc03的时间和金钱是有限的，所以他很难满足所有同学的愿望。所以他想知道在自己的能力范围内，最多可以完成多少同学的愿望？

#### 输入格式：
第一行,n M T，表示一共有n(n<=100)个愿望，kkksc03 的手上还剩M(M<=200)元，他的暑假有T(T<=200)分钟时间。

第2~n+1行 mi,ti 表示第i个愿望所需要的时间和金钱。

#### 输出格式：
一行，一个数，表示kkksc03最多可以实现愿望的个数。

---
### 思路

&emsp;&emsp;二维01背包，$dp[i][j]$代表拥有$i$元钱，$j$分钟时最多能实现的愿望数。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 207;
int n, m, t, ans, dp[maxn][maxn];
struct { int m, t; } node[maxn];
int main() {
    scanf("%d%d%d", &n, &m, &t);
    for (int i = 0; i < n; i++) scanf("%d%d", &node[i].m, &node[i].t);
    for (int i = 0; i < n; i++)
        for (int j = m; j >= node[i].m; j--)
            for (int k = t; k >= node[i].t; k--)
                ans = std::max(dp[j][k] = std::max(dp[j][k], dp[j - node[i].m][k - node[i].t] + 1), ans);
    printf("%d\n", ans);
    return 0;
}
```