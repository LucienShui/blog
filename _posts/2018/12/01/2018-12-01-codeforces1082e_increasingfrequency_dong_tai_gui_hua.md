---
title: "Codeforces 1082E - Increasing Frequency - 动态规划"
date: 2018-12-01 01:32:00 +0800
last_modified_at: 2018-12-01 01:48:05 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "codeforces"]
---

## Codeforces 1082E - Increasing Frequency - 动态规划

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/E

------

### 题目

You are given array $a$ of length $n$. You can choose one segment $[l, r]$ ($1 \le l \le r \le n$) and integer value $k$ (positive, negative or even zero) and change $a_l, a_{l + 1}, \dots, a_r$ by $k$ each (i.e. $a_i := a_i + k$ for each $l \le i \le r$).

What is the maximum possible number of elements with value $c$ that can be obtained after one such operation?

------

### 题意

&emsp;&emsp;有$n$个元素，第$i$个元素的值为$a_i$，你可以选择一个区间$[l, r]$，并将这个区间的每个元素都加上$k$（$k$为任意值，包括负数），问你在最多修改一次的情况下，能让这个序列中最多存在几个值为$c$的元素。

------

### 思路

&emsp;&emsp;考虑我们将区间$[l, r]$中所有的$x$都修改为$c$，则只需让这个区间中的每一个元素都加上$c - x$，此时区间中所有的$x$都会变为$c$，而$c$则变成了非$c$的值。

&emsp;&emsp;记$sum_i$为区间$[1, i]$中有多少个元素的值为$c$，记$cnt_i$为区间$[1, i]$中有多少个元素的值为$x$。

&emsp;&emsp;则我们修改某个区间$[l, r]$中的$x$的时候，整个序列中$c$的个数由$sum_n$变为了$sum_{l - 1} + cnt_r - cnt_{l - 1} + sum_n - sum_r$。

&emsp;&emsp;而我需要对于每一个区间都求一个这样的答案，然后取最大值，即: $max\{sum_{l - 1} + cnt_r - cnt_{l - 1} + sum_n - sum_r\}\ (1 \leq l \leq r \leq n)$。

&emsp;&emsp;注意到对于每一个固定的$r$，$cnt_r$、$sum_n$、$sum_r$均为定值，问题就转化成为对于每一个$r$，求$max\{sum_{l - 1} - cnt_{l - 1}\}\ (1 \leq l \leq r)$，这样以来就可以$O(n)$进行$DP$了。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(5e5) + 7;
std::map<int, std::vector<int>> map;
int n, c, sum[maxn], a[maxn], cnt[maxn];
int main() {
    scanf("%d%d", &n, &c);
    for (int i = 1; i <= n; i++) {
        scanf("%d", a + i);
        sum[i] = sum[i - 1] + (a[i] == c);
        map[a[i]].push_back(i);
    }
    int ans = sum[n];
    for (auto cur : map) {
        const std::vector<int> &vector = cur.second;
        int num = cur.first, max = 0;
        for (const auto &pos : vector) {
            max = std::max(max, sum[pos - 1] - cnt[num]++);
            ans = std::max(ans, cnt[num] - sum[pos] + max + sum[n]);
        }
    }
    printf("%d\n", ans);
    return 0;
}
```