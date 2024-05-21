---
title: "UPC-5243 - 数字删除 - 动态规划"
date: 2018-02-01 20:11:00 +0800
last_modified_at: 2018-05-23 18:19:12 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

### 链接：

https://www.lucien.ink/go/UPC5243/

---
### 题目：

#### 题目描述
小明最近在研究一个数字删除游戏，正要考考佳佳。游戏规则如下
给定一个正整数，去掉其中若干个数字后剩下的数字按原左右次序将组成一个新的正整数。请问最少删去几个数字，能够使得这个新的正整数合法（不含前导0）且是3的倍数。
小明写下的数字太大，佳佳一时处理不了。请你帮他写一个程序处理出结果吧！
#### 输入
第一行一个整数n（n≤5），表示小明写下了n正整数
第2~n+1行每行一个正整数Ai（Ai≤10100000）,数字的长度可能达到100001位。
#### 输出
共n行，每行一个整数，表示最少删去的数字的个数。如果没有合法的方案，请输出“ERR”（不含引号）。
#### 样例输入
```
3
1234
1000
2
```
#### 样例输出
```
1
3
ERR
```
#### 提示
第一组删除1个留下的整数为234或123。
第二组删除3个留下的整数为0。

---
### 思路：

&emsp;&emsp;因为不能有前导零，方便起见从右往左推，考虑`dp[i][j]`代表从最后一个位置到第`i`位求和后对3取模等于`j`时最少需要删几个数字，设第i位的数字为`num[i]`，比较容易得到转移方程：$$dp[i][j] = min(dp[i+1][j] + 1,\ dp[i + 1][(j - (num[i]\%3) + 3) \% 3]$$

&emsp;&emsp;然后我们从左往右枚举最优答案的起点，如果当前点`num[i]`不为零的话代表可以枚举，假设最优解是从第`i`位开始的，那么之前的`i-1`位数字全都删去，然后这个最优解需要删去的总数字个数就是$$i - 1 + dp[i + 1][(3 - num[i] \% 3 + 3) \% 3]$$

&emsp;&emsp;答案取一下最小值就可以了。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, inf = 0x3f3f3f3f;
int n, num[maxn], mod[maxn], dp[maxn][3], ans;
char s[maxn];
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d", &n);
    while (ans = inf, memset(dp, 0x3f, sizeof(dp)), n--) {
        scanf("%s", s + 1);
        int len = int(strlen(s + 1));
        for (int i = 1; i <= len; i++) num[i] = s[i] ^ '0', mod[i] = num[i] % 3;
        dp[len][0] = 1, dp[len][mod[len]] = 0;
        for (int i = len - 1; i >= 1; i--) for (int j = 0; j < 3; j++) dp[i][j] = std::min(dp[i + 1][j] + 1, dp[i + 1][(j - mod[i] + 3) % 3]);
        for (int i = 1; i <= len; i++) {
            if (num[i] && i < len) ans = std::min(ans, i - 1 + dp[i + 1][3 - mod[i]]);
            else if (mod[i] == 0) ans = std::min(ans, len - 1);
        }
        if (ans == inf) puts("ERR");
        else printf("%d\n", ans);
    }
    return 0;
}
```