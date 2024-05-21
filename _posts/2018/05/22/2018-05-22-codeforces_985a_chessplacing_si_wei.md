---
title: "Codeforces-985A - Chess Placing - 思维"
date: 2018-05-22 08:07:00 +0800
last_modified_at: 2018-05-22 08:08:03 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接

https://codeforces.com/contest/985/problem/A

---
### 题目

You are given a chessboard of size $1 × n$. It is guaranteed that n is even. The chessboard is painted like this: "BWBW...BW".

Some cells of the board are occupied by the chess pieces. Each cell contains no more than one chess piece. It is known that the total number of pieces equals to $\frac{n}{2}$.

In one step you can move one of the pieces one cell to the left or to the right. You cannot move pieces beyond the borders of the board. You also cannot move pieces to the cells that are already occupied.

Your task is to place all the pieces in the cells of the same color using the minimum number of moves (all the pieces must occupy only the black cells or only the white cells after all the moves are made).

#### Input
The first line of the input contains one integer $n$ $(2 ≤ n ≤ 100$, n is even$)$ — the size of the chessboard.

The second line of the input contains  integer numbers  $(1 ≤ pi ≤ n)$ — initial positions of the pieces. It is guaranteed that all the positions are distinct.

#### Output
Print one integer — the minimum number of moves you have to make to place all the pieces in the cells of the same color.

---
### 题意

&emsp;&emsp;有一个$1\times n$的黑白棋盘（n一定是偶数），有$\frac{n}{2}$个棋子，第$i$个棋子的位置为$p_i$，问把所有棋子都移到黑格子上或者是白格子上最少总共要挪多少下。

---
### 思路

&emsp;&emsp;枚举一遍全挪到黑色再枚举一遍全挪到白色取最小值即可。

---
### 实现

```cpp
## include <bits/stdc++.h>
int main() {
    int n, p[1007], sum[2] = {0}, cur[2] = {1, 2};
    std::cin >> n;
    for (int i = 1; i <= n / 2; i++) std::cin >> p[i];
    std::sort(p + 1, p + 1 + n / 2);
    for (int i = 1; i <= n / 2; i++, cur[0] += 2, cur[1] += 2) {
        sum[0] += abs(cur[0] - p[i]);
        sum[1] += abs(cur[1] - p[i]);
    }
    std::cout << std::min(sum[0], sum[1]) << std::endl;
    return 0;
}
```