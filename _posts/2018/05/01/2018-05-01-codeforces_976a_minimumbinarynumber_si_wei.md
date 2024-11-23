---
title: "Codeforces-976A - Minimum Binary Number - 思维"
date: 2018-05-01 00:50:00 +0800
last_modified_at: 2018-05-01 00:57:58 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/976/problem/A

---
### 题目：

String can be called correct if it consists of characters "0" and "1" and there are no redundant leading zeroes. Here are some examples: "0", "10", "1001".

You are given a correct string s.

You can perform two different operations on this string:

swap any pair of adjacent characters (for example, "101"  "110");
replace "11" with "1" (for example, "110"  "10").
Let val(s) be such a number that s is its binary representation.

Correct string a is less than some other correct string b iff val(a) < val(b).

Your task is to find the minimum correct string that you can obtain from the given one using the operations described above. You can use these operations any number of times in any order (or even use no operations at all).

#### Input
The first line contains integer number n (1 ≤ n ≤ 100) — the length of string s.

The second line contains the string s consisting of characters "0" and "1". It is guaranteed that the string s is correct.

#### Output
Print one string — the minimum correct string that you can obtain from the given one.

#### Examples
##### input
```
4
1001
```
##### output
```
100
```
##### input
```
1
1
```
##### output
```
1
```
#### Note
In the first example you can obtain the answer by the following sequence of operations: "1001"  "1010"  "1100"  "100".

In the second example you can't obtain smaller answer no matter what operations you use.

---
### 题意：

&emsp;&emsp;如果一个$01$串没有前导零，那么这个零一串就是合法的。一个合法的$01$串的权值为其二进制所对应的数，你可以有两种操作，一种是交换两个相邻的数字，另一种是将两个连续的1合并成一个1，问给你一个合法的$01$串，通过上面的两个操作能得到的权值最小的合法$01$串是什么。

---
### 思路：

&emsp;&emsp;假设一个串有$a$个$1$，$b$个$0$，如果$a \neq 0$就输出一个$1$和$b$个$0$，否则输出一个$0$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int main() {
    int n, cnt[2] = {0}, tmp;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) scanf("%1d", &tmp), cnt[tmp]++;
    if (cnt[1]) {
        putchar('1');
        while (cnt[0]--) putchar('0');
        putchar('\n');
    } else puts("0");
    return 0;
}
```