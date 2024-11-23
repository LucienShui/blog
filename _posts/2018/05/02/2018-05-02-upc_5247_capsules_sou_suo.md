---
title: "UPC-5247 - Capsules - 搜索"
date: 2018-05-02 19:35:00 +0800
last_modified_at: 2018-05-23 18:12:51 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["搜索"]
img_path: /assets/img/posts/2018/05/02/2018-05-02-upc_5247_capsules_sou_suo/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5247

---
### 题目：

#### 题目描述
At some point or another, most computer science students have written a standard Sudoku solving program.  This is yet another “put numbers in a grid’’ puzzle.  
Numbers are placed in the grid so that each outlined region contains the numbers 1 to n, where n is the number of squares in the region.  The same number can never touch itself, not even diagonally. 

![20171230163906_28389.jpg][1]

For this problem, you will write a program that takes as input an incomplete puzzle grid and outputs the puzzle solution grid. 
#### 输入
The first line of input contains a single decimal integer P, (1≤P≤100), which is the number of data sets that follow.  Each data set should be processed identically and independently. 
 
Each data set starts with a line containing the data set number K, (1≤K≤100), the number of rows in the input grid R, (1≤R≤7), and the number of columns in the input grid C, (1≤C≤7), separated by spaces.  The next R lines contain a representation of the incomplete input grid, one row per line.  The value in each cell is represented by either the digit already in that cell or a ‘-’ for an initially empty cell. 
 
This grid is followed by a description of the separate regions in the grid.  The first of these lines specifies the total number of regions.  This is followed by one line for each region that specifies the cells contained in that region.  Each region description consists of a decimal number N, specifying the number of cells in the region, followed by N cell descriptions separated by spaces.  Each cell description consists of a left parenthesis, followed the cell’s row index, followed by a comma, followed by the cell’s row number, followed by a right parenthesis. 
#### 输出
For each data set, the output consists of the data set number, K, on a line by itself.  This is followed by R lines containing C digits (separated by single spaces) showing the solution grid for the corresponding input data set. 
#### 样例输入
```
2 
1 3 5 
- - - - - 
- - - - - 
4 - - - 1 
5 
1 (1,1) 
2 (1,2) (1,3) 
5 (2,1) (2,2) (3,1) (3,2) (3,3) 
4 (2,3) (2,4) (1,4) (1,5) 
3 (3,4) (3,5) (2,5) 
2 7 7 
- - - - - - - 
4 - - - - 5 - 
- - - - - - - 
- - - 3 - - - 
- - - - - - - 
- - - - - - - 
- - - - - - - 
14 
5 (1,1) (2,1) (3,1) (2,2) (2,3) 
4 (2,4) (1,2) (1,3) (1,4) 
2 (1,5) (1,6) 
1 (1,7) 
4 (4,1) (5,1) (6,1) (5,2) 
1 (7,1) 
4 (3,2) (4,2) (4,3) (5,3) 
3 (7,3) (7,2) (6,2) 
4 (6,3) (6,4) (7,4) (7,5) 
6 (2,5) (3,5) (4,5) (3,6) (2,6) (2,7) 
4 (3,7) (4,7) (4,6) (5,6) 
1 (5,7) 
5 (7,7) (7,6) (6,7) (6,6) (6,5) 
5 (3,3) (3,4) (4,4) (5,4) (5,5) 
```
#### 样例输出
```
1
1 2 1 2 1
3 5 3 4 3
4 2 1 2 1
2
3 1 4 2 1 2 1
4 2 5 3 6 5 4
1 3 1 4 2 3 1
2 4 2 3 1 4 2
1 3 1 5 2 3 1
4 2 4 3 4 5 2
1 3 1 2 1 3 1
```

---
### 题意：

&emsp;&emsp;给你一个样例组数`T`，然后对于每个样例，先给你一个没用的整数，然后给你`n`和`m`，代表`n`行`m`列，然后给你一个矩阵，`-`代表空地，数字代表当前位置被固定了一个数字，随后告诉你这个矩阵被分成了几块，每块包含哪些点，现在让你往这些块里填数字，要求在同一块内每个数字只能出现一次，对于整个矩形来说，如果某一个空地的周围（八连通）包含某个数字，那么这个空地就不能放这个数字，让你输出最终的摆放方案。

---
### 思路：

&emsp;&emsp;看到矩阵的长宽最大只有$7$，不考虑复杂度随意搜一搜即可，我在这里用了简单状压和深搜。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int static_map[11][11], map[11][11], T, t, n, m, len[57], tot_block;

int qread(int ch = 0, int ret = 0) {
    do ch = getchar(); while (!isdigit(ch));
    while (isdigit(ch)) ret = ret * 10 + ch - '0', ch = getchar();
    return ret;
}

struct Point {
    int x, y;
    void read() { x = qread(), y = qread(); }
} point[57][57];

bool found, vis[11][11];
int next[8][2] = {0, 1, 0, -1, 1, 0, -1, 0, 1, 1, 1, -1, -1, -1, -1, 1};

bool check(int h, int l, int val) {
    if (vis[h][l]) return false;
    if (~static_map[h][l]) return static_map[h][l] == val;
    for (int i = 0, nh, nl; i < 8; i++) {
        nh = h + next[i][0], nl = l + next[i][1];
        if (map[nh][nl] == val || static_map[nh][nl] == val) return false;
    }
    return true;
}

void dfs(int num_block, int num_point, long long status) {
    if (num_block > tot_block) {
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
                if (!vis[i][j]) return ;
        found = true;
        return ;
    }
    int h = point[num_block][num_point].x, l = point[num_block][num_point].y;
    for (int i = 1; i <= len[num_block]; i++)
        if (((1ll << i) & status) == 0 && check(h, l, i)) {
            vis[h][l] = true;
            map[h][l] = i;
            if (num_point == len[num_block]) dfs(num_block + 1, 1, 0);
            else dfs(num_block, num_point + 1, status | (1ll << i));
            if (found) return;
            vis[h][l] = false;
            map[h][l] = -1;
        }
}

void init() {
    memset(vis, 0, sizeof(vis));
    memset(static_map, 0xff, sizeof(static_map));
    memset(map, 0xff, sizeof(map));
    memset(len, 0, sizeof(0));
    found = false;
}

void read(char ch = '\0') {
    scanf(" %*d%d%d", &n, &m);
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            scanf(" %c", &ch);
            if (ch != '-') map[i][j] = static_map[i][j] = ch ^ '0';
        }
    scanf("%d", &tot_block);
    for (int i = 1; i <= tot_block; i++) {
        len[i] = qread();
        for (int j = 1; j <= len[i]; j++) point[i][j].read();
    }
}

void solve() {
    printf("%d\n", t);
    dfs(1, 1, 0);
    for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++)
            printf("%d%c", map[i][j], j == m ? '\n' : ' ');
}

int main() {
    for (scanf("%d", &T), t = 1; t <= T; t++) init(), read(), solve();
    return 0;
}
```


  [1]: assets/img/posts/2018/05/02/2018-05-02-upc_5247_capsules_sou_suo/20171230163906_28389.jpg