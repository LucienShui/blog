---
title: "Codeforces 1087B - Div Times Mod"
date: 2018-12-24 01:13:47 +0800
last_modified_at: 2018-12-24 01:13:47 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1087B - Div Times Mod

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/B

---
### 题意

给你一个 $n$、$k$ ，找到一个最小的 $x$ 使得 $\lfloor x \div k \rfloor \cdot (x\ mod\ k) = n$ 成立。

---
### 思路

令 $x = a \cdot k + b\ (b < k)$，枚举一下 $b$ 即可。

---
### 实现

https://pasteme.cn/2802

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll n, k, ans = 0x3f3f3f3f3f3f3f3f;
    std::cin >> n >> k;
    for (ll b = k - 1; b >= 1; b--) {
        if (n % b == 0) {
            ll a = n / b;
            ans = std::min(ans, a * k + b);
        }
    }
    std::printf("%lld\n", ans);
    return 0;
}

```