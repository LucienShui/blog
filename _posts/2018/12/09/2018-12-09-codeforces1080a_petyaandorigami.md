---
title: "Codeforces 1080A - Petya and Origami"
date: 2018-12-09 01:47:35 +0800
last_modified_at: 2018-12-09 01:47:35 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1080A - Petya and Origami

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/A

---
### 题目

Petya is having a party soon, and he has decided to invite his $n$ friends.

He wants to make invitations in the form of origami. For each invitation, he needs **two** red sheets, **five** green sheets, and **eight** blue sheets. The store sells an infinite number of notebooks of each color, but each notebook consists of only **one** color with $k$ sheets. That is, each notebook contains $k$ sheets of either red, green, or blue.

Find the minimum number of notebooks that Petya needs to buy to invite all $n$ of his friends.

---
### 题意

&emsp;&emsp;$2$ 张红纸 + $5$ 张绿纸 + $8$ 张蓝纸 = $1$ 一个人，每一份彩纸中包含 $k$ 张彩纸，且只有一种颜色的彩纸。现在有 $n$ 个人，问最少需要买多少份彩纸。

---
### 思路

&emsp;&emsp;模拟一下即可，复杂度 $O(1)$。

---
### 实现

https://pasteme.cn/2336

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll n, k;
    scanf("%lld%lld\n", &n, &k);
    printf("%lld\n", (n * 2 + k - 1) / k + (n * 5 + k - 1) / k + (n * 8 + k - 1) / k);
    return 0;
}
```