---
title: "Codeforces 1076C - Meme Problem"
date: 2018-12-22 17:25:29 +0800
last_modified_at: 2018-12-22 17:25:29 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1076C - Meme Problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/C

---
### 题意

给你一个非负整数 $d$ ，你要找到两个非负的自然数 $a$、$b$，使得 $a + b = d$ 和 $a \cdot b = d$ 同时成立，问是否存在这样的一对 $a$、$b$，不存在输出 `N`，存在的话输出 `Y a b`。

---
### 思路

$$\begin{cases}a + b = d\\a \ \cdot \  b = d\end{cases}$$

$$\Rightarrow a \cdot (d - a) = d$$

$$\Rightarrow a ^ 2 - d \cdot a + d = 0$$

解一下这个方程即可。

---
### 实现

https://pasteme.cn/2741

```cpp
## include <bits/stdc++.h>
std::vector<double> solve(double a, double b, double c) {
    std::vector<double> ret;
    double delta = b * b - a * c * 4;
    if (delta < 0) return ret;
    delta = sqrt(delta);
    double x[2] = {(-b - delta) / 2 / a, (-b + delta) / 2 / a};
    for (double i : x) if (i > 0) ret.push_back(i);
    return ret;
}
int solve(std::vector<double> ans, int d) {
    for (auto i : ans) if (fabs((d - i) * i - d) < 1e-9) return printf("Y %.9lf %.9lf\n", i, d - i);
    return 0 * puts("N");
}
int main() {
    int t, d;
    for (std::cin >> t; t; t--) {
        std::cin >> d;
        if (d != 0) solve(solve(1, -d, d), d);
        else puts("Y 0.000000000 0.000000000");
    }
    return 0;
}
/*
 * a + b = d
 * a * b = d
 * b = d - a
 * a * (d - a) = d
 * a * d - a * a = d
 * a * a - d * a + d = 0
 */

```