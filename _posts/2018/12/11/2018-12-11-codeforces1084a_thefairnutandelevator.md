---
title: "Codeforces 1084A - The Fair Nut and Elevator"
date: 2018-12-11 04:52:57 +0800
last_modified_at: 2018-12-11 04:52:57 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1084A - The Fair Nut and Elevator

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/A

---
### 题意

&emsp;&emsp;有一个电梯，它初始时会停留在第 $k$ 层楼，每当有一个人要从第 $a$ 楼去第 $b$ 楼，电梯就会始终按照 $k \rightarrow a \rightarrow b \rightarrow k$ 的路线去运行，而且电梯最多只会同时容纳一个人，现在有一个 $n$ 层楼的楼房，第 $i$ 层有 $a_i$ 个人，这一层的每个人每天都要按照 $i \rightarrow 1 \rightarrow i$ 的顺序使用电梯，问将电梯的 $k$ 设为多少时，每天的运行距离最少。

---
### 思路

&emsp;&emsp;注意到 $n$ 只有 $100$，暴力枚举，复杂度 $O(n ^ 2)$。

---
### 实现

https://pasteme.cn/2418

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll a[1007], n, ans = 0x3f3f3f3f;
int main() {
    scanf("%lld", &n);
    for (ll i = 1; i <= n; i++) scanf("%lld", a + i);
    for (ll i = 1; i <= n; i++) {
        ll sum = 0;
        for (ll j = 1; j <= n; j++) sum += a[j] * 2 * (abs(i - j) + abs(j - 1) + abs(1 - i));
        ans = std::min(ans, sum);
    }
    printf("%lld\n", ans);
    return 0;
}
```