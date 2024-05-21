---
title: "Codeforces - 1166D - Cute Sequences"
date: 2019-05-19 03:26:44 +0800
last_modified_at: 2019-05-19 03:26:44 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces", "构造"]
---

## Codeforces - 1166D - Cute Sequences

### 地址

https://codeforces.com/contest/1166/problem/D

### 原文地址

https://www.lucien.ink/archives/433

### 题目

Given a positive integer $m$, we say that a sequence $x_1, x_2, \dots, x_n$ of positive integers is $m$-cute if for every index $i$ such that $2 \le i \le n$ it holds that $x_i = x_{i - 1} + x_{i - 2} + \dots + x_1 + r_i$ for some positive integer $r_i$ satisfying $1 \le r_i \le m$.

You will be given $q$ queries consisting of three positive integers $a$, $b$ and $m$. For each query you must determine whether or not there exists an $m$-cute sequence whose first term is $a$ and whose last term is $b$. If such a sequence exists, you must additionally find an example of it.



### 题意

定义 $x_i = x_{i - 1} + x_{i - 2} + \dots + x_1 + r_i$ ，$1 \le r_i \le m$ ，给你 `a b m` ，判断是否存在一个一个序列 $x$ ，假定这个序列的长度为 $n$ ，使得 $x_1 = a$ 且 $x_n = b$ 。 

### 题解

规定 $2 ^ {x} = 0$ $(x < 0)$ ，归纳一下，可以发现：$$x_{n(n \ge 2)} = 2 ^ {n - 2}a + 2 ^ {n - 3} r_2 + 2 ^ {n - 4} r_3 + \dots + 2r_{n - 2} + r_{n - 1} + r_n\ \tag{a}$$

即判断是否存在一个 $x_n$ 满足 $(a)$ 式且 $x_n = b$ 。

可以进一步简写一下，如果将 $b$ 代入 $(a)$ 式，且令：$$r = 2 ^ {n - 3} r_2 + 2 ^ {n - 4} r_3 + \dots + 2r_{n - 2} + r_{n - 1} + r_n \tag{b}$$ 则有：$$b = 2 ^ {n - 2}a + r$$ 可以发现忽略 $(b)$ 式中的 $r_n$ 之后，剩下的式子为 $r$ 为一个二进制表示，我们可以将 $(b)$ 整体减去一个 $k$ 从而消掉 $r_n$ ，这样一来可以表示为 $x_n = 2 ^ {n - 2}(a + k) + r$ ，令 $r$ 的二进制表示为 $d_{n - 3}d_{n - 4} \dots d_0$ ，此时 $r_{i(i < n)} = k + d_{n - i - 1}$ ，$r_n = k$ 。

然后暴力输出 $x$ 序列即可。

#### 代码

https://pasteme.cn/8173

```cpp
## include <bits/stdc++.h>
const int maxn = 54;
typedef long long ll;
ll __pow[maxn] = {1}, r[maxn], a, b, m;
int solve() {
    if (a == b) return 1;
    for (int n = 2; __pow[n - 2] <= b; n++) {
        ll div = b / __pow[n - 2], mod = b % __pow[n - 2];
        if (div > a && (div - a < m || (mod == 0 && div - a <= m)) && __pow[n - 2] - 1 >= mod) {
            for (int i = 2, bit = n - 3; bit >= 0; i++, bit--) r[i] = (mod >> bit & 1) + div - a;
            return n;
        }
    }
    return -1;
}
ll calc(int x, int n) {
    if (x > 1 && x < n) {
        ll ret = __pow[x - 2] * a;
        for (int i = 2; i < x; i++) ret = ret + __pow[x - i - 1] * r[i];
        return ret + r[x];
    } else return x == 1 ? a : b;
}
int main() {
    int q, n;
    for (int i = 1; i < maxn; i++) __pow[i] = __pow[i - 1] << 1;
    for (scanf("%d", &q); q; q--) {
        scanf("%lld%lld%lld", &a, &b, &m);
        if (~(n = solve())) {
            printf("%d ", n);
            for (int i = 1; i <= n; i++) printf("%lld%c", calc(i, n), i == n ? '\n' : ' ');
        } else puts("-1");
    }
    return 0;
}

```
