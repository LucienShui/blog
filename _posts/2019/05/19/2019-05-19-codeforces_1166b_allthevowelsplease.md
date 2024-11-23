---
title: "Codeforces - 1166B - All the Vowels Please"
date: 2019-05-19 02:29:00 +0800
last_modified_at: 2019-05-19 02:29:00 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces - 1166B - All the Vowels Please

### 地址

https://codeforces.com/contest/1166/problem/B

### 原文地址

https://www.lucien.ink/archives/431

### 题目

Tom loves vowels, and he likes long words with many vowels. His favorite words are vowelly words. We say a word of length $k$ is vowelly if there are positive integers $n$ and $m$ such that $n\cdot m = k$ and when the word is written by using $n$ rows and $m$ columns (the first row is filled first, then the second and so on, with each row filled from left to right), every vowel of the English alphabet appears at least once in every row and every column.

You are given an integer $k$ and you must either print a vowelly word of length $k$ or print $-1$ if no such word exists.

In this problem the vowels of the English alphabet are '`a`', '`e`', '`i`', '`o`' ,'`u`'.



### 题意

问你是否存在一个长度为 $k$ 的字符串，使得你将他们平铺成一个矩形之后，每行每列都包含 $5$ 个元音字母。

### 题解

看是否能展开成大于等于 $5 \times 5$ 的矩形，可以的话就每行循环铺一下。

#### 代码

https://pasteme.cn/8171

```cpp
## include <bits/stdc++.h>
int n, x = -1, y = -1;
char ans[int(1e5) + 7];
int index(int a, int b) {
    return a * y + b;
}
char table[] = "aeiou";
void solve(int a) {
    for (int j = 0; j < y; j++) {
        ans[index(a, j)] = table[(a + j) % 5];
    }
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i * i <= n; i++) {
        if (n % i == 0) {
            if (i >= 5 && n / i >= 5) {
                x = i, y = n / i;
                break;
            }
        }
    }
    if (x < 0 || y < 0) return 0 * puts("-1");
    for (int i = 0; i < x; i++) {
        solve(i);
    }
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
            printf("%c", ans[index(i, j)]);
        }
    }
    putchar('\n');
    return 0;
}

```
