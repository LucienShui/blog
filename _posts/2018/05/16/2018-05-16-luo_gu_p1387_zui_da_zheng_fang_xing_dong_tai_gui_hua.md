---
title: "洛谷P1387 - 最大正方形 - 动态规划"
date: 2018-05-16 15:31:40 +0800
last_modified_at: 2018-05-16 15:32:06 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1387

---
### 题目：

#### 题目描述

在一个n*m的只包含0和1的矩阵里找出一个不包含0的最大正方形，输出边长。

#### 输入格式：
输入文件第一行为两个整数n,m（1<=n,m<=100），接下来n行，每行m个数字，用空格隔开，0或1.

#### 输出格式：
一个整数，最大正方形的边长

---
### 思路：

&emsp;&emsp;记$dp[i][j]$为以$(i,j)$为右下角的全一正方形的最大边长，转移方程为：$$dp[i][j] = min(dp[i - 1][j], dp[i - 1][j - 1], dp[i][j - 1]) + 1$$

---
### 实现：

```cpp
## include <bits/stdc++.h>
int n, m, tmp, ans = 0, dp[107][107];
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            scanf("%d", &tmp);
            if (tmp) ans = std::max(dp[i][j] = std::min(std::min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1, ans);
        }
    printf("%d\n", ans);
    return 0;
}
```