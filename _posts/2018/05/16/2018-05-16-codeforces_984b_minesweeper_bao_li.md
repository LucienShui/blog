---
title: "Codeforces-984B - Minesweeper - 暴力"
date: 2018-05-16 01:13:21 +0800
last_modified_at: 2018-05-16 01:16:47 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["暴力"]
---

### 题目链接：

https://codeforces.com/contest/984/problem/B

---
### 题目：
One day Alex decided to remember childhood when computers were not too powerful and lots of people played only default games. Alex enjoyed playing Minesweeper that time. He imagined that he saved world from bombs planted by terrorists, but he rarely won.

Alex has grown up since then, so he easily wins the most difficult levels. This quickly bored him, and he thought: what if the computer gave him invalid fields in the childhood and Alex could not win because of it?

He needs your help to check it.

A Minesweeper field is a rectangle $n×m$, where each cell is either empty, or contains a digit from $1$ to $8$, or a bomb. The field is valid if for each cell:

- if there is a digit $k$ in the cell, then exactly $k$ neighboring cells have bombs.
- if the cell is empty, then all neighboring cells have no bombs.

Two cells are neighbors if they have a common side or a corner (i. e. a cell has at most $8$ neighboring cells).

#### Input
The first line contains two integers $n$ and $m (1≤n,m≤100)$ — the sizes of the field.

The next nn lines contain the description of the field. Each line contains mm characters, each of them is "." (if this cell is empty), "*" (if there is bomb in this cell), or a digit from $1$ to $8$, inclusive.

#### Output
Print "YES", if the field is valid and "NO" otherwise.

You can choose the case (lower or upper) for each letter arbitrarily.

---
### 题意：

&emsp;&emsp;给你一个$n\times m$的八连通矩阵，`.`代表这个点周围一定没有`*`，如果是数字，代表这个点周围一定有`x`个`*`，让你检查一下所给的矩阵是否合法。

---
### 思路：

&emsp;&emsp;暴力`check`即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxn = 507;
int n, m, nxt[8][2] = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
char mp[maxn][maxn];
bool check(int x, int y) {
    if (mp[x][y] == '*') return true;
    int cnt = 0, aim = isdigit(mp[x][y]) ? mp[x][y] - '0' : 0;
    for (int k = 0; k < 8; k++) if (mp[x + nxt[k][0]][y + nxt[k][1]] == '*') cnt++;
    return cnt == aim;
}
int main() {
    cin >> n >> m;
    for (int i = 1; i <= n; i++) cin >> mp[i] + 1;
    for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++) {
            if (check(i, j)) continue;
            return 0 * puts("NO");
        }
    return 0 * puts("YES");
}

```