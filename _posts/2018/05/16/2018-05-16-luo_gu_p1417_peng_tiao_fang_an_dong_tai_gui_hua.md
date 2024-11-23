---
title: "洛谷P1417 - 烹调方案 - 动态规划"
date: 2018-05-16 15:47:00 +0800
last_modified_at: 2018-05-16 15:48:23 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://www.luogu.org/problemnew/show/P1417

---
### 题目

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

#### 输出格式
输出最大美味指数


---
### 思路

&emsp;&emsp;假设现在为$t$时刻，只剩下了最后的两个食材$i、j$，如果先选$i$后选$j$，贡献为：
$$a_i-t · b_i + a_j - (t + c_i) · b_j$$
&emsp;&emsp;如果先选$j$后选$i$，贡献为：
$$a_j-t · b_j + a_i - (t + c_j) · b_i$$

&emsp;&emsp;假设先选$i$更优，则有：
$$a_i-t · b_i + a_j - (t + c_i) · b_j > a_j-t · b_j + a_i - (t + c_j) · b_i$$

&emsp;&emsp;化简得：
$$c_i·b_j < c_j·b_i$$

&emsp;&emsp;根据上面得出的结论进行排序一下，按照这个顺序取就能保证一定是最优的，剩下的问题就是对于每道菜究竟是取还是不取，很裸的01背包。

---
### 实现

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