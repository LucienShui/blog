---
title: "Codeforces - 1139E - Maximize Mex"
date: 2019-03-26 01:27:00 +0800
last_modified_at: 2019-03-26 12:15:36 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["题解", "二分图", "图论", "codeforces"]
---

## 地址

https://codeforces.com/contest/1139/problem/E

## 原文地址

https://www.lucien.ink/archives/410

### 题意

$n$ 个点，$m$ 个集合，每个点都有一个权值，且只属于一个集合，每次你可以从每个集合中选定至多一个点，你的目标是使这些选出来的点权值的 $Mex$ 最大。有 $d$ 个询问，每个询问为一个数字 $k$ ，代表在上一次询问（如果有的话）的基础上，将第 $k$ 个点删掉之后，$Mex$ 最大可以是多少。

### 题解

~~恕我直言，这道题显然比 [D 题](https://www.lucien.ink/archives/409) 简单得多得多啊。~~

如果只询问一次且不删点的话显然二分图跑一遍即可。

对于删点，我们可以倒着来，使之变成往一个初始图中不断加点（边）的过程，每次在上一次的基础上跑一次二分图即可，~~复杂度不太会算~~，在 $Codeforces$ 上跑了 $46$ $ms$。

### 代码

https://pasteme.cn/4962

```cpp
## include <cstdio>
const int maxn = int(1e4) + 7;
int n, m, d, clk, base = 5000, link[maxn], val[maxn], group[maxn], query[maxn], ans[maxn], vis[maxn];
bool disabled[maxn];
struct { int next, v; } edge[maxn];
struct Graph {
    int head[maxn], cnt;
    void addedge(int u, int v) {
        edge[cnt] = {head[u], v};
        head[u] = cnt++;
    }
} graph;
void init() {
    for (int i = 0; i < maxn; i++) link[i] = graph.head[i] = -1;
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) scanf("%d", val + i);
    for (int i = 1; i <= n; i++) scanf("%d", group + i);
    scanf("%d", &d);
    for (int i = 1; i <= d; i++) scanf("%d", query + i), disabled[query[i]] = true;
    for (int i = 1; i <= n; i++) if (!disabled[i]) graph.addedge(val[i], group[i] + base);
}
bool dfs(int u) {
    for (int i = graph.head[u]; ~i; i = edge[i].next) {
        int v = edge[i].v;
        if (vis[v] == clk) continue;
        vis[v] = clk;
        if (link[v] == -1 || dfs(link[v])) {
            link[v] = u;
            return true;
        }
    }
    return false;
}
int calc(int l) {
    for (int i = l; i < maxn; i++) {
        if (link[i] == -1) {
            clk++;
            if (!dfs(i)) return i;
        }
    }
}
void solve() {
    for (int i = d; i >= 1; i--) {
        ans[i] = calc(ans[i + 1]);
        int idx = query[i];
        graph.addedge(val[idx], group[idx] + base);
    }
}
int main() {
    init();
    solve();
    for (int i = 1; i <= d; i++) printf("%d\n", ans[i]);
    return 0;
}
```