---
title: "Codeforces 1088B - Ehab and subtraction - 模拟"
date: 2018-12-05 03:40:59 +0800
last_modified_at: 2018-12-05 03:40:59 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "模拟", "codeforces"]
---


## Codeforces 1088B - Ehab and subtraction 

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/B

---
### 题目

You're given an array $a$. You should repeat the following operation $k$ times: find the minimum non-zero element in the array, print it, and then subtract it from all the non-zero elements of the array. If all the elements are 0s, just print 0.

---
### 题意

&emsp;&emsp;你有一个数组$a[n]$，你每次需要找出一个非$0$最小值$min\{a[n]\}$，然后输出这个最小值，并将这个数组中的每一个非$0$元素的值都减去这个最小值。如果这个最小值不存在则输出$0$。

---
### 思路

&emsp;&emsp;根据题意模拟即可。

---
### 实现

https://pasteme.cn/2208

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll base = 0;
std::priority_queue<ll, std::vector<ll>, std::greater<ll>> que;
int main() {
    ll n, k;
    std::cin >> n >> k;
    for (int i = 1, buf; i <= n; i++) std::cin >> buf, que.push(buf);
    while (k--) {
        while (!que.empty() && que.top() == base) que.pop();
        if (que.empty()) puts("0");
        else {
            printf("%lld\n", que.top() - base);
            base += que.top() - base;
            que.pop();
        }
    }
    return 0;
}
```