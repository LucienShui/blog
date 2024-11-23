---
title: "UKIEPC2017 - K - Knightsbridge Rises - 网络流"
date: 2018-08-28 22:38:00 +0800
last_modified_at: 2018-08-28 22:58:33 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["网络流", "题解", "图论"]
---

### 题目链接

https://codeforces.com/gym/101606

---

### 题目

High-rise buildings in the wealthy retail district of Knightsbridge are usually built with exotic hoisting machines known, in construction circles, as cranes.
While it is common to mount these devices on the ground, it’s not always ideal—for example, a skyscraper building would need an equally tall crane. In these cases, the clever solution the industry has developed is for a smaller crane to be mounted directly on top of the tower.
However, this solution presents another challenge: how can such heavy equipment be brought to the summit in the first place? The industry’s solution is to simply use a smaller crane to lift the main crane up. And if that smaller crane is still too massive, find another smaller still, and so on, until said device fits inside a pocket and can be carried up by some enterprising engineer.
Once on top of the building, whether by being carried up, or by being lifted up by another crane capable of holding its weight, a crane can be used to lift others up onto its tower. Once raised, it is not possible to transfer a crane anywhere else.
We have several construction projects in progress at the moment, each with its own requirements on how heavy the loads eventually lifted from the ground need to be. Find an assignment of cranes to buildings that can satisfy these requirements.

---

### 题意

&emsp;&emsp;你有$n$台起重机，每台起重机有一个重量$w_i$和一个最大能举起的重量$l_i$，同时有$m$个物品，每个物品的重量为$t_i$，你可以通过用一个起重机举起另一个起重机，以此来举起更重的物品，初始时你必须使用一个重量为$0$的起重机，问是否存在一种分配方案使得所有的物品都能被成功举起，能的话输出你的方案，否则输出`impossible`。

---

### 思路

&emsp;&emsp;很裸的网络流，只是需要输出一下路径。写的时候踩了一个坑，赛后重判`WA`了。比赛的时候用的是`pre`数组来记录路径，可这样写是错的，因为一般来说网络流中的路径应该是泛指流量在正向边中所走的路径，而采用`pre`数组的话，记录的便是增广过程中的真实路径，其中包含了算法反悔时所走的回头路，所以要输出狭义上的增广路径时不可用`pre`数组取代遍历反向边，切记，切记。

---

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 307, inf = 0x3f3f3f3f;
namespace graph {
    int head[maxn], cnt;
    struct {int next, u, v, flow, index; } edge[maxn * maxn << 2];
    void addedge(int u, int v, int flow, int index) {
        edge[cnt] = {head[u], u, v, flow, index};
        head[u] = cnt++;
        edge[cnt] = {head[v], v, u, 0, -1};
        head[v] = cnt++;
    }
}
struct Node { int x, y; } node[maxn];
int n, m, w[maxn];
namespace dinic {
    int dist[maxn], que[maxn << 2], S, T, cur[maxn], pre[maxn];
    void init(int S_, int T_) {
        S = S_, T = T_;
        memset(graph::head, 0xff, sizeof(graph::head));
        graph::cnt = 0;
    }
    void build() {
        for (int i = 1; i <= n; i++) {
            if (node[i].x == 0) graph::addedge(S, i, 1, -1);
            graph::addedge(i, n + i, 1, i);
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                if (i == j) continue;
                if (node[i].y >= node[j].x && node[j].x) {
                    graph::addedge(i + n, j, 1, -1);
                }
            }
            for (int j = 1; j <= m; j++) if (node[i].y >= w[j]) graph::addedge(i + n, n * 2 + j, 1, -1);
        }
        for (int i = 1; i <= m; i++) {
            graph::addedge(2 * n + i, 2 * n + m + i, 1, -1);
            graph::addedge(2 * n + m + i, T, 1, -1);
        }
    }
    bool bfs() {
        memset(dist, 0xff, sizeof(dist));
        int head = 0, tail = 0;
        que[tail++] = S;
        dist[S] = 0;
        while (head != tail) {
            int u = que[head++];
            for (int i = graph::head[u]; ~i; i = graph::edge[i].next) {
                int v = graph::edge[i].v, flow = graph::edge[i].flow;
                if (flow > 0 && dist[v] == -1) {
                    dist[v] = dist[u] + 1;
                    if (v == T) return true;
                    que[tail++] = v;
                }
            }
        }
        return false;
    }
    int dfs(int u, int low) {
        if (u == T || low == 0) return low;
        for (int &i = cur[u]; ~i; i = graph::edge[i].next) {
            int v = graph::edge[i].v, flow = graph::edge[i].flow;
            if (flow && dist[v] == dist[u] + 1) {
                int tmp = dfs(v, low < flow ? low : flow);
                if (tmp > 0) {
                    graph::edge[i].flow -= tmp;
                    graph::edge[i ^ 1].flow += tmp;
                    pre[v] = i;
                    return tmp;
                }
            }
        }
        return 0;
    }
    int dinic() {
        int ans = 0, tmp;
        while (bfs()) {
            memcpy(cur, graph::head, sizeof(cur));
            while ((tmp = dfs(S, inf)) > 0) ans += tmp;
        }
        return ans;
    }
}

namespace solve {
    int ans[maxn], len;
    void init() {
        dinic::init(0, n + m << 1 | 1);
        dinic::build();
    }
    void read() {
        scanf("%d", &n);
        for (int i = 1; i <= n; i++) scanf("%d%d", &node[i].x, &node[i].y);
        scanf("%d", &m);
        for (int i = 1; i <= m; i++) scanf("%d", w + i);
    }
    void dfs(int u) {
        for (int i = graph::head[u]; ~i; i = graph::edge[i].next) {
            if (i & 1 && graph::edge[i].flow == 1) {
                int v = graph::edge[i].v;
                if (v > 0 && v <= n) ans[++len] = v;
                dfs(v);
            }
        }
    }
    void solve() {
        read();
        init();
        int maxflow = dinic::dinic();
        if (maxflow == m) {
            for (int i = 1; len = 0, i <= m; i++) {
                dfs(2 * n + m + i);
                for (int j = len; j; j--) {
                    printf("%d%c", ans[j], j == 1 ? '\n' : ' ');
                }
            }
        } else puts("impossible");
    }
}
int main() {
    solve::solve();
    return 0;
}

```