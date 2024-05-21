---
title: "2018徐州邀请赛B - Array - 动态规划"
date: 2018-06-06 17:12:00 +0800
last_modified_at: 2018-06-06 17:12:15 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目

#### 题目描述
JSZKC is the captain of the lala team.   
There are N girls in the lala team. And their height is [1,N] and distinct. So it means there are no two girls with a same height. 
JSZKC has to arrange them as an array from left to right and let h[i] be the height of the ith  girl counting from the left.  After that, he can calculate the sum of the inversion pairs. A inversion pair counts if h[i]>h[j] with i<j. 
Now JSZKC wants to know how many different arranging plans with the sum of the inversion pairs equaling K. Two plans are considered different if and only if there exists an i with h[i] different in these two plans. 
As the answer may be very large, you should output the answer mod 1000000007. 
#### 输入
The input file contains several test cases, each of them as described below. 
The first line of the input contains two integers N and K (1 ≤ N ≤ 5000, 0 ≤ K ≤ 5000), giving the number of girls and the pairs that JSZKC asked.    
There are no more than 5000 test cases. 
#### 输出
An integer in one line for each test case, which is the number of the plans mod 1000000007. 
#### 样例输入
```
3 2
3 3
```
#### 样例输出
```
2
1
```

---
### 题意

&emsp;&emsp;问你`1~n`的所有排列中有多少种排列拥有`k`对逆序数。

---
### 思路

&emsp;&emsp;$f[i][j]$代表长度为$i$的排列有$j$对逆序数的方案数，考虑放第$i$个数的时候，前面$i-1$个数的所有方案都已知，且都比$i$小，如果$i$放在前$i - 1$个数的最左边，则会新产生$i - 1$对逆序数，如果$i$放在前$i - 1$个数的最右边，则不会产生逆序数。也就是说在前$i - 1$个数已经固定，准备放置第$i$个数时，可以产生的逆序数对的数量$x \in [0, i - 1]$，于是有：$$f[i][j] = \sum_{x = 0}^{i - 1}f[i - 1][j - x]$$

&emsp;&emsp;题目只给了$64MB$说的内存，所以需要把询问离线下来，然后用滚动数组求解同时离线答案。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 5007, mod = int(1e9) + 7;
int ans[maxn], f[3][maxn], cnt, cur;
struct Query { int n, k, index; } query[maxn];
int main() {
    while (~scanf("%d%d", &query[cnt].n, &query[cnt].k)) {
        query[cnt].index = cnt;
        cnt++;
    }
    std::sort(query, query + cnt, [](Query x, Query y) { return x.n < y.n; });
    f[0][0] = 1;
    for (int i = 1; i <= 5000; i++) {
        int sum = 0;
        for (int j = 0; j <= 5000; j++) {
            sum = (sum + f[i - 1 & 1][j]) % mod;
            if (j - i >= 0) sum = (sum - f[i - 1 & 1][j - i] + mod) % mod;
            f[i & 1][j] = sum;
        }
        while (cur < cnt && query[cur].n == i) {
            ans[query[cur].index] = f[i & 1][query[cur].k];
            cur++;
        }
    }
    for (int i = 0; i < cnt; i++) printf("%d\n", ans[i]);
    return 0;
}
```