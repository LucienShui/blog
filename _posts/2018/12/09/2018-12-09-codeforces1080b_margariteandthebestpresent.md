---
title: "Codeforces 1080B - Margarite and the best present"
date: 2018-12-09 01:48:43 +0800
last_modified_at: 2018-12-09 01:48:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1080B - Margarite and the best present

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/B

---
### 题目

Little girl Margarita is a big fan of competitive programming. She especially loves problems about arrays and queries on them.

Recently, she was presented with an array $a$ of the size of $10^9$ elements that is filled as follows: 

+ $a_1 = -1$ 
+ $a_2 = 2$ 
+ $a_3 = -3$ 
+ $a_4 = 4$ 
+ $a_5 = -5$ 
+ And so on ... 

That is, the value of the $i$-th element of the array $a$ is calculated using the formula $a_i = i \cdot (-1)^i$.

She immediately came up with $q$ queries on this array. Each query is described with two numbers: $l$ and $r$. The answer to a query is the sum of all the elements of the array at positions from $l$ to $r$ inclusive.

Margarita really wants to know the answer to each of the requests. She doesn't want to count all this manually, but unfortunately, she couldn't write the program that solves the problem either. She has turned to you — the best programmer.

Help her find the answers!

---
### 题意

&emsp;&emsp;给你 $q$ 次询问，每次询问一个区间 $[l, r]$，输出 $\sum_{i = l}^{r}i \cdot (-1)^i$。

---
### 思路

&emsp;&emsp;用两次等差数列求和公式，注意边界即可，单次询问复杂度为 $O(1)$。

---
### 实现

https://pasteme.cn/2337

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll calc(ll l, ll r) {
    return (r + l) / 2 * ((r - l) / 2 + 1);
}
int main() {
    int _, l, r;
    for (scanf("%d", &_); _; _--) {
        scanf("%d%d", &l, &r);
        ll ans = calc(l + (l & 1), r - (r & 1));
        ans -= calc(l | 1, r - (r % 2 == 0));
        printf("%lld\n", ans);
    }
    return 0;
}
```