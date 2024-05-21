---
title: "Codeforces-987D - Fair - 搜索"
date: 2018-05-31 00:53:00 +0800
last_modified_at: 2018-05-31 00:53:27 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["搜索"]
---

### 题目链接

https://codeforces.com/contest/987/problem/D

---
### 题目
Some company is going to hold a fair in Byteland. There are n towns in Byteland and m two-way roads between towns. Of course, you can reach any town from any other town using roads.

There are k types of goods produced in Byteland and every town produces only one type. To hold a fair you have to bring at least s different types of goods. It costs d(u, v) coins to bring goods from town u to town v where d(u, v) is the length of the shortest path from u to v. Length of a path is the number of roads in this path.

The organizers will cover all travel expenses but they can choose the towns to bring goods from. Now they want to calculate minimum expenses to hold a fair in each of n towns.
#### Input
There are 4 integers n, m, k, s in the first line of input ($1 ≤ n ≤ 10^5$, $0 ≤ m ≤ 10^5$, 1 ≤ s ≤ k ≤ min(n, 100)) — the number of towns, the number of roads, the number of different types of goods, the number of different types of goods necessary to hold a fair.

In the next line there are n integers a1 , a2 , ... , an (1 ≤ ai ≤ k), where ai is the type of goods produced in the i-th town. It is guaranteed that all integers between 1 and k occur at least once among integers ai.

In the next m lines roads are described. Each road is described by two integers u v (1 ≤ u, v ≤ n, u ≠ v) — the towns connected by this road. It is guaranteed that there is no more than one road between every two towns. It is guaranteed that you can go from any town to any other town via roads.
#### Output
Print n numbers, the i-th of them is the minimum number of coins you need to spend on travel expenses to hold a fair in town i. Separate numbers with spaces.

---
### 题意

&emsp;&emsp;有`n`个城市，`m`条道路，`k`种东西，使所有城市都公平需要使每个城市都有`s`种东西，每个城市可以生产一种东西，第$i$个城市能生产的东西的编号为$a_i$，然后给你这个图，问你让每个城市都拥有`s`种不同的物品的最小花费是多少。

---
### 思路

&emsp;&emsp;先对于每种物品处理一下每个城市得到它需要的最小花费，$dist[i,j]$代表第$j$个城市得到第$i$种物品的最小花费，然后对于每个城市排序一下对前`s`个求和就可以了。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, maxk = 107;
int dist[maxk][maxn], n, m, k, s, ans[maxk];
std::vector<int> edge[maxn], color[maxk];

void bfs(std::vector<int> color, int *dist) {
    std::fill(dist + 1, dist + 1 + n, -1);
    std::queue<int> que;
    for (auto u : color) dist[u] = 0, que.push(u);
    while (!que.empty()) {
        int u = que.front();
        que.pop();
        for (int v : edge[u]) if (dist[v] == -1) {
                dist[v] = dist[u] + 1;
                que.push(v);
            }
    }
}

int main() {
    std::cin >> n >> m >> k >> s;
    for (int i = 1, tmp; i <= n; i++) std::cin >> tmp, color[tmp].push_back(i);
    for (int i = 1, u, v; i <= m; i++) {
        std::cin >> u >> v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    for (int i = 1; i <= k; i++) bfs(color[i], dist[i]);
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= k; j++) ans[j] = dist[j][i];
        std::sort(ans + 1, ans + 1 + k);
        std::cout << std::accumulate(ans + 1, ans + 1 + s, 0) << (i == n ? '\n' : ' ');
    }
    return 0;
}

```