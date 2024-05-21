---
title: "UPCOJ-5333 - 大佬 - 数学期望"
date: 2018-01-23 10:03:00 +0800
last_modified_at: 2018-01-31 16:53:32 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["题解", "数论"]
---

### 题目：

#### 题目描述

辣鸡 ljh   NOI 之后就退役了，然后就滚去学文化课了。 
他发现 katarina 大佬真是太强了，于是就学习了一下 katarina 大佬的做题方法。 
比如这是一本有 n 道题的练习册， katarina 大佬每天都会做 k 道题。 
第一天做第 1~k 题，第二天做第 2~k + 1 题……第 n − k + 1 天做第 n − k + 1~n 道题。 
但是辣鸡 ljh 又不想太累，所以他想知道 katarina 大佬做完这本练习册的劳累度。 
每道题有它的难度值，假设今天 katarina 大佬做的题目中最大难度为 t ，那么今天 katarina 大佬的劳累度就是 wt r ，做完这本书的劳累值就是每天的劳累值之和。 
但是辣鸡 ljh 一道题都不会，自然也不知道题目有多难，他只知道题目的难度一定在 1~m 之间随机。 
他想让即将参加 NOIP 的你帮他算算 katarina 大佬做完这本书的劳累值期望 

#### 输入

第一行，三个整数 n, m, k  
第二行， m 个整数表示 wt1,...,wtm. 

#### 输出

输出劳累值期望对 1000000007 取模的值。 

#### 样例输入
```
2 2 2
1 2
```
#### 样例输出
```
750000007
```

#### 提示

有 {1,1}, {1,2}, {2,1}, {2,2} 四种可能，期望为7/4;
$1 \leq k \leq n \leq 500, 0 \leq w[t_i] \leq 998244353$

---
### 题意：

&emsp;&emsp;刚开始没太看懂题，在这里记一下。每天做k = 2道题，有n = 4道题，那么第一天做1、2，第二天做2、3，第三天做3、4，然后就结束了，会做n - k + 1天。三天里第i天的最大难度为$t_i(1 \leq t_i \leq m)$，那么这一天就会获得$w[t_i]$的劳累度。

---
### 思路：

&emsp;&emsp;题目的难度主要就是在如何计算这个区间最大值上面，观察了一下范围，发现应该是可以推个公式然后枚举的。

&emsp;&emsp;假设我们已知某一个长度为$k$的区间的最大难度为$i$，那么也就是说这个区间里每一道题随机出来的难度都不会超过$i$，所以我们用$1~i$去填满这个长度为k的区间。

$$i^k$$

&emsp;&emsp;但是这个方案数中还包含着一些所有难度都小于$i$，也就是说最大难度不是$i$的情况，所以要减去。

$$i^k-(i-1)^k$$

&emsp;&emsp;那么这个区间的贡献就是$w_i$。

&emsp;&emsp;然后我们从$1~m$枚举最大难度，再求和，就得到了一个区间里的难度贡献。

$$\sum_{i = 1}^m w_i \times (i^k - (i-1)^k)$$

&emsp;&emsp;再乘以区间总数，然后再除去所有的情况，就是最终答案了。

$$(n-k+1) \times \frac{\sum_{i = 1}^m w_i \times (i^k - (i-1)^k)}{m^k}$$

---
### 实现：

```cpp
## include <cstdio>
const int mod = 1000000007;
typedef long long ll;
ll qpow(ll p, ll q) {
    ll ret = 1;
    p %= mod;
    while (q) {
        if (q & 1) ret = (ret * p) % mod;
        p = (p * p) % mod;
        q >>= 1;
    }
    return ret % mod;
}
ll w[1007], n, m, k, e[1007], ans;
int main() {
    scanf("%lld%lld%lld", &n, &m, &k);
    for (int i = 1; i <= m; i++) scanf("%lld", w + i), ans = (ans + (w[i] * (((e[i] = qpow(i, k)) - e[i-1] + mod) % mod) % mod)) % mod;
    ans = (ans * (n - k + 1) % mod) * qpow(e[m], mod - 2) % mod;
    printf("%lld\n", ans);
    return 0;
}
```