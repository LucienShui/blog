---
title: "UPCOJ-4161 - BZOJ-2753 - 滑雪与时间胶囊 - 最小生成树"
date: 2018-01-22 18:45:00 +0800
last_modified_at: 2018-01-31 16:53:39 +0800
math: false
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["最小生成树", "题解"]
---

### 题目：

#### Description
a180285非常喜欢滑雪。他来到一座雪山，这里分布着M条供滑行的轨道和N个轨道之间的交点（同时也是景点），而且每个景点都有一编号i（1<=i<=N）和一高度Hi。a180285能从景点i 滑到景点j 当且仅当存在一条i 和j 之间的边，且i 的高度不小于j。 与其他滑雪爱好者不同，a180285喜欢用最短的滑行路径去访问尽量多的景点。如果仅仅访问一条路径上的景点，他会觉得数量太少。于是a180285拿出了他随身携带的时间胶囊。这是一种很神奇的药物，吃下之后可以立即回到上个经过的景点（不用移动也不被认为是a180285 滑行的距离）。请注意，这种神奇的药物是可以连续食用的，即能够回到较长时间之前到过的景点（比如上上个经过的景点和上上上个经过的景点）。 

现在，a180285站在1号景点望着山下的目标，心潮澎湃。他十分想知道在不考虑时间胶囊消耗的情况下，以最短滑行距离滑到尽量多的景点的方案（即满足经过景点数最大的前提下使得滑行总距离最小）。你能帮他求出最短距离和景点数吗？
#### Input
输入的第一行是两个整数N，M。
接下来1行有N个整数Hi，分别表示每个景点的高度。
接下来M行，表示各个景点之间轨道分布的情况。每行3个整数，Ui，Vi，Ki。表示
编号为Ui的景点和编号为Vi的景点之间有一条长度为Ki的轨道。
#### Output
 
输出一行，表示a180285最多能到达多少个景点，以及此时最短的滑行距离总和。 
#### Sample Input
```
3 3 
3 2 1 
1 2 1 
2 3 1 
1 3 10 
```
#### Sample Output
```
3 2 
```
#### HINT

对于30%的数据，保证 1<=N<=2000 

对于100%的数据，保证 1<=N<=100000 

对于所有的数据，保证 1<=M<=1000000，1<=Hi<=1000000000，1<=Ki<=1000000000。

---
### 思路：

&emsp;&emsp;第一反应是裸最小树形图，观察了一下数据之后发现并不可行，考虑其它方法。注意到A点可以到达B点的条件是有边而且A点的高度大于B点，我们在加边的时候只考虑可行的有向边，之后再BFS判断哪些点是可以被到达的，顺便记一下第一问的答案。然后在并查集求最小生成树之前优先按照到达点高度的降序排序，高度相同时按边权升序排序，这样一来就可以保证生成树的可行性。复杂度O(ElogE)。

---
### 实现：

```cpp
## include <cstdio>
## include <cstring>
## include <algorithm>
## include <queue>
const int maxn = int(2e6) + 7;
int cnt_edge, head_edge[int(2e7) + 7], n, m, h[maxn], num = 1, pre[maxn];
long long ans = 0;
bool vis[maxn];
struct Edge {
    int next, u, v, val;
    bool operator < (const Edge &tmp) const {
        return h[v] == h[tmp.v] ? val < tmp.val : h[v] > h[tmp.v];
    }
} edge[maxn];
void addedge(int u, int v, int val) {
    edge[cnt_edge] = {head_edge[u], u, v, val};
    head_edge[u] = cnt_edge++;
}
void bfs() {
    std::queue<int> que;
    que.push(1);
    vis[1] = true;
    while (!que.empty()) {
        int u = que.front();
        que.pop();
        for (int i = head_edge[u]; ~i; i = edge[i].next) {
            if (!vis[edge[i].v]) {
                que.push(edge[i].v);
                vis[edge[i].v] = true;
                num++;
            }
        }
    }
}
int find(int x) { return x == pre[x] ? x : pre[x] = find(pre[x]); }
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d", &n, &m);
    memset(head_edge, -1, sizeof(head_edge));
    cnt_edge = 0;
    for (int i = 1; i <= n; i++) scanf("%d", h + i), pre[i] = i;
    for (int i = 0, u, v, w; i < m; i++) {
        scanf("%d%d%d", &u, &v, &w);
        if (h[u] >= h[v]) addedge(u, v, w);
        if (h[v] >= h[u]) addedge(v, u, w);
    }
    bfs();
    std::sort(edge, edge + cnt_edge);
    for (int i = 0, u, v; i < cnt_edge; i++) {
        u = edge[i].u, v = edge[i].v;
        if (vis[u] && vis[v] && find(u) != find(v)) {
            ans += edge[i].val;
            pre[v] = u;
        }
    }
    printf("%d %lld\n", num, ans);
    return 0;
}
```