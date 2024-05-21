---
title: "UPC-5911 - 计数问题 - 二维树状数组"
date: 2018-03-20 15:46:00 +0800
last_modified_at: 2018-03-20 15:47:35 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["树状数组"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5911

---
### 题目：

#### 题目描述
 一个n*m的方格，初始时每个格子有一个整数权值。接下来每次有2种操作：
改变一个格子的权值；
求一个子矩阵中某种特定权值出现的个数。
#### 输入
第一行有两个数n,m。
接下来n行，每行m个数，第i+1行第j个数表示格子(i,j)的初始权值。
接下来输入一个整数q。
接下来q行，每行描述一个操作。
操作1：“1 x y c”(不含双引号)。表示将格子(x,y)的权值改成c（1<=x<=n,1<=y<=m,1<=c<=100)。
操作2：“2 x1 x2 y1 y2 c”(不含双引号，x1<=x2,y1<=y2)。表示询问所有满足格子权值为c，且x1<=x<=x2,y1<=y<=y2的格子(x,y)的个数。
#### 输出
对于每个操作2，按照在输入中出现的顺序，依次输出一行一个整数表示所求得的个数。
#### 样例输入
```
3 3
1 2 3
3 2 1
2 1 3
3
2 1 2 1 2 1
1 2 3 2
2 2 3 2 3 2
```
#### 样例输出
```
1
2
```
#### 提示
对于30%的数据n,m<=30，q<=10000
对于100%的数据 n,m<=300，q<=100000，1<=c<=100

---
### 思路：

&emsp;&emsp;注意到$c$的范围只有$[1, 100]$，考虑开100个二维树状数组，维护矩阵内某一个数字的计数。单次查询复杂度$O(log_2n \times log_2 m)$

---
### 实现：

```cpp
## include <cstdio>
int n, m, q, x, x_, y, y_, op, tmp, map[307][307];
struct Tree {
    int data[307][307];
    int lowbit(int x) {
        return x & -x;
    }
    void update(int x, int y, int w) {
        for (int i = x; i <= n; i += lowbit(i)) {
            for (int j = y; j <= n; j += lowbit(j)) {
                data[i][j] += w;
            }
        }
    }
    int query(int x, int y) {
        int ans = 0;
        for (int i = x; i > 0; i -= lowbit(i)) {
            for (int j = y; j > 0; j -= lowbit(j)) {
                ans += data[i][j];
            }
        }
        return ans;
    }
} tree[107];

int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++) scanf("%d", map[i] + j), tree[map[i][j]].update(i, j, 1);
    scanf("%d", &q);
    while (q--) {
        scanf("%d", &op);
        if (op == 1) {
            scanf("%d%d%d", &x, &y, &tmp);
            tree[map[x][y]].update(x, y, -1);
            map[x][y] = tmp;
            tree[tmp].update(x, y, 1);
        } else {
            scanf("%d%d%d%d%d", &x, &x_, &y, &y_, &tmp);
            int ret = tree[tmp].query(x_, y_) - tree[tmp].query(x - 1, y_) - tree[tmp].query(x_, y - 1) + tree[tmp].query(x - 1, y - 1);
            printf("%d\n", ret);
        }
    }
    return 0;
}
```