---
title: "ARC-061D - Snuke's Coloring - 思维"
date: 2018-05-20 23:51:29 +0800
last_modified_at: 2018-05-20 23:52:00 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题解链接



---
### 题目链接

https://arc061.contest.atcoder.jp/tasks/arc061_b

---
### 题目

#### Problem Statement
We have a grid with $H$ rows and $W$ columns. At first, all cells were painted white.

Snuke painted N of these cells. The $i$-th $( 1≤i≤N )$ cell he painted is the cell at the $a_i$-th row and $b_i$-th column.

Compute the following:

For each integer $j$ $( 0≤j≤9 )$, how many subrectangles of size $3×3$ of the grid contains exactly $j$ black cells, after Snuke painted $N$ cells?
#### Constraints
$3≤H≤10^9$
$3≤W≤10^9$
$0≤N≤min(10^5,H×W)$
$1≤a_i≤H$ $(1≤i≤N)$
$1≤b_i≤W$ $(1≤i≤N)$
$(ai,bi)≠(aj,bj)$ $(i≠j)$
#### Input
The input is given from Standard Input in the following format:

$H$ $W$ $N$
$a_1$ $b_1$
$:$
$a_N$ $b_N$
#### Output
Print 10 lines. The $(j+1)$-th $( 0≤j≤9 )$ line should contain the number of the subrectangles of size $3×3$ of the grid that contains exactly $j$ black cells.

---
### 题意

&emsp;&emsp;有一个`H`行`W`列的矩阵，其中有`N`个方格会被涂黑，第$i$个被涂黑的方格的坐标是$a_i、b_i$，问对于每一个$3 \times 3$的小矩阵，有多少个小矩阵中有`i`格被涂黑了，输出$10$行，为`i`从`0~9`的答案。

---
### 思路

&emsp;&emsp;对于每个$3\times 3$的小矩形，我们可以只关心它的中心点（第二行第二列的点）被其它点八连通地覆盖了多少次就可以正确地统计答案，于是对于每个被涂黑的方块，他会影响到周围的`9`个$3\times 3$的小矩形（八连通加上这个点本身），然后统计每个点即可，$0$的情况用总的小矩形数减一下$1$到$9$的情况即可。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
int x, y, h, w, n;
long long ans[17], base = int(1e9) + 7, zero, node[maxn << 4], tot_node;
int main(void) {
    scanf("%d%d%d", &h, &w, &n);
    zero = 1ll * (h - 2) * (w - 2);
    while (n--) {
        scanf("%d%d", &x, &y);
        for (int i = 0; i < 3; i++) for (int j = 0; j < 3; j++)
                if (1 <= x - i && x - i <= h - 2 && 1 <= y - j && y - j <= w - 2)
                    node[tot_node++] = base * (x - i) + (y - j);
    }
    std::sort(node, node + tot_node);
    for (int i = 0, cnt = 1; i < tot_node; i++) {
        if (node[i] == node[i + 1]) cnt++;
        else ans[cnt]++, cnt = 1, zero--;
    }
    printf("%lld\n", zero);
    for (int i = 1; i < 10; i++) printf("%lld\n", ans[i]);
    return 0;
}
```