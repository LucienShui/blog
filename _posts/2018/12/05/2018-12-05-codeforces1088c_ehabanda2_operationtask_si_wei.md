---
title: "Codeforces 1088C - Ehab and a 2-operation task - 思维"
date: 2018-12-05 03:42:54 +0800
last_modified_at: 2018-12-05 03:42:54 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## Codeforces 1088C - Ehab and a 2-operation task

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/C

---
### 题目

You're given an array $a$ of length $n$. You can perform the following operations on it:

+ choose an index $i$ $(1 \le i \le n)$, an integer $x$ $(0 \le x \le 10^6)$, and replace $a_j$ with $a_j+x$ for all $(1 \le j \le i)$, which means add $x$ to all the elements in the prefix ending at $i$. 
+ choose an index $i$ $(1 \le i \le n)$, an integer $x$ $(1 \le x \le 10^6)$, and replace $a_j$ with $a_j \% x$ for all $(1 \le j \le i)$, which means replace every element in the prefix ending at $i$ with the remainder after dividing it by $x$. 

Can you make the array **strictly increasing** in no more than $n+1$ operations?

---
### 题意

&emsp;&emsp;初始时你有一个元素个数为$n$的数组，第$i$个元素的初始值为$a_i$，你有两种操作：

+ 将区间$[1, i]$中所有的数字都加上$x$
+ 将区间$[1, i]$中所有的数字都对$x$取模

&emsp;&emsp;问能否在$n + 1$步之内将这个序列变成一个严格递增的序列。

---
### 思路

&emsp;&emsp;考虑让$n$个数分别变为模意义下的$1 \dots n$，随便取一个大于$n$的模数，比如说$mod = n + 1$，也就是对于第$i$个数来说，我让其变为$k \cdot mod + i$，这样在进行了$n$次修改之后，第$n + 1$次修改我进行一次取模操作，第$i$个数就会变为$i$了。

---
### 实现

https://pasteme.cn/2209

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = 2007;
ll a[maxn], base = 0, cnt = 1;
int n, mod;
std::queue<std::pair<int, ll>> ans;
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%lld", a + i);
    mod = n + 1;
    for (int i = n; i >= 1; i--) {
        if ((a[i] + base) % mod == i) continue;
        cnt++;
        ll cur = a[i] + base, add = (mod - cur % mod) + i;
        base += add;
        ans.emplace(i, add);
    }
    printf("%lld\n", cnt);
    while (!ans.empty()) printf("1 %d %lld\n", ans.front().first, ans.front().second), ans.pop();
    printf("2 %d %d\n", n, mod);
    return 0;
}
```