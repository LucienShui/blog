---
title: "Codeforces 1082G - Petya and Graph - 网络流"
date: 2018-12-01 01:33:00 +0800
last_modified_at: 2018-12-01 01:48:12 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["网络流", "题解", "codeforces"]
---

## Codeforces 1082G - Petya and Graph - 网络流

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/G

------

### 题目

Petya has a simple graph (that is, a graph without loops or multiple edges) consisting of $n$ vertices and $m$ edges.

The weight of the $i$-th vertex is $a_i$.

The weight of the $i$-th edge is $w_i$.

A subgraph of a graph is some set of the graph vertices and some set of the graph edges. The set of edges must meet the condition: both ends of each edge from the set must belong to the chosen set of vertices. 

The weight of a subgraph is the sum of the weights of its edges, minus the sum of the weights of its vertices. You need to find the maximum weight of subgraph of given graph. **The given graph does not contain loops and multiple edges**.

------

### 题意

&emsp;&emsp;有$n$个点，$m$条边，每个点和每条边都有一个权值，要求你从所给的图中选出一个子图，使得$sum\{val_{edges}\} - sum\{val_{vertices}\}$的值最大。

------

### 思路

&emsp;&emsp;很裸的最大权闭合子图，注意答案开`long long`，剩下的无脑`Dinic`就行。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e3) + 7, inf = 0x3f3f3f3f;
typedef long long ll;
struct { int next, v, flow; } edge[maxn << 4];
struct Graph {
    int head[maxn << 1], cnt;
    Graph() { memset(head, 0xff, sizeof(head)), cnt = 0; }
    void addedge(int u, int v, int flow) {
        edge[cnt] = {head[u], v, flow};
        head[u] = cnt++;
        edge[cnt] = {head[v], u, 0};
        head[v] = cnt++;
    }
} graph;
struct Dinic {
    int cur[maxn << 1], dist[maxn << 1];
    bool bfs(int S, int T) {
        memset(dist, 0xff, sizeof(dist));
        dist[S] = 0;
        std::queue<int> que;
        que.push(S);
        while (!que.empty()) {
            int u = que.front();
            que.pop();
            for (int i = graph.head[u]; ~i; i = edge[i].next) {
                int v = edge[i].v, flow = edge[i].flow;
                if (dist[v] == -1 && flow > 0) {
                    dist[v] = dist[u] + 1;
                    if (v == T) return true;
                    que.push(v);
                }
            }
        }
        return false;
    }
    int dfs(int u, int low, int T) {
        if (u == T || low == 0) return low;
        for (int &i = cur[u]; ~i; i = edge[i].next) {
            int v = edge[i].v, flow = edge[i].flow;
            if (flow > 0 && dist[v] == dist[u] + 1) {
                int min = dfs(v, std::min(low, flow), T);
                if (min > 0) {
                    edge[i].flow -= min;
                    edge[i ^ 1].flow += min;
                    return min;
                }
            }
        }
        return 0;
    }
    ll solve(int S, int T) {
        ll ans = 0, tmp;
        while (bfs(S, T)) {
            memcpy(cur, graph.head, sizeof(cur));
            while (tmp = dfs(S, inf, T), tmp > 0) {
                ans += tmp;
            }
        }
        return ans;
    }
} dinic;
int n, m;
ll sum;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, buf; i <= n; i++) { // [1, n] -> n + m + 1
        scanf("%d", &buf);
        graph.addedge(i, n + m + 1, buf);
    }
    for (int i = 1, u, v, cost; i <= m; i++) { // 0 -> [n + 1, n + m]
        scanf("%d%d%d", &u, &v, &cost);
        sum += cost;
        graph.addedge(0, n + i, cost);
        graph.addedge(n + i, u, inf);
        graph.addedge(n + i, v, inf);
    }
    printf("%lld\n", sum - dinic.solve(0, n + m + 1));
    return 0;
}
```