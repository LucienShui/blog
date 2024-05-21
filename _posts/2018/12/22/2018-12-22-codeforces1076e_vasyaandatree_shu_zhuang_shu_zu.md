---
title: "Codeforces 1076E - Vasya and a Tree - 树状数组"
date: 2018-12-22 17:27:00 +0800
last_modified_at: 2018-12-23 13:20:26 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["题解", "树状数组", "codeforces"]
---

## Codeforces 1076E - Vasya and a Tree - 树状数组

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/E

---
### 题意

给你一棵有根树，有 $m$ 次操作，每次操作为 `v d x`，代表着把以 $v$ 为根深度不超过 $d$ 的所有点的权值都加上 $x$，问所有操作都进行完之后，每个点的权值是多少。

---
### 思路

维护一个以深度为下标的树状数组 `bit`，考虑 `dfs`，进入一个点时把这个节点对其它节点的影响全都加到树状数组中，查询一个点 $u$ 时直接 `bit.query(dep[u])` 即可，`dfs` 退出当前节点时再将这个节点对其它节点的影响在树状数组中消去即可。

---
### 实现

https://pasteme.cn/2743

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
typedef long long ll;
int n, m, max_dep, dep[maxn];
std::vector<int> edge[maxn];
std::vector<std::pair<int, int>> query[maxn];
struct Bit {
    ll data[maxn];
    void add(int pos, int val) {
        while (pos <= n) data[pos] += val, pos += pos & -pos;
    }
    ll query(int pos) {
        ll ret = 0;
        while (pos) ret += data[pos], pos -= pos & -pos;
        return ret;
    }
} bit;
void dfs(int u, int pre) {
    max_dep = std::max(dep[u] = dep[pre] + 1, max_dep);
    for (int v : edge[u]) if (v != pre) dfs(v, u);
}
ll ans[maxn];
void solve(int u, int pre) {
    for (auto pair : query[u]) {
        bit.add(dep[u], pair.second);
        bit.add(pair.first + 1, -pair.second);
    }
    ans[u] = bit.query(dep[u]);
    for (int v : edge[u]) if (v != pre) solve(v, u);
    for (auto pair : query[u]) {
        bit.add(dep[u], -pair.second);
        bit.add(pair.first + 1, pair.second);
    }
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    std::cin >> n;
    for (int i = 1, u, v; i < n; i++) {
        std::cin >> u >> v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1, 1);
    std::cin >> m;
    for (int i = 1, u, d, x; i <= m; i++) {
        std::cin >> u >> d >> x;
        query[u].emplace_back(std::min(dep[u] + d, max_dep), x);
    }
    solve(1, 1);
    for (int i = 1; i <= n; i++) printf("%lld%c", ans[i], i == n ? '\n' : ' ');
    return 0;
}

```