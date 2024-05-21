---
title: "UPC-4991 - Manhattan Mornings - 思维"
date: 2018-04-18 22:03:00 +0800
last_modified_at: 2018-04-21 23:16:19 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["lis"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=4991

---
### 题目：

#### 题目描述
As a New Yorker you are always very busy. Apart from your long work day you tend to have a very long list of
errands that need to be done on any particular day. You really hate getting up early so you always end up going over
your to-do list after work, but this is starting to seriously hurt your free time.
One day you realize that some of the places you have to go by lie on your walk to the oﬃce, so you can visit them before work. The next day you notice that if you take a slightly different route to work you can run most of your errands without increasing the length of your route. 
Since errands take a negligible amount of time, you don’t even have to get up any earlier to do this! This nice little side effect of the grid-like New York streets gets you thinking. Given all the locations of your errands on the New York grid, how many can you visit on your way to work without getting up any earlier?
The New York grid is modelled with streets that are parallel to the x-axis and avenues that are parallel to the y-axis. Speciﬁcally, there is a street given by y = a for every a ∈ Z , and there is an avenue given by x = b for every b ∈ Z . It is given that an errand always takes place on an intersection between a street and an avenue. Since you walk to your work, you can use all roads in both directions.
#### 输入
• The ﬁrst line contains an integer 0 ≤ n ≤ 105, the number of errands you have to run that day.
• The next line contains four integers 0 ≤ xh, yh, xw, yw ≤ 109 corresponding to the locations of your house and workplace.
• The next n lines each contain two integers 0 ≤ xi, yi ≤ 109 , the coordinates of your ith errand.
#### 输出
Output a single line, containing the number of errands you can run before work without taking a longer route than necessary.
#### 样例输入
```
3
0 0 6 6
5 4
2 6
3 1
```
#### 样例输出
```
2
```

---
### 题意：

&emsp;&emsp;给你一个起点和一个终点，再给你k个点，每次只能上下左右移动，问在走最短路径的情况下最多能经过多少个点。

---
### 思路：

&emsp;&emsp;先将起点和终点处理成一个从左下角到右上角的路线，然后对所有的点按照`x`坐标进行排序，`x`相等按照`y`排序，求一遍最长不下降子序列即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
struct Node {
    int x, y;
    bool operator < (const Node &tmp) const {
        return x == tmp.x ? y < tmp.y : x < tmp.x;
    }
} node[maxn], a, b;
int upper[2], low[2], n, tot, flag = 1, dp[maxn], len = 1;
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d%d%d%d", &n, &a.x, &a.y, &b.x, &b.y);
    low[0] = std::min(a.x, b.x), low[1] = std::min(a.y, b.y);
    upper[0] = std::max(a.x, b.x), upper[1] = std::max(a.y, b.y);
    if (a.x > b.x) std::swap(a, b);
    if (a.y > b.y) flag = -1;
    for (int i = 0, tmpx, tmpy; i < n; i++) {
        scanf("%d%d", &tmpx, &tmpy);
        if (tmpx < low[0] || tmpx > upper[0] || tmpy < low[1] || tmpy > upper[1]) continue;
        node[tot++] = {tmpx, flag * tmpy};
    }
    std::sort(node, node + tot);
    dp[0] = node[0].y;
    for (int i = 1; i < tot; i++) {
        if (node[i].y >= dp[len - 1]) dp[len++] = node[i].y;
        else dp[std::upper_bound(dp, dp + len, node[i].y) - dp] = node[i].y;
    }
    printf("%d\n", tot ? len : 0);
    return 0;
}

```