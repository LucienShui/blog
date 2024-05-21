---
title: "2017第八届蓝桥杯C/C++第十题 - k倍区间 - 前缀和"
date: 2018-01-31 23:55:27 +0800
last_modified_at: 2018-01-31 23:55:27 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维"]
---

### 题目：

给定一个长度为N的数列，A1, A2, ... AN，如果其中一段连续的子序列Ai, Ai+1, ... Aj(i <= j)之和是K的倍数，我们就称这个区间[i, j]是K倍区间。  

你能求出数列中总共有多少个K倍区间吗？  

#### 输入
第一行包含两个整数N和K。(1 <= N, K <= 100000)  
以下N行每行包含一个整数Ai。(1 <= Ai <= 100000)  

#### 输出
输出一个整数，代表K倍区间的数目。  


#### 样例输入
```
5 2
1
2
3
4
5
```
#### 样例输出：
```
6
```

---
### 思路：

&emsp;&emsp;首先统计前缀和`sum[i]`表示$A_1+A_2+…+A_i$，所以对于任意一段区间`[l,r]`的和就是`sum[r]-sum[l-1]`。如果要保证这个区间和为k倍数，则需要满足：$(sum[r]-sum[l-1])\%k == 0$，变形后就是：$sum[r]\%k==sum[l-1]\%k$，所以我们计算前缀和的时候顺带模K，然后统计前缀和中相同的数据就行了。复杂度O(n)。

&emsp;&emsp;写完之后发现代码可以进一步精简，就压缩成一个循环了。

---
### 实现：

```cpp
## include <cstdio>
int tmp, sum, cnt[100007], n, k;
long long ans;
int main() {
    scanf("%d%d", &n, &k);
    for (int i = 1; i <= n; i++) scanf("%d", &tmp), sum = (sum + tmp) % k, ans += cnt[sum]++;
    printf("%lld\n", ans + cnt[0]);
    return 0;
}
```