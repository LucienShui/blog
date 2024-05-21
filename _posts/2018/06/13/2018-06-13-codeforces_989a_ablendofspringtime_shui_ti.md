---
title: "Codeforces-989A - A Blend of Springtime - 水题"
date: 2018-06-13 19:45:00 +0800
last_modified_at: 2024-04-15 02:12:14 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目链接

[https://codeforces.com/contest/989/problem/A](https://www.lucien.ink/go/cf989a/)

---
### 题目

The landscape can be expressed as a row of consecutive cells, each of which either contains a flower of colour amber or buff or canary yellow, or is empty.

When a flower withers, it disappears from the cell that it originally belonged to, and it spreads petals of its colour in its two neighbouring cells (or outside the field if the cell is on the side of the landscape). In case petals fall outside the given cells, they simply become invisible.

You are to help Kanno determine whether it's possible that after some (possibly none or all) flowers shed their petals, at least one of the cells contains all three colours, considering both petals and flowers. Note that flowers can wither in arbitrary order.

#### Input
The first and only line of input contains a non-empty string s consisting of uppercase English letters 'A', 'B', 'C' and characters '.' (dots) only ( |s| ≤ 100) — denoting cells containing an amber flower, a buff one, a canary yellow one, and no flowers, respectively.
#### Output
Output "Yes" if it's possible that all three colours appear in some cell, and "No" otherwise. You can print each letter in any case (upper or lower).

---
### 题意

&emsp;&emsp;一个点可以覆盖它自己和相邻的两个点，问是否存在一个点同时被`ABC`覆盖，`.`代表空白。

---
### 思路

&emsp;&emsp;扫一遍就可以了。

---
### 实现

```cpp
## include <bits/stdc++.h>
char str[1007];
bool vis[1007][3];
int main() {
	std::cin >> str + 1;
	int len = strlen(str + 1);
	for (int i = 1; i <= len; i++)
		if (isalpha(str[i])) {
			int cur = str[i] - 'A';
			vis[i - 1][cur] = vis[i + 1][cur] = vis[i][cur] = true;
		}
	for (int i = 1; i <= len; i++)
		if (vis[i][0] && vis[i][1] && vis[i][2]) return 0 * puts("Yes");
	puts("No");
	return 0;
}
```