---
title: "Codeforces-985C - Liebig's Barrels - 贪心"
date: 2018-05-22 08:53:00 +0800
last_modified_at: 2018-05-22 08:54:09 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["贪心"]
---

### 题目链接

https://codeforces.com/contest/985/problem/C

---
### 题目


You have m = n·k wooden staves. The i-th stave has length ai. You have to assemble n barrels consisting of k staves each, you can use any k staves to construct a barrel. Each stave must belong to exactly one barrel.

Let volume vj of barrel j be equal to the length of the minimal stave in it.

You want to assemble exactly n barrels with the maximal total sum of volumes. But you have to make them equal enough, so a difference between volumes of any pair of the resulting barrels must not exceed l, i.e. |vx - vy| ≤ l for any 1 ≤ x ≤ n and 1 ≤ y ≤ n.

Print maximal total sum of volumes of equal enough barrels or 0 if it's impossible to satisfy the condition above.

#### Input
The first line contains three space-separated integers n, k and l $(1 ≤ n, k ≤ 10^5, 1 ≤ n·k ≤ 10^5, 0 ≤ l ≤ 10^9)$.

The second line contains m = n·k space-separated integers $a_1, a_2, ..., a_m$ $(1 ≤ ai ≤ 10^9)$ — lengths of staves.

#### Output
Print single integer — maximal total sum of the volumes of barrels or 0 if it's impossible to construct exactly n barrels satisfying the condition $|v_x - v_y| ≤ l$ for any 1 ≤ x ≤ n and 1 ≤ y ≤ n.

---
### 题意

&emsp;&emsp;需要造`n`个桶，每个桶需要`k`个木板，任意两个桶之间容积（一个桶中最短的木板的高度）的差距不能超过`l`，然后给你`n * k`个木板，第$i$个木板的长度为$a_i$，问能否造出符合条件的`n`个桶，如果能的话问这`n`个桶的容积之和最大是多少，如果不能的话就输出`0`。

---
### 思路

&emsp;&emsp;首先对所有木板`sort`一下，由于短板效应，我们至少可以让前`n`个木板恰好为`n`个桶的容积，判断一下$a_n-a_1\leq l$是否成立，不成立的话一定是$0$，因为前`n`个的木板的差距一定是最小的。

&emsp;&emsp;我们发现，如果我们让每连续的`k`个木板形成一个桶的话，那么这些桶的容积将会是$a_1、a_{k+1}、a_{2k+1}、\dots$，中间一些较小的木板都会被更短但是又必须得取的木板给包含，这样一定是最优的。

&emsp;&emsp;首先我们找到一个最大的`upper`，使得$a_{upper} - a_1 \leq l\ \ (upper \leq n · k)$成立，这样在$[1,upper]$的范围内以任意`n`个木板的高度为桶的容积都是合法的。假设此时我们选了$x$个连续的`k`来造桶，还需要再造$y$个桶才能造够`n`个桶，则有：$$x·k+y\leq upper$$$$x + y = n$$

&emsp;&emsp;移项、代入、化简：$$x\leq \frac{upper - n}{k - 1}$$

&emsp;&emsp;也就是说：得到$x$后，$y$也就相应出来了，对于剩下的$upper - x·k$个木板，显然取后$y - 1$个和第$x·k+1$个木板作为剩下的$y$个桶的容积是最优的。


---
### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
ll n, k, l, m, a[maxn], ans, upper;
int main() {
    scanf("%lld%lld%lld", &n, &k, &l);
    m = n * k;
    for (ll i = 1; i <= m; i++) scanf("%lld", a + i);
    std::sort(a + 1, a + 1 + m);
    if (a[n] - a[1] > l) return 0 * puts("0");
    if (k == 1) for (ll i = 1; i <= n; i++) ans += a[i];
    else {
        while (a[upper] - a[1] <= l && upper <= m) upper++;
        upper--;
        ll x = (upper - n) / (k - 1);
        for (ll i = 1, cur = 1; i <= x; i++, cur += k) ans += a[cur];
        for (ll i = 1; i < n - x; i++) ans += a[upper--];
        ans += a[x * k + 1];
    }
    printf("%lld\n", ans);
    return 0;
}

```