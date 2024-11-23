---
title: "Codeforces-985B - Switches and Lamps - 思维"
date: 2018-05-22 08:20:00 +0800
last_modified_at: 2018-05-22 08:20:26 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接

https://codeforces.com/contest/985/problem/B

---
### 题目

You are given n switches and m lamps. The i-th switch turns on some subset of the lamps. This information is given as the matrix a consisting of n rows and m columns where ai, j = 1 if the i-th switch turns on the j-th lamp and ai, j = 0 if the i-th switch is not connected to the j-th lamp.

Initially all m lamps are turned off.

Switches change state only from "off" to "on". It means that if you press two or more switches connected to the same lamp then the lamp will be turned on after any of this switches is pressed and will remain its state even if any switch connected to this lamp is pressed afterwards.

It is guaranteed that if you push all n switches then all m lamps will be turned on.

Your think that you have too many switches and you would like to ignore one of them.

Your task is to say if there exists such a switch that if you will ignore (not use) it but press all the other n - 1 switches then all the m lamps will be turned on.

#### Input
The first line of the input contains two integers n and m (1 ≤ n, m ≤ 2000) — the number of the switches and the number of the lamps.

The following n lines contain m characters each. The character ai, j is equal to '1' if the i-th switch turns on the j-th lamp and '0' otherwise.

It is guaranteed that if you press all n switches all m lamps will be turned on.

#### Output
Print "YES" if there is a switch that if you will ignore it and press all the other n - 1 switches then all m lamps will be turned on. Print "NO" if there is no such switch.

---
### 题意

&emsp;&emsp;有`n`个开关和`m`盏灯，对于一盏灯，只要存在一个控制这个灯的开关是开着的，这个灯就会被点亮。然后给你$n \times m$的`01`矩阵，如果$i$行$j$列为`1`代表开关$i$可以控制灯$j$，问你能否删掉一个开关，使得所有的灯仍旧能被点亮。

---
### 思路

&emsp;&emsp;对于每一求和，如果对于某一行，如果去掉某一行后这一列的和会变成`0`，说明会有灯不受控制，这一行就不能删掉。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 2007;
int map[maxn][maxn], sum[maxn], n, m;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) 
        for (int j = 1; j <= m; j++) {
        scanf("%1d", map[i] + j);
        sum[j] += map[i][j];
    }
    for (int i = 1, j; i <= n; i++) {
        for (j = 1; j <= m; j++) if (sum[j] - map[i][j] == 0) break;
        if (j > m) return 0 * puts("YES");
    }
    return 0 * puts("NO");
}

```