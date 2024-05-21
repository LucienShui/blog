---
title: "牛客多校第七场C题 - Bit Compression - 搜索"
date: 2018-08-10 00:58:00 +0800
last_modified_at: 2018-08-10 00:59:48 +0800
math: true
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["题解", "搜索"]
---

### 题目链接

https://www.nowcoder.com/acm/contest/145/C

---

### 题目描述

A binary string s of length $N = 2^n$ is given. You will perform the following operation n times :

- Choose one of the operators AND (&), OR (|) or XOR (^). Suppose the current string is $S = s_1s_2 \dots s_k$. 
- Then, for all $1 \leq i \leq \frac{k}{2}$, replace $s_{2i-1}s_{2i}$ with the result obtained by applying the operator to $s_{2i-1}$ and $s_{2i}$. 

For example, if we apply XOR to ${1101}$ we get ${01}$.

After n operations, the string will have length 1.

There are 3n ways to choose the n operations in total. How many of these ways will give 1 as the only character of the final string. 

### 输入描述:

The first line of input contains a single integer n (1 ≤ n ≤ 18).

The next line of input contains a single binary string s $(|s| = 2^n)$. All characters of s are either 0 or 1.

### 输出描述:

Output a single integer, the answer to the problem.

---

### 题意

&emsp;&emsp;给你一个长度为$2^n$的$01$串，每次你可以从`^`、`&`、`|`中选择一个操作符$op$，对这个串$S$进行一次运算（下标从0开始）：$s_i = s_{2i}\ _{op}\ s_{2i+1}\ (0 \leq 2i < |S|)$，每运算一次之后$|S|_{new} = \frac{|S|_{old}}{2}$。

&emsp;&emsp;问有多少种方案可以使得$S$最后只剩下一个$1$。

---

### 思路

&emsp;&emsp;算了一下如果暴力搜索的话那么极限数据的状态集的大小约为$3^{18}=387420489$，显然不行。发现如果长度为$2$的时候，只要是包含$1$的串就一定会对答案产生贡献$2$，这样状态集的大小就减少为$3^{17}=129140163$，显然，可以再多递推几层，最优情况下状态集的大小为$3^9 \times 2=39366$，复杂度不要太优。

&emsp;&emsp;其实没那么麻烦，这道题完全可以$3^{17}$配合剪枝莽过去，然而我比赛的时候居然不会，还是自己太垃圾了。

---

### 实现

```cpp
## include <bits/stdc++.h>
int status[20][1 << 20], ans, n;
char str[1 << 20];
int operation(int op, int x, int y) {
    return op == 0 ? (x ^ y) : (op == 1 ? (x & y) : (x | y));
}
void dfs(int cur) {
    for (int k = 0, upperK = (1 << cur + 1); k < upperK; k++) {
        if (status[cur + 1][k]) {
            if (cur)
                for (int op = 0; op < 3; op++) {
                    for (int i = 0, upper = (1 << cur); i < upper; i++)
                        status[cur][i] = operation(op, status[cur + 1][i << 1], status[cur + 1][i << 1 | 1]);
                    dfs(cur - 1);
                }
            else ans += 2;
            return ;
        }
    }
}
int main() {
    scanf("%d%s", &n, str);
    for (int i = 0; i < (1 << n); i++) status[n][i] = str[i] ^ '0';
    dfs(n - 1);
    printf("%d\n", ans);
    return 0;
}
```