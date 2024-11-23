---
title: "UPC-5793 - 飞扬的小鸟II - 单调栈"
date: 2018-02-27 21:48:00 +0800
last_modified_at: 2018-02-27 21:50:42 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["单调栈"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5793

---
### 题目：

#### 题目描述
有n棵大树从左到右排成一排，编号为1到n，每棵有高度hi与疲劳值wi。 有一只鸟儿现在站在最左侧的1号大树上，它想飞到第n棵树上去，但它不 能连续飞行太远，当它在第i棵树上时，只能飞到第i + 1, i + 2,..., i + k棵 树上，并获得对应大树的疲劳值；同时，假如它飞到的那棵树的高度不小 于当前这棵树的高度，那么它会获得额外的d疲劳值。求飞到第n棵树的最 小疲劳值是多少。
#### 输入
第一行三个整数n、k和d，由空格分割，表示树有多少棵，飞行的最大距离，以及额外的疲劳值。 接下来n行，第i行包含两个整数hi和wi，表示第i棵树的高度和疲劳值。
#### 输出
输出一行，表示最小疲劳值。
#### 样例输入
```
5 2 1
4 3
3 2
5 3
2 1
6 1
```
#### 样例输出
```
8
```
#### 提示
最优策略是1 → 2 → 4 → 5，总疲劳值是3 + 2 + 1 + 1，并在4 → 5时支付额外的1疲劳值。

对于20%的数据，n ≤ 1000；
对于另外40%的数据，d = 0；
对于100%的数据，1 ≤ k < n ≤ 3 ∗ 105, 0 ≤ hi ≤ 109, 0 ≤ wi ≤ 103, d ∈{0, 1}。

---
### 思路：

&emsp;&emsp;对于每棵树，飞到这棵树的最小花费只可能由前k棵树更新过来，又注意到$d$只可能是0或1，只要每次取前k棵树里权最小的前提下高度最高的那棵树就能够保证答案最优。所以对于第$i$棵树可以$O(1)$求解，也就是$dp[i] = min(dp[i-1], dp[i-2], ... , dp[i-k])$，需不需要加一判断一下即可。

&emsp;&emsp;比赛的时候比较脑残，没有想到单调栈，用单调栈的话可以$O(n)$，贴的代码相当于用线段树实现了单调栈的功能...复杂度是$O(nlgn)$。

---
### 实现：

```cpp
## include <bits/stdc++.h>
## define lson (u << 1)
## define rson (u << 1 | 1)
const int maxn = int(3e6) + 7, inf = 0x3f3f3f3f;
int dp[maxn], h[maxn], w[maxn], n, k, d, idx;
struct Node {
    int w, idx;
    bool operator < (const Node &tmp) const {
        return w == tmp.w ? h[idx] > h[tmp.idx] : w < tmp.w;
    }
} node[maxn << 2];
void build(int u = 1, int l = 1, int r = n) {
    if (l == r) {
        node[u] = {inf, l};
        return ;
    }
    int mid = (l + r) >> 1;
    build(lson, l, mid);
    build(rson, mid + 1, r);
    node[u] = std::min(node[lson], node[rson]);
}
Node query(int b, int e, int u = 1, int l = 1, int r = n) {
    if (b <= l && r <= e) return node[u];
    int mid = (l + r) >> 1;
    if (e <= mid) return query(b, e, lson, l, mid);
    if (b > mid) return query(b, e, rson, mid + 1, r);
    return std::min(query(b, e, lson, l, mid), query(b, e, rson, mid + 1, r));
}
void update(int aim, int val, int u = 1, int l = 1, int r = n) {
    if (l == r) {
        node[u].w = val;
        return ;
    }
    int mid = (l + r) >> 1;
    if (aim <= mid) update(aim, val, lson, l, mid);
    else update(aim, val, rson, mid + 1, r);
    node[u] = std::min(node[lson], node[rson]);
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d%d", &n, &k, &d);
    for (int i = 1; i <= n; i++) scanf("%d%d", h + i, w + i);
    memset(dp, 0x3f, sizeof(dp));
    build();
    update(1, dp[1] = w[1]);
    for (int i = 2; i <= n; i++) {
        idx = query(std::max(i - k, 1), i - 1).idx;
        dp[i] = dp[idx] + w[i] + (d & (h[i] >= h[idx]));
        update(i, dp[i]);
    }
    printf("%d\n", dp[n]);
    return 0;
}

```