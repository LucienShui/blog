---
title: "Codeforces-1008B - Turn the Rectangles - 水题"
date: 2018-07-14 00:56:00 +0800
last_modified_at: 2018-07-14 01:08:57 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "贪心"]
---

### 题目链接

https://codeforces.com/contest/1008/problem/B

---
### 题目

There are $n$ rectangles in a row. You can either turn each rectangle by $90$ degrees or leave it as it is. If you turn a rectangle, its width will be height, and its height will be width. Notice that you can turn any number of rectangles, you also can turn all or none of them. You can not change the order of the rectangles.

Find out if there is a way to make the rectangles go in order of non-ascending height. In other words, after all the turns, a height of every rectangle has to be not greater than the height of the previous rectangle (if it is such).

#### Input
The first line contains a single integer $n$ ($1 \leq n \leq 10^5$) — the number of rectangles.

Each of the next $n$ lines contains two integers $w_i$ and $h_i$ ($1 \leq w_i, h_i \leq 10^9$) — the width and the height of the $i$-th rectangle.

#### Output
Print "YES" (without quotes) if there is a way to make the rectangles go in order of non-ascending height, otherwise print "NO".

You can print each letter in any case (upper or lower).

#### Input
```
3
3 4
4 6
3 5
```
#### Output
```
YES
```
#### Input
```
2
3 4
5 5
```
#### Output
```
NO
```
#### Note
In the first test, you can rotate the second and the third rectangles so that the heights will be [4, 4, 3].

In the second test, there is no way the second rectangle will be not higher than the first one.


---
### 题意

&emsp;&emsp;给你`n`个长方形，问你能否通过任意多次旋转，在不改变他们的相对顺序的情况下让他们的高度形成一个不上升序列。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
typedef long long ll;
int x[maxn], y[maxn], n;
int main() {
    std::cin >> n;
    for (int i = 1; i <= n; i++) {
        std::cin >> x[i] >> y[i];
        if (x[i] > y[i]) std::swap(x[i], y[i]);
    }
    int upper = 0x3f3f3f3f;
    for (int i =1 ; i <= n; i++) {
        if (x[i] > upper) return 0 * puts("NO");
        if (y[i] <= upper) upper = y[i];
        else if (x[i] <= upper) upper = x[i];
    }
    puts("YES");
    return 0;
}
```