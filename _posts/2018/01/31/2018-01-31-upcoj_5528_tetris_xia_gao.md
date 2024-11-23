---
title: "UPCOJ-5528 - Tetris - 瞎搞"
date: 2018-01-31 12:56:00 +0800
last_modified_at: 2018-05-23 18:19:54 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维"]
img_path: /assets/img/posts/2018/01/31/2018-01-31-upcoj_5528_tetris_xia_gao/
---

### 链接：

https://www.lucien.ink/go/UPC5528/

---
### 题目：

#### 题目描述
Ivica is a passionate computer scientist. He recently started working on his first computer game: a clone of the popular Tetris. Although he’s far from being finished, his program supports placing five different Tetris figures shown in the image below in a matrix. Before placing it in the Tetris matrix, the figure can be rotated by 90 degrees an arbitrary number of times and coloured. Additionally, the current version of the game doesn’t support placing the figure if that would mean it goes out of the matrix boundaries or overlaps with another existing figure in the matrix. 

![20180124171117_52680.jpg][1]

While Ivica was in school, his sister Marica started the game and randomly rotated, coloured  and placed the figures in a way that the adjacent figures are coloured differently. Two figures are adjacent if they share a common side or touch in the tip. 
When Ivica came back to his computer, he found the game running with the figures his sister placed. He wants to know how many of which figures there are in the Tetris matrix and he is asking you to help him solve this problem while he’s busy with improving the game. 
#### 输入
The first line of input contains positive integers N and M (1 ≤ N, M ≤ 10) that represent the number of rows and columns of the Tetris matrix. 
Each of the following N lines contains M characters that represent the matrix. Each character can be ‘.’ (dot) that represents a blank space or a lowercase letter of the English alphabet that represents a part of the figure. Different letters represent different colours, and the parts of the same figure are coloured the same. 
#### 输出
You must output exactly five rows. The ith line must contain the number of appearances of  the ith  figure in the game of Tetris. 
#### 样例输入
```
4 5
aaaa.
.bb..
.bbxx
...xx
```
#### 样例输出
```
2
1
0
0
0
```
#### 提示
In test cases worth 20% of total points, only the first figure will appear. 
In test cases worth an additional 20% of total points, only the first two figures will appear. 
In test cases worth an additional 20% of total points, only the first three figures will appear. 
In test cases worth an additional 20% of total points, only the first four figures will appear. 
![thumb][2]

---
### 题意：

&emsp;&emsp;给你一个$n\times m$的图，只包含小写字母和空白，相同的字母代表一个方块，`.`代表空白。问所给图中第1到5种方块各有多少个，五种方块的样式见题目里的第一张图片。

---
### 思路：

&emsp;&emsp;先dfs找出所有方块，然后按照笛卡尔坐标系的坐标习惯对每种方块的4个子块进行排序，排序后可以发现根据1号子块和4号子块间的距离与2号子块和3号子块间的一些特征可以判断出当前的这个方块是哪种方块。

---
### 实现：

```cpp
## include <bits/stdc++.h>
struct Node {
    int x, y;
    bool operator < (const Node &tmp) const { return y == tmp.y ? x > tmp.x : y < tmp.y; }
    // 这里排序是按照笛卡尔坐标系的习惯来排序的，优先按照横坐标的升序，横坐标相等时按照纵坐标的升序
    int dist(const Node &tmp) const {
        int a = abs(x - tmp.x), b = abs(y - tmp.y);
        return a * a + b * b;
    }
} fig[107][107];
char map[107][107];
bool vis[107][107];
int next[4][2] = {0, 1, 1, 0, 0, -1, -1, 0}, n, m, tot, len, cnt[7], nx, ny;
void dfs(int x, int y, char c) {
    vis[x][y] = true;
    fig[tot][++len] = {x, y};
    for (int k = 0; k < 4; k++) {
        nx = x + next[k][0], ny = y + next[k][3];
        if (0 <= nx && nx < n && 0 <= ny && ny < m && map[nx][ny] == c && !vis[nx][ny]) dfs(nx, ny, c);
    }
}
void judge(int cur) {
    switch (fig[cur][4].dist(fig[cur][4])) {
        case 1: cnt[3]++; break;
        case 2: (fig[cur][2].dist(fig[cur][3]) == 1) ? cnt[5]++ : cnt[1]++; break;
        case 4: cnt[5]++; break;
        case 5: fig[cur][5].x == fig[cur][2].x ? cnt[3]++ : cnt[4]++; break;
        case 9: cnt[2]++; break;
        default: break;
    }
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d", &n, &m);
    for (int i = 0; i < n; i++) scanf("%s", map[i]);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (!vis[i][j] && isalpha(map[i][j])) {
                len = 0;
                dfs(i, j, map[i][j]);
                if (len == 4) {
                    std::sort(fig[tot] + 1, fig[tot] + 5);
                    tot++;
                }
            }
    for (int i = 0; i < tot; i++) judge(i);
    for (int i = 1; i <= 5; i++) printf("%d\n", cnt[i]);
    return 0;
}
```


  [1]: assets/img/posts/2018/01/31/2018-01-31-upcoj_5528_tetris_xia_gao/20180124171117_52680.jpg
  [2]: assets/img/posts/2018/01/31/2018-01-31-upcoj_5528_tetris_xia_gao/20180124171201_70283.jpg