---
title: "ARC-060D - Digit Sum - 数论"
date: 2018-05-20 23:34:00 +0800
last_modified_at: 2018-05-20 23:37:08 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["数论"]
---

### 题解链接



---
### 题目链接

https://arc060.contest.atcoder.jp/tasks/arc060_b

---
### 题目

#### Problem Statement
For integers b(b≥2) and n(n≥1), let the function f(b,n) be defined as follows:

$f(b,n)=n$, when $n<b$
$f(b,n)=f(b, floor(n⁄b))+(n\ mod\ b)$, when $n≥b$
Here, $floor(n⁄b)$ denotes the largest integer not exceeding $n⁄b$, and n mod $b$ denotes the remainder of $n$ divided by $b$.

Less formally, $f(b,n)$ is equal to the sum of the digits of n written in base $b$. For example, the following hold:

$f(10, 87654)=8+7+6+5+4=30$
$f(100, 87654)=8+76+54=138$
You are given integers $n$ and $s$. Determine if there exists an integer $b(b≥2)$ such that $f(b,n)=s$. If the answer is positive, also find the smallest such $b$.

#### Constraints
$1≤n≤10^{11}$
$1≤s≤10^{11}$
$n$, $s$ are integers.
#### Input
The input is given from Standard Input in the following format:

```
n
s
```

#### Output
If there exists an integer $b(b≥2)$ such that $f(b,n)=s$, print the smallest such $b$. If such $b$ does not exist, print $-1$ instead.

---
### 题意

&emsp;&emsp;给你一个`n`和一个`s`，问是否存在一个$b\ (2 \leq b)$，使得`n`在$b$进制下各位数字的和为`s`，如果存在，则输出这个$b$，如果不存在，则输出`-1`。

---
### 思路

&emsp;&emsp;假设$x_0,x_1,\dots ,x_m$为`n`在$b$进制下的各位数字（$x_0$为最低位），那么有：
$$x_0 + x_1 · b + x_2 · b^2 + \dots x_m · b^m = n$$$$x_0 + x_1 + x_2 + \dots + x_m = s$$

&emsp;&emsp;考虑某个进制$b$，使得`n`在$b$进制下的表示的最高次幂大于等于$2$次幂，则有：$b^2 \leq n = b \leq \sqrt{n}$，于是我们在$b$进制的最高次为2次幂及以上的时候直接暴力枚举即可。

&emsp;&emsp;对于最高次为一次幂的$b$，等式为：
$$x_0 + x_1 · b = n\ \ ①$$$$x_0 + x_1 = s\ \ ②$$

&emsp;&emsp;将$②$式移项并代入$①$式得：$$s - x_1 + x_1·b = n$$$$x_1·(b-1) = n - s$$

&emsp;&emsp;于是我们可以从大到小枚举$x_1$（相当于从小到大枚举$(b - 1)$），判断一下是否存在合法$b$的即可。

&emsp;&emsp;因为前面我们枚举$b$的时候已经枚举过$[2, \sqrt{n}]$的范围，而$\sqrt{n-s}$显然小于$\sqrt{n}$，所以我们第二次枚举只用枚举$(\sqrt{n},n-s]$这个区间就可以了。

---
### 实现

```cpp
## include <bits/stdc++.h>
long long n, s;
bool check(long long base) {
    long long ret = 0, tmp = n;
    while (tmp) ret += tmp % base, tmp /= base;
    return ret == s;
}
bool check(long long a1, long long tmp, long long a0 = 0, long long b = 0) {
    return (a0 = s - a1) >= 0 && a0 < (b = tmp / a1 + 1) && a1 < b;
}
int main() {
    scanf("%lld%lld", &n, &s);
    long long up = (long long)sqrt(n) + 1;
    for (long long base = 2; base <= up; base++) if (check(base)) return 0 * printf("%lld\n", base);
    if (n <= s) return 0 * printf("%lld\n", n < s ? -1: n + 1);
    long long tmp = n - s, upper = tmp / up + 1;
    for (long long a1 = upper; a1 >= 1; a1--)
        if (!(tmp % a1) && check(a1, tmp)) return 0 * printf("%lld\n", tmp / a1 + 1);
    return 0 * puts("-1");
}
```