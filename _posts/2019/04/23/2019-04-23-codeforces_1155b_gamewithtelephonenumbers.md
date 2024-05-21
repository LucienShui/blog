---
title: "Codeforces - 1155B - Game with Telephone Numbers"
date: 2019-04-23 15:38:03 +0800
last_modified_at: 2019-04-23 15:38:03 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1155/problem/B

## 原文地址

https://www.lucien.ink/archives/418/

## 题意

如果一个纯数字的串长度为 $11$ 且以数字 $8$ 开头，那么这个串就是一个好串，给你一个纯数字的串 $s$ ，你和另一个人轮流从中任意删掉一个数字，你先手，直到这个串的长度变为 $11$ ，如果最后的串是一个好串，那么你赢，问能否必胜。

## 题解

首先必败和必胜态和两人的取数顺序无关，只和次数和串本身有关。对方每次肯定尽可能地拿走最靠左的 $8$ ，那么看一下对方用完所有的操作之后我方能否将其变为一个好串即可。

### 代码

https://pasteme.cn/6688

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
int n, cnt;
char str[maxn], buf[maxn];
bool judge() {
    int len = 0;
    int b = (n - 11) / 2, a = n - 11 - b;
    for (int i = 0; i < n; i++) {
        if (str[i] == '8' && b > 0) b--;
        else buf[len++] = str[i];
    }
    for (int i = 0; i <= a; i++) {
        if (buf[i] == '8') return true;
    }
    return false;
}
int main() {
    scanf("%d%s", &n, str);
    puts(judge() ? "YES" : "NO");
    return 0;
}
```
