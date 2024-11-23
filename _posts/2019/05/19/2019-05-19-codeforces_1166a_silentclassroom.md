---
title: "Codeforces - 1166A - Silent Classroom"
date: 2019-05-19 02:25:58 +0800
last_modified_at: 2019-05-19 02:25:58 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces - 1166A - Silent Classroom

### 地址

https://codeforces.com/contest/1166/problem/A

### 原文地址

https://www.lucien.ink/archives/430

### 题目

There are $n$ students in the first grade of Nlogonia high school. The principal wishes to split the students into two classrooms (each student must be in exactly one of the classrooms). Two distinct students whose name starts with the same letter will be chatty if they are put in the same classroom (because they must have a lot in common). Let $x$ be the number of such pairs of students in a split. Pairs $(a, b)$ and $(b, a)$ are the same and counted only once.

For example, if there are $6$ students: "`olivia`", "`jacob`", "`tanya`", "`jack`", "`oliver`" and "`jessica`", then:

You are given the list of the $n$ names. What is the minimum $x$ we can obtain by splitting the students into classrooms?

Note that it is valid to place all of the students in one of the classrooms, leaving the other one empty.



### 题意

有 $n$ 个小孩，两间教室，要把这些小孩分到两间教室去，如果同一间教室里两个孩子的名字首字母相同那么他们就可以配对，问最少可以配对多少。

### 题解

均分一下。

#### 代码

https://pasteme.cn/8170

```cpp
## include <bits/stdc++.h>
std::map<char, int> map;
int main() {
    int n;
    char str[1007];
    scanf("%d", &n);
    while (n--) {
        scanf("%s", str);
        map[str[0]]++;
    }
    long long ans = 0;
    for (auto it : map) {
        int a = it.second / 2, b = it.second - a;
        ans += a * (a - 1) / 2;
        ans += b * (b - 1) / 2;
    }
    printf("%lld\n", ans);
    return 0;
}

```
