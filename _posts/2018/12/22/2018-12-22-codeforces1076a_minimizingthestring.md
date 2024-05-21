---
title: "Codeforces 1076A - Minimizing the String"
date: 2018-12-22 17:23:54 +0800
last_modified_at: 2018-12-22 17:23:54 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1076A - Minimizing the String

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/A

---
### 题意

你有一个字符串，你最多可以删掉一个字母，使得剩下的字符串的字典序最小。

---
### 思路

从左向右找到第一个当前字母小于下一个字母的位置，删掉这个字母即可。

---
### 实现

https://pasteme.cn/2739

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
char str[maxn];
int n, ans = -1;
int main() {
    scanf("%d %s", &n, str + 1);
    for (int i = 1; i <= n && ans == -1; i++) if (str[i] > str[i + 1]) ans = i;
    for (int i = 1; i <= n; i++) if (i != ans) printf("%c", str[i]);
    return 0;
}
```