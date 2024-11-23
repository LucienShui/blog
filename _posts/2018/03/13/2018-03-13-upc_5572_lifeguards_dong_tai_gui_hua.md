---
title: "UPC-5572 - Lifeguards - 动态规划"
date: 2018-03-13 10:51:00 +0800
last_modified_at: 2018-03-13 11:11:12 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5572

---
### 题目：

#### 题目描述
Farmer John has opened a swimming pool for his cows, figuring it will help them relax and produce more milk.
To ensure safety, he hires NN cows as lifeguards, each of which has a shift that covers some contiguous interval of time during the day. For simplicity, the pool is open from time t=0 until time t=1,000,000,000 on a daily basis, so each shift can be described by two integers, giving the time at which a cow starts and ends her shift. For example, a lifeguard starting at time t=4 and ending at time t=7 covers three units of time (note that the endpoints are "points" in time).

Unfortunately, Farmer John hired 1 more lifeguard than he has the funds to support. Given that he must fire exactly one lifeguard, what is the maximum amount of time that can still be covered by the shifts of the remaining lifeguards? An interval of time is covered if at least one lifeguard is present.
#### 输入
The first line of input contains N (1≤N≤100,000). Each of the next N lines describes a lifeguard in terms of two integers in the range 0…1,000,000,000, giving the starting and ending point of a lifeguard's shift. All such endpoints are distinct. Shifts of different lifeguards might overlap.
#### 输出
Please write a single number, giving the maximum amount of time that can still be covered if Farmer John fires 1 lifeguard.
#### 样例输入
```
3
5 9
1 4
3 7
```
#### 样例输出
```
7
```

---
### 题意：

&emsp;&emsp;给你$n$条线段，每条线段的覆盖区间为$[l, r]$，数据保证每个线段的右端点坐标都是唯一的，问你删去某一条线段后，最大能覆盖多少。

---
### 思路：

&emsp;&emsp;设$dp[i][0]$为处理到$i$时还没有删去线段的最大覆盖值，$dp[i][1]$为处理到$i$时已经删去的最大值，$upper[i]$记录右区间比$i$点右区间大的最近的线段的下标。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 100007;
int dp[maxn][2], upper[maxn], n;
struct Node {
    int l, r;
    bool operator < (const Node &tmp) const {
        return l == tmp.l ? r < tmp.r : l < tmp.l;
    }
} node[maxn];
int calc(int cur, int pre) {
    return std::max(node[cur].r - node[pre].r, 0) - std::max(node[cur].l - node[pre].r, 0);
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d%d", &node[i].l, &node[i].r);
    std::sort(node + 1, node + 1 + n);
    for (int i = 1; i <= n; i++) {
        if (i < n) {
            dp[i][0] = dp[i - 1][0] + calc(i, upper[i - 1]);
            upper[i] = node[upper[i - 1]].r > node[i].r ? upper[i - 1] : i;
        }
        if (i > 1) dp[i][1] = std::max(dp[i - 1][1] + calc(i, upper[i - 1]), dp[i - 2][0] + calc(i, upper[i - 2]));
    }
    printf("%d\n", std::max(dp[n - 1][0], dp[n][1]));
    return 0;
}
```