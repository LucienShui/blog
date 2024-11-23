---
title: "UPC-5909 - 货物运输 - 倍增LCA"
date: 2018-03-20 15:39:00 +0800
last_modified_at: 2018-03-20 15:41:19 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["lca"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5909

---
### 题目：

#### 题目描述
在一片苍茫的大海上，有n座岛屿，岛屿与岛屿之间由桥梁连接，所有的岛屿刚好被桥梁连接成一个树形结构，即共n-1架桥梁，且从任何一座岛屿出发都能到达其他任何一座岛屿。
第i座桥梁有一个承重量wi，表示该桥梁一次性最多通过重量为wi的货物。
现在有m个货物运输路线，第i个路线要从岛屿xi出发到达岛屿yi。为了最大化利益，你需要求出在不超过路线上任何一架桥梁的承重量的基础上，每个路线最多运输重量为多少货物。
#### 输入
第一行为两个整数n，m。
接下来n-1行，每行三个整数x,y,w，表示有一座承重量为w的桥梁连接岛屿x和y。
接下来m行，每行两个整数x,y，表示有一条从岛屿x出发到达岛屿y的路线，保证x≠y。
#### 输出
输出共m行，每行一个整数，第i个整数表示第i条路线的最大重量。
#### 样例输入
```
6 5
1 2 2
2 3 5
2 4 2
2 5 3
5 6 1
2 4
6 2
1 3
3 5
1 6
```
#### 样例输出
```
2
1
2
3
1
```
#### 提示

对于50%的数据n,m<=2000
对于100%的数据 n,m<=100000，w<=10^9

---
### 思路：

&emsp;&emsp;倍增求一下lca，然后再倍增求一下路径上的最小值即可，复杂度$O(m \times log_2n)$，觉得可以求lca的同时求出路径最小值，但是不知道为什么这样写会WA。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, maxm = int(4e5) + 7, inf = 0x3f3f3f3f;
int n, m;
struct Lca {
    int dep[maxn], up[maxn][32], min[maxn][32], cnt, head[maxn];
    struct { int next, to, val; } edge[maxm];
    void addedge(int u, int v, int w) {
        edge[cnt] = {head[u], v, w};
        head[u] = cnt++;
    }
    Lca() {
        cnt = 0;
        memset(head, 0xff, sizeof(head));
        memset(up, 0xff, sizeof(up));
        memset(min, 0x3f, sizeof(min));
    }
    void init(int n) {
        std::queue<int> que;
        que.emplace(dep[1] = 1); // 下标从1开始
        int u, v;
        while (!que.empty()) {
            u = que.front(), que.pop();
            for (int i = head[u]; ~i; i = edge[i].next) {
                v = edge[i].to;
                if (dep[v]) continue ;
                up[v][0] = u, min[v][0] = edge[i].val, dep[v] = dep[u] + 1, que.push(v);
            }
        }
        for (int j = 1; j <= 20; j++)
            for (int i = 1; i <= n; i++)
                if (~up[i][j - 1]) {
                    up[i][j] = up[up[i][j - 1]][j - 1];
                    min[i][j] = std::min(min[i][j - 1], min[up[i][j - 1]][j - 1]);
                }
    }
    int query(int u, int v) {
        int ret = inf;
        if (dep[u] < dep[v]) std::swap(u, v);
        int tmp = dep[u] - dep[v];
        for (int j = 0; tmp; j++)
            if (tmp & (1 << j)) tmp ^= (1 << j), u = up[u][j];
        if (u == v) return v;
        for (int j = 20; j >= 0; j--) {
            if (up[u][j] != up[v][j]) {
                u = up[u][j], v = up[v][j];
            }
        }
        return up[u][0];
    }
    int calc(int u, int lca) {
        int ret = inf, tmp = dep[u] - dep[lca];
        for (int i = 0; tmp; i++) {
            if (tmp & (1 << i)) {
                tmp ^= (1 << i);
                ret = std::min(min[u][i], ret);
                u = up[u][i];
            }
        }
        return ret;
    }
} lca;

int solve(int u, int v) {
    int pre = lca.query(u, v);
    return std::min(lca.calc(u, pre), lca.calc(v, pre));
}

int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, u, v, w; i < n; i++) {
        scanf("%d%d%d", &u, &v, &w);
        lca.addedge(u, v, w);
        lca.addedge(v, u, w);
    }
    lca.init(n);
    for (int i = 0, u, v; i < m; i++) {
        scanf("%d%d", &u, &v);
        printf("%d\n", solve(u, v));
    }
    return 0;
}
```