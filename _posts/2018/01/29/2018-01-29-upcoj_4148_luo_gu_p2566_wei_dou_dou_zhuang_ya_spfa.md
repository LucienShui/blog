---
title: "UPCOJ-4148 - 洛谷P2566 - 围豆豆 - 状压spfa"
date: 2018-01-29 12:52:00 +0800
last_modified_at: 2018-05-23 18:20:20 +0800
math: false
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["题解", "最短路"]
img_path: /assets/img/posts/2018/01/29/2018-01-29-upcoj_4148_luo_gu_p2566_wei_dou_dou_zhuang_ya_spfa/
---

### 链接：

https://www.lucien.ink/go/P2566/

---
### 题目：

#### 题目描述
是不是平时在手机里玩吃豆豆游戏玩腻了呢？最近MOKIA手机上推出了一种新的围豆豆游戏，大家一起来试一试吧。

游戏的规则非常简单，在一个N×M的矩阵方格内分布着D颗豆子，每颗豆有不同的分值Vi。游戏者可以选择任意一个方格作为起始格，每次移动可以随意的走到相邻的四个格子，直到最终又回到起始格。最终游戏者的得分为所有被路径围住的豆豆的分值总和减去游戏者移动的步数。矩阵中某些格子内设有障碍物，任何时刻游戏者不能进入包含障碍物或豆子的格子。游戏者可能的最低得分为0，即什么都不做。

注意路径包围的概念，即某一颗豆在路径所形成的多边形（可能是含自交的复杂多边形）的内部。下面有两个例子：

![20170718192012_14995.jpg][1]

第一个例子中，豆在路径围成的矩形内部，所以豆被围住了。第二个例子中，虽然路径经过了豆的周围的8个格子，但是路径形成的多边形内部并不包含豆，所以没有围住豆子。
布布最近迷上了这款游戏，但是怎么玩都拿不了高分。聪明的你决定写一个程序来帮助他顺利通关。

#### 输入
第一行两个整数N和M，为矩阵的边长。
第二行一个整数D，为豆子的总个数。
第三行包含D个整数V1到VD，分别为每颗豆子的分值。
接着N行有一个N×M的字符矩阵来描述游戏矩阵状态，0表示空格，#表示障碍物。而数字1到9分别表示对应编号的豆子。
#### 输出
仅包含一个整数，为最高可能获得的分值。
#### 样例输入
```
3 8
3
30 -100 30
00000000
010203#0
00000000
```
#### 样例输出
```
38
```
#### 提示
100%的数据满足1≤D≤9，1≤N, M≤10，-10000≤Vi≤10000。

---
### 思路：

&emsp;&emsp;题目提到从某个出发点开始，最终要回到出发点，参考计算几何判断点在内部，可以推广出，以某个豆子为起点，向任意方向发射一条射线，如果这条射线穿过玩家经过的路径奇数次，则代表这个豆子被玩家围住。

&emsp;&emsp;在队列里分别记录x，y， status，第三维状压表示第i个豆子围住或者不围住。然后枚举出发点，每次跑完spfa枚举1024种状态，更新答案。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int n, m, d, mp[17][17], val[17], ans = 0, dist[17][17][1 << 10], next[4][2] = {0, 1, 1, 0, 0, -1, -1, 0};
bool inque[17][17][1 << 10];
char s[17];
struct { int x, y, val; } bean[17];
struct Node {
    int x, y, status;
    Node (int x = 0, int y = 0, int status = 0) : x(x), y(y), status(status) {}
} cur;
void spfa(int x, int y) {
    memset(dist, 0x7f, sizeof(dist));
    int cur_x, cur_y, cur_status;
    dist[x][y][0] = 0, inque[x][y][0] = true;
    std::queue<Node> que;
    que.emplace(x, y, 0);
    while (!que.empty()) {
        cur = que.front(), que.pop();
        cur_x = cur.x, cur_y = cur.y, cur_status = cur.status;
        inque[cur_x][cur_y][cur_status] = false;
        for (int i = 0; i < 4; i++) {
            int next_x = cur_x + next[i][0], next_y = cur_y + next[i][1];
            if (1 <= next_x && next_x <= n && 1 <= next_y && next_y <= m && mp[next_x][next_y] == 0) {
                int next_status = cur_status;
                for (int k = 1; k <= d; k++) if(next_x<bean[k].x && ((cur_y == bean[k].y && next_y > bean[k].y) || (cur_y > bean[k].y && next_y == bean[k].y))) next_status ^= (1 << (k - 1));
                if (dist[next_x][next_y][next_status] > dist[cur_x][cur_y][cur_status] + 1) {
                    dist[next_x][next_y][next_status] = dist[cur_x][cur_y][cur_status] + 1;
                    if (!inque[next_x][next_y][next_status]) inque[next_x][next_y][next_status], que.emplace(next_x, next_y, next_status);
                }
            }
        }
    }
    for (int status = 0, sum_tmp = 0; status < (1 << d); status++, sum_tmp = 0) {
        for (int i = 1; i <= d; i++) if ((1 << (i - 1)) & status) sum_tmp += bean[i].val;
        ans = std::max(ans, sum_tmp - dist[x][y][status]);
    }
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d%d", &n, &m, &d);
    for (int i = 1; i <= d; i++) scanf("%d", val + i);
    for (int i = 1; i <= n; i++) {
        scanf("%s", s + 1);
        for (int j = 1; j <= m; j++) {
            if (s[j] == '#') mp[i][j] = -1;
            else if ((mp[i][j] = s[j] - '0') > 0) bean[mp[i][j]] = {i, j, val[mp[i][j]]};
        }
    }
    for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++) if (mp[i][j] == 0) spfa(i, j);
    printf("%d\n", ans);
    return 0;
}
```


  [1]: assets/img/posts/2018/01/29/2018-01-29-upcoj_4148_luo_gu_p2566_wei_dou_dou_zhuang_ya_spfa/20170718192012_14995.jpg