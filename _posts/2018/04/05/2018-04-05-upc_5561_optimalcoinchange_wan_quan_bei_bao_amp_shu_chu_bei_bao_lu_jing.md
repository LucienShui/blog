---
title: "UPC-5561 - Optimal Coin Change - 完全背包 &amp; 输出背包路径"
date: 2018-04-05 19:47:50 +0800
last_modified_at: 2018-04-05 19:48:03 +0800
math: false
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5561

---
### 题目：

#### 题目描述
In a 10-dollar shop, everything is worthy 10 dollars or less. In order to serve customers more effectively at the cashier, change needs to be provided in the minimum number of coins.
In this problem, you are going to provide a given value of the change in different coins. Write a program to calculate the number of coins needed for each type of coin.
The input includes a value v, a size of the coinage set n, and a face value of each coin, f1, f2, ..., fn. The output is a list of numbers, namely, c1, ..., cn, indicating the number of coins needed for each type of coin. There may be many ways for the change. The value v is an integer satisfying 0 < v ≤ 2000, representing the change required
in cents. The face value of a coin is less than or equal to 10000. The output of your program should take the combination with the least number of coins needed.
For example, the Hong Kong coinage issued by the Hong Kong Monetary Authority consists of 10 cents, 20 cents, 50 cents, 1 dollar, 2 dollars, 5 dollars and 10 dollars would be represented in the input by n = 7, f1 = 10, f2 = 20, f3 = 50, f4 = 100, f5 = 200, f6 = 500, f7 = 1000.
#### 输入
The test data may contain many test cases, please process it to the end of the file.
Each test case contains integers v, n, f1, ..., fn in a line. It is guaranteed that n ≤ 10 and 0 < f1 < f2 < ...< fn.
#### 输出
The output be n numbers in a line, separated by space. If there is no possible change, your output should be a single −1. If there are more than one possible solutions, your program should output the one that uses more coins of a lower face value.
#### 样例输入
```
2000 7 10 20 50 100 200 500 1000
250 4 10 20 125 150
35 4 10 20 125 150
48 4 1 8 16 20
40 4 1 10 13 37
43 5 1 2 21 40 80
```
#### 样例输出
```
0 0 0 0 0 0 2
0 0 2 0
-1
0 1 0 2
3 0 0 1
1 1 0 1 0
```

---
### 题意：

&emsp;&emsp;给你`v`元钱，有`n`种面值的硬币，第`i`个硬币的面额为`f[i]`，问你能否凑出`v`元钱，不能的话输出`-1`，能的话输出需要硬币数最少且小面额使用得最多的方案。

---
### 思路：

&emsp;&emsp;记录一下路径即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int v, n, f[17], dp[10007], pre[10007], inf = 0x3f3f3f3f, ans[10007];
int main() {
//    freopen("in.txt", "r", stdin);
    while (~scanf("%d%d", &v, &n)) {
        memset(dp, 0x3f, sizeof(dp));
        memset(ans, 0, sizeof(ans));
        for (int i = 1; i <= n; i++) scanf("%d", f + i);
        dp[0] = 0;
        for (int i = 1; i <= n; i++) {
            for (int j = f[i]; j <= v; j++) {
                if (dp[j - f[i]] < inf && dp[j - f[i]] + 1 <= dp[j]) {
                    dp[j] = dp[j - f[i]] + 1;
                    pre[j] = j - f[i];
                }
            }
        }
        if (dp[v] == inf) puts("-1");
        else {
            int cur = v;
            while (cur) {
                ans[cur - pre[cur]]++;
                cur = pre[cur];
            }
            for (int i = 1; i <= n; i++) printf("%d%c", ans[f[i]], i == n ? '\n' : ' ');
        }
    }
    return 0;
}
```