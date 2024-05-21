---
title: "Codeforces 1076D - Edge Deletion - 思维"
date: 2018-12-22 17:26:29 +0800
last_modified_at: 2018-12-22 17:26:29 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["题解", "最短路", "贪心", "codeforces"]
---

## Codeforces 1076D - Edge Deletion - 思维

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/D

---
### 题意

有一个 $n$ 个点 $m$ 条边的无向图 $G<n, m>$，定义 $dist(i)$ 为从 $1$ 号点出发到 $i$ 号点的最短路。

你最多可以保留 $k$ 条边，得到一个新的无向图 $G'<n, x>\ (x \leq k)$。

对于某个点 $i$ 来说，如果在 $G'$ 中的 $dist(i)$ 与 $G$ 中的 $dist(i)$ 相等，那么这个点就会产生一次贡献。

问在贡献最大化的情况下，需要保留哪些边。

---
### 思路

先跑出一棵最短路树，然后贪心选边即可。

---
### 实现

https://pasteme.cn/2742

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
typedef long long ll;
std::pair<int, int> pre[maxn];
std::vector<std::pair<int, int>> tree[maxn];
std::vector<int> ans;
struct { int next, v, cost, index; } edge[maxn << 1];
struct Graph {
    int head[maxn], cnt;
    Graph() { memset(head, 0xff, sizeof(head)), cnt = 0; }
    void addedge(int u, int v, int cost, int index) {
        edge[cnt] = {head[u], v, cost, index};
        head[u] = cnt++;
    }
} graph;
int n, m, k, cnt;
namespace Dijkstra {
    ll dist[maxn];
    bool vis[maxn];
    struct Node {
        int u;
        ll dist;
        Node(int u, ll dist):u(u), dist(dist) {}
        bool operator < (const Node &tmp) const {
            return dist > tmp.dist;
        }
    };
    void run() {
        std::priority_queue<Node> que;
        que.emplace(1, 0);
        memset(dist, 0x3f, sizeof(dist));
        dist[1] = 0;
        while (!que.empty()) {
            int u = que.top().u;
            que.pop();
            if (vis[u]) continue;
            vis[u] = true;
            for (int i = graph.head[u]; ~i; i = edge[i].next) {
                int v = edge[i].v, cost = edge[i].cost, index = edge[i].index;
                if (dist[v] > dist[u] + cost) {
                    dist[v] = dist[u] + cost;
                    que.emplace(v, dist[v]);
                    pre[v] = std::make_pair(u, index);
                }
            }
        }
    }
}
void dfs(int u) {
    for (auto it : tree[u]) {
        if (cnt++ < k) {
            ans.push_back(it.second);
            dfs(it.first);
        }
    }
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    std::cin >> n >> m >> k;
    for (int i = 1, u, v, cost; i <= m; i++) {
        std::cin >> u >> v >> cost;
        graph.addedge(u, v, cost, i);
        graph.addedge(v, u, cost, i);
    }
    Dijkstra::run();
    for (int i = 2; i <= n; i++) tree[pre[i].first].emplace_back(i, pre[i].second);
    dfs(1);
    std::cout << ans.size() << std::endl;
    for (auto i : ans) std::cout << i << ' ';
    return 0;
}

```