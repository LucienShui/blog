---
title: "洛谷P1508 - Likecloud-吃、吃、吃 - 动态规划"
date: 2018-04-22 00:48:22 +0800
last_modified_at: 2018-04-22 00:48:34 +0800
math: false
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1508

---
### 题目：

#### 题目背景

问世间，青春期为何物？

答曰：“甲亢，甲亢，再甲亢；挨饿，挨饿，再挨饿！”

#### 题目描述

正处在某一特定时期之中的李大水牛由于消化系统比较发达，最近一直处在饥饿的状态中。某日上课，正当他饿得头昏眼花之时，眼前突然闪现出了一个n*m(n and m<=200)的矩型的巨型大餐桌，而自己正处在这个大餐桌的一侧的中点下边。餐桌被划分为了n*m个小方格，每一个方格中都有一个圆形的巨型大餐盘，上面盛满了令李大水牛朝思暮想的食物。李大水牛已将餐桌上所有的食物按其所能提供的能量打了分（有些是负的，因为吃了要拉肚子），他决定从自己所处的位置吃到餐桌的另一侧，但他吃东西有一个习惯——只吃自己前方或左前方或右前方的盘中的食物。

由于李大水牛已饿得不想动脑了，而他又想获得最大的能量，因此，他将这个问题交给了你。

每组数据的出发点都是最后一行的中间位置的下方！


#### 输入格式：

第一行为m n.(n为奇数)，李大水牛一开始在最后一行的中间的下方

接下来为m*n的数字距阵.

共有m行,每行n个数字.数字间用空格隔开.代表该格子上的盘中的食物所能提供的能量.

数字全是整数.

#### 输出格式：

一个数,为你所找出的最大能量值.

#### 输入样例#1：
```
6 7
16 4 3 12 6 0 3
4 -5 6 7 0 0 2
6 0 -1 -2 3 6 8
5 3 4 0 0 -2 7
-1 7 4 0 7 -5 6
0 -1 3 4 12 4 2

```
#### 输出样例#1：
```
41
```

---
### 思路：

&emsp;&emsp;倒着更新的话不仅可以优化空间还可以优化常数。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int m, n, a[207][207];
int main() {
	scanf("%d%d", &m, &n);
	for (int i = 1; i <= m; i++) 
		for (int j = 1; j <= n; j++) {
			scanf("%d", a[i] + j);
			a[i][j] += std::max(std::max(a[i - 1][j - 1], a[i - 1][j + 1]), a[i - 1][j]);
		}
	printf("%d\n", std::max(std::max(a[m][n >> 1], a[m][n + 3 >> 1]), a[m][n + 1 >> 1]));
	return 0;
}
```