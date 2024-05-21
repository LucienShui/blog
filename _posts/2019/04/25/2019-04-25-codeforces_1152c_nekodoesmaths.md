---
title: "Codeforces - 1152C - Neko does Maths"
date: 2019-04-25 00:58:22 +0800
last_modified_at: 2019-04-25 00:58:22 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["题解", "思维", "数论", "codeforces"]
---

## 地址

https://codeforces.com/contest/1152/problem/C

## 原文地址

https://www.lucien.ink/archives/423/

### 题意

给你 $a$ 和 $b$ ，找到一个最小的 $k$ ，使得 $lcm(a + k, b + k)$ 最小。

### 题解

不妨设 $a > b$ ，则有：

$$lcm(a + k, b + k)$$$$ = \frac{(a + k) \cdot (b + k)}{gcd(a + k, b+ k)}$$$$ = \frac{a \cdot b + (a + b) \cdot k + k ^ 2}{gcd(b + k, a - b)}$$

枚举 $a - b$ 的所有因子即可。

### 代码

https://pasteme.cn/6827

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll gcd(ll p, ll q) { return q ? gcd(q, p % q) : p; }
ll a, b, ans_k{}, ans = 0x3f3f3f3f3f3f3f3f;
ll calc(ll a, ll b) { // find minimal k, st. b * k >= a, then return b * k
    if (a <= b) return b;
    if (a % b == 0) return a;
    return (a + b - a % b);
}
std::vector<ll> fac;
int main() {
    scanf("%lld%lld", &a, &b);
    if (a == b) return 0 * puts("0");
    if (a < b) std::swap(a, b);
    ans = a * b / gcd(a, b);
    ll upper = calc(b, a - b);
    for (ll i = 1; i * i <= upper; i++) {
        if (upper % i == 0) {
            fac.push_back(i);
            fac.push_back(upper / i);
        }
    }
    for (auto each : fac) {
        ll k = calc(b, each) - b, tmp = (a * b + (a + b) * k + k * k) / each;
        if (tmp < ans) {
            ans = tmp;
            ans_k = k;
        }
    }
    printf("%lld\n", ans_k);
    return 0;
}
```