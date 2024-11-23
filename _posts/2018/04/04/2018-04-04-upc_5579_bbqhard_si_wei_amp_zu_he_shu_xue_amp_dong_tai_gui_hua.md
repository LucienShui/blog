---
title: "UPC-5579 - BBQ Hard - 思维 &amp; 组合数学 &amp; 动态规划"
date: 2018-04-04 03:09:00 +0800
last_modified_at: 2018-05-23 18:16:33 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["动态规划", "思维", "组合数学"]
img_path: /assets/img/posts/2018/04/04/2018-04-04-upc_5579_bbqhard_si_wei_amp_zu_he_shu_xue_amp_dong_tai_gui_hua/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5579

---
### 题目：

#### 题目描述
Snuke is having another barbeque party.

This time, he will make one serving of Skewer Meal.

He has a stock of N Skewer Meal Packs. The i-th Skewer Meal Pack contains one skewer, Ai pieces of beef and Bi pieces of green pepper. All skewers in these packs are different and distinguishable, while all pieces of beef and all pieces of green pepper are, respectively, indistinguishable.

To make a Skewer Meal, he chooses two of his Skewer Meal Packs, and takes out all of the contents from the chosen packs, that is, two skewers and some pieces of beef or green pepper. (Remaining Skewer Meal Packs will not be used.) Then, all those pieces of food are threaded onto both skewers, one by one, in any order.

(See the image in the Sample section for better understanding.)

In how many different ways can he make a Skewer Meal? Two ways of making a Skewer Meal is different if and only if the sets of the used skewers are different, or the orders of the pieces of food are different. Since this number can be extremely large, find it modulo 109+7.

Constraints
2≦N≦200,000
1≦Ai≦2000,1≦Bi≦2000
#### 输入
The input is given from Standard Input in the following format:

N
A1 B1
A2 B2
:
AN BN

#### 输出
Print the number of the different ways Snuke can make a serving of Skewer Meal, modulo 109+7.
#### 样例输入
```
3
1 1
1 1
2 1
```
#### 样例输出
```
26
```
#### 提示
The 26 ways of making a Skewer Meal are shown below. Gray bars represent skewers, each with a number denoting the Skewer Meal Set that contained the skewer. Brown and green rectangles represent pieces of beef and green pepper, respectively.

![20180128180734_31937.png][1]

---
### 题意：

&emsp;&emsp;有n个背包，第i个背包里有一个编号为$i$的棍子、$a_i$个肉和$b_i$个菜。你可以任选两个不同的背包，把这两个背包里所有的肉和菜都用两根棍子串起来形成一个烤串，问能串出多少种烤串。

&emsp;&emsp;当且仅当至少有一根棍子的编号不同或者是肉和菜的数目不同或者是排列方式不同时，称这两种烤串是不同的。

---
### 思路：

&emsp;&emsp;不难得出，对于任意的背包$i$和一个背包$j$ $(i\neq j)$，他们俩对答案的贡献为$C_{a_i+b_i+a_j+b_j}^{a_i+a_j}$，因为形成一种烤串时，所有的菜和肉都要用完，所以总共有$a_i+b_i+a_j+b_j$个位置，从中挑出$a_i+a_j$个位置来放菜，剩下的就是肉的位置。

&emsp;&emsp;于是，容易推出，对于一组样例来说，最终答案就是$\sum_{i = 1}^n \sum_{j = i + 1}^n C_{a_i+b_i+a_j+b_j}^{a_i+a_j}$，但这样是$O(n^2)$的。

&emsp;&emsp;可以观察到，$1\leq a_i,b_i \leq 2000$，他们俩相乘最大的范围只有$4\times 10^6$，可以通过枚举$a$和$b$来求出所有需要的组合数，可是加和的过程依然是$O(n^2)$的。

&emsp;&emsp;假设平面上存在两个点$A(x, y)、B(p, q)$，A在B的左下方，那么当A以向右或向上走的方式到达B的方案数就等于$C_{p-x + q - y}^{p-x}$，于是对于本题的$C_{a_i+b_i+a_j+b_j}^{a_i+a_j}$来说，就等于平面上有两个点$A(-a_j, -b_j)、B(a_i, b_i)$，A点只向右或向上走到达B点的方案数。

&emsp;&emsp;于是，小小的容斥一下，做一个转化：

&emsp;&nbsp;$\sum_{i = 1}^n \sum_{j = i + 1}^n C_{a_i+b_i+a_j+b_j}^{a_i+a_j}$

$= [(\sum_{i = 1}^n \sum_{j = 1}^n C_{a_i+b_i+a_j+b_j}^{a_i+a_j}) - \sum_{i = 1}^n C_{(a_i+b_i)\times 2}^{a_i \times 2}] \div 2$

&emsp;&emsp;其中：$\sum_{i = 1}^n C_{(a_i+b_i)\times 2}^{a_i \times 2}$ 很好求，主要就是求减号左边的部分，可以通过转化为二维平面上点的问题动态规划出来。

&emsp;&emsp;记$dp[i][j]$为平面上$(i,j)$这个点的左方、左下方、下方所有存在的点向右或向上走到达这个点的方案数，转移方程为：
$$dp[i][j] = dp[i-1][j] + dp[i][j-1]$$

&emsp;&emsp;不难看出，$\sum_{j = 1}^n C_{a_i+b_i+a_j+b_j}^{a_i+a_j} = dp[a_i][b_i]$，于是就可以将$O(n^2)$的复杂度降至$O(n)$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
 
const int maxn = int(4e4) + 7, mod = int(1e9) + 7;
typedef long long ll;
ll fac[maxn], inv[maxn];
 
ll power_mod(ll p, ll q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return ret;
}
 
void init() {
    fac[0] = 1;
    for (int i = 1; i <= maxn - 10; ++i) fac[i] = fac[i - 1] * i % mod;
    inv[maxn - 10] = power_mod(fac[maxn - 10], mod - 2);
    for (int i = maxn - 11; i >= 0; --i) inv[i] = inv[i + 1] * (i + 1) % mod;
}
 
ll C(int x, int y) {
    return fac[x] * inv[y] % mod * inv[x - y] % mod;
}
 
int n, a[2000007], b[2000007], dp[4007][4007];
 
int main() {
//    freopen("in.txt", "r", stdin);
    init();
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) {
        scanf("%d%d", a + i, b + i);
        dp[2001 - a[i]][2001 - b[i]]++;
    }
    for (int i = 1; i <= 4001; i++)
        for (int j = 1; j <= 4001; j++) {
            dp[i][j] = (dp[i][j] + dp[i - 1][j]) % mod;
            dp[i][j] = (dp[i][j] + dp[i][j - 1]) % mod;
        }
    ll ans = 0;
    for (int i = 1; i <= n; i++) ans = (ans + dp[2001 + a[i]][2001 + b[i]]) % mod;
    for (int i = 1; i <= n; i++) ans = (ans - C(a[i] + a[i] + b[i] + b[i], a[i] + a[i]) + mod) % mod;
    printf("%lld\n", ans * power_mod(2, mod - 2) % mod);
    return 0;
}
```


  [1]: assets/img/posts/2018/04/04/2018-04-04-upc_5579_bbqhard_si_wei_amp_zu_he_shu_xue_amp_dong_tai_gui_hua/20180128180734_31937.png