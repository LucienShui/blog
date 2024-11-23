---
title: "Codeforces-984D - XOR-pyramid - 思维"
date: 2018-05-16 02:08:00 +0800
last_modified_at: 2018-05-16 10:46:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/984/problem/D

---
### 题目：

For an array $b$ of length $m$ we define the function $f$ as

(由于技术原因此处公式显示不全，完整公式请见：[CSDN](https://blog.csdn.net/xs18952904/article/details/80331469))

where $⊕$ is [bitwise exclusive OR](https://en.wikipedia.org/wiki/Bitwise_operation#XOR).

For  example,$f(1,2,4,8)=f(1⊕2,2⊕4,4⊕8)=f(3,6,12)=f(3⊕6,6⊕12)=f(5,10)=f(5⊕10)=f(15)=15$

You are given an array $a$ and a few queries. Each query is represented as two integers $l$ and $r$. The answer is the maximum value of $f$ on all continuous subsegments of the array $a_l,a_{l+1},…,a_r$.

#### Input
The first line contains a single integer $n\ (1≤n≤5000)$ — the length of $a$.

The second line contains nn integers $a_1,a_2,…,a_n\ (0≤ai≤2^{30}-1)$ — the elements of the array.

The third line contains a single integer $q\ (1≤q≤100\ 000)$ — the number of queries.

Each of the next $q$ lines contains a query represented as two integers $l, r\ (1≤l≤r≤n)$.

#### Output
Print $q$ lines — the answers for the queries.

---
### 题意：

&emsp;&emsp;定义一个函数$f(b)$，$b$对应一个数组，作用方式见题意。给你一个长度为`n`的序列`b`，然后给你`q`次询问，对于每次询问，给你`l r`，问你在$[l,r]$这段区间内所有子串中$f$的最大值为多少。

---
### 思路：

&emsp;&emsp;我开始看这道题的时候还剩20分钟了，然而小伙伴已经思考了很久了...并且发现了一个十分关键的性质。

&emsp;&emsp;定义$f[l][r]$为在$[l,r]$这个区间内函数$f$的结果，那么有：

(由于技术原因此处公式显示不全，完整公式请见：[CSDN](https://blog.csdn.net/xs18952904/article/details/80331469))

&emsp;&emsp;于是我们可以根据这个性质$O(n^2)$预处理出所有区间的$f$，与此同时可以把答案离线下来，然后$O(1)$出答案即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int f[5007][5007], ans[5007][5007], n, q, l, r, i;
int main() {
    for (scanf("%d", &n), i = 1; i <= n; i++) scanf("%d", f[i] + i), ans[i][i] = f[i][i];
    for (int len = 2; len <= n; len++)
        for (l = 1, r; (r = l + len - 1) <= n; l++) {
            f[l][r] = f[l][r - 1] ^ f[l + 1][r];
            ans[l][r] = std::max(f[l][r], std::max(ans[l][r - 1], ans[l + 1][r]));
        }
    for (scanf("%d", &q), i = 0; i < q; i++) {
        scanf("%d%d", &l, &r);
        printf("%d\n", ans[l][r]);
    }
    return 0;
}
```