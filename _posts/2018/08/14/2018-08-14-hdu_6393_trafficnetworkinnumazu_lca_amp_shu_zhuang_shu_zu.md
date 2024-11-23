---
title: "HDU-6393 - Traffic Network in Numazu - LCA &amp; 树状数组"
date: 2018-08-14 01:39:00 +0800
last_modified_at: 2018-08-14 01:42:56 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["题解", "lca", "树状数组"]
---

### 题目链接

https://acm.hdu.edu.cn/showproblem.php?pid=6393

---

### 题目

#### Problem Description
Chika is elected mayor of Numazu. She needs to manage the traffic in this city. To manage the traffic is too hard for her. So she needs your help. 
You are given the map of the city —— an undirected connected weighted graph with $N$ nodes and $N$ edges, and you have to finish $Q$ missions. Each mission consists of $3$ integers $OP$, $X$ and $Y$. 
When $OP=0$, you need to modify the weight of the $X_{th}$ edge to $Y$. 
When $OP=1$, you need to calculate the length of the shortest path from node $X$ to node $Y$.
 

#### Input
The first line contains a single integer $T$, the number of test cases. 
Each test case starts with a line containing two integers $N$ and $Q$, the number of nodes (and edges) and the number of queries. $(3≤N≤10^5)(1≤Q≤10^5)$
Each of the following $N$ lines contain the description of the edges. The $i_{th}$ line represents the $i_{th}$ edge, which contains $3$ space-separated integers $u_i$, $v_i$, and $w_i$. This means that there is an undirected edge between nodes $u_i$ and $v_i$, with a weight of $w_i$. $(1\leq u_i,v_i\leq N)(1\leq w_i\leq 10^5)$
Then Q lines follow, the ith line contains $3$ integers $OP$, $X$ and $Y$. The meaning has been described above.$(0\leq OP\leq 1)(1\leq X\leq 10^5)(1\leq Y\leq 10^5)$
It is guaranteed that the graph contains no self loops or multiple edges.

#### Output
For each test case, and for each mission whose $OP=1$, print one line containing one integer, the length of the shortest path between $X$ and $Y$.

---

### 题意

&emsp;&emsp;给你$N$个点$N$条边的有权无向图，有两种询问，$op=0$代表把第$X$条边的权值改为$Y$，$op=1$代表查询点点$X$到点$Y$的最短路。

---

### 思路

&emsp;&emsp;可以观察所给的图是一棵基环树，可以将环的某一条边断开，通过树状数组来维护树上距离。这样一来两个点的最短路就是点到环的距离加上环内的距离。

---

### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
int swap(int &a, int &b, int c = 0) { c = a, a = b, b = c; }
struct Bit {
    ll data[maxn];
    int len;
    void init(int len_) { len = len_, memset(data, 0, sizeof(data)); }
    void add(int pos, int val) { while (pos <= len) data[pos] += val, pos += pos & -pos; }
    ll query(int pos) {
        ll ret = 0;
        while (pos) ret += data[pos], pos -= pos & -pos;
        return ret;
    }
} bit;
struct Edge { int u, v, val; } edge[maxn];
std::vector<int> edges[maxn];
int t, n, q, base, l[maxn], r[maxn], dep[maxn], up[maxn][20], dfn;
bool visNode[maxn], visEdge[maxn];
void dfs(int u, int pre = 0, int val = 0) {
    visNode[u] = true;
    dep[u] = dep[pre] + 1;
    l[u] = ++dfn;
    bit.add(dfn, val);
    for (int i : edges[u]) {
        if (edge[i].u == pre) continue;
        if (edge[i].v == u) swap(edge[i].u, edge[i].v);
        if (visNode[edge[i].v]) continue;
        visEdge[i] = true;
        up[edge[i].v][0] = u;
        dfs(edge[i].v, u, edge[i].val);
    }
    r[u] = dfn;
    bit.add(dfn + 1, -val);
}
void init(int n) {
    dfn = 0;
    bit.init(n);
    memset(visNode, 0, sizeof(visNode));
    memset(visEdge, 0, sizeof(visEdge));
    memset(up, 0xff, sizeof(up));
    for (int i = 1; i <= n; i++) edges[i].clear();
}
void process(int n) {
    dfs(1);
    for (int j = 1; j <= 18; j++)
        for (int i = 1; i <= n; i++)
            if (~up[i][j - 1])
                up[i][j] = up[up[i][j - 1]][j - 1];
}
int lca(int u, int v) {
    if (dep[u] < dep[v]) swap(u, v);
    int diff = dep[u] - dep[v];
    for (int i = 0; diff; i++)
        if (diff & (1 << i)) {
            u = up[u][i];
            diff ^= 1 << i;
        }
    if (u == v) return u;
    for (int j = 18; j >= 0; j--)
        if (up[u][j] != up[v][j])
            u = up[u][j], v = up[v][j];
    return up[u][0];
}
void update(int x, int y) {
    int u = edge[x].v, diff = y - edge[x].val;
    bit.add(l[u], diff);
    bit.add(r[u] + 1, -diff);
    edge[x].val = y;
}
ll lcaDist(int u, int v) {
    return bit.query(l[u]) + bit.query(l[v]) - bit.query(l[lca(u, v)]) * 2;
}
ll query(int u, int v) {
    ll ret = lcaDist(u, v), dist[2];
    dist[0] = lcaDist(u, edge[base].u);
    dist[1] = lcaDist(v, edge[base].v);
    ret = std::min(ret, dist[0] + dist[1] + edge[base].val);
    dist[0] = lcaDist(u, edge[base].v);
    dist[1] = lcaDist(v, edge[base].u);
    ret = std::min(ret, dist[0] + dist[1] + edge[base].val);
    return ret;
}
int main() {
    for (scanf("%d", &t); t; t--) {
        scanf("%d%d", &n, &q);
        init(n);
        for (int i = 1, u, v, val; i <= n; i++) {
            scanf("%d%d%d", &u, &v, &val);
            edge[i] = {u, v, val};
            edges[u].push_back(i);
            edges[v].push_back(i);
        }
        process(n);
        for (int i = 1; i <= n; i++) if (!visEdge[i]) base = i;
        for (int i = 1, op, x, y; i <= q; i++) {
            scanf("%d%d%d", &op, &x, &y);
            if (op == 0) update(x, y);
            else printf("%lld\n", query(x, y));
        }
    }
    return 0;
}
```