---
title: "Codeforces 1082A - Vasya and Book"
date: 2018-12-01 01:27:43 +0800
last_modified_at: 2018-12-01 01:27:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1082A - Vasya and Book

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/A

------

### 题目

&emsp;&emsp;Vasya is reading a e-book. The file of the book consists of $n$ pages, numbered from $1$ to $n$. The screen is currently displaying the contents of page $x$, and Vasya wants to read the page $y$. There are two buttons on the book which allow Vasya to scroll $d$ pages forwards or backwards (but he cannot scroll outside the book). For example, if the book consists of $10$ pages, and $d = 3$, then from the first page Vasya can scroll to the first or to the fourth page by pressing one of the buttons; from the second page — to the first or to the fifth; from the sixth page — to the third or to the ninth; from the eighth — to the fifth or to the tenth.

&emsp;&emsp;Help Vasya to calculate the minimum number of times he needs to press a button to move to page $y$.

------

### 题意

&emsp;&emsp;这个人有一本$n$页的书，他每次翻书可以从第$i$页翻到第$max(i - d, 1)$或$min(i + d, n)$页，问他能否从第$x$页翻到第$y$页。

------

### 思路

&emsp;&emsp;按照题意瞎搞一下。

------

### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll n, x, y, d, t;
int main() {
    std::cin >> t;
    while (t--) {
        std::cin >> n >> x >> y >> d;
        if (abs(y - x) % d == 0) printf("%lld\n", abs(y - x) / d);
        else {
            ll ans = ll(1e18);
            if ((y - 1) % d == 0) ans = std::min(ans, (y - 1) / d + (x - 1 + d - 1) / d);
            if ((n - y) % d == 0) ans = std::min(ans, (n - y) / d + (n - x + d - 1) / d);
            if (ans == ll(1e18)) puts("-1");
            else printf("%lld\n", ans);
        }
    }
    return 0;
}
```