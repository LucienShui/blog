---
title: "ACM-ICPC 2018 沈阳赛区网络预赛-D - Made In Heaven - A*"
date: 2018-09-08 21:24:00 +0800
last_modified_at: 2018-09-08 22:23:04 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["a*"]
---

### 题目链接

https://nanti.jisuanke.com/t/31445

---

### 题目

One day in the jail, F·F invites Jolyne Kujo (JOJO in brief) to play tennis with her. However, Pucci the father somehow knows it and wants to stop her. There are $N$ spots in the jail and $M$ roads connecting some of the spots. JOJO finds that Pucci knows the route of the former $(K-1)$-th shortest path. If Pucci spots JOJO in one of these $K-1$ routes, Pucci will use his stand Whitesnake and put the disk into JOJO's body, which means JOJO won't be able to make it to the destination. So, JOJO needs to take the $K$-th quickest path to get to the destination. What's more, JOJO only has $T$ units of time, so she needs to hurry.JOJO starts from spot $S$, and the destination is numbered $E$. It is possible that JOJO's path contains any spot more than one time. Please tell JOJO whether she can make arrive at the destination using no more than $T$ units of time.

#### Input
There are at most $50$ test cases.The first line contains two integers $N$ and $M$ $(1 \leq N \leq 1000, 0 \leq M \leq 10000)$. Stations are numbered from $1$ to $N$.The second line contains four numbers $S, E, K$ and $T$ ( $1 \leq S,E \leq N$, $S \neq E$, $1 \leq K \leq 10000$, $1 \leq T \leq 100000000$ ).Then $M$ lines follows, each line containing three numbers $U, V$ and $W$ $(1 \leq U,V \leq N, 1 \leq W \leq 1000)$ . It shows that there is a directed road from $U$-th spot to $V$-th spot with time $W$.It is guaranteed that for any two spots there will be only one directed road from spot $A$ to spot $B$ $(1 \leq A,B \leq N, A \neq B)$, but it is possible that both directed road $<A,B>$ and directed road $<B,A>$ exist.All the test cases are generated randomly.

---

### 题意

&emsp;&emsp;$n$个点，$m$条边，一个人要从$S$点出发到$E$点去，她必须走第$K$短的路，而且走过的路程不能超过$T$，问你能否走到。

---

### 思路

&emsp;&emsp;裸`A*`跑一下第`K`短路，然后判一下是否小于等于`T`即可，值得注意的是如果$S$到$E$之间不连通，$A*$会跑满复杂度，会$TLE$，所以可以选择特判，或者是在跑`A*`的途中判断走过的路程是否已经超过$T$，如果超过的话直接返回正无穷，因为每一次从优先队列中取出的点一定都是最优的，如果某个时刻已经大于$T$了，那么后面的时候必然大于$T$。

---

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e4) + 7, maxm = int(1e5) + 7, inf = 0x3f3f3f3f;
int n, m, k, T, S, E, f[maxn];
struct Graph {
    int head[maxn], cnt;
    struct { int next, v, cost; } edge[maxm];
    void init() {
        memset(head, 0xff, sizeof(head));
        cnt = 0;
    }
    void addedge(int u, int v, int cost) {
        edge[cnt] = {head[u], v, cost};
        head[u] = cnt++;
    }
} graph, inv;
struct Node {
    int index, cost, dist;
    Node(int index, int dist, int cost = 0):index(index), dist(dist), cost(cost) {}
    bool operator < (const Node &tmp) const {
        return dist + cost > tmp.dist + tmp.cost;
    }
};
void bfs(int S, const Graph &g) {
    std::bitset<maxn> vis;
    std::priority_queue<Node> que;
    memset(f, 0x3f, sizeof(f));
    f[S] = 0;
    que.emplace(S, 0);
    while (!que.empty()) {
        Node cur = que.top();
        que.pop();
        int u = cur.index;
        if (vis[u]) continue;
        vis[u] = true;
        for (int i = g.head[u]; ~i; i = g.edge[i].next) {
            int v = g.edge[i].v, cost = g.edge[i].cost;
            if (f[v] > f[u] + cost) {
                f[v] = f[u] + cost;
                if (!vis[v]) que.emplace(v, f[v]);
            }
        }
    }
}

int Astar(int S, int E, int k, const Graph &g) {
    int cnt[maxn] = {0};
    std::priority_queue<Node> que;
    que.emplace(S, 0, f[S]);
    while (!que.empty()) {
        Node cur = que.top();
        que.pop();
        int u = cur.index;
        if (++cnt[u] > k) continue;
        if (u == E && cnt[u] == k) return cur.dist;
        if(cur.dist >= T) return inf;
        for (int i = g.head[u]; ~i; i = g.edge[i].next) {
            int v = g.edge[i].v, cost = g.edge[i].cost;
            if (cnt[v] < k) que.emplace(v, cur.dist + cost, f[v]);
        }
    }
    return inf;
}
int main() {
    while (graph.init(), inv.init(), ~scanf("%d%d", &n, &m)) {
        scanf("%d%d%d%d", &S, &E, &k, &T);
        for (int i = 1, u, v, cost; i <= m; i++) {
            scanf("%d%d%d", &u, &v, &cost);
            graph.addedge(u, v, cost);
            inv.addedge(v, u, cost);
        }
        bfs(E, inv);
        puts(Astar(S, E, k, graph) <= T ? "yareyaredawa" : "Whitesnake!");
    }
    return 0;
}
```