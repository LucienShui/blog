---
title: "Codeforces 1088A - Ehab and another construction problem"
date: 2018-12-05 03:31:00 +0800
last_modified_at: 2018-12-05 03:41:27 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1088A - Ehab and another construction problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/A

---
### 题目

Given an integer $x$, find 2 integers $a$ and $b$ such that: 

+ $1 \le a,b \le x$ 
+ $b$ divides $a$ ($a$ is divisible by $b$). 
+ $a \cdot b > x$. 
+ $\frac{a}{b} < x$. 

---
### 题意

&emsp;&emsp;给你一个$x$，让你找一对$a$、$b$，使得$a$、$b$满足上述条件。

---
### 思路

&emsp;&emsp;显然$x$等于$1$的时候无解，故特判掉，之后虽然可以观察出来解，但还是证明一下吧。

&emsp;&emsp;令：$a = k \cdot b\ (k \in Z)$

&emsp;&emsp;则有：$k \cdot b \cdot b > x$、$k < x$同时成立。

&emsp;&emsp;不妨设：$k = 1$，则有：$b ^ 2 > x$，此时$a = b$，

&emsp;&emsp;即：取$a = b = x$即可。

---
### 实现

https://pasteme.cn/2207

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll x;
    std::cin >> x;
    if (x == 1) puts("-1");
    else printf("%lld %lld\n", x, x);
    return 0;
}
```