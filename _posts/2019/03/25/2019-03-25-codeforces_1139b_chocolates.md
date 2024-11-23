---
title: "Codeforces - 1139B - Chocolates"
date: 2019-03-25 01:26:32 +0800
last_modified_at: 2019-03-25 01:26:32 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心", "codeforces"]
---

## 地址

https://codeforces.com/contest/1139/problem/B

## 原文地址

https://www.lucien.ink/archives/407

### 题意

你有 $n$ 堆物品，第 $i$ 堆物品有 $a_i$ 个，如果你要从第 $i$ 堆物品中取走 $x_i$ 个，那么对于 $1 \leq j < i$ ，必须满足 $x_j < x_i \vee x_j = 0$ 。

问最多能拥有多少个物品。

### 题解

也就是说序列 $x_i$ 是一个上升子序列，最后一个物品一定会取，倒着扫一遍即可。

### 代码

https://pasteme.cn/4938

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(2e5) + 7;
int a[maxn], n;
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", a + i);
    ll sum = a[n];
    for (int i = n - 1; i >= 1; i--) {
        int tmp = std::max(0, std::min(a[i], a[i + 1] - 1));
        sum += tmp;
        a[i] = tmp;
    }
    printf("%lld\n", sum);
    return 0;
}
```