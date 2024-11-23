---
title: "Codeforces-984A - Game - 思维"
date: 2018-05-16 01:01:00 +0800
last_modified_at: 2018-05-16 01:01:45 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/984/problem/A

---
### 题目：

Two players play a game.

Initially there are n integers $a_1,a_2,…,a_n$ written on the board. Each turn a player selects one number and erases it from the board. This continues until there is only one number left on the board, i. e. $n−1$ turns are made. The first player makes the first move, then players alternate turns.

The first player wants to minimize the last number that would be left on the board, while the second player wants to maximize it.

You want to know what number will be left on the board after $n−1$ turns if both players make optimal moves.

#### Input
The first line contains one integer $n (1≤n≤1000)$ — the number of numbers on the board.

The second line contains $n$ integers $a_1,a_2,…,a_n (1≤a_i≤10^6)$.


#### Output
Print one number that will be left on the board.

---
### 题意：

&emsp;&emsp;给你一个序列，两个人轮流删数字，第一个人会删当前序列里最大的数字，第二个人会删当前序列里最小的数字，直到只剩下一个数字，输出剩下的数字。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxn = 1007;
int a[maxn], n;
int main() {
    cin >> n;
    for (int i = 1; i <= n; i++) cin >> a[i];
    sort(a + 1, a + 1 + n);
    cout << a[(n >> 1) + (n & 1)] << endl;
    return 0;
}

```