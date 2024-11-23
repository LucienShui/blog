---
title: "Codeforces - 1152B - Neko Performs Cat Furrier Transform"
date: 2019-04-25 00:50:03 +0800
last_modified_at: 2019-04-25 00:50:03 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1152/problem/B

## 原文地址

https://www.lucien.ink/archives/422/

### 题意

给你一个 $x$ ，让你在 $40$ 步之内把它变成 $2 ^ n - 1$ 的形式，你一定会在奇数步将其异或上一个值 $2 ^ k - 1$ ，在偶数步将其自增 $1$ ，让你输出你需要花多少步，以及每次奇数步时的 $k$ 值。

### 题解

观察可得，每次将最高位的 $0$ 置为 $1$ 之后一定是最优的。

### 代码

https://pasteme.cn/6826

```cpp
## include <bits/stdc++.h>
int x, ans[107], len;
bool check(int x) {
    x++;
    return (x & -x) == x;
}
int main() {
    scanf("%d", &x);
    int h = 28, step = 0;
    while (!(x >> h)) h--;
    while (!check(x)) {
        step++;
        if (step & 1) {
            for (int i = h; i >= 0; i--) {
                if (!((x >> i) & 1)) {
                    x ^= ((1 << (i + 1)) - 1);
                    ans[++len] = i + 1;
                    break;
                }
            }
        } else x++;
    }
    printf("%d\n", step);
    for (int i = 1; i <= len; i++) printf("%d%c", ans[i], i == len ? '\n' : ' ');
    return 0;
}
```