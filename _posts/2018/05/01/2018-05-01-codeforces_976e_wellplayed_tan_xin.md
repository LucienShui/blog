---
title: "Codeforces-976E - Well played! - 贪心"
date: 2018-05-01 01:21:00 +0800
last_modified_at: 2018-05-01 01:22:28 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/976/problem/E

---
### 题目：

Recently Max has got himself into popular CCG "BrainStone". As "BrainStone" is a pretty intellectual game, Max has to solve numerous hard problems during the gameplay. Here is one of them:

Max owns n creatures, i-th of them can be described with two numbers — its health hpi and its damage dmgi. Max also has two types of spells in stock:

Doubles health of the creature $(hp_i = hp_i\times2)$;
Assigns value of health of the creature to its damage $(dmg_i = hp_i)$.
Spell of first type can be used no more than a times in total, of the second type — no more than b times in total. Spell can be used on a certain creature multiple times. Spells can be used in arbitrary order. It isn't necessary to use all the spells.

Max is really busy preparing for his final exams, so he asks you to determine what is the maximal total damage of all creatures he can achieve if he uses spells in most optimal way.

#### Input
The first line contains three integers $n, a, b (1 ≤ n ≤ 2·10^5, 0 ≤ a ≤ 20, 0 ≤ b ≤ 2·10^5)$ — the number of creatures, spells of the first type and spells of the second type, respectively.

The i-th of the next n lines contain two number $hp_i$ and $dmg_i (1 ≤ hp_i, dmg_i ≤ 10^9)$ — description of the i-th creature.

#### Output
Print single integer — maximum total damage creatures can deal.

#### Examples
##### input
```
2 1 1
10 15
6 1
```
##### output
```
27
```
##### input
```
3 0 3
10 8
7 11
5 2
```
##### output
```
26
```

#### Note
In the first example Max should use the spell of the first type on the second creature, then the spell of the second type on the same creature. Then total damage will be equal to $15 + 6·2 = 27$.

In the second example Max should use the spell of the second type on the first creature, then the spell of the second type on the third creature. Total damage will be equal to $10 + 11 + 5 = 26$.

---
### 题意：

&emsp;&emsp;有`n`个物品，能进行一类操作`a`次和二类操作`b`次，每个物品有一个权`x`和权`y`，一类操作为把某个物品的`x`变为原来的两倍，二类操作为令某个物品的`y = x`，问这`n`个物品的`y`的总和最大是多少。

---
### 思路：

&emsp;&emsp;不难证明，如果要对某个物品进行加倍的话，那么剩余的加倍次数也都要分给这个物品，所以我们可以枚举对哪个物品进行加倍，统计答案即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
struct Node {
    long long x, y;
    bool operator < (const Node &tmp) const {
        return x - y > tmp.x - tmp.y;
    }
} node[maxn];
int main() {
//    freopen("in.txt", "r", stdin);
    long long sum = 0;
    int a, b, n;
    scanf("%d%d%d", &n, &a, &b);
    for (int i = 1; i <= n; i++) scanf("%lld%lld", &node[i].x, &node[i].y);
    std::sort(node + 1, node + 1 + n);
    for (int i = 1; i <= b; i++) sum += std::max(node[i].x, node[i].y);
    for (int i = b + 1; i <= n; i++) sum += node[i].y;
    long long ans = sum;
    for (int i = 1; i <= b; i++) ans = std::max(ans, sum - std::max(node[i].x, node[i].y) + (node[i].x << a));
    sum = sum - std::max(node[b].x, node[b].y) + node[b].y;
    for (int i = b + 1; i <= n && b; i++) ans = std::max(ans, sum - node[i].y + (node[i].x << a));
    printf("%lld\n", ans);
    return 0;
}
```