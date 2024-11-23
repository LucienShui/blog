---
title: "UPC-5093 - Orderly Class - 思维"
date: 2018-04-21 23:56:00 +0800
last_modified_at: 2018-04-21 23:56:14 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5093

---
### 题目：

#### 题目描述
Ms. Thomas is managing her class of n students.
She placed all her students in a line, and gave the i-th student from the left a card with the letter ai written on it.
She would now like to rearrange the students so that the i-th student from the left has a card with the letter bi written on it.
To do this, she will choose some consecutive group of students, and reverse their order. Students will hold on to their original cards during this process.
She’s now wondering, what is the number of valid ways to do this? (It may be impossible, in which case, the answer is zero).
With sequences abba and aabb, Ms. Thomas can choose the group a(bba). With sequences caxcab and cacxab, Ms. Thomas can choose ca(xc)ab or c(axca)b. With sequences a and z, there are clearly no solutions.
#### 输入
The input is two lines of lowercase letters, A and B. The i-th character of A and B represent ai and bi respectively. It is guaranteed that A and B have the same positive length, and A and B are not identical. The common length is allowed to be as large as 100 000.
#### 输出
For each test case, output a single integer, the number of ways Ms. Thomas can reverse some consecutive group of A to form the line specified by string B.
#### 样例输入
```
abba
aabb
```
#### 样例输出
```
1
```

---
### 题意：

&emsp;&emsp;给你字符串`a`和字符串`b`，你需要在`a`中选择一个连续的区间翻转**一次**，问有多少种方法通过`a`得到`b`，保证`a`、`b`不相同。

---
### 思路：

&emsp;&emsp;本来觉得这个题很难，但是后来又读了一遍题发现只能翻转一次，才发现原来是个签到题。找到第一个不相同的字符的左端点和右端点，判断能否翻转得到`b`，可以的话尝试对这个区间进行增广即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
char a[maxn], b[maxn];
int main() {
//    freopen("in.txt", "r", stdin);
    scanf(" %s %s", a , b);
    int l = 0, len = int(strlen(a)), r = len - 1;
    while (a[l] == b[l]) l++;
    while (a[r] == b[r]) r--;
    for (int p = l, q = r; p <= r; p++, q--) if (a[p] != b[q]) return 0 * puts("0");
    int cnt = 0;
    while (l - cnt - 1 >= 0 && r + cnt + 1 < len && a[l - cnt - 1] == b[r + cnt + 1]) cnt++;
    printf("%d\n", cnt + 1);
    return 0;
}
```