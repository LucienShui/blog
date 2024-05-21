---
title: "Codeforces-855B - Marvolo Gaunt's Ring - DP"
date: 2018-01-23 17:24:00 +0800
last_modified_at: 2018-01-31 16:52:03 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

### 题目：
Professor Dumbledore is helping Harry destroy the Horcruxes. He went to Gaunt Shack as he suspected a Horcrux to be present there. He saw Marvolo Gaunt's Ring and identified it as a Horcrux. Although he destroyed it, he is still affected by its curse. Professor Snape is helping Dumbledore remove the curse. For this, he wants to give Dumbledore exactly x drops of the potion he made.

Value of x is calculated as maximum of p·ai + q·aj + r·ak for given p, q, r and array a1, a2, ... an such that 1 ≤ i ≤ j ≤ k ≤ n. Help Snape find the value of x. Do note that the value of x may be negative.

#### Input
First line of input contains 4 integers n, p, q, r ( - 109 ≤ p, q, r ≤ 109, 1 ≤ n ≤ 105).

Next line of input contains n space separated integers a1, a2, ... an ( - 109 ≤ ai ≤ 109).

#### Output
Output a single integer the maximum value of p·ai + q·aj + r·ak that can be obtained provided 1 ≤ i ≤ j ≤ k ≤ n.

#### Examples
input
```
5 1 2 3
1 2 3 4 5
```
output
```
30
```
input
```
5 1 2 -3
-1 -2 -3 -4 -5
```
output
```
12
```
#### Note
In the first sample case, we can take i = j = k = 5, thus making the answer as 1·5 + 2·5 + 3·5 = 30.

In second sample case, selecting i = j = 1 and k = 5 gives the answer 12.

---
### 题意：

&emsp;&emsp;给出$p， q， r$，给出n个数v[i]，问$ \max(p∗ai+q∗aj+r∗ak)\ \ (i≤j≤k)$

---
### 思路：

&emsp;&emsp;枚举$a_j$，当$0≤p$，选取$max(ai),i∈[1,j]$, 否则选取$min(ai),i∈[1,j]$。 

&emsp;&emsp;q同理。对于取max和取min，维护前缀和后缀即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
## define ll long long
const ll maxn = int(1e5)+7, INF = 0x7f7f7f7f7f7f7f7f;
ll n, p, q, r;
ll premi[maxn], prema[maxn], sufmi[maxn], sufma[maxn], num[maxn];
int main() {
    scanf("%lld%lld%lld%lld", &n, &p, &q, &r);
    for(int i=1 ; i<=n ; i++) scanf("%lld", num+i);
    prema[0] = sufma[n+1] = -INF;
    premi[0] = sufmi[n+1] = INF;
    for(int i=n ; i>=1 ; i--) {
        sufma[i] = max(num[i], sufma[i+1]);
        sufmi[i] = min(num[i], sufmi[i+1]);
    }
    for(int i=1 ; i<=n ; i++) {
        prema[i] = max(num[i], prema[i-1]);
        premi[i] = min(num[i], premi[i-1]);
    }
    ll ans = -INF, tmp;
    for(int i=1 ; tmp = 0, i<=n ; i++) {
        tmp += p * (p < 0 ? premi[i] : prema[i]);
        tmp += r * (r < 0 ? sufmi[i] : sufma[i]);
        ans = max(ans, tmp + q * num[i]);
    }
    printf("%lld\n", ans);
    return 0;
}
```