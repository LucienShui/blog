---
title: "UPC-5120 - Open-Pit Mining - 最大权闭合子图"
date: 2018-04-24 23:52:00 +0800
last_modified_at: 2018-04-24 23:52:52 +0800
math: false
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["最大权闭合子图"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5120

---
### 题目：

#### 题目描述
Open-pit mining is a surface mining technique of extracting rock or minerals from the earth by their removal from an open pit or borrow. Open-pit mines are used when deposits of commercially useful minerals or rocks are found near the surface. Automatic Computer Mining (ACM) is a company that would like to maximize
its profits by open-pit mining. ACM has hired you to write a program that will determine the maximum profit it can achieve given the description of a piece of land.
Each piece of land is modelled as a set of blocks of material. Block i has an associated value (vi), as well as a cost (ci), to dig that block from the land. Some blocks obstruct or bury other blocks. So for example if block i is obstructed by blocks j and k, then one must first dig up blocks j and k before block i can be dug up. A block can be dug up when it has no other blocks obstructing it.
#### 输入
The first line of input is an integer N (1≤N≤200) which is the number of blocks. These blocks are numbered 1 through N.
Then follow N lines describing these blocks. The ith such line describes block i and starts with two integers vi, ci denoting the value and cost of the ith block (0≤vi,ci≤200).
Then a third integer 0≤mi≤N-1 on this line describes the number of blocks that block i obstructs.
Following that are mi distinct space separated integers between 1 and N (but excluding i) denoting the label(s) of the blocks that block i obstructs.
You may assume that it is possible to dig up every block for some digging order. The sum of values mi over all blocks i will be at most 500.
#### 输出
Output a single integer giving the maximum profit that ACM can achieve from the given piece of land.
#### 样例输入
```
5
0 3 2 2 3
1 3 2 4 5
4 8 1 4
5 3 0
9 2 0
```
#### 样例输出
```
2
```

---
### 题意：

&emsp;&emsp;有`n`种矿石，第i种矿石的价值为`v[i]`，开采的花费为`c[i]`，这个矿石的下方压着`m[i]`种矿石，随后是`m[i]`个整数，代表压着的矿石的编号。如果矿石`a`压着矿石`b`，那么得先开采矿石`a`才能再开采矿石`b`，问能获得的最大权值为多少。

---
### 思路：

&emsp;&emsp;最大权闭合子图的裸题。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 507, maxm = 505 * 505 * 2;
int head_edge[maxn], cnt_edge;
struct { int next, to, flow; } edge[maxm << 1];
void addedge(int u, int v, int c) {
    edge[cnt_edge] = {head_edge[u], v, c};
    head_edge[u] = cnt_edge++;
    edge[cnt_edge] = {head_edge[v], u, 0};
    head_edge[v] = cnt_edge++;
}
int dist[maxn], S, T, n, sum;
bool bfs(int S, int T) {
    memset(dist, -1, sizeof(dist));
    std::queue<int> que;
    dist[S] = 0;
    que.push(S);
    int u, v;
    while (!que.empty()) {
        u = que.front(), que.pop();
        for (int i = head_edge[u]; ~i; i = edge[i].next) {
            v = edge[i].to;
            if (dist[v] == -1 && edge[i].flow > 0) {
                dist[v] = dist[u] + 1;
                if (v == T) return true;
                que.push(v);
            }
        }
    }
    return false;
}
int cur[maxn];
int dfs(int u, int low) {
    if (u == T) return low;
    for (int &i = cur[u]; ~i; i = edge[i].next) {
        int v = edge[i].to, flow = edge[i].flow;
        if (dist[v] != dist[u] + 1 || flow <= 0) continue;
        int tmp = dfs(v, std::min(flow, low));
        if (tmp > 0) {
            edge[i].flow -= tmp;
            edge[i ^ 1].flow += tmp;
            return tmp;
        }
    }
    return 0;
}
int dinic() {
    int ans = 0, tmp;
    while (bfs(S, T)) {
        memcpy(cur, head_edge, sizeof(cur));
        while ((tmp = dfs(S, 0x3f3f3f3f)) > 0) ans += tmp;
    }
    return ans;
}
void init() {
    memset(head_edge, -1, sizeof(head_edge));
    cnt_edge = 0;
}
int main() {
//    freopen("in.txt", "r", stdin);
    init();
    scanf("%d", &n);
    S = 0, T = n + 1;
    for (int i = 1, val, cost, m, x; i <= n; i++) {
        scanf("%d%d", &val, &cost);
        if (val > cost) sum += val - cost, addedge(S, i, val - cost);
        else addedge(i, T, cost - val);
        scanf("%d", &m);
        while (m--) {
            scanf("%d", &x);
            addedge(x, i, 0x3f3f3f3f);
        }
    }
    printf("%d\n", sum - dinic());
    return 0;
}
```