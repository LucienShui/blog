---
title: "UPC-5434 - Column Addition - 动态规划"
date: 2018-04-22 15:31:00 +0800
last_modified_at: 2018-05-23 18:14:33 +0800
math: false
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
img_path: /assets/img/posts/2018/04/22/2018-04-22-upc_5434_columnaddition_dong_tai_gui_hua/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5434

---
### 题目：

#### 题目描述
A multi-digit column addition is a formula on adding two integers written like this:

![20180119160853_82068.jpg][1]

A multi-digit column addition is written on the blackboard, but the sum is not necessarily correct. We can erase any number of the columns so that the addition becomes correct. For example, in the following addition, we can obtain a correct addition by erasing the second and the forth columns.

![20180119160903_49478.jpg][2]

Your task is to find the minimum number of columns needed to be erased such that the remaining formula becomes a correct addition.
#### 输入
There are multiple test cases in the input. Each test case starts with a line containing the single integer n, the number of digit columns in the addition (1 ⩽ n ⩽ 1000). Each of the next 3 lines contain a string of n digits. The number on the third line is presenting the (not necessarily correct) sum of the numbers in the first and the second line. The input terminates with a line containing “0” which should not be processed.
#### 输出
For each test case, print a single line containing the minimum number of columns needed to be erased.
#### 样例输入
```
3
123
456
579
5
12127
45618
51825
2
24
32
32
5
12299
12299
25598
0
```
#### 样例输出
```
0
2
2
1
```

---
### 题意：

&emsp;&emsp;给你一个每个数长度为`n`的加法，问你至少删去多少列可以使算式成立。

---
### 思路：

&emsp;&emsp;预处理出一个`need[i]`和`add[i]`数组，代表第`i`列如果成立的话需要多少进位，和会进多少位，然后`dp[i]`代表前`i`列中最多可以保留多少列，要注意最高位不能有进位，所以最后枚举一下最高位是第几列即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 1007;
int n, ans, a[maxn], b[maxn], c[maxn], add[maxn], need[maxn], dp[maxn];
void read(int *tmp) { for (int i = n; i >= 1; i--) scanf(" %1d", tmp + i); }
int max(int x, int y) { return x > y ? x : y; }
int main() {
//    freopen("in.txt", "r", stdin);
    while (ans = 0, scanf("%d", &n), n > 0) {
        memset(dp, 0xff, sizeof(dp));
        read(a), read(b), read(c);
        for (int i = 1; i <= n; i++) {
            if (a[i] + b[i] == 9 && c[i] == 0) need[i] = 1;
            else need[i] = c[i] - (a[i] + b[i]) % 10;
            add[i] = (a[i] + b[i] + need[i]) / 10;
        }
        for (int i = 1; i <= n; i++) {
            if (need[i] == 0) dp[i] = 1;
            for (int j = i - 1; j >= 1; j--) if (need[i] == add[j] && ~dp[j]) dp[i] = max(dp[i], dp[j] + 1);
        }
        for (int i = 1; i <= n; i++) if (add[i] == 0) ans = max(ans, dp[i]);
        printf("%d\n", n - ans);
    }
    return 0;
}
```


  [1]: assets/img/posts/2018/04/22/2018-04-22-upc_5434_columnaddition_dong_tai_gui_hua/20180119160853_82068.jpg
  [2]: assets/img/posts/2018/04/22/2018-04-22-upc_5434_columnaddition_dong_tai_gui_hua/20180119160903_49478.jpg