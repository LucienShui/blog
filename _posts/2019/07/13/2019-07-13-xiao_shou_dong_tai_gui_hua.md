---
title: "销售 - 动态规划"
date: 2019-07-13 11:10:00 +0800
last_modified_at: 2019-07-13 11:10:31 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

## 销售 - 动态规划

### 原文链接

https://blog.lucien.ink/archives/456/

### 题目地址

https://icpc.upc.edu.cn/problem.php?id=12765

### 题目

农夫 John 正在筹划从他的谷仓中售出 N 头奶牛，与此同时也有 N 个农夫想要购买奶牛。每个农夫都有刚好足够购买一头奶牛的钱并且将会把买来的这头奶牛用来挤奶。为了减少买来的牛挤不出奶的风险，农夫们每个人都将会购买两头不同的奶牛各自一半的产权，然后将获得每头牛产奶量的一半。
如果将两种方案中每个农夫都购买了相同的奶牛看作是相同的销售方案。那么农夫 John 一共有多少种不同的销售方案呢？

### 题解

$f_{i, j}$ 代表还剩 $i$ 头没有被选的奶牛和 $j$ 头被选了一次的奶牛时的方案数，则有：

1. 选两头被选过一次的奶牛：$f_{i, j} = C_j^2 \cdot f_{i, j - 2}$
2. 选两头没有被选过的奶牛：$f_{i, j} = C_i^2 \cdot f_{i - 2, j + 2}$
3. 选一头被选过一次的奶牛和一头没被选过的奶牛：$f_{i, j} = i \cdot j \cdot f_{i - 1, j}$

#### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 2007, mod = int(1e7) + 7;
typedef long long ll;
ll C[maxn][maxn];
ll calc(ll x) {
    return x * (x - 1) >> 1;
}

ll f(int a, int b) {
    if (~C[a][b]) return C[a][b];
    ll ret = 0;
    if (b >= 2) ret = (ret + calc(b) * f(a, b - 2)) % mod;
    if (a >= 2) ret = (ret + calc(a) * f(a - 2, b + 2)) % mod;
    if (a >= 1 && b >= 1) ret = (ret + 1ll * a * b * f(a - 1, b)) % mod;
    return C[a][b] = ret;
}

ll t, n;
int main() {
    memset(C, 0xff, sizeof(C));
    C[0][0] = 1, C[1][0] = 0, C[2][0] = 1, C[3][0] = 6;
    scanf("%lld", &t);
    while (t--) {
        scanf("%lld", &n);
        printf("%lld\n", f(n, 0));
    }
    return 0;
}

```
