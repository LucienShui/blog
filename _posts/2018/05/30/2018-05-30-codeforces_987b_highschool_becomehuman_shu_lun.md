---
title: "Codeforces-987B - High School: Become Human - 数论"
date: 2018-05-30 02:31:00 +0800
last_modified_at: 2018-06-05 10:55:45 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["数论"]
---

### 题目链接

https://codeforces.com/contest/987/problem/B

---
### 题目

Year 2118. Androids are in mass production for decades now, and they do all the work for humans. But androids have to go to school to be able to solve creative tasks. Just like humans before.

It turns out that high school struggles are not gone. If someone is not like others, he is bullied. Vasya-8800 is an economy-class android which is produced by a little-known company. His design is not perfect, his characteristics also could be better. So he is bullied by other androids.

One of the popular pranks on Vasya is to force him to compare $x^y$ with $y^x$. Other androids can do it in milliseconds while Vasya's memory is too small to store such big numbers.

Please help Vasya! Write a fast program to compare $x^y$ with $y^x$ for Vasya, maybe then other androids will respect him. 
#### Input
On the only line of input there are two integers x and y (1 ≤ x, y ≤ 109). 
#### Output
If $x^y < y^x$, then print '<' (without quotes). If $x^y > y^x$, then print '>' (without quotes). If $x^y = y^x$, then print '=' (without quotes).

---
### 题意

&emsp;&emsp;给你两个数字`x y`，让你比较$x^y$和$y^x$的大小。

---
### 思路

&emsp;&emsp;假设$x^y@y^x$（$@$代表$>、<、=$三个中的任意一个），则有：$$ylog_2x@xlog_2y$$

&emsp;&emsp;两边同时除以$xy$：$$\frac{log_2x}{x} @ \frac{log_2y}{y}$$

&emsp;&emsp;即：比较$\frac{log_2x}{x}$和$\frac{log_2y}{y}$的大小就可以得出答案。

&emsp;&emsp;对于$\frac{log_2x}{x}$而言，通过求导或肉眼观察可以发现，$x$小于2时是增函数，大于2时是减函数，所以$x$和$y$在同一侧时根据单调性去判断，如果异侧的话只有两种情况。

---
### 实现

```cpp
## include <bits/stdc++.h>
int main() {
	int x, y, ans, flag = 1;
	scanf("%d%d", &x, &y);
	if (x == y) ans = 0;
	else if (x >= 3 && y >= 3) ans = y - x;
	else if (x <= 2 && y <= 2) ans = x - y;
	else {
	    if (x > y) std::swap(x, y), flag = -1;
	    if (x == 2) ans = y - 4;
        else ans = -1;
	}
	if (ans) puts(ans * flag > 0 ? ">" : "<");
	else puts("=");
	return 0;
}

```