---
title: "BZOJ-1854 - 游戏 - 二分图"
date: 2018-01-31 23:19:00 +0800
last_modified_at: 2018-05-23 18:19:39 +0800
math: false
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["题解", "二分图"]
---

### 链接：

https://www.lucien.ink/go/bzoj1854/

---
### 题目：

#### Description

lxhgww最近迷上了一款游戏，在游戏里，他拥有很多的装备，每种装备都有2个属性，这些属性的值用[1,10000]之间的数表示。当他使用某种装备时，他只能使用该装备的某一个属性。并且每种装备最多只能使用一次。 游戏进行到最后，lxhgww遇到了终极boss，这个终极boss很奇怪，攻击他的装备所使用的属性值必须从1开始连续递增地攻击，才能对boss产生伤害。也就是说一开始的时候，lxhgww只能使用某个属性值为1的装备攻击boss，然后只能使用某个属性值为2的装备攻击boss，然后只能使用某个属性值为3的装备攻击boss……以此类推。 现在lxhgww想知道他最多能连续攻击boss多少次？
#### Input

输入的第一行是一个整数N，表示lxhgww拥有N种装备 接下来N行，是对这N种装备的描述，每行2个数字，表示第i种装备的2个属性值
#### Output

输出一行，包括1个数字，表示lxhgww最多能连续攻击的次数。
#### Sample Input
```
3
1 2
3 2
4 5
```
#### Sample Output
```
2
```
#### HINT

【数据范围】
对于30%的数据，保证N<=1000
对于100%的数据，保证N<=1000000

---
### 思路：

&emsp;&emsp;对于每个装备，拥有两个属性a和b，那么这个装备要么在位置a被使用，要么在位置b被使用。显而易见可以用二分图来解决，连续的最大匹配数就是答案。

&emsp;&emsp;然后，我们会发现朴素写会TLE，我在这里采用的优化就是用单向边去跑以及用时间戳去替代每一轮的memset。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxm = int(5e6) + 7, maxn = int(1e6) + 7;
struct { int next, to; } edge[maxm];
int head_edge[maxn << 1], cnt_edge, cur, n, vis[maxn << 1], link[maxn << 1];
void addedge(int u, int v) {
    edge[cnt_edge] = {head_edge[u], v};
    head_edge[u] = cnt_edge++;
}
bool dfs(int u) {
    for (register int i = head_edge[u], v; ~i; i = edge[i].next)
        if (vis[v = edge[i].to] != cur) {
            vis[v] = cur;
            if (!link[v] || dfs(link[v])) {
                link[v] = u;
                return true;
            }
        }
    return false;
}
int solve() {
    int ans = 0;
    for (int i = cur = 1; i <= 10001; i++, cur++) {
        if (dfs(i)) ans++;
        else return ans;
    }
}
int main() {
    memset(head_edge, 0xff, sizeof(head_edge));
    scanf("%d", &n);
    for (int i = 0, x, y; i < n; i++) {
        scanf("%d%d", &x, &y);
        addedge(x, i + 10001);
        addedge(y, i + 10001);
    }
    printf("%d\n", solve());
    return 0;
}
```