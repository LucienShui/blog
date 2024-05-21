---
title: "Codeforces-1008C - Reorder the Array - 水题"
date: 2018-07-14 01:03:00 +0800
last_modified_at: 2018-07-14 01:08:51 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "贪心"]
---

### 题目链接

https://codeforces.com/contest/1008/problem/C

---
### 题目

You are given an array of integers. Vasya can permute (change order) its integers. He wants to do it so that as many as possible integers will become on a place where a smaller integer used to stand. Help Vasya find the maximal number of such integers.

For instance, if we are given an array $[10, 20, 30, 40]$, we can permute it so that it becomes $[20, 40, 10, 30]$. Then on the first and the second positions the integers became larger ($20>10$, $40>20$) and did not on the third and the fourth, so for this permutation, the number that Vasya wants to maximize equals $2$. Read the note for the first example, there is one more demonstrative test case.

Help Vasya to permute integers in such way that the number of positions in a new array, where integers are greater than in the original one, is maximal.

#### Input
The first line contains a single integer $n$ ($1 \leq n \leq 10^5$) — the length of the array.

The second line contains $n$ integers $a_1, a_2, \ldots, a_n$ ($1 \leq a_i \leq 10^9$) — the elements of the array.

#### Output
Print a single integer — the maximal number of the array's elements which after a permutation will stand on the position where a smaller element stood in the initial array.

#### Input
```
7
10 1 1 1 5 5 3
```
#### Output
```
4
```
#### Input
```
5
1 1 1 1 1
```
#### Output
```
0
```
#### Note
In the first sample, one of the best permutations is $[1, 5, 5, 3, 10, 1, 1]$. On the positions from second to fifth the elements became larger, so the answer for this permutation is 4.

In the second sample, there is no way to increase any element with a permutation, so the answer is 0.

---
### 题意

&emsp;&emsp;给你一个序列，你可以生成这个序列的任意一个排列，对于某个排列，如果这个排列上某个位置的值大于原序列的值，那么就会产生`1`的贡献，问你最大能有多少贡献。

---
### 思路

&emsp;&emsp;直接排序一下贪心即可。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
int a[maxn], n, r = 1, ans;
int main() {
    std::cin >> n;
    for (int i = 1; i <= n; i++) std::cin >> a[i];
    std::sort(b + 1, b + 1 + n);
    for (int i = 1; i <= n; i++) {
        while (r <= n && a[r] <= a[i]) r++;
        if (r <= n) ans++, r++;
    }
    std::cout << ans << std::endl;
    return 0;
}
```