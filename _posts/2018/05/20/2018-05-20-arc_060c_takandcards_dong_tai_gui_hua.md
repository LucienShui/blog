---
title: "ARC-060C - Tak and Cards - 动态规划"
date: 2018-05-20 20:26:00 +0800
last_modified_at: 2018-05-20 23:37:24 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://arc060.contest.atcoder.jp/tasks/arc060_a

---
### 题目

#### Problem Statement
Tak has $N$ cards. On the $i$-th $(1≤i≤N)$ card is written an integer $x_i$. He is selecting one or more cards from these $N$ cards, so that the average of the integers written on the selected cards is exactly $A$. In how many ways can he make his selection?

#### Constraints
$1≤N≤50$
$1≤A≤50$
$1≤x_i≤50$
$N, A, x_i$ are integers.
#### Partial Score
200 points will be awarded for passing the test set satisfying $1≤N≤16$.
#### Input
The input is given from Standard Input in the following format:

$N$ $A$
$x_1$ $x_2$ $…$ $x_N$
#### Output
Print the number of ways to select cards such that the average of the written integers is exactly $A$.

---
### 题意

&emsp;&emsp;给你`N`张卡片，每个卡片有一个权值，然你选任意多张卡片（不能为$0$），使得这些卡片权值的平均值严格等于`A`，问你有多少种选法。

---
### 思路

&emsp;&emsp;因为比较小，所以三维递推的复杂度是允许的。`dp[i][j][k]`代表前`i`个元素里严格选`j`个的和为`k`的方案数，很容易得到递推公式：$$dp[i][j][k] = dp[i - 1][j][k] + dp[i - 1][j - 1][k - num[i]]$$

&emsp;&emsp;然后$50^4$的`long long`开不下，又发现每一层只会用到上一层的状态，用滚动数组优化一下第一维就可以。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 57;
long long f[3][maxn][maxn * maxn], ans;
int n, num[maxn], a;
int main() {
    scanf("%d%d", &n, &a);
    for (int i = 1; i <= n; i++) scanf("%d", num + i);
    f[0][0][0] = f[1][0][0] = 1;
    for (int i = 1, cur = 1; i <= n; i++, cur ^= 1)
        for (int k = 1; k <= i; k++)
            for (int val = 0; val <= 2500; val++) {
                f[cur][k][val] = f[cur ^ 1][k][val];
                if (val >= num[i]) f[cur][k][val] += f[cur ^ 1][k - 1][val - num[i]];
            }
    for (int i = 1, cur = n & 1; i <= n; i++) ans += f[cur][i][a * i];
    printf("%lld\n", ans);
    return 0;
}
```