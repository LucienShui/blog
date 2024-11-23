---
title: "洛谷P1736 - 创意吃鱼法 - 动态规划"
date: 2018-05-16 16:21:00 +0800
last_modified_at: 2018-05-16 16:22:00 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://www.luogu.org/problemnew/show/P1736

---
### 题目

#### 题目描述

回到家中的猫猫把三桶鱼全部转移到了她那长方形大池子中，然后开始思考：到底要以何种方法吃鱼呢（猫猫就是这么可爱，吃鱼也要想好吃法 ^_*）。她发现，把大池子视为01矩阵（0表示对应位置无鱼，1表示对应位置有鱼）有助于决定吃鱼策略。

在代表池子的01矩阵中，有很多的正方形子矩阵，如果某个正方形子矩阵的某条对角线上都有鱼，且此正方形子矩阵的其他地方无鱼，猫猫就可以从这个正方形子矩阵“对角线的一端”下口，只一吸，就能把对角线上的那一队鲜鱼吸入口中。

猫猫是个贪婪的家伙，所以她想一口吃掉尽量多的鱼。请你帮猫猫计算一下，她一口下去，最多可以吃掉多少条鱼？

#### 输入格式：
有多组输入数据，每组数据：

第一行有两个整数n和m（n,m≥1），描述池塘规模。接下来的n行，每行有m个数字（非“0”即“1”）。每两个数字之间用空格隔开。

对于30%的数据，有n,m≤100

对于60%的数据，有n,m≤1000

对于100%的数据，有n,m≤2500

#### 输出格式：
只有一个整数——猫猫一口下去可以吃掉的鱼的数量，占一行，行末有回车。

---
### 思路

&emsp;&emsp;答案需要统计两次，一次是从左上角到右下角的对角线，一次是左下角到右上角的对角线，现在只考虑左上角到右下角的对角线，`dp[i][j]`代表当以$(i,j)$为方阵右下角的时候，最多能吃多少条鱼，在维护的时候还需要两个辅助数组，一个统计当$(i,j)$这个点为$0$的时候向上有多少个连续的$0$，另一个统计向左有多少个连续的$0$，不难得到：$$dp[i][j] = min(dp[i - 1][j - 1],\ up[i - 1][j],\ left[i][j - 1]) + 1$$

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 3007;
int dp[maxn][maxn], a[maxn][maxn], up[maxn][maxn], row[maxn][maxn], n, m, ans;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) for (int j = 1; j <= m; j++) {
            scanf("%d", a[i] + j);
            if (a[i][j]) ans = std::max(
                        dp[i][j] = std::min(dp[i - 1][j - 1],
                                            std::min(up[i - 1][j], row[i][j - 1])) + 1,
                        ans);
            else {
                up[i][j] = up[i - 1][j] + 1;
                row[i][j] = row[i][j - 1] + 1;
            }
        }
    memset(dp, 0, sizeof(dp));
    memset(row, 0, sizeof(row));
    for (int i = 1; i <= n; i++) {
        for (int j = m; j >= 1; j--) {
            if (a[i][j]) ans = std::max(
                        dp[i][j] = std::min(dp[i - 1][j + 1],
                                            std::min(up[i - 1][j], row[i][j + 1])) + 1,
                        ans);
            else row[i][j] = row[i][j + 1] + 1;
        }
    }
    printf("%d\n", ans);
    return 0;
}
```