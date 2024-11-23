---
title: "洛谷P1282 - 多米诺骨牌 - 动态规划"
date: 2018-04-22 00:42:00 +0800
last_modified_at: 2018-05-23 18:14:56 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
img_path: /assets/img/posts/2018/04/22/2018-04-22-luo_gu_p1282_duo_mi_nuo_gu_pai_dong_tai_gui_hua/
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1282

---
### 题目：

#### 题目描述

多米诺骨牌有上下2个方块组成，每个方块中有1~6个点。现有排成行的

上方块中点数之和记为S1，下方块中点数之和记为S2，它们的差为|S1-S2|。例如在图8-1中，S1=6+1+1+1=9，S2=1+5+3+2=11，|S1-S2|=2。每个多米诺骨牌可以旋转180°，使得上下两个方块互换位置。 编程用最少的旋转次数使多米诺骨牌上下2行点数之差达到最小。

![91.png][1]

对于图中的例子，只要将最后一个多米诺骨牌旋转180°，可使上下2行点数之差为0。

#### 输入格式：
输入文件的第一行是一个正整数n(1≤n≤1000)，表示多米诺骨牌数。接下来的n行表示n个多米诺骨牌的点数。每行有两个用空格隔开的正整数，表示多米诺骨牌上下方块中的点数a和b，且1≤a，b≤6。

#### 输出格式：
输出文件仅一行，包含一个整数。表示求得的最小旋转次数。

#### 输入样例#1：
```
4
6 1
1 5
1 3
1 2
```
#### 输出样例#1：
```
1
```

---
### 思路：

&emsp;&emsp;注意到`n`只有`1000`，每个多米诺骨牌的差值最大为`5`，即所有骨牌的和的差值的绝对值最大不超过$1000 \times 5 = 5000$，我们可以枚举这个差值进行DP，复杂度为$O(10^4 \times 10^3)$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int num[1007], dp[1007][10007], base = 5000, n;
int main() {
	scanf("%d", &n);
	for (int i = 1, a, b; i <= n; i++) scanf("%d%d", &a, &b), num[i] = a - b;
	memset(dp, 0x3f, sizeof(dp));
	dp[0][base] = 0;
	for (int i = 1; i <= n; i++)
		for (int val = -5000; val <= 5000; val++)
			dp[i][val + base] = std::min(dp[i - 1][val - num[i] + base], dp[i - 1][val + num[i] + base] + 1);
	for (int i = 0; i <= 5000; i++) {
		int ans = std::min(dp[n][i + base], dp[n][-i + base]);
		if (ans != 0x3f3f3f3f) return 0 * printf("%d\n", ans);
	}
}

```


  [1]: assets/img/posts/2018/04/22/2018-04-22-luo_gu_p1282_duo_mi_nuo_gu_pai_dong_tai_gui_hua/91.png