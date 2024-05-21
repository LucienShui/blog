---
title: "Codeforces-985D - Sand Fortress - 二分 &amp; 贪心"
date: 2018-05-22 09:11:00 +0800
last_modified_at: 2018-05-22 09:11:57 +0800
math: true
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "贪心"]
---

### 题目链接

https://codeforces.com/contest/985/problem/D

---
### 题目

You are going to the beach with the idea to build the greatest sand castle ever in your head! The beach is not as three-dimensional as you could have imagined, it can be decribed as a line of spots to pile up sand pillars. Spots are numbered 1 through infinity from left to right.

Obviously, there is not enough sand on the beach, so you brought n packs of sand with you. Let height hi of the sand pillar on some spot i be the number of sand packs you spent on it. **You can't split a sand pack to multiple pillars, all the sand from it should go to a single one.** There is a fence of height equal to the height of pillar with H sand packs to the left of the first spot and you should prevent sand from going over it.

Finally you ended up with the following conditions to building the castle:

+ $h1 ≤ H$: no sand from the leftmost spot should go over the fence;
+ For any  $i \in [1,\infty)\ |hi - hi + 1| ≤ 1$: large difference in heights of two neighboring pillars can lead sand to fall down from the higher one to the lower, you really don't want this to happen;
+ $\sum_{i=1}^{\infty}{h_i} = n$: you want to spend all the sand you brought with you.

As you have infinite spots to build, it is always possible to come up with some valid castle structure. Though you want the castle to be as compact as possible.

Your task is to calculate the minimum number of spots you can occupy so that all the aforementioned conditions hold.

#### Input
The only line contains two integer numbers $n$ and $H$ $(1 ≤ n, H ≤ 10^{18})$ — the number of sand packs you have and the height of the fence, respectively.

#### Output
Print the minimum number of spots you can occupy so the all the castle building conditions hold.

---
### 题意

&emsp;&emsp;你有`n`个沙袋，你要把它们摆成若干堆，在一条直线上有无限个点，坐标从$1$到$\infty$，你只能把沙袋放在这些点上，要求相邻的堆的高差不能超过$1$，而且最左边的堆的高度不能超过$H$，问你最少可以摆多少堆。

---
### 思路

&emsp;&emsp;二分一下合法的最高摆放高度，对于每轮`check`，先看看高度为$h$时最少需要多少沙袋，如果小于等于`n`的话，假设剩下$last$包沙袋，就需要额外摆放`ceil(last / h)`堆，然后更新答案即可。

---
### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll n, H, ans = 0x7f7f7f7f7f7f7f7f;
bool check(ll h) {
    ll need, ret;
    if (h > H) {
        need = ll(1.0 * (h + H) * (h - H + 1) / 2 + 1.0 * (h + 1) * h / 2 - h);
        ret = h - H + h;
    }
    else {
        need = ll(1.0 * (h + 1) * h / 2);
        ret = h;
    }
    if (need > n) return false;
    ll last = n - need;
    ret += last / h + (last % h > 0);
    if (ret <= ans) {
        ans = ret;
        return true;
    }
    return false;
}
int main() {
    std::cin >> n >> H;
    ll l = 1, r = int(2e9) + 7, mid;
    while (l <= r) {
        mid = l + r >> 1;
        if (check(mid)) l = mid + 1;
        else r = mid - 1;
    }
    printf("%lld\n", ans);
    return 0;
}

```