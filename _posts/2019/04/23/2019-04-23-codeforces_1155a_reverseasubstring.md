---
title: "Codeforces - 1155A - Reverse a Substring"
date: 2019-04-23 15:29:00 +0800
last_modified_at: 2019-04-23 15:29:14 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1155/problem/A

## 原文地址

https://www.lucien.ink/archives/417/

## 题意

给你一个串 $s$ ，问能否翻转一个区间使得它的字典序变小。

## 题解

先 `sort` 一下判断是否可以，可以的话枚举一下。

### 代码

https://pasteme.cn/6687

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
char str[maxn], buf[maxn];
int n;
int main() {
    scanf("%d%s", &n, str);
    strcpy(buf, str);
    std::sort(buf, buf + n);
    if (strcmp(str, buf) == 0) return 0 * puts("NO");
    puts("YES");
    for (int i = 0; i < n; i++) {
        if (str[i] > buf[i]) {
            for (int j = n - 1; j > i; j--) {
                if (str[j] == buf[i]) {
                    return 0 * printf("%d %d\n", i + 1, j + 1);
                }
            }
        }
    }
    return 0;
}
```