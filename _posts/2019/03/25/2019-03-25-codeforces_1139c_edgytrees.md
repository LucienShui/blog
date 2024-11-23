---
title: "Codeforces - 1139C - Edgy Trees"
date: 2019-03-25 01:29:06 +0800
last_modified_at: 2019-03-25 01:29:06 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1139/problem/C

## 原文地址

https://www.lucien.ink/archives/408

### 题解

容斥一下。

### 代码

https://pasteme.cn/4939

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(2e5) + 7, mod = int(1e9) + 7;
ll qpow(ll p, ll q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return ret;
}
std::vector<int> edge[maxn];
int cnt, n, k;
bool vis[maxn];
void dfs(int u) {
    vis[u] = true;
    cnt++;
    for (int v : edge[u]) if (!vis[v]) dfs(v);
}
int main() {
    scanf("%d%d", &n, &k);
    ll ans = qpow(n, k);
    for (int i = 1, u, v, w; i < n; i++) {
        scanf("%d%d%d", &u, &v, &w);
        if (w == 0) {
            edge[u].push_back(v);
            edge[v].push_back(u);
        }
    }
    for (int i = 1; i <= n; i++) {
        if (!vis[i]) {
            cnt = 0;
            dfs(i);
            ans = (ans - qpow(cnt, k) + mod) % mod;
        }
    }
    printf("%lld\n", ans);
    return 0;
}
```