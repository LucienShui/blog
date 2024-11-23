---
title: "Codeforces 1084C - The Fair Nut and String"
date: 2018-12-11 04:55:26 +0800
last_modified_at: 2018-12-11 04:55:26 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1084C - The Fair Nut and String

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/C

---
### 题意

&emsp;&emsp;给你一串字符串，问你能选出多少个形如 `aba` 这样的子序列（任意两个 `a` 之间至少包含一个 `b`），`a` 也算，`aba` 与 `abba` 与 `ab*ba` 算同一种，`aaba` 是非法的，复杂度 $O(n)$。

---
### 思路

&emsp;&emsp;显然可以只保留 `a` 和 `b`，然后把连续的 `a` 都提取出来，剩下的类似于统计 $DAG$ 不同路径数那样统计就可以。

---
### 实现

https://pasteme.cn/2420

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, mod = int(1e9) + 7;
char buf[maxn], str[maxn] = {'b'};
int len = 0, cnt[maxn], n = 0;
int main() {
    scanf("%s", buf);
    for (int i = 0; buf[i]; i++) if (buf[i] <= 'b') str[++len] = buf[i];
    for (int i = 1; i <= len; i++) {
        if (str[i] == 'a') {
            if (str[i - 1] == 'b') cnt[++n] = 1;
            else cnt[n]++;
        }
    }
    long long ans = 0;
    for (int i = 1; i <= n; i++) ans = (ans + (ans + 1) * cnt[i] % mod) % mod;
    printf("%lld\n", ans);
    return 0;
}

```