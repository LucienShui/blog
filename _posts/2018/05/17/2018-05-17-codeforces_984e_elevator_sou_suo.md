---
title: "Codeforces-984E - Elevator - 搜索"
date: 2018-05-17 23:43:07 +0800
last_modified_at: 2018-05-17 23:43:21 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["搜索"]
---

### 题目链接

https://codeforces.com/contest/984/problem/E

---
### 题目

You work in a big office. It is a $9$ floor building with an elevator that can accommodate up to $4$ people. It is your responsibility to manage this elevator.

Today you are late, so there are queues on some floors already. For each person you know the floor where he currently is and the floor he wants to reach. Also, you know the order in which people came to the elevator.

According to the company's rules, if an employee comes to the elevator earlier than another one, he has to enter the elevator earlier too (even if these employees stay on different floors). Note that the employees are allowed to leave the elevator in arbitrary order.

The elevator has two commands:

- Go up or down one floor. The movement takes $1$ second.
- Open the doors on the current floor. During this operation all the employees who have reached their destination get out of the elevator. Then all the employees on the floor get in the elevator in the order they are queued up while it doesn't contradict the company's rules and there is enough space in the elevator. Each employee spends $1$ second to get inside and outside the elevator.

Initially the elevator is empty and is located on the floor $1$.

You are interested what is the minimum possible time you need to spend to deliver all the employees to their destination. It is not necessary to return the elevator to the floor $1$.

#### Input
The first line contains an integer $n$ $(1 ≤ n ≤ 2000)$ — the number of employees.

The $i$-th of the next $n$ lines contains two integers $a_i$ and $b_i$ $(1 ≤ ai, bi ≤ 9, a_i ≠ b_i)$ — the floor on which an employee initially is, and the floor he wants to reach.

The employees are given in the order they came to the elevator.

#### Output
Print a single integer — the minimal possible time in seconds.

---
### 题意

&emsp;&emsp;有一栋九层的楼，里面有$n$个人，第$i$个人站在$a_i$楼，想要去$b_i$楼，楼里有一个电梯，初始时在一楼，电梯上升或下降一层需要一个单位时间，每个人进或出电梯也要一个单位时间，电梯最多能同时乘坐$4$个人，问你把所有人都送到目的地最少需要多少单位时间。（不需要按照所给顺序去运送）

---
### 思路

&emsp;&emsp;`dfs(i, cur, a, b, c)`，`i`代表第$i$个人此时正在电梯里，前`i - 1`个人要么正在电梯上，要么已经到达了目的地，`cur`代表当前电梯正停在第`cur`层，`a, b, c`代表正在电梯里的三个人的目的地。

&emsp;&emsp;因为电梯最多只能乘坐$4$个人，所以当坐满的时候一定得先把某个人送到目的地才可以继续载别的人，所以说只用记录三个人的目的地就可以了。

&emsp;&emsp;对于某个状态，有以下几种决策：

+ 如果电梯为空，那么只能去载一个人。
+ 如果电梯不为空，也没坐满，可以再载一个人，或者是下去一个人。
+ 如果电梯满了，只能在乘客中选一个人，把他送到目的地。
+ 如果`i > n`，代表前`i - 1 = n`个人都已经处理完毕，那么现在要做的就是把现在电梯里的所有乘客都送到目的地。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 2007, inf = 0x3f3f3f3f;
int n, u[maxn], v[maxn], f[maxn][11][11][11][11];
int dist(int a, int b) { return abs(a - b); }
int min(int a, int b) { return a < b ? a : b; }
int dfs(int i, int cur, int a, int b, int c) {
    if (~f[i][cur][a][b][c]) return f[i][cur][a][b][c];
	int ret = inf;
	if (i > n) { // 如果n个乘客都处理完毕
		if (a == 0 && b == 0 && c == 0) return 0;
		if (a) ret = min(ret, dfs(i, a, 0, b, c) + dist(cur, a) + 1);
		if (b) ret = min(ret, dfs(i, b, a, 0, c) + dist(cur, b) + 1);
		if (c) ret = min(ret, dfs(i, c, a, b, 0) + dist(cur, c) + 1);
		return f[i][cur][a][b][c] = ret;
	}
	// 如果电梯不为空
	if (a) ret = min(ret, dfs(i, a, 0, b, c) + dist(cur, a) + 1);
	if (b) ret = min(ret, dfs(i, b, a, 0, c) + dist(cur, b) + 1);
	if (c) ret = min(ret, dfs(i, c, a, b, 0) + dist(cur, c) + 1);
	if (a && b && c) { // 如果此时电梯坐满了，先下去一个人
		ret = min(ret, dfs(i + 1, v[i], a, b, c) + dist(cur, u[i]) + dist(u[i], v[i]) + 2);
		ret = min(ret, dfs(i + 1, a, v[i], b, c) + dist(cur, u[i]) + dist(u[i], a) + 2);
		ret = min(ret, dfs(i + 1, b, a, v[i], c) + dist(cur, u[i]) + dist(u[i], b) + 2);
		ret = min(ret, dfs(i + 1, c, a, b, v[i]) + dist(cur, u[i]) + dist(u[i], c) + 2);
	} else { // 如果没坐满，考虑再多拉一个人
		if (!a) ret = min(ret, dfs(i + 1, u[i], v[i], b, c) + dist(cur, u[i]) + 1);
		else if (!b) ret = min(ret, dfs(i + 1, u[i], a, v[i], c) + dist(cur, u[i]) + 1);
		else ret = min(ret, dfs(i + 1, u[i], a, b, v[i]) + dist(cur, u[i]) + 1);
	}
	return f[i][cur][a][b][c] = ret;
}
int main() {
	memset(f, 0xff, sizeof(f));
	scanf("%d", &n);
	for (int i = 1; i <= n; i++) scanf("%d%d", u + i, v + i);
	printf("%d\n", dfs(1, 1, 0, 0, 0));
	return 0;
}

```