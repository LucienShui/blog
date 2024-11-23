---
title: "Codeforces - 1155C - Alarm Clocks Everywhere"
date: 2019-04-23 15:48:09 +0800
last_modified_at: 2019-04-23 15:48:09 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## 地址

https://codeforces.com/contest/1155/problem/C

## 原文地址

https://www.lucien.ink/archives/419/

## 题意

你有 $n$ 个事件，第 $i$ 个事件需要在第 $x_i$ 时刻去做，你是一个机器人，你只能选定任意一个起始时间 $y$ ，然后从给定的 $m$ 个数字中选出一个 $p_i$ ，然后你从第 $y$ 时刻起，每隔 $p_i$ 个时刻有做事的权利（包括第 $y$ 个时刻），问能否做完掉所有的事，能的话输出 `y i`。

## 题解

起始时间肯定是第一个时间发生的时刻，然后对所有事件的间隔求一下 $gcd$ ，判断一下是否存在一个 $p_i$ 满足 $gcd \mod\ p_i = 0$ 即可。

### 代码

https://pasteme.cn/6689

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(3e5) + 7;
ll gcd(ll p, ll q) { return q ? gcd(q, p % q) : p; }
int n, m;
ll x[maxn], p[maxn];
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) scanf("%lld", x + i);
    for (int i = 1; i <= m; i++) scanf("%lld", p + i);
    ll d = 0;
    for (int i = 2; i <= n; i++) d = gcd(d, x[i] - x[i - 1]);
    for (int i = 1; i <= m; i++) {
        if (d % p[i] == 0) {
            return 0 * printf("YES\n%lld %d\n", x[1], i);
        }
    }
    return 0 * puts("NO");
}
```
