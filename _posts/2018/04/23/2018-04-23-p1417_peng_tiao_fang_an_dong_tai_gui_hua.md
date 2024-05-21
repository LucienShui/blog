---
title: "P1417 - 烹调方案 - 动态规划"
date: 2018-04-23 23:23:00 +0800
last_modified_at: 2018-04-23 23:23:17 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1417

---
### 题目：

#### 题目背景

由于你的帮助，火星只遭受了最小的损失。但gw懒得重建家园了，就造了一艘飞船飞向遥远的earth星。不过飞船飞到一半，gw发现了一个很严重的问题：肚子饿了~

gw还是会做饭的，于是拿出了储藏的食物准备填饱肚子。gw希望能在T时间内做出最美味的食物，但是这些食物美味程度的计算方式比较奇葩，于是绝望的gw只好求助于你了。

#### 题目描述

一共有n件食材，每件食材有三个属性，ai，bi和ci，如果在t时刻完成第i样食材则得到ai-t*bi的美味指数，用第i件食材做饭要花去ci的时间。

众所周知，gw的厨艺不怎么样，所以他需要你设计烹调方案使得美味指数最大

#### 输入格式：
第一行是两个正整数T和n，表示到达地球所需时间和食材个数。

下面一行n个整数，ai

下面一行n个整数，bi

下面一行n个整数，ci

#### 输出格式：
输出最大美味指数

#### 输入样例#1：
```
74 1
502
2
47
```
#### 输出样例#1：
```
408
```

#### 说明


对于40%的数据1<=n<=10

对于100%的数据1<=n<=50

所有数字均小于100,000

---
### 思路：

&emsp;&emsp; 因为先选和后选对答案会产生影响，所以需要先分析一下：

&emsp;&emsp;假设第$i$个物品是的三个数据为$a_i、b_i、c_i$，第$j$个物品的三个数据为$a_j、b_j、c_j$，如果当前时间为$t$，先选$i$后选$j$的贡献$x$为：
$$\ \ \ a_i-(t+c_i)\times b_i+a_j-(t+c_i+c_j)\times b_j$$$$=a_i+a_j-t\times (b_i+b_j)-c_ib_i-c_jb_j-c_ib_j$$

&emsp;&emsp;如果当前时间为$t$，先选$j$后选$i$的贡献$y$为：
$$\ \ \ a_j-(t+c_j)\times b_j+a_i-(t+c_j+c_i)\times b_i$$$$=a_i+a_j-t\times (b_i+b_j)-c_ib_i-c_jb_j-c_jb_i$$

令：$val = a_i+a_j-t\times (b_i+b_j)-c_ib_i-c_jb_j$

&emsp;&emsp;则有：$$x = val -c_ib_j$$$$y = val-c_jb_i$$

不妨设：$x > y$，则有：$c_ib_j<c_jb_i$

&emsp;&emsp;也就是说，对于$i、j$两个物品，先选$c_ib_j$小的那个会更优，所以我们先按照这个规则进行一下排序，然后顺序进行0-1背包即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
ll T, n, dp[maxn], ans;
struct Node {
    ll a, b, c;
    bool operator < (const Node &tmp) const {
        return c * tmp.b < tmp.c * b;
    }
} node[maxn];
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%lld%lld", &T, &n);
    for (ll i = 0; i < n; i++) scanf("%lld", &node[i].a);
    for (ll i = 0; i < n; i++) scanf("%lld", &node[i].b);
    for (ll i = 0; i < n; i++) scanf("%lld", &node[i].c);
    std::sort(node, node + n);
    for (ll i = 0; i < n; i++)
        for (ll t = T; t >= node[i].c; t--)
            ans = std::max(dp[t] = std::max(dp[t], dp[t - node[i].c] + node[i].a - t * node[i].b), ans);
    printf("%lld\n", ans);
    return 0;
}
```