---
title: "Codeforces - 1166E - The LCMs Must be Large"
date: 2019-05-19 03:43:00 +0800
last_modified_at: 2019-05-22 19:40:53 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## Codeforces - 1166E - The LCMs Must be Large

### 地址

https://codeforces.com/contest/1166/problem/E

### 原文地址

https://www.lucien.ink/archives/434

### 题目

Dora the explorer has decided to use her money after several years of juicy royalties to go shopping. What better place to shop than Nlogonia?

There are $n$ stores numbered from $1$ to $n$ in Nlogonia. The $i$-th of these stores offers a **positive integer** $a_i$.

Each day among the last $m$ days Dora bought a single integer from some of the stores. The same day, Swiper the fox bought a single integer from all the stores that Dora did not buy an integer from on that day.

Dora considers Swiper to be her rival, and she considers that she beat Swiper on day $i$ if and only if the least common multiple of the numbers she bought on day $i$ is strictly greater than the least common multiple of the numbers that Swiper bought on day $i$.

The least common multiple (LCM) of a collection of integers is the smallest positive integer that is divisible by all the integers in the collection.

However, Dora forgot the values of $a_i$. Help Dora find out if there are positive integer values of $a_i$ such that she beat Swiper on **every** day. You don't need to find what are the possible values of $a_i$ though.

Note that it is possible for some values of $a_i$ to coincide in a solution.



### 题意

有 $n$ 种石头，每个石头有一个未知的权值，有 $m$ 天，每天一个整数 $k$ 代表这一天拿了 $k$ 个石头，接下来是 $k$ 个整数，代表石头的下标。

问是否存在一种分配权值的方案，使得每一天拿的所有石头权值的 $LCM$ 都严格大于补集中所有石头权值的 $LCM$ 。

### 题解

反证法，考虑某一天拿的集合为 $D_i$ ，补集为 $S_i$ ，另一天的集合为 $D_j$ ，补集为 $S_j$ ，且 $S_i$ 严格等于 $D_j$ 。假设题设成立，那么有：

$$LCM(D_i) > LCM(S_i) = LCM(D_j) > LCM(S_j) = LCM(D_i)$$

显然矛盾，所以不成立。

考虑另一个问题，假设 $A$ 是 $B$ 的子集，那么一定存在 $LCM(B) \ge LCM(A)$ 而且 $LCM(B) \mod LCM(A) = 0$ ，假设 $D_i$ 和 $D_j$ 的交集为空，那么 $D_j$ 一定为 $S_i$ 的真子集，同理，$D_i$ 也是 $S_j$ 的真子集，那么：

$$LCM(D_i) > LCM(S_i) \ge LCM(D_j) > LCM(S_j) \ge LCM(D_i)$$

显然也矛盾，即：**任意两天所拿的石头都必须有交集** (1)。

**2019年5月22日补充**

> 虽然不满足条件 (1) 一定不能赢，但满足条件 (1) 就一定可以赢吗？答案是不一定。但我们可以通过合理的构造来使得当满足条件 (1) 时是一定全胜的。
>
> 如何构造出来一组解呢？根据结论 (1) ，一个显然的想法就是将权值全都集中在有交集的那部分石头上，剩下的全为 $1$ ，这样一来我方取到的石头的 LCM 一定是严格大于对面的。
>
> 更详细一些，我们取出 $m$ 个互不相同的素数 ${p_1, p_2, \dots, p_{m - 1}, p_m}$ ，令 $n$ 个石头的权值为 ${a_1, a_2, a_3, \dots, a_{n - 1}, a_n}$ ，初始时 $a_i$ 均为 $1$ 。假设我们在第 $j$ 天访问了 $a_i$ ，那么我们就令 $a_i = a_i \cdot p_j$ ，这样一来 $p_j$ 就是 $a_i$ 的一个因子。
>
> 下面来证明这样分配一定是必胜的。我们知道在第 $i$ 天，我们访问了一个在第 $j$ 天访问过的石头，而且这个石头的权值一定是 $p_j$ 的倍数。所以对于每一天 $i$ ，$LCM(D_i) = p_1p_2\dots p_m$ 。另一方面，$S_i$ 并不包含 $p_i$ 这个因子，因为 $p_i$ 都在 $D_i$ 里，所以 $LCM(S_i)$ 严格小于 $LCM(D_i)$ 。

$m$ 的范围只有 $50$ ，所以直接 $O(nm^2)$ 暴力判断一下即可。

#### 代码

https://pasteme.cn/8174

```cpp
## include <bits/stdc++.h>
const int maxm = 57, maxn = int(1e4) + 7;
int m, n;
bool vis[maxm][maxn];
int main() {
    scanf("%d%d", &m, &n);
    for (int i = 1, cnt, buf; i <= m; i++) {
        scanf("%d", &cnt);
        while (cnt--) scanf("%d", &buf), vis[i][buf] = true;
    }
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= m; j++) {
            bool flag = false;
            for (int k = 1; k <= n && !flag; k++) {
                if (vis[i][k] && vis[j][k]) flag = true;
            }
            if (!flag) return 0 * puts("impossible");
        }
    }
    puts("possible");
    return 0;
}

```
