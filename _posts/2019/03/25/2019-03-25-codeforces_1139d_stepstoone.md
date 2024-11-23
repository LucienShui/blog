---
title: "Codeforces - 1139D - Steps to One"
date: 2019-03-25 01:30:00 +0800
last_modified_at: 2019-04-07 00:53:37 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1139/problem/D

## 原文地址

https://www.lucien.ink/archives/409

### 题意

模拟一个循环，一开始有一个空序列，之后每次循环：

1. 从 $[1, m]$ 中等概率选出一个数字添加到序列里去。

2. 检查这个序列所有元素的 $gcd$ 是否为 $1$，如果为 $1$ 则停止，若否则重复 $1$ 操作直至 $gcd$ 为 $1$ 为止。

求这个序列的长度期望。

### 题解

（废了很大的劲才理解朴素做法，并不会队友 $O(m \cdot log_2m)$ 的写法，`Orz` 好菜啊）。

设 $f_i$ 为当前序列的 $gcd$ 为 $i$ 时，将这个序列的 $gcd$ 变为 $1$ 的期望次数。

显然有 $f_1 = 0$ 。

接下来讨论 $i > 1$ 的情况，根据意义我们可以得到：

$$f_i = 1 + \sum_{j = 1}^{m} \frac{f_{gcd(i, j)}}{m}$$

这是一个优秀的 $O(m^2log_2{10^5})$ 的超时算法，考虑优化。

观察上式子中的 $gcd(i, j)$ ，我们发现可以只枚举 $i$ 的因子，设 $calc(x, y)$ 为计算集合 $\{i | i \in [1, m], gcd(x, i) = y\}$ 的元素数量 $|set|$ ，那么上式就演化为：

$$f_i = 1 + \sum_{k \in divisors(i)} \frac{calc(i, k)}{m} \cdot f_k$$

发现等式右边也会含有 $f_i$ ，为了消除影响，将其挪至等式左侧并化简：

$$f_i = 1 + \frac{\lfloor \frac{m}{i} \rfloor}{m} \cdot f_i + \sum_{k \in divisors(i) \cap k \neq i} \frac{calc(i, k)}{m} \cdot f_k$$

$$f_i - \frac{\lfloor \frac{m}{i} \rfloor}{m} \cdot f_i = 1 + \sum_{k \in divisors(i) \cap k \neq i} \frac{calc(i, k)}{m} \cdot f_k$$

$$f_i \cdot (1 - \frac{\lfloor \frac{m}{i} \rfloor}{m}) = 1 + \sum_{k \in divisors(i) \cap k \neq i} \frac{calc(i, k)}{m} \cdot f_k$$

$$f_i = \frac{1 + \sum_{k \in divisors(i) \cap k \neq i} \frac{calc(i, k)}{m} \cdot f_k}{1 - \frac{\lfloor \frac{m}{i} \rfloor}{m}}$$

忽略 $calc$ 的复杂度，那么外围复杂度为 $O(mlog_2m)$ ，下面考虑 $calc$ 函数：

对于集合 $set = \{i | i \in [1, m], gcd(x, i) = y\}$ ，令：

$$
\begin{cases}
x = k_x \cdot y& (1 \leq k_x, k_x \in Z)\\
i = k_i \cdot y& (1 \leq k_i, k_i \in Z)
\end{cases}
$$

那么：

$$
\begin{cases}
x = k_x \cdot y \\
i = k_i \cdot y \\
1 \leq i \leq m \\
gcd(x, i) = y
\end{cases}
\Rightarrow
\begin{cases}
k_x = \frac{x}{y} \\
k_i = \frac{i}{y} \\
1 \leq k_i \leq \frac{m}{y} \\
gcd(k_x, k_i) = 1
\end{cases}
$$

显然，当且仅当 $m' = \frac{m}{y}, x' = \frac{x}{y}$ 时，集合 $set' = \{i | i \in [1, m'], gcd(x', i) = 1\}$ 的元素数量 $|set'| = |set|$ 。

考虑计算 $|set'|$ ，那么问题就变成了，给定 $m'$ 和 $x'$ ，求 $[1, m']$ 中与 $x'$ 互质的元素的数量，设 $n$ 为 $x'$ 的质因子的数量，这个子问题的复杂度为 $O(2 ^ n \cdot n)$。

最后的总复杂度为 $O(m \cdot log_2m \cdot 2 ^ n \cdot n)$ 。

### 代码

https://pasteme.cn/4936

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7, mod = int(1e9) + 7;
bool not_prime[maxn];
std::vector<int> factor[maxn], prime_factor[maxn];
int f[maxn], m;

ll qpow(ll p, ll q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return ret;
}

void init() {
    for (int i = 2; i < maxn; i++) {
        for (int j = 2; i * j < maxn; j++) factor[i * j].push_back(i);
        if (!not_prime[i]) {
            for (int j = 1; i * j < maxn; j++) {
                int num = i * j;
                not_prime[num] = true;
                prime_factor[num].push_back(i);
            }
        }
    }
}

int __calc(int a, int b) {
    int ret = b;
    std::vector<int> buf;
    for (int &it : prime_factor[a]) buf.push_back(it);
    int len = int(buf.size());
    for (int i = 1; i < 1 << len; i++) {
        int tmp = 1;
        for (int j = 0; j < len; j++) {
            if ((i >> j) & 1) {
                tmp = -tmp * buf[j];
            }
        }
        ret += b / tmp;
    }
    return ret;
}

int calc(int x, int y) {
    return __calc(x / y, m / y);
}

int main() {
    init();
    std::cin >> m;
    int inv_m = int(qpow(m, mod - 2)), ans = 1;
    for (int i = 2; i <= m; i++) {
        f[i] = 1;
        for (auto &k : factor[i]) {
            f[i] = int((f[i] + 1ll * calc(i, k) * f[k] % mod * inv_m % mod) % mod);
        }
        f[i] = int(1ll * f[i] * qpow((1 - 1ll * (m / i) * inv_m % mod + mod) % mod, mod - 2) % mod);
        ans = int((ans + 1ll * f[i] * inv_m % mod) % mod);
    }
    std::cout << ans << std::endl;
    return 0;
}
```