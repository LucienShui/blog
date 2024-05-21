---
title: "Codeforces 1082D - Maximum Diameter Graph - 贪心"
date: 2018-12-01 01:31:00 +0800
last_modified_at: 2018-12-01 01:47:57 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "贪心", "codeforces"]
---

## Codeforces 1082D - Maximum Diameter Graph - 贪心

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/D

------

### 题目

Graph constructive problems are back! This time the graph you are asked to build should match the following properties.

The graph is connected if and only if there exists a path between every pair of vertices.

The diameter (aka &quot;longest shortest path&quot;) of a connected undirected graph is the maximum number of edges in the **shortest** path between any pair of its vertices.

The degree of a vertex is the number of edges incident to it.

Given a sequence of $n$ integers $a_1, a_2, \dots, a_n$ construct a **connected undirected** graph of $n$ vertices such that:

- the graph contains no self-loops and no multiple edges;
- the degree $d_i$ of the $i$-th vertex doesn't exceed $a_i$ (i.e. $d_i \le a_i$);
- the diameter of the graph is maximum possible.

Output the resulting graph or report that no solution exists.

------

### 题意

&emsp;&emsp;有$n$个点，第$i$个点的度最大为$a_i$，问将这$n$个点连通后图的最大直径是多少。

------

### 思路

&emsp;&emsp;判断是否能构造一个连通图，如果可以的话，将所有度数大于$1$的点连成一条线，剩下度为一点尽量连一下最左边和最右边的点，然后随便连即可。可以证明，这样贪心一定是最优的。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 507;
int n, sum, cnt, ans;
struct Node {
    int deg, index;
} node[maxn];
std::queue<int> que;
struct Edge {
    int u, v;
} edge[maxn << 1];
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    scanf("%d", &n);
    int len = 0;
    for (int i = 1, buf; i <= n; i++) {
        scanf("%d", &buf);
        sum += buf;
        if (buf == 1) que.push(i);
        else node[++len] = {buf, i};
    }
    if (sum < (n - 1) * 2) return 0 * puts("NO");
    for (int i = 1; i < len; i++) {
        edge[++cnt] = {node[i].index, node[i + 1].index};
        node[i].deg--;
        node[i + 1].deg--;
        ans++;
    }
    if (!que.empty()) {
        int cur = que.front();
        que.pop();
        edge[++cnt] = {cur, node[1].index};
        node[1].deg--;
        ans++;
    }
    if (!que.empty()) {
        int cur = que.front();
        que.pop();
        edge[++cnt] = {cur, node[len].index};
        node[len].deg--;
        ans++;
    }
    while (!que.empty()) {
        int cur = que.front();
        que.pop();
        for (int i = 1; i <= len; i++) {
            if (node[i].deg > 0) {
                edge[++cnt] = {node[i].index, cur};
                node[i].deg--;
                break;
            }
        }
    }
    printf("YES %d\n", ans);
    printf("%d\n", cnt);
    for (int i = 1; i <= cnt; i++) printf("%d %d\n", edge[i].u, edge[i].v);
    return 0;
}
```