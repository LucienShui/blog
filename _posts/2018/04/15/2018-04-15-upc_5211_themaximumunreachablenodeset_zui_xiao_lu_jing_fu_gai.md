---
title: "UPC-5211 - The Maximum Unreachable Node Set - 最小路径覆盖"
date: 2018-04-15 11:19:00 +0800
last_modified_at: 2018-04-15 11:20:57 +0800
math: false
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["最小路径覆盖"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5211

---
### 题目：

#### 题目描述
In this problem, we would like to talk about unreachable sets of a directed acyclic graph G = (V, E). In mathematics a directed acyclic graph (DAG) is a directed graph with no directed cycles. That is a graph such that there is no way to start at any node and follow a consistently-directed sequence of edges in E that eventually loops back to the beginning again.
A node set denoted by V UR ⊂ V containing several nodes is known as an unreachable node set of G if, for each two different nodes u and v in V UR , there is no way to start at u and follow a consistently-directed sequence of edges in E that ﬁnally archives the node v. You are asked in this problem to calculate the size of the maximum unreachable node set of a given graph G.
#### 输入
The input contains several test cases and the first line contains an integer T (1 ≤ T ≤ 500) which is the number of test cases.
For each case, the first line contains two integers n (1 ≤ n ≤ 100) and m (0 ≤ m ≤ n(n − 1)/2) indicating the number of nodes and the number of edges in the graph G. Each of the following m lines describes a directed edge with two integers u and v (1 ≤ u, v ≤ n and u 6= v) indicating an edge from the u-th node to the v-th node. All edges provided in this case are distinct.
We guarantee that all directed graphs given in input are DAGs and the sum of m in input is smaller than 500000.
#### 输出
For each test case, output an integer in a line which is the size of the maximum unreachable node set of G.
#### 样例输入
```
3
4 4
1 2
1 3
2 4
3 4
4 3
1 2
2 3
3 4
6 5
1 2
4 2
6 2
2 3
2 5
```
#### 样例输出
```
2
1
3
```

---
### 题意：

&emsp;&emsp;给你一个`n`个点，`m`条边的DAG（有向无环图），定义一个点集A：点集A内的任意一个点都不可到达除自己外的其它点，让你求出这个最大的点集A。

---
### 思路：

&emsp;&emsp;求一下最大独立集即可，即：用点的数目减去最小路径覆盖的数目。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 107;
bool map[maxn][maxn], vis[maxn];
int n, m, T, link[maxn];
bool dfs(int u) {
    for (int v = 1; v <= n; v++) {
        if (map[u][v] && !vis[v]) {
            vis[v] = true;
            if (link[v] == -1 || dfs(link[v])) {
                link[v] = u;
                return true;
            }
        }
    }
    return false;
}
int solve() {
    int ans = 0;
    memset(link, 0xff, sizeof(link));
    for (int i = 1; i <= n; i++) {
        memset(vis, false, sizeof(vis));
        ans += dfs(i);
    }
    return ans;
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d", &T);
    while (memset(map, false, sizeof(map)), T--) {
        scanf("%d%d", &n, &m);
        for (int i = 0, u, v; i < m; i++) scanf("%d%d", &u, &v), map[u][v] = true;
        for (int k = 1; k <= n; k++) for (int i = 1; i <= n; i++) for (int j = 1; j <= n; j++) map[i][j] |= map[i][k] & map[k][j];
        printf("%d\n", n - solve());
    }
    return 0;
}
```