---
title: "UPC-5431 - Barareh on Fire - 搜索"
date: 2018-04-22 15:42:00 +0800
last_modified_at: 2018-04-22 15:42:30 +0800
math: false
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["搜索"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5431

---
### 题目：

#### 题目描述
The Barareh village is on fire due to the attack of the virtual enemy. Several places are already on fire and the fire is spreading fast to other places. Khorzookhan who is the only person remaining alive in the war with the virtual enemy,tries to rescue himself by reaching to the only helicopter in the Barareh villiage.
Suppose the Barareh village is represented by an n  m grid. At the initial time, some grid cells are on fire. If a cell catches fire at time x, all its 8 vertex-neighboring cells will catch fire at time x + k. If a cell catches fire, it will be on fire forever.
At the initial time, Khorzookhan stands at cell s and the helicopter is located at cell t. At any time x, Khorzookhan can move from its current cell to one of four edge-neighboring cells, located at the left, right, top, or bottom of its current cell if that cell is not on fire at time x + 1. Note that each move takes one second.
Your task is to write a program to find the shortest path from s to t avoiding fire.
#### 输入
There are multiple test cases in the input. The first line of each test case contains three positive integers n, m and k (1 ⩽ n, m, k ⩽ 100), where n and m indicate the size of the test case grid n  m, and k denotes the growth rate of fire. The next n lines, each contains a string of length m, where the jth character of the ith line represents the cell (i, j) of the grid. Cells which are on fire at time 0, are presented by character “f”. There may exist no “f” in the test case. 
The helicopter and Khorzookhan are located at cells presented by “t” and “s”, respectively. Other cells are filled by “-” characters. The input terminates with a line containing “0 0 0” which should not be processed.
#### 输出
For each test case, output a line containing the shortest time to reach t from s avoiding fire. If it is impossible to reach t from s, write “Impossible” in the output.
#### 样例输入
```
7 7 2
f------
-f---f-
----f--
-------
------f
---s---
t----f-
3 4 1
t--f
--s-
----
2 2 1
st
f-
2 2 2
st
f-
0 0 0
```
#### 样例输出
```
4
Impossible
Impossible
1
```

---
### 题意：

&emsp;&emsp;给你一张`n`行`m`列的图，`-`代表空地，`f`代表火源，`s`代表人的起点，`t`代表人的终点，对于每个单位的火，每`k`秒会八联通地蔓延一次，人每秒可以走一次，如果人和火可以同时到达一个点，那么人将不能走这个点。问人最少多少秒可以走到终点，如果不能的话就输出`Impossible`。

---
### 思路：

&emsp;&emsp;先对所有的火进行一次宽搜处理出每个点最早什么时候会开始着火，然后再对人进行一次宽搜，增广的时候判断当前的时间是不是严格小于这个点开始着火的时间即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int n, m, k, fire[107][107], people[107][107], ex, ey, inf = 0x3f3f3f3f;
int jump[8][2] = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}, {-1, -1}, {-1, 1}, {1, -1}, {1, 1}};
char s[107];
int main() {
//    freopen("in.txt", "r", stdin);
    while (scanf("%d%d%d", &n, &m, &k), n > 0 && m > 0 && k > 0) {
        std::queue<std::tuple<int, int>> fire_que, people_que;
        memset(fire, 0x3f, sizeof(fire));
        memset(people, 0x3f, sizeof(people));
        for (int i = 1; i <= n; i++) {
            scanf(" %s", s + 1);
            for (int j = 1; j <= m; j++) {
                if (s[j] == 'f') fire_que.emplace(i, j), fire[i][j] = 0;
                else if (s[j] == 's') people_que.emplace(i, j), people[i][j] = 0;
                else if (s[j] == 't') ex = i, ey = j;
            }
        }
        int x, y, nx, ny;
        while (!fire_que.empty()) {
            std::tie(x, y) = fire_que.front();
            fire_que.pop();
            for (int i = 0; i < 8; i++) {
                nx = x + jump[i][0], ny = y + jump[i][1];
                if (1 <= nx && nx <= n && 1 <= ny && ny <= m && fire[nx][ny] == inf) {
                    fire[nx][ny] = fire[x][y] + k;
                    fire_que.emplace(nx, ny);
                }
            }
        }
        while (!people_que.empty()) {
            std::tie(x, y) = people_que.front();
            people_que.pop();
            for (int i = 0; i < 4; i++) {
                nx = x + jump[i][0], ny = y + jump[i][1];
                if (1 <= nx && nx <= n && 1 <= ny && ny <= m && people[nx][ny] == inf) {
                    if (people[x][y] + 1 < fire[nx][ny]) {
                        people[nx][ny] = people[x][y] + 1;
                        people_que.emplace(nx, ny);
                    }
                }
            }
        }
        if (people[ex][ey] == inf) puts("Impossible");
        else printf("%d\n", people[ex][ey]);
    }
    return 0;
}
```