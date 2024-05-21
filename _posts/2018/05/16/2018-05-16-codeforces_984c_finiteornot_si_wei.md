---
title: "Codeforces-984C - Finite or not? - 思维"
date: 2018-05-16 01:36:00 +0800
last_modified_at: 2018-06-09 23:48:13 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/984/problem/C

---
### 题目：

You are given several queries. Each query consists of three integers $p$, $q$ and $b$. You need to answer whether the result of $p/q$ in notation with base $b$ is a finite fraction.

A fraction in notation with base $b$ is finite if it contains finite number of numerals after the decimal point. It is also possible that a fraction has zero numerals after the decimal point.

#### Input
The first line contains a single integer $n(1≤n≤10^5)$ — the number of queries.

Next nn lines contain queries, one per line. Each line contains three integers $p$, $q$, and$b (0≤p≤10^{18}, 1≤q≤10^{18}, 2≤b≤10^{18})$. All numbers are given in notation with base $10$.

#### Output
For each question, in a separate line, print Finite if the fraction is finite and Infinite otherwise.

---
### 题意：

&emsp;&emsp;`n`组样例，对于每组样例，给你三个数`p q b`，问你$\frac{p}{q}$在$b$进制下是不是一个有限小数，是的话输出`Finite`，否则输出`Infinite`。

---
### 思路：

&emsp;&emsp;首先对于$\frac{p}{q}$可以先对分子分母约分一下，然后只关心$\frac{1}{q}$是否可以在$b$进制下被有限表示即可，因为他们俩之间只相差一个系数$p$，也就是说如果$\frac{1}{q}$可以被有限表示，那么$\frac{p}{q}$也一定可以被有限表示。

&emsp;&emsp;考虑$\frac{1}{q}$，一定是一个小于等于$1$的数，考虑将小数转化为$b$进制的过程，每次将小数乘以$b$然后取整数部分，直到这个小数变成了$0$，也就是说如果某个小数$\frac{1}{q}$在$b$进制下可以被有限表示，那么一定存在一个$i$，使得$b^i = 0\ (mod\ q)$成立，于是我们判断这个$i$是否存在即可。

&emsp;&emsp;判断的方法刚开始一直想不出来，莽了一发`BSGS`果断TLE了（我还是太弱了），听了小伙伴的思路才过的。

&emsp;&emsp;考虑$b^i$，其不同因子的个数恒等于$b$的不同因子的个数，于是判断$b^i\ mod\ q$是否可以等于$0$就等价于判断$b$是否拥有所有$q$的因子。

---
### 实现：

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll gcd(ll p, ll q) { return q ? gcd(q, p % q) : p; }
ll p, q, b, tmp, i, n;

int main() {
    for (i = 0, scanf("%lld", &n); i < n; i++){
        scanf("%lld%lld%lld", &p, &q, &b);
        q = q / gcd(p, q);
        while ((tmp = gcd(q, b)) != 1) while (q % tmp == 0) q /= tmp;
        puts(q == 1 ? "Finite" : "Infinite");
    }
    return 0;
}
```