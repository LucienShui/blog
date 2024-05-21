---
title: "UPC-5559 - Base Station Sites - 二分"
date: 2018-04-05 19:38:38 +0800
last_modified_at: 2018-04-05 19:38:38 +0800
math: false
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5559

---
### 题目：

#### 题目描述
5G is the proposed next telecommunications standards beyond the current 4G standards. 5G planning aims at higher capacity than current 4G, allowing a higher density of mobile broadband users, and supporting device-to- device, reliable, and massive wireless communications. A telecommunication company would like to install more base stations to provide better communication for customers. Due to the installation cost and available locations,the company can only install S (2 ≤ S ≤ L) base stations at L (2 ≤ L ≤ 100, 000) candidate locations.  Since the base stations work in the same frequency band, they will interfere and cause severe performance degradation. To provide high quality communication experience to customers, the company would like to maximize the distance between the base stations so as to reduce the wireless interference among the base stations. Suppose the L candidate locations are in a straight line at locations P1, P2,..., PL (0 ≤ Pi ≤ 1, 000, 000) and the company wants to install S base stations at the L candidate locations. What is the largest minimum distance among the S base stations?
#### 输入
The input data includes multiple test sets.
Each set starts with a line which specifies L (i.e., the number of candidate locations) and S (i.e., the number of base stations). The next line contains L space-separated integers which represent P1, P2,..., PL.
The input data ends “0 0”.
#### 输出
For each set, you need to output a single line which should be the largest minimum distance among the base stations.
#### 样例输入
```
5 3
2 3 9 6 11
4 3
1 4 9 10
0 0
```
#### 样例输出
```
4
3
```
#### 提示
For the first set, the 3 base stations can be installed at locations 2, 6, 11.



---
### 题意：

&emsp;&emsp;在x轴上给你`L`个点的坐标，从中选出`S`个点，使得这些点之间坐标差值的最小值最大。

---
### 思路：

&emsp;&emsp;差分一下，二分答案（不差分也可以，会稍微慢一点）。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int n, m, p[int(2e5) + 7];
bool check(int aim) {
    int cnt = 0, sum = 0;
    for (int i = 2; i <= n; i++) {
        sum += p[i];
        if (sum >= aim) cnt++, sum = 0;
    }
    return cnt >= m - 1;
}
int main() {
//    freopen("in.txt", "r", stdin);
    while (scanf("%d%d", &n, &m), n + m > 0) {
        int maxn = -1;
        for (int i = 1; i <= n; i++) scanf("%d", p +i), maxn = std::max(maxn, p[i]);
        std::sort(p + 1, p + 1 + n);
        for (int i = n; i >= 1; i--) p[i] = p[i] - p[i - 1];
        int l = 1, r = maxn, mid = 0, ans = -1;
        while (l <= r) {
            mid = (l + r) >> 1;
            if (check(mid)) l = mid + 1, ans = mid;
            else r = mid - 1;
        }
        printf("%d\n", ans);
    }
    return 0;
}
```