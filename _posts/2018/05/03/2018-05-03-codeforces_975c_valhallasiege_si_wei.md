---
title: "Codeforces-975C - Valhalla Siege - 思维"
date: 2018-05-03 09:34:00 +0800
last_modified_at: 2018-05-03 09:35:03 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/975/problem/C

---
### 题目：

Ivar the Boneless is a great leader. He is trying to capture Kattegat from Lagertha. The war has begun and wave after wave Ivar's warriors are falling in battle.

Ivar has $n$ warriors, he places them on a straight line in front of the main gate, in a way that the $i$-th warrior stands right after $(i-1)$-th warrior. The first warrior leads the attack.

Each attacker can take up to $a_i$ arrows before he falls to the ground, where $a_i$ is the $i$-th warrior's strength.

Lagertha orders her warriors to shoot $k_i$ arrows during the $i$-th minute, the arrows one by one hit the first still standing warrior. After all Ivar's warriors fall and all the currently flying arrows fly by, Thor smashes his hammer and all Ivar's warriors get their previous strengths back and stand up to fight again. In other words, if all warriors die in minute $t$, they will all be standing to fight at the end of minute $t$.

The battle will last for $q$ minutes, after each minute you should tell Ivar what is the number of his standing warriors.

#### Input
The first line contains two integers $n$ and $q(1\leq n, q\leq 200\ 000)$ — the number of warriors and the number of minutes in the battle.

The second line contains $n$ integers $a_1,a_2,\dots ,a_n(1 \leq a_i \leq 10^9)$ that represent the warriors' strengths.

The third line contains $q$ integers $k_1,k_2,\dots k_q(1 \leq k_i \leq 10^{14})$, the $i$-th of them represents Lagertha's order at the $i$-th minute: $k_i$ arrows will attack the warriors.

#### Output
Output $q$ lines, the $i$-th of them is the number of standing warriors after the $i$-th minute.

#### Examples
##### input
```
5 5
1 2 1 2 1
3 10 1 1 1
```
##### output
```
3
5
4
4
3
```
##### input
```
4 4
1 2 3 4
9 1 10 6
```
##### output
```
1
4
4
1
```
#### Note
In the first example:

after the 1-st minute, the 1-st and 2-nd warriors die.
after the 2-nd minute all warriors die (and all arrows left over are wasted), then they will be revived thus answer is 5 — all warriors are alive.
after the 3-rd minute, the 1-st warrior dies.
after the 4-th minute, the 2-nd warrior takes a hit and his strength decreases by 1.
after the 5-th minute, the 2-nd warrior dies.

---
### 题意：

&emsp;&emsp;你有`n`个士兵，每个士兵的生命值为$a_i$，有`q`轮攻击，每轮攻击的伤害值为$k_i$，如果在某一轮中士兵全部死光了，那么在这一轮结束的时候就会全部复活，且这一轮攻击剩下的伤害就会被忽略，问你每轮攻击结束后你会有多少个士兵。

---
### 思路：

&emsp;&emsp;对`n`个士兵的生命值记一下前缀和，每轮攻击的时候用`upper_bound`找一下前缀和里第一个大于$k_i$的值所对应的编号，假设这一轮中`upper_bound`的结果为`cur`，那么前`cur - 1`个士兵一定全部死完了，所以就会剩下`n - cur + 1`个士兵。

---
### 实现：

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(2e5) + 7;
ll a[maxn], k[maxn], sum[maxn], dmg;

int main() {
//    freopen("in.txt", "r", stdin);
    int n, q;
    scanf("%d%d", &n, &q);
    for (int i = 1; i <= n; i++) scanf("%lld", a + i), sum[i] = sum[i - 1] + a[i];
    for (int i = 1; i <= q; i++) scanf("%lld", k + i);
    for (int turn = 1, cur; turn <= q; turn++) {
        dmg += k[turn];
        if (dmg >= sum[n]) dmg = 0, printf("%d\n", n);
        else printf("%d\n", n - int(std::upper_bound(sum + 1, sum + 1 + n, dmg) - sum - 1));
    }
    return 0;
}
```