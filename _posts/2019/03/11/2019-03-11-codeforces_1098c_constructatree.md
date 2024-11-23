---
title: "Codeforces - 1098C - Construct a tree"
date: 2019-03-11 22:52:00 +0800
last_modified_at: 2019-03-11 22:53:00 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心", "codeforces"]
---

## 地址

https://codeforces.com/contest/1098/problem/C

## 原文地址

https://www.lucien.ink/archives/402/

### 题意

能否构造出一棵 $n$ 个节点的树，使得以每个点为根的子树的 $size$ 加起来等于 $s$ ，如果能，输出使得儿子最多的点的儿子数目最少的那种。

### 题解

不难看出，以每个点为根的子树的 $size$ 加起来的和等价于每个点的深度和，那么对于一棵 $n$ 个节点的树来说，$s_{max} = \frac{n * (n + 1)}{2}$ ，即一条链的情况，$s_{min} = (n - 1) * 2 + 1$ ，即一个菊花图。暴力枚举一下即可。

### 代码

https://pasteme.cn/4442

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
typedef long long ll;
ll n, s, pre[maxn], dep[maxn];
void gen(int k) {
	int cur = 1;
	dep[cur] = 1;
	pre[cur] = 0;
	std::queue<int> que;
	que.push(cur);
	while (!que.empty()) {
		int u = que.front();
		que.pop();
		for (int i = 1; i <= k && cur < n; i++) {
			que.push(++cur);
			pre[cur] = u;
			dep[cur] = dep[u] + 1;
		}
	}
}
bool vis[maxn];
bool check(int k) {
	ll sum = 1, cnt = 1, base = 1, depth = 1;
    while (cnt < n) base *= k, cnt += base, sum += base * ++depth;
    sum -= (cnt - n) * depth;
	if (sum > s) return false;
	gen(k);
	ll cur = cnt - base + 1;
	while (cur) vis[cur] = true, cur = pre[cur];
	cur = cnt - base + 1;
	std::queue<ll> que;
	for (ll i = n; i; i--) if (!vis[i]) que.push(i);
	while (sum < s) {
		ll front = que.front();
		que.pop();
		sum -= dep[front];
		pre[front] = cur;
		dep[front] = dep[cur] + 1;
		sum += dep[front];
		cur = front;
	}
	if (sum > s) {
		for (ll i = cur; i; i = pre[i]) {
			if (sum - dep[cur] + dep[i] + 1 == s) {
				pre[cur] = i;
				break;
			}
		}
	}
	return true;
}
int main() {
	scanf("%lld%lld", &n, &s);
	if (s < n * 2 - 1 || (n + 1) * n / 2 < s) return 0 * puts("No");
	for (int i = 1; i < n; i++) if (check(i)) break;
	puts("Yes");
	for (int i = 2; i <= n; i++) printf("%lld%c", pre[i], i == n ? '\n' : ' ');
	return 0;
}
```