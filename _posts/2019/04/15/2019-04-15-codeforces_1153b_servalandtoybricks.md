---
title: "Codeforces - 1153B - Serval and Toy Bricks"
date: 2019-04-15 00:03:00 +0800
last_modified_at: 2019-04-15 00:04:35 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维", "codeforces", "构造"]
---

## 地址

https://codeforces.com/contest/1153/problem/B

## 原文地址

https://www.lucien.ink/archives/414

### 代码

https://pasteme.cn/6248

```cpp
## include <bits/stdc++.h>
const int maxn = 1007;
int N, M, H, m[maxn], n[maxn], h[maxn][maxn], ans[maxn][maxn];
int main() {
    scanf("%d%d%d", &N, &M, &H);
    for (int i = 1; i <= M; i++) scanf("%d", m + i);
    for (int i = 1; i <= N; i++) scanf("%d", n + i);
    for (int i = 1; i <= N; i++) {
        for (int j = 1; j <= M; j++) {
            scanf("%d", h[i] + j);
        }
    }
    for (int i = 1; i <= N; i++) {
        for (int j = 1; j <= M; j++) {
            if (h[i][j]) ans[i][j] = std::min(n[i], m[j]);
            else ans[i][j] = 0;
        }
    }
    for (int i = 1; i <= N; i++) {
        for (int j = 1; j <= M; j++) {
            printf("%d%c", ans[i][j], j == M ? '\n' : ' ');
        }
    }
    return 0;
}
```