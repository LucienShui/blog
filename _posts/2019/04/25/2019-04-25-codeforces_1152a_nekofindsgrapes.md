---
title: "Codeforces - 1152A - Neko Finds Grapes"
date: 2019-04-25 00:42:00 +0800
last_modified_at: 2019-04-25 00:42:25 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1152/problem/A

## 原文地址

https://www.lucien.ink/archives/421/

### 题意

有 $n$ 把锁 $m$ 把钥匙，如果锁 $A$ 和钥匙 $B$ 的权值加起来是一个奇数，那么 $A$ 和 $B$ 就可以配对，问最多能配多少对。

### 代码

https://pasteme.cn/6825

```cpp
## include <bits/stdc++.h>
int lock[2], key[2], n, m;
int main() {
	scanf("%d%d", &n, &m);
	for (int i = 1, buf; i <= n; i++) {
		scanf("%d", &buf);
		lock[buf & 1]++;
	}
	for (int i = 1, buf; i <= m; i++) {
		scanf("%d", &buf);
		key[buf & 1]++;
	}
	printf("%d\n", std::min(lock[0], key[1]) + std::min(lock[1], key[0]));
	return 0;
}
```