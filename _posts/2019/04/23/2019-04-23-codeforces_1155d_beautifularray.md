---
title: "Codeforces - 1155D - Beautiful Array"
date: 2019-04-23 15:54:27 +0800
last_modified_at: 2019-04-23 15:54:27 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "codeforces"]
---

## 地址

https://codeforces.com/contest/1155/problem/D

## 原文地址

https://www.lucien.ink/archives/420/

## 题意

你有一个长为 $n$ 的序列，你可以选择一个子区间（可以为空），将这个子区间所有的元素乘以 $x$ ，问做完上述操作之后这个序列的最大连续区间和可以是多少。

## 题解

记状态为 `f[i][status]` ，其中 $status \in \{used, unused, inuse\}$

`used` 代表已经使用过了 $x$ ，`unused` 代表暂时还没使用 $x$ ，`inuse` 代表正在使用 $x$ ，转移一下即可。

### 代码

https://pasteme.cn/6690

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
typedef long long ll;
enum { used, inuse, unused };
ll n, x, ans, a[maxn], f[maxn][3];
int main() {
    std::cin >> n >> x;
    for (int i = 1; i <= n; i++) std::cin >> a[i];
    for (int i = 1; i <= n; i++) {
        f[i][unused] = std::max(f[i - 1][unused] + a[i], a[i]);
        f[i][inuse] = std::max({f[i - 1][unused] + a[i] * x, f[i - 1][inuse] + a[i] * x, a[i] * x});
        f[i][used] = std::max({f[i - 1][inuse] + a[i], f[i - 1][used] + a[i], a[i]});
        for (int j = 0; j < 3; j++) ans = std::max(ans, f[i][j]);
    }
    std::cout << ans << std::endl;
    return 0;
}
```
