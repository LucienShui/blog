---
title: "Codeforces - 1139A - Even Substrings"
date: 2019-03-25 01:25:00 +0800
last_modified_at: 2019-03-25 01:25:15 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "codeforces"]
---

## 地址

https://codeforces.com/contest/1139/problem/A

## 原文地址

https://www.lucien.ink/archives/406/

### 题意

给你一个只包含数字的字符串，问有多少个子串是偶数。

### 代码

https://pasteme.cn/4937

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
char str[maxn];
int main() {
    int n;
    scanf("%d%s", &n, str + 1);
    ll ans = 0;
    for (ll i = 1; i <= n; i++) {
        if ((str[i] - '0') % 2 == 0) {
            ans += i;
        }
    }
    printf("%lld\n", ans);
    return 0;
}
```