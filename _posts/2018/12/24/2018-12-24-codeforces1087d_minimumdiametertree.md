---
title: "Codeforces 1087D - Minimum Diameter Tree"
date: 2018-12-24 01:15:39 +0800
last_modified_at: 2018-12-24 01:15:39 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1087D - Minimum Diameter Tree

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/D

---
### 题意

你有一棵树，你可以给每条边一个非负的权值，使得整棵树的权值和为 $s$ ，定义这棵权值树的直径为权值和最大的一条路径，问最小直径为多少。

---
### 思路

翻译一下，其实就是让任意两个叶节点之间的路径权值和的最大值最小，显然均摊一下最为合适，所以答案就是 $s \div 叶节点的数量 \times 2$ 。比赛的时候想麻烦了，简单的写法明天补上来。

如果要在最小化直径的前提下让权值最大的边的权值尽可能的小，就得像我这样写了，emmm，好像 YY 出来一个新题？

---
### 实现

https://pasteme.cn/2804

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7, maxm = int(4e5) + 7;
struct Lca {
    int dep[maxn]{}, up[maxn][32]{}, cnt, head[maxn]{};
    struct { int next, to, val; } edge[maxm]{};
    void addedge(int u, int v) {
        edge[cnt] = {head[u], v};
        head[u] = cnt++;
    }
    explicit Lca() {
        cnt = 0;
        memset(head, 0xff, sizeof(head));
        memset(up, 0xff, sizeof(up));
    }
    void init(int n) {
        std::queue<int> que;
        que.emplace(dep[1] = 1);
        int u, v;
        while (!que.empty()) {
            u = que.front(), que.pop();
            for (int i = head[u]; ~i; i = edge[i].next) {
                v = edge[i].to;
                if (dep[v]) continue ;
                up[v][0] = u, dep[v] = dep[u] + 1, que.push(v);
            }
        }
        for (int j = 1; j <= 20; j++)
            for (int i = 1; i <= n; i++)
                if (~up[i][j - 1])
                    up[i][j] = up[up[i][j - 1]][j - 1];
    }
    int query(int u, int v) {
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
} lca;
int deg[maxn], n, s, leaf[maxn], cnt;
int main() {
    std::scanf("%d%d", &n, &s);
    if (n == 2) return 0 * std::printf("%d\n", s);
    for (int i = 1, u, v; i < n; i++) {
        std::scanf("%d%d", &u, &v);
        deg[u]++, deg[v]++;
        lca.addedge(u, v);
        lca.addedge(v, u);
    }
    lca.init(n);
    for (int i = 1; i <= n; i++) if (deg[i] == 1) leaf[++cnt] = i;
    int pre = leaf[1], min = 0x3f3f3f3f, min_dep = lca.dep[leaf[1]];
    for (int i = 2; i <= cnt; i++) {
        pre = lca.query(pre, leaf[i]);
        min = std::min(min_dep + lca.dep[leaf[i]] - lca.dep[pre] * 2, min);
        min_dep = std::min(min_dep, lca.dep[leaf[i]]);
    }
    min >>= 1;
    printf("%.15lf\n", double(s) / double(min * cnt) * min * 2);
    return 0;
}
```