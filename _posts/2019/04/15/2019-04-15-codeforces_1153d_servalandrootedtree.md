---
title: "Codeforces - 1153D - Serval and Rooted Tree"
date: 2019-04-15 00:09:11 +0800
last_modified_at: 2019-04-15 00:09:11 +0800
math: false
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "codeforces", "树形dp"]
---

## 地址

https://codeforces.com/contest/1153/problem/D

## 原文地址

https://www.lucien.ink/archives/416

### 代码

https://pasteme.cn/6251

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
std::vector<int> edge[maxn];
int sz[maxn], f[maxn], n, max[maxn];
void calc(int u) {
    sz[u] = 0;
    if (edge[u].empty()) {
        sz[u] = 1;
        return ;
    }
    for (int v : edge[u]) {
        calc(v);
        sz[u] += sz[v];
    }
}
void dfs(int u) {
    f[u] = 0;
    if (!edge[u].empty()) {
        if (max[u]) {
            for (int v : edge[u]) {
                dfs(v);
                f[u] = std::max(f[u], sz[u] - sz[v] + f[v]);
            }
        } else {
            for (int v : edge[u]) {
                dfs(v);
                f[u] += f[v];
            }
        }
    }
}
int main() {
## ifdef __AC
    freopen("in.txt", "r", stdin);
## endif
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", max + i);
    for (int i = 2, pre; i <= n; i++) {
        scanf("%d", &pre);
        edge[pre].push_back(i);
    }
    calc(1);
    dfs(1);
    printf("%d\n", 1 + f[1]);
    return 0;
}
```