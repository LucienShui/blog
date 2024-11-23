---
title: "ARC-060E - Tak and Hotels - 贪心"
date: 2018-05-20 20:46:00 +0800
last_modified_at: 2018-05-20 23:37:16 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["贪心"]
---

### 题目链接

https://arc060.contest.atcoder.jp/tasks/arc060_c

---
### 题目

#### Problem Statement
N hotels are located on a straight line. The coordinate of the i-th hotel $(1≤i≤N)$ is $x_i$.

Tak the traveler has the following two personal principles:

He never travels a distance of more than L in a single day.
He never sleeps in the open. That is, he must stay at a hotel at the end of a day.
You are given Q queries. The $j$-th $(1≤j≤Q)$ query is described by two distinct integers aj and bj. For each query, find the minimum number of days that Tak needs to travel from the aj-th hotel to the bj-th hotel following his principles. It is guaranteed that he can always travel from the aj-th hotel to the bj-th hotel, in any given input.

#### Constraints
+ $2≤N≤105$
+ $1≤L≤109$
+ $1≤Q≤105$
+ $1≤x_i<x_2<…<x_N≤109$
+ $x_i+1−x_i≤L$
+ $1≤a_j,b_j≤N$
+ $a_j≠b_j$
+ $N, L, Q, x_i, a_j, b_j$ are integers.
#### Partial Score
$200$ points will be awarded for passing the test set satisfying $N≤10^3$ and $Q≤10^3$.
#### Input
The input is given from Standard Input in the following format:

$N$
$x_1$ $x_2$ $…$ $x_N$
$L$
$Q$
$a_1$ $b_1$
$a_2$ $b_2$
$:$
$a_Q$ $b_Q$
#### Output
Print Q lines. The j-th line $(1≤j≤Q)$ should contain the minimum number of days that Tak needs to travel from the $a_j$-th hotel to the $b_j$-th hotel.



---
### 题意

&emsp;&emsp;有`n`个点，第`i`个点的坐标为`x[i]`，有一个人每天最多走`L`米，他每天必须从某个点出发，然后再终止于某个点，有`Q`个询问，代表他的起点和终点，问最少需要多少天可以到达。

---
### 思路

&emsp;&emsp;预处理一下，倍增的过程中统计答案即可，路径不唯一，但答案一定是唯一的。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, inf = 0x3f3f3f3f;
int n, x[maxn], up[maxn][20], l, q, u, v, e[27] = {1}, ans, tmp;
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", x + i);
    scanf("%d%d", &l, &q);
    memset(up, 0x3f, sizeof(up));
    int cur = 1;
    for (int i = 1; i <= n; i++) while (x[i] > x[cur] + l) up[cur++][0] = i - 1;
    for (int j = 1; j < 20; j++) {
        e[j] = e[j - 1] << 1;
        for (int i = 1; i <= n; i++) if (up[i][j - 1] < inf)
            up[i][j] = up[up[i][j - 1]][j - 1];
    }
    while (ans = 0, q--) {
        scanf("%d%d", &u, &v);
        if (u > v) std::swap(u, v);
        for (int i = 19; i >= 0; i--) if (up[u][i] < v) u = up[u][i], ans += e[i];
        printf("%d\n", ans + 1);
    }
    return 0;
}
```