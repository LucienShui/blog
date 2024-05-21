---
title: "Codeforces 1084D - The Fair Nut and the Best Path - 树形DP"
date: 2018-12-11 04:56:00 +0800
last_modified_at: 2018-12-11 23:59:47 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "codeforces"]
---

## Codeforces 1084A - The Fair Nut and the Best Path - 树形DP

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/D

---
### 题意

&emsp;&emsp;给你一棵树，数上的每个点都有一个正权值，每条边都有一个负权值，让你在树中找一条简单路径，使得权值和最大。

---
### 思路

&emsp;&emsp;我们定义 $f_i$ 为从以节点 $i$ 为根的子树中出发，到达节点 $i$ 时的最大权值和，转移方程为：

$$f_u = max\{f_v - cost_{u, v} + w_u\}$$

&emsp;&emsp;这样处理的是竖着的路径，其中 $v$ 是 $u$ 的每一个儿子。穿过节点 $i$ 的横向路径的最大值为：

$$({f_{v_1} - cost_{u, v_1}})_{最大值} + ({f_{v_2} - cost_{u, v_2}})_{次大值} + w_u$$

&emsp;&emsp;答案在所有 $f_i$ 与上述表达式中取最大值，复杂度为 $O(n)$。

---
### 实现

https://pasteme.cn/2421

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
std::vector<std::pair<int, long long>> edge[maxn];
long long ans = 0, f[maxn];
int n, w[maxn];
void dfs(int u, int pre) {
    f[u] = w[u];
    long long max[2] = {0, 0};
    for (auto cur : edge[u]) {
        int v = cur.first;
        long long cost = cur.second;
        if (v != pre) {
            dfs(v, u);
            long long tmp = f[v] - cost;
            if (tmp > max[0]) std::swap(max[0], tmp);
            max[1] = std::max(max[1], tmp);
            f[u] = std::max(f[u], f[v] - cost + w[u]);
        }
    }
    ans = std::max({f[u], ans, max[0] + max[1] + w[u]});
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", w + i);
    for (int i = 1, u, v, cost; i < n; i++) {
        scanf("%d%d%d", &u, &v, &cost);
        edge[u].emplace_back(v, cost);
        edge[v].emplace_back(u, cost);
    }
    dfs(1, 1);
    printf("%lld\n", ans);
    return 0;
}
```