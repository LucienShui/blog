---
title: "Codeforces 1082B - Vova and Trophies "
date: 2018-12-01 01:29:05 +0800
last_modified_at: 2018-12-01 01:29:05 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "贪心", "codeforces"]
---

## Codeforces 1082B - Vova and Trophies 

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/B

------

### 题目

&emsp;&emsp;Vova has won $n$ trophies in different competitions. Each trophy is either golden or silver. The trophies are arranged in a row.
&emsp;&emsp;The beauty of the arrangement is the length of the longest subsegment consisting of golden trophies. Vova wants to swap two trophies (not necessarily adjacent ones) to make the arrangement as beautiful as possible — that means, to maximize the length of the longest such subsegment.
&emsp;&emsp;Help Vova! Tell him the maximum possible beauty of the arrangement if he is allowed to do at most one swap.

------

### 题意

&emsp;&emsp;给你一串`GS`串，你至多能够将任意两个字母做一次交换，问交换一次后最长的连续的字母`G`能有多长。

------

### 思路

&emsp;&emsp;先将`G`分段，然后各种特判一下就好。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
char s[maxn];
int n, tot, cnt[maxn], sum, max;
struct Node {
    int l, r, len;
    Node(int _l = 0, int _r = 0) {
        l = _l, r = _r, len = _r - _l + 1;
        max = std::max(len, max);
    }
} node[maxn];
int main() {
    scanf("%d%s", &n, s + 1);
    s[++n] = 'S';
    for (int i = 1; i <= n; i++) {
        if (s[i] == 'G') cnt[i] = cnt[i - 1] + 1, sum++;
        else {
            cnt[i] = 0;
            if (cnt[i - 1] > 0) {
                node[++tot] = Node(i - cnt[i - 1], i - 1);
            }
        }
    }
    if (tot == 0) puts("0");
    else if (tot == 1) printf("%d\n", node[1].len);
    else {
        int ans = max + 1;
        for (int i = 1; i < tot; i++) {
            if (node[i].r == node[i + 1].l - 2) {
                ans = std::max(ans, node[i].len + node[i + 1].len + (sum - node[i].len - node[i + 1].len > 0));
            }
        }
        printf("%d\n", ans);
    }
    return 0;
}
```