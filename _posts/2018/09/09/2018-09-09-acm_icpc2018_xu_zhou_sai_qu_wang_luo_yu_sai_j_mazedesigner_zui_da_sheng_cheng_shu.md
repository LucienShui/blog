---
title: "ACM-ICPC 2018 徐州赛区网络预赛-J - Maze Designer - 最大生成树"
date: 2018-09-09 23:49:00 +0800
last_modified_at: 2018-09-09 23:49:33 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["最小生成树", "lca"]
---

### 题目链接

https://nanti.jisuanke.com/t/31462

---

### 题目

After the long vacation, the maze designer master has to do his job. A tour company gives him a map which is a rectangle. The map consists of $N \times M$ little squares. That is to say, the height of the rectangle is $N$ and the width of the rectangle is $M$. The master knows exactly how the maze is going to use. The tour company will put a couple in two different squares in the maze and make them seek each other. Of course,the master will not make them find each other easily. The only thing the master does is building some wall between some little squares. He knows in that way, wherever the couple is put, there is only one path between them. It is not a difficult thing for him, but he is a considerate man. He also knows that the cost of building  every wall between two adjacent squares is different(Nobody knows the reason). As a result, he designs the maze to make the tour company spend the least money to build it.

Now, here's your part. The tour company knows you're the apprentice of the master, so they give you a task. you're given $Q$ qustions which contain the information of where the couple will be put. You need to figure out the length of the shortest path between them.

However,the master doesn't tell you how he designs the maze, but he believes that you, the best student of himself, know the way. So he goes on vacation again.

InputThe first line of the input contains two integers $N$ and $M$ ($1 \le N,M \le 500$), giving the number of rows and columns of the maze.

The next $N \times M$ lines of the input give the information of every little square in the maze, and their coordinates are in order of $(1,1)$ , $(1,2)$ $\cdots$ $(1,M)$ , $(2,1)$ , $(2,2)$ , $\cdots$ , $(2,M)$ , $\cdots$ ,$(N,M)$.

Each line contains two characters $D$ and $R$ and two integers $a$ , $b$ ($0 \le a,b \le 2000000000$ ), $a$ is the cost of building the wall between it and its lower adjacent square, and $b$ is the cost of building the wall between it and its right adjacent square. If the side is boundary, the lacking path will be replaced with X $0$.

The next line contains an integer $Q$ ($1 \le Q \le 100000$ ), which represents the number of questions.

The next $Q$ lines gives four integers, $x_1$, $y_1$, $x_2$, $y_2$ ( $1 \le x_1$ , $x_2 \le N$ , $1 \le y_1$ , $y_2 \le M$ ), which represent two squares and their coordinate are ($x_1$ , $y_1$) and ($x_2$ , $y_2$).

($x$,$y$) means row $x$ and column $y$.

It is guaranteed that there is only one kind of maze.

OutputFor each question, output one line with one integer which represents the length of the shortest path between two given squares.

---

### 题意

&emsp;&emsp;你有一个$n \times m$的矩阵，在某两个个点之间建立一堵墙会有一定的花费，最后再给你一个$q$，然后是$q$组询问，询问你在建立若干堵墙，使得任意两点间的路径都唯一且花费最少的情况下，两个点之间的距离。

---

### 思路

&emsp;&emsp;正面考虑建立墙的花费最少可能会有点难写，于是我们考虑在所有墙都已经建立起来的情况下，移除一堵墙会有一定的花费，那么让所有点联通的最大花费就一定是题目中所说的建立墙并让路径唯一的最小花费。于是我们可以跑一遍最大生成树，建树跑`LCA`即可。

---

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 507;
struct { int next, v; } edge[maxn * maxn << 1];
int dep[maxn * maxn], n, m, up[maxn * maxn][27], tot, q;
int index(int x, int y) { return (x - 1) * m + y; }
namespace graph {
    int head[maxn * maxn], cnt;
    void addedge(int u, int v) {
        edge[++cnt] = {head[u], v};
        head[u] = cnt;
    }
}
void bfs() {
    memset(up, 0xff, sizeof(up));
    std::queue<int> que;
    que.push(1);
    dep[1] = 1;
    while (!que.empty()) {
        int u = que.front();
        que.pop();
        for (int i = graph::head[u]; i; i = edge[i].next) {
            int v = edge[i].v;
            if (dep[v] == 0) {
                dep[v] = dep[u] + 1;
                up[v][0] = u;
                que.push(v);
            }
        }
    }
    for (int j = 1; j <= 22; j++) {
        for (int i = 1; i <= n * m; i++) {
            if (~up[i][j - 1]) up[i][j] = up[up[i][j - 1]][j - 1];
        }
    }
}
int query(int u, int v) {
    if (dep[u] < dep[v]) std::swap(u, v);
    int tmp = dep[u] - dep[v];
    for (int j = 0; tmp; j++) if (tmp & (1 << j)) tmp ^= (1 << j), u = up[u][j];
    if (u == v) return u;
    for (int j = 22; ~j; j--) if (up[u][j] != up[v][j]) u = up[u][j], v = up[v][j];
    return up[u][0];
}
struct Disjoint {
    int pre[maxn * maxn];
    Disjoint() { for (int i = 0; i < maxn * maxn; i++) pre[i] = i; }
    int find(int x) { return x == pre[x] ? x : pre[x] = find(pre[x]); }
    void merge(int x, int y) { if (x != y) pre[x] = y; }
} disjoint;
struct Edge { int u, v, cost; } edges[maxn * maxn << 1];
int main() {
    scanf("%d%d", &n, &m);
    char ch;
    for (int i = 1, cost; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            for (int k = 0; k < 2; k++) {
                scanf(" %c%d", &ch, &cost);
                if (ch != 'X') {
                    if (ch == 'R') edges[tot++] = {index(i, j), index(i, j + 1), cost};
                    else edges[tot++] = {index(i, j), index(i + 1, j), cost};
                }
            }
        }
    }
    std::sort(edges, edges + tot, [](Edge x, Edge y) { return x.cost > y.cost; });
    for (int i = 0; i < tot; i++) {
        int u = disjoint.find(edges[i].u), v = disjoint.find(edges[i].v);
        if (u != v) {
            graph::addedge(edges[i].u, edges[i].v);
            graph::addedge(edges[i].v, edges[i].u);
            disjoint.merge(u, v);
        }
    }
    bfs();
    scanf("%d", &q);
    for (int i = 0, x, y, a, b; i < q; i++) {
        scanf("%d%d%d%d", &x, &y, &a, &b);
        int u = index(x, y), v = index(a, b), lca = query(u, v);
        printf("%d\n", dep[u] + dep[v] - 2 * dep[lca]);
    }
    return 0;
}
```