---
title: "Codeforces - 1098A - Sum in the tree"
date: 2019-03-11 22:33:00 +0800
last_modified_at: 2019-03-11 22:34:01 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心", "codeforces"]
---

## 地址

https://codeforces.com/contest/1098/problem/A

## 原文地址

https://www.lucien.ink/archives/400/

### 题意

给出一棵有点权的树，跟节点深度为 $1$ ，现在你只知道深度为奇数的点到数根的路经权值和，让你给所有点都分配一个非负的权值，满足所给和，且所有点权的和最小。如果不存在输出 $-1$ 。

### 题解

对于权值和未知的节点，让他们的点权最大即可。

### 代码

https://pasteme.cn/4440

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
std::vector<int> edge[maxn];
int n, dep[maxn];
ll sum[maxn], ans;
void dfs(int u, int pre = 0) {
	dep[u] = dep[pre] + 1;
	if (dep[u] & 1) for (int v : edge[u]) dfs(v, u);
	else {
		if (edge[u].empty()) sum[u] = sum[pre];
		else {
		    sum[u] = 0x3f3f3f3f;
			for (int v : edge[u]) {
				dfs(v, u);
				sum[u] = std::min(sum[u], sum[v]);
			}
		}
	}
}
void calc(int u, int pre = 0) {
	if (sum[u] < sum[pre]) {
		puts("-1");
		exit(0);
	}
	ans += sum[u] - sum[pre];
	for (int v : edge[u])
	    calc(v, u);
}
int main() {
	scanf("%d", &n);
	for (int i = 2, pre; i <= n; i++) scanf("%d", &pre), edge[pre].push_back(i);
	for (int i = 1; i <= n; i++) scanf("%lld", sum + i);
	dfs(1);
	calc(1);
	printf("%lld\n", ans);
	return 0;
}
```