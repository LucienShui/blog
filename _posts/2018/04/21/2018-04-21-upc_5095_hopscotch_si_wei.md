---
title: "UPC-5095 - Hopscotch - 思维"
date: 2018-04-21 23:15:52 +0800
last_modified_at: 2018-04-21 23:15:52 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5095

---
### 题目：

#### 题目描述
You’re playing hopscotch! You start at the origin and your goal is to hop to the lattice point (N, N). A hop consists of going from lattice point (x1, y1) to (x2, y2), where x1 < x2 and y1 < y2.
You dislike making small hops though. You’ve decided that for every hop you make between two lattice points, the x-coordinate must increase by at least X and the y-coordinate must increase by at least Y .
Compute the number of distinct paths you can take between (0, 0) and (N, N) that respect the above constraints. Two paths are distinct if there is some lattice point that you visit in one path which you don’t visit in the other.
Hint: The output involves arithmetic mod 109+ 7. Note that with p a prime like 109+ 7, and x an integer not equal to 0 mod p, then x(xp−2) mod p equals 1 mod p.
#### 输入
The input consists of a line of three integers, N X Y . You may assume 1 ≤ X, Y ≤ N ≤ 106.
#### 输出
The number of distinct paths you can take between the two lattice points can be very large. Hence output this number modulo 1 000 000 007 (109+ 7).
#### 样例输入
```
7 2 3
```
#### 样例输出
```
9
```

---
### 题意：

&emsp;&emsp;初始时你在`(0,0)`点，每一次你只能向右至少移动`X`，向上至少移动`Y`格，问你从`(0,0)`点走到`(n,n)`点有多少种方案，答案对$10^9+7$取模。


---
### 思路：

&emsp;&emsp;考虑一维，从`0`点每次至少走`x`步走到`n`这个点有多少种方案。我们最多可以走恰好$n\div x$次，最少可以走恰好$1$次。

&emsp;&emsp;比如当前我们打算走恰好$t$次到达终点，那么我们可以先规定每走一次都会至少走$x - 1$个格子，这样还剩下$last = n - t \times (x - 1)$步需要走，我们把这剩下的$last$步分配给$t$次移动之中。显然，需要至少再给这$t$次移动至少分配一步，这样才能满足每一步都会至少走$x - 1 + 1 = x$个格子，剩下的随便分。这样问题就转化为：当前有$last$个小球，需要把它们分成$t$份，问有多少种分法。可以用隔板法轻易求解，答案为$C_{last - 1}^{t - 1}$。

&emsp;&emsp;再将其推广至二维，我们记$calc(x, t)$为一维时从$0$点走$t$次到$n$点，每次至少走$x$步时的答案，则有：$ans = \sum_{t = 1}^{min(\frac{n}{x}, \frac{n}{y})} calc(x, t) \times calc(y,t)$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e6) + 7, mod = int(1e9) + 7;
typedef long long ll;
ll N, X, Y, fac[maxn], inv[maxn];
ll power_mod(ll p, ll q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod, q >>= 1;
    }
    return ret;
}

void init() {
    fac[0] = 1;
    for(int i = 1; i <= maxn - 7; ++i) fac[i] = fac[i-1] * i % mod;
    inv[maxn - 7] = power_mod(fac[maxn - 7], mod - 2);
    for(int i = maxn - 8; i >= 0; --i) inv[i] = inv[i+1] * (i + 1) % mod;
}

ll C(ll x, ll y) { // calculate C_n^m
    if (x == y || y == 0) return 1;
    return fac[x] * inv[y] % mod * inv[x-y] % mod;
}

ll calc(ll x, ll t) {
    return C(N - t * (x - 1) - 1, t - 1) % mod;
}

int main() {
//    freopen("in.txt", "r", stdin);
    init();
    scanf("%lld%lld%lld", &N, &X, &Y);
    ll upper = std::min(N / X, N / Y), ans = 0;
    for (ll t = 1; t <= upper; t++) ans = (ans + calc(X, t) * calc(Y, t) % mod) % mod;
    printf("%lld\n", ans);
    return 0;
}
```