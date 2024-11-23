---
title: "Codeforces 1088E - Ehab and a component choosing problem - 贪心"
date: 2018-12-05 03:46:00 +0800
last_modified_at: 2018-12-05 12:41:02 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "贪心", "codeforces"]
---

## Codeforces 1088E - Ehab and a component choosing problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/E

---
### 题目

You're given a tree consisting of $n$ nodes. Every node $u$ has a weight $a_u$. You want to choose an integer $k$ $(1 \le k \le n)$ and then choose $k$ connected components of nodes that don't overlap (i.e every node is in at most 1 component). Let the set of nodes you chose be $s$. You want to maximize:

$$\frac{\sum\limits_{u \in s} a_u}{k}$$

In other words, you want to maximize the sum of weights of nodes in $s$ divided by the number of connected components you chose. Also, if there are several solutions, you want to **maximize $k$**.

Note that adjacent nodes **can** belong to different components. Refer to the third sample.

---
### 题意

&emsp;&emsp;你有一个拥有 $n$ 个节点的树，你要选 $k$ 个联通块出来，使得这 $k$ 个联通块中所有点的权值总和 $sum$ 与联通块个数 $k$ 的比值最大，多解时应使联通块的数量尽可能地多。

---
### 思路

&emsp;&emsp;考虑贪心，先求出权值和最大的联通块的权值和，记为 $max$ ，然后统计有多少个联通块的权值和与 $max$ 相等即可，显然，这样的贪心策略是最优的。

---
### 实现

https://pasteme.cn/2211

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
int n, a[maxn], cnt;
std::vector<int> edge[maxn];
long long max = -(int(1e9) + 7);
long long dfs(int u, int pre, bool flag) {
    long long sum = a[u];
    for (int v : edge[u]) if (v != pre) sum += std::max(0ll, dfs(v, u, flag));
    if (!flag) max = std::max(max, sum);
    else if (sum == max) cnt++, sum = 0;
    return sum;
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", a + i);
    for (int i = 1, u, v; i < n; i++) {
        scanf("%d%d", &u, &v);
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1, 1, false), dfs(1, 1, true);
    printf("%lld %d\n", cnt * max, cnt);
    return 0;
}
```