---
title: "Codeforces-976B - Lara Croft and the New Game - 思维"
date: 2018-05-01 00:57:00 +0800
last_modified_at: 2018-05-23 18:13:24 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
img_path: /assets/img/posts/2018/05/01/2018-05-01-codeforces_976b_laracroftandthenewgame_si_wei/
---

### 题目链接：

https://codeforces.com/contest/976/problem/B

---
### 题目：

You might have heard about the next game in Lara Croft series coming out this year. You also might have watched its trailer. Though you definitely missed the main idea about its plot, so let me lift the veil of secrecy.

Lara is going to explore yet another dangerous dungeon. Game designers decided to use good old 2D environment. The dungeon can be represented as a rectangle matrix of n rows and m columns. Cell (x, y) is the cell in the x-th row in the y-th column. Lara can move between the neighbouring by side cells in all four directions.

Moreover, she has even chosen the path for herself to avoid all the traps. She enters the dungeon in cell (1, 1), that is top left corner of the matrix. Then she goes down all the way to cell (n, 1) — the bottom left corner. Then she starts moving in the snake fashion — all the way to the right, one cell up, then to the left to the cell in 2-nd column, one cell up. She moves until she runs out of non-visited cells. n and m given are such that she always end up in cell (1, 2).

Lara has already moved to a neighbouring cell k times. Can you determine her current position?

#### Input
The only line contains three integers n, m and k (2 ≤ n, m ≤ 109, n is always even, 0 ≤ k < n·m). Note that k doesn't fit into 32-bit integer type!

#### Output
Print the cell (the row and the column where the cell is situated) where Lara ends up after she moves k times.

#### Examples
##### input
```
4 3 0
```
##### output
```
1 1
```
##### input
```
4 3 11
```
##### output
```
1 2
```
##### input
```
4 3 7
```
##### output
```
3 2
```
#### Note
Here is her path on matrix 4 by 3:

![a2d4cd624dd499b913ad6a79275c24a29a066124.png][1]

---
### 题意：

&emsp;&emsp;有一个$n\times m$的矩阵，初始时这个人在左上方$(1,1)$点，首先她会走到左下方$(n,1)$点，然后开始走蛇形，问你走$k$步时这个人在第几行第几列。

---
### 思路：

&emsp;&emsp;观察一下然后推一推公式即可。

---

### 实现（hacked）：

```cpp
## include <bits/stdc++.h>
int main() {
    long long n, m, k, mod, h, l;
    scanf("%lld%lld%lld", &n, &m, &k);
    if (k < n) printf("%lld 1\n", k + 1);
    else {
        k -= n, mod = (m - 1) << 1, h = (k - 1) / mod * 2 + 1, l = k % mod;
        if (l < (m - 1)) l += 2;
        else h++, l = (m - 1) * 2 - l + 1;
        printf("%lld %lld\n", n - h + 1, l);
    }
    return 0;
}
```

### 5月1日晨更新：

&emsp;&emsp;上面的实现是错的，昨晚比赛的时候急着上分，都没有好好测就直接交了，早上起来之后发现被hack了...瞬间从190名掉到1200名，算是一次教训吧。

&emsp;&emsp;下面这份代码是改过之后的：

```cpp
## include <bits/stdc++.h>
int main() {
    long long n, m, k, mod, h, l;
    scanf("%lld%lld%lld", &n, &m, &k);
    if (k < n) printf("%lld 1\n", k + 1);
    else {
        k -= n - 1, mod = m - 1, h = k / mod + (k % mod > 0), l = (k % mod ? k % mod : mod);
        l = ((h & 1) ? l + 1 : mod - l + 2);
        printf("%lld %lld\n", n - h + 1, l);
    }
    return 0;
}
```


  [1]: assets/img/posts/2018/05/01/2018-05-01-codeforces_976b_laracroftandthenewgame_si_wei/a2d4cd624dd499b913ad6a79275c24a29a066124.png