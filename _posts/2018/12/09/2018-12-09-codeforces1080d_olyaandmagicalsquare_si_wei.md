---
title: "Codeforces 1080D - Olya and magical square - 思维"
date: 2018-12-09 01:50:58 +0800
last_modified_at: 2018-12-09 01:50:58 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## Codeforces 1080D - Olya and magical square - 思维

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/D

---
### 题目

Recently, Olya received a magical square with the size of $2^n\times 2^n$.

It seems to her sister that one square is boring. Therefore, she asked Olya to perform **exactly** $k$ *splitting operations*.

A *Splitting operation* is an operation during which Olya takes a square with side $a$ and cuts it into 4 equal squares with side $\dfrac{a}{2}$. If the side of the square is equal to $1$, then it is impossible to apply a splitting operation to it (see examples for better understanding).

Olya is happy to fulfill her sister's request, but she also wants *the condition of Olya's happiness* to be satisfied after all operations.

*The condition of Olya's happiness* will be satisfied if the following statement is fulfilled:

Let the length of the side of the lower left square be equal to $a$, then the length of the side of the right upper square should also be equal to $a$. There should also be a path between them that consists only of squares with the side of length $a$. All consecutive squares on a path should have a common side.

Obviously, as long as we have one square, these conditions are met. So Olya is ready to fulfill her sister's request only under the condition that she is satisfied too. Tell her: is it possible to perform exactly $k$ splitting operations in a certain order so that the condition of Olya's happiness is satisfied? If it is possible, tell also the size of the side of squares of which the path from the lower left square to the upper right one will consist.

---
### 题意

&emsp;&emsp;有一个初始时宽为 $2^n$ 的正方形，你每次可以对一个完整的正方形进行四等分。问是否存在一种方案，使得在恰好四等分 $k$ 次之后，存在一条等宽的路径，使得左下角的方块和右上角的方块联通（四联通），如果这种方案存在，输出路径的宽度对 $2$ 取对数的值。

---
### 思路

&emsp;&emsp;显然 $n$ 大于 $31$ 的时候我可以只切一刀，剩下的刀全切右下角的那一块，这样一来答案就是 $n - 1$。

&emsp;&emsp;在 $n$ 小于等于 $31$ 的时候可以枚举答案，枚举的同时判断一下当前状态是否可行，输出任意解即可。单组测试用例复杂度为 $O(31)$。

---
### 实现

https://pasteme.cn/2339

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll tot[37], n, k, _;
void init() {
    ll cur = 1;
    for (int i = 0; i <= 31; i++, cur *= 4) tot[i] = (cur - 1) / 3;
}
ll solve(ll n, ll k) {
    if (n > 31) return n - 1;
    for (int i = 0; i < n; i++) {
        ll tmp = n - i, need = (1ll << tmp + 1) - tmp - 2;
        if (need <= k) {
            ll last = tot[n] - ((1ll << tmp + 1) - 1) * tot[i];
            if (last >= k) return i;
        }
    }
    return -1;
}
int main() {
    init();
    for (scanf("%lld", &_); _; _--) {
        scanf("%lld%lld", &n, &k);
        ll ans = solve(n, k);
        if (~ans) printf("YES %lld\n", ans);
        else puts("NO");
    }
    return 0;
}
```