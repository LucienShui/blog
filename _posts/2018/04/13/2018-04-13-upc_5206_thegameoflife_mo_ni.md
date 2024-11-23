---
title: "UPC-5206 - The Game of Life - 模拟"
date: 2018-04-13 18:55:00 +0800
last_modified_at: 2018-05-23 18:15:45 +0800
math: true
render_with_liquid: false
categories: ["ACM", "模拟"]
tags: ["模拟"]
img_path: /assets/img/posts/2018/04/13/2018-04-13-upc_5206_thegameoflife_mo_ni/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5206

---
### 题目：

#### 题目描述

![20171222111227_87204.jpg][1]

From an evolutionary gene’s-eye perspective, the genes are immortal, and our role, the meaning of life, is to perpetuate the genes. In a few centuries, all traces of our existence as human individuals, memories of us, all our accomplishments, will likely be gone and forgotten, except for genes that survive from those of us who successfully reproduced through the generations.
Of course, we do not experience the world from a gene’s eye evolutionary perspective, but the Game of Life does.
The universe of the Game of Life is an inﬁnite two-dimensional orthogonal grid of square cells. Each cell is in one of two possible states, alive or dead. Every cell interacts with its eight neighbours, which are the cells that are horizontally, vertically or diagonally adjacent. At each step in time, the following transitions occur.
Any live cell with fewer than two live neighbours dies, as if caused by underpopulation. 
Any live cell with two or three live neighbours lives on to the next generation.
Any live cell with more than three live neighbours dies, as if by overpopulation.
Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
The initial pattern, the 0-th generation, is given by a ﬁnite N × M grid where N ≤ 3 and M ≤ 5 as a part of the inﬁnite grid. That implies that the state of any other grid is dead.
Genetic evolution is the meaning of biologic life, in that it is the why and how of it, as well as the stock of future biological existence. The trinity life in the game requests you to ﬁnd answers of three problems.
At what point in the ﬁrst 321 generations, including the 0-th generation, will the population be at its maximum?
And what is that maximum?
What will the population be at the 321-th generation?

#### 输入
The first line of the input contains an integer t (1 ≤ t ≤ 300) specifying the number of test cases.
Each case consists of several lines. The first line contains two positive integers N and M. Each of the next N lines contains a string of length M, corresponding the initial pattern. We use “#” to describe a cell which is alive, and use “.” to describe a cell which is dead.
#### 输出
For each test case, output three integers a, b and c in a line, where a means the a-th generation, b is the population at that generation, and c is the population at the 321-th generation. If there are several generations whose population meets the maximum, choose the smallest a for the output.
#### 样例输入
```
3
3 3
...
### .
.#.
3 3
.#.
...
####
3 3
...
####
...
```
#### 样例输出
```
1 4 4
10 20 12
0 3 3
```

---
### 题意：

&emsp;&emsp;如果一个细胞的周围（八连通）有小于两个细胞或者是大于三个细胞，这个细胞就会死亡，如果他的周围有两个或三个细胞，这个细胞就会活到下一轮。如果一个没有细胞的格子的周围恰好有三个细胞，那么这里就会产生一个新的细胞。总而言之：对于一个格子，如果上一轮这个格子的周围有恰好三个细胞，这一轮这个格子必定有细胞，如果上一轮有细胞且他的周围恰好有两个细胞，那么这一轮也会有细胞。

&emsp;&emsp;初始给你一个$n \times m$的矩阵，`.`代表空地，`#`代表细胞，他们会繁衍`321`轮，问你第几轮的时候细胞数目最多，最多是多少，第321轮的时候有多少细胞。

---
### 思路：

&emsp;&emsp;这个题的时限当时给了30秒，用stl的话可以20多秒过，手写的话可以2秒过。

&emsp;&emsp;因为是手写的，所以用到了`vis`和`cnt`两个辅助数组，然而！如果一直用`memset`去初始化这两个数组，会非常非常慢，因为这两个数组的`size`都为$10^6$的数量级，再加上最多有`300`组样例，每组都会循环`321`次，铁定会超时。`cnt`数组可以在每次读值之后赋零，`vis`数组则可以通过时间戳来达到优化。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 1400 + 7, base = 666;
int cnt[maxn][maxn], vis[2][maxn][maxn];
struct Point { int x, y; };
struct Stack {
    int cur = 0;
    Point data[maxn * maxn];
    void pop(int &x, int &y) { x = data[cur].x, y = data[cur].y, cur--; }
    void push(int x, int y) { data[++cur] = {x, y}; }
    void clear() { cur = 0; }
    int size() { return cur; }
    bool emppy() { return cur == 0; }
} stack[2], tmp;
int n, m, x, y, cur, pre = 1, T, next[8][2] = {-1, -1, -1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 1};
char str[7];
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d", &T);
    while (T--) {
        memset(vis, -1, sizeof(vis));
        stack[cur].clear();
        scanf("%d%d", &n, &m);
        for (int i = 0; i < n; i++) {
            scanf(" %s", str);
            for (int j = 0; j < m; j++)
                if (str[j] == '#') {
                    stack[cur].push(i + base, j + base);
                    vis[cur][i + base][j + base] = 0;
                }
        }
        int ans_turn = 0, ans_max = stack[cur].size();
        for (int turn = 1; turn <= 321; turn++) {
            cur ^= 1, pre ^= 1, stack[cur].clear(), tmp.clear();
            while (!stack[pre].emppy()) {
                stack[pre].pop(x, y);
                for (int k = 0, nx, ny; k < 8; k++) {
                    nx = x + next[k][0], ny = y + next[k][1];
                    cnt[nx][ny]++;
                    if (vis[cur][nx][ny] < turn) tmp.push(nx, ny), vis[cur][nx][ny] = turn;
                }
            }
            while (!tmp.emppy()) {
                tmp.pop(x, y);
                if (cnt[x][y] == 3 || (cnt[x][y] == 2 && vis[pre][x][y] + 1 == turn)) stack[cur].push(x, y);
                else vis[cur][x][y] = -1;
                cnt[x][y] = 0;
            }
            if (stack[cur].size() > ans_max) ans_turn = turn, ans_max = stack[cur].size();
        }
        printf("%d %d %d\n", ans_turn, ans_max, stack[cur].size());
    }
    return 0;
}

```


  [1]: assets/img/posts/2018/04/13/2018-04-13-upc_5206_thegameoflife_mo_ni/20171222111227_87204.jpg