---
title: "Codeforces 1084B - Kvass and the Fair Nut - 二分"
date: 2018-12-11 04:54:04 +0800
last_modified_at: 2018-12-11 04:54:04 +0800
math: true
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "题解", "codeforces"]
---

## Codeforces 1084B - Kvass and the Fair Nut - 二分

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/B

---
### 题意

&emsp;&emsp;你有 $n$ 桶水，第 $i$ 桶水里初始时有 $v_i$ 升水，你需要从这 $n$ 桶水中取出 $s$ 升水，问是否能取 $s$ 升水出来，如果可以的话让 $n$ 桶水剩下水最少的那桶水尽量的多。

---
### 思路

&emsp;&emsp;直接暴力二分即可，复杂度 $O(n \cdot log_2(v_{max}))$。

---
### 实现

https://pasteme.cn/2419

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = 1007;
ll v[maxn], n, s, max, sum;
bool check(ll mid) {
    ll ret = 0;
    for (int i = 1; i <= n; i++) {
        if (v[i] < mid) return false;
        ret += v[i] - mid;
    }
    return ret >= s;
}
int main() {
    std::cin >> n >> s;
    for (int i = 1; i <= n; i++) std::cin >> v[i], sum += v[i], max = std::max(v[i], max);
    if (sum < s) return 0 * puts("-1");
    ll l = 0, r = max, ret = -1;
    while (l <= r) {
        ll mid = l + r >> 1;
        if (check(mid)) ret = mid, l = mid + 1;
        else r = mid - 1;
    }
    std::cout << ret << std::endl;
    return 0;
}
```