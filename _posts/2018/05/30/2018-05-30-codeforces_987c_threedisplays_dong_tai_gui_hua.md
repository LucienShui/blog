---
title: "Codeforces-987C - Three displays - 动态规划"
date: 2018-05-30 02:43:00 +0800
last_modified_at: 2018-05-30 02:43:19 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://codeforces.com/contest/987/problem/C

---
### 题目

It is the middle of 2018 and Maria Stepanovna, who lives outside Krasnokamensk (a town in Zabaikalsky region), wants to rent three displays to highlight an important problem.

There are n displays placed along a road, and the i-th of them can display a text with font size si only. Maria Stepanovna wants to rent such three displays with indices i < j < k that the font size increases if you move along the road in a particular direction. Namely, the condition si < sj < sk should be held.

The rent cost is for the i-th display is ci. Please determine the smallest cost Maria Stepanovna should pay. 
#### Input
The first line contains a single integer n (3 ≤ n ≤ 3 000) — the number of displays.

The second line contains n integers s1 , s2 , ... , sn (1 ≤ si ≤ 109 ) — the font sizes on the displays in the order they stand along the road.

The third line contains n integers c1 , c2 , ... , cn (1 ≤ ci ≤ 108 ) — the rent costs for each display.
#### Output
If there are no three displays that satisfy the criteria, print -1. Otherwise print a single integer — the minimum total rent cost of three displays with indices i < j < k such that si < sj < sk.

---
### 题意

&emsp;&emsp;给你一个长度为`n`的序列，每个序列有一个权值$s_i$和花费$c_i$，让你从中选出3个值，使得$i < j < k$且$s_i < s_j < s_k$，如果存在输出最小话费，不存在的话输出`-1`。

---
### 思路

&emsp;&emsp;因为只用选出三个物品，$f[i,k]$代表第$i$个物品作为选出的三个物品中的第$k$个物品的最小花费，显然有：$f[i,k] = min(f[j, k - 1] + c[i])$，其中：$j < i$且$s[j] < s[i]$。

---
### 实现

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxn = 3007, inf = 0x3f3f3f3f;
int f[maxn][4], n, val[maxn], cost[maxn], ans = inf;
int main() {
	scanf("%d", &n);
	for (int i = 1; i <= n; i++) scanf("%d", val + i);
	for (int i = 1; i <= n; i++) scanf("%d", cost + i);
	memset(f, 0x3f, sizeof(f));
	for (int i = 1; i <= n; i++) {
	    f[i][1] = cost[i];
	    for (int k = 2; k <= 3; k++)
	        for (int j = 1; j < i; j++)
	            if (val[j] < val[i]) f[i][k] = std::min(f[i][k], f[j][k - 1] + cost[i]);
	}
	for (int i = 1; i <= n; i++) ans = std::min(ans, f[i][3]);
	printf("%d\n", ans == inf ? -1 : ans);
	return 0;
}

```