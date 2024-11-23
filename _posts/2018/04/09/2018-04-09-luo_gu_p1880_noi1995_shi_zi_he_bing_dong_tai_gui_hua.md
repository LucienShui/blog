---
title: "洛谷P1880 [NOI1995] - 石子合并 - 动态规划"
date: 2018-04-09 21:51:55 +0800
last_modified_at: 2018-04-09 21:51:55 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1880

---
### 题目：

#### 题目描述

在一个圆形操场的四周摆放N堆石子,现要将石子有次序地合并成一堆.规定每次只能选相邻的2堆合并成新的一堆，并将新的一堆的石子数，记为该次合并的得分。

试设计出1个算法,计算出将N堆石子合并成1堆的最小得分和最大得分.

#### 输入格式：
数据的第1行试正整数N,1≤N≤100,表示有N堆石子.第2行有N个数,分别表示每堆石子的个数.

#### 输出格式：
输出共2行,第1行为最小得分,第2行为最大得分.

#### 输入样例#1：
```
4
4 5 9 4
```
#### 输出样例#1：
```
43
54
```

---
### 思路：

&emsp;&emsp;看到`n`的范围很小，考虑区间DP，$min[l][r]$表示$l$~$r$这个区间内的所有石子合并成一堆获得的最小权值，$sum$为前缀和数组，则有：

$$min[l][r] = min(min[l][r], min[l][mid] + min[mid + 1][r] + sum[r] - sum[l])$$

&emsp;&emsp;求$max$时也同理，值得注意的是，因为是一个圈，所以要化环为链把数组的长度增长一下。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 207;
int n, num[maxn], min[maxn][maxn], max[maxn][maxn], sum[maxn], ans_min = 0x3f3f3f3f, ans_max;
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d", &n);
    memset(min, 0x3f, sizeof(min));
    for (int i = 1; i <= n; i++) scanf("%d", num + i), num[n + i] = num[i];
    for (int i = 1; i <= n << 1; i++) min[i][i] = 0, sum[i] = sum[i - 1] + num[i];
    for (int len = 2; len <= n; len++)
        for (int l = 1, r; (r = l + len - 1) <= n << 1; l++)
            for (int mid = l; mid < r; mid++) {
                min[l][r] = std::min(min[l][r], min[l][mid] + min[mid + 1][r] + sum[r] - sum[l - 1]);
                max[l][r] = std::max(max[l][r], max[l][mid] + max[mid + 1][r] + sum[r] - sum[l - 1]);
            }
    for (int i = 1; i <= n; i++) {
        ans_min = std::min(ans_min, min[i][i + n - 1]);
        ans_max = std::max(ans_max, max[i][i + n - 1]);
    }
    printf("%d\n%d\n", ans_min, ans_max);
    return 0;
}
```