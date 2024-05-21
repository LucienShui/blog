---
title: "Codeforces-989C - A Mist of Florescence - 思维"
date: 2018-06-13 20:13:00 +0800
last_modified_at: 2018-06-13 20:27:51 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
img_path: /assets/img/posts/2018/06/13/2018-06-13-codeforces_989c_amistofflorescence_si_wei/
---

### 题目链接

[https://codeforces.com/contest/989/problem/C](https://www.lucien.ink/go/cf989c/)

---
### 题目

There are four kinds of flowers in the wood, Amaranths, Begonias, Centaureas and Dianthuses.

The wood can be represented by a rectangular grid of n rows and m columns. In each cell of the grid, there is exactly one type of flowers.

According to Mino, the numbers of connected components formed by each kind of flowers are a, b, c and d respectively. Two cells are considered in the same connected component if and only if a path exists between them that moves between cells sharing common edges and passes only through cells containing the same flowers.

You are to help Kanno depict such a grid of flowers, with n and m arbitrarily chosen under the constraints given below. It can be shown that at least one solution exists under the constraints of this problem.

Note that you can choose arbitrary n and m under the constraints below, they are not given in the input.
#### Input
The first and only line of input contains four space-separated integers a, b, c and d (1 ≤ a, b, c, d ≤ 100) — the required number of connected components of Amaranths, Begonias, Centaureas and Dianthuses, respectively.

#### Output
In the first line, output two space-separated integers n and m (1 ≤ n, m ≤ 50) — the number of rows and the number of columns in the grid respectively.

Then output n lines each consisting of m consecutive English letters, representing one row of the grid. Each letter should be among 'A', 'B', 'C' and 'D', representing Amaranths, Begonias, Centaureas and Dianthuses, respectively.

In case there are multiple solutions, print any. You can output each letter in either case (upper or lower).

---
### 题意

&emsp;&emsp; 给你四个数字`a b c d`，让你生成一个至多$50 \times 50$的图，其中字母`A`有恰好`a`个联通块，字母`B`有恰好`b`个联通块，字母`C`有恰好`c`个联通块，字母`D`有恰好`d`个联通块。

---
### 思路

&emsp;&emsp;直接上图，不多BB。

![IMG_0073.jpg][1]

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 57;
char ans[maxn][maxn];
int num[7];
void color(int x, int y, char ch) {
    for (int i = 1; i <= 25; i++)
        for (int j = 1; j <= 25; j++)
            ans[x + i][y + j] = ch;
}
void solve(int x, int y, char ch, int num) {
    for (int i = 1; i <= 25 && num; i += 2)
        for (int j = 1; j <= 25 && num; j += 2) {
            ans[x + i][y + j] = ch;
            num--;
        }
}
int main() {
    for (int i = 1; i <= 4; i++) scanf("%d", num + i), num[i]--;
    color(0, 0, 'C');
    color(0, 25, 'D');
    color(25, 25, 'A');
    color(25, 0, 'B');
    solve(0, 0, 'A', num[1]);
    solve(0, 25, 'B', num[2]);
    solve(25, 25, 'C', num[3]);
    solve(25, 0, 'D', num[4]);
    puts("50 50");
    for (int i = 1; i <= 50; i++) {
        for (int j = 1; j <= 50; j++) putchar(ans[i][j]);
        putchar('\n');
    }
    return 0;
}
```


  [1]: assets/img/posts/2018/06/13/2018-06-13-codeforces_989c_amistofflorescence_si_wei/img_0073.jpg