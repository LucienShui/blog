---
title: "Codeforces-975D - Ghosts - 思维"
date: 2018-05-03 11:25:00 +0800
last_modified_at: 2020-02-10 23:47:47 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
img_path: /assets/img/posts/2018/05/03/2018-05-03-codeforces_975d_ghosts_si_wei/
---

### 题目链接

https://codeforces.com/contest/975/problem/D

---
### 题目

Ghosts live in harmony and peace, they travel the space without any purpose other than scare whoever stands in their way.
There are n ghosts in the universe, they move in the $OXY$ plane, each one of them has its own velocity that does not change in time: $\overrightarrow V = V_x \overrightarrow i + V_y \overrightarrow j$ where $V_x$ is its speed on the $x$-axis and $V_y$ is on the $y$-axis.
A ghost $i$ has experience value $EX_i$, which represent how many ghosts tried to scare him in his past. Two ghosts scare each other if they were in the same cartesian point at a moment of time.
As the ghosts move with constant speed, after some moment of time there will be no further scaring (what a relief!) and the experience of ghost kind $GX = \sum_{i=1}^{n} EX_i$ will never increase.
Tameem is a red giant, he took a picture of the cartesian plane at a certain moment of time T , and magically all the ghosts were aligned on a line of the form $y = a \cdot x + b$. You have to compute what will be the experience index of the ghost kind $GX$ in the indefinite future, this is your task for today.
Note that when Tameem took the picture, $GX$ may already be greater than $0$, because many ghosts may have scared one another at any moment between $[−\infty, T ]$.
#### Input
The first line contains three integers $n$, $a$ and $b (1 \leq n ≤ 200000, 1 \leq |a| \leq 10^9 ,0 \leq |b| \leq 10^9 )$ — the number of ghosts in the universe and the parameters of the straight line.
Each of the next n lines contains three integers $x_i, V_{xi}, V_{yi} (−10^9 \leq xi \leq 10^9 , −10^9 ≤ V_{xi} , V_{yi} ≤ 10^9 )$, where $x_i$ is the current $x$-coordinate of the $i$-th ghost (and $y_i = a ⋅ x_i + b$).
It is guaranteed that no two ghosts share the same initial position, in other words, it is guaranteed that for all $(i, j)\ x_i \neq \ x_j\ for\ i \neq j$.
#### Output
Output one line: experience index of the ghost kind GX in the indefinite future.
#### Examples
##### input
```
4 1 1
1 -1 -1
2 1 1
3 1 1
4 -1 -1
```
##### output
```
8
```
##### input
```
3 1 0
-1 1 0
0 0 -1
1 -1 -2
```
##### output
```
6
```
##### input
```
3 1 0
0 0 0
1 0 0
2 0 0
```
##### output
```
0
```
#### Note
There are four collisions $(1, 2, T − 0.5 ), (1, 3 , T − 1), (2, 4 , T + 1), (3 , 4 , T + 0.5 )$, where $(u, v, t)$ means a collision happened between ghosts $u$ and $v$ at moment $t$. At each collision, each ghost gained one experience point, this means that $GX = 4 ⋅ 2 = 8$.

In the second test, all points will collide when $t = T + 1$.

![9143da6576fc0dc25cd0151da083642b4917796a.png][1]

The red arrow represents the $1$-st ghost velocity, orange represents the $2$-nd ghost velocity, and blue represents the $3$-rd ghost velocity.

---
### 题意

&emsp;&emsp;在一个平面上，$0$时刻有`n`个点在一条方程为$y=a \cdot x + b$的直线上，保证这`n`个点不重合，告诉你`n`、`a`和`b`，然后给你`n`个点的`x`坐标和它们所具有的速度矢量`Vx`和`Vy`，代表这个点在$X$方向上的速度为`Vx`，$Y$方向上的速度为`Vy`，某两个点碰撞一次会产生2个单位的权值（碰撞时不会改变路径也不会改变速度），问你这些点一共会产生多少权值。

&emsp;&emsp;需要注意的是给的是$0$时刻的状态，但时间的范围是$(-\infty , \infty)$，所以说在$0$时刻以前的碰撞也会对答案产生贡献。

---
### 思路

&emsp;&emsp;既然题目要求的是碰撞产生的权值，那么我们就从分析碰撞开始下手。我们假定$0$时刻为初始状态，那么初始状态时所有点的横纵坐标$(x,y)$就可以很轻易的得到，又知道所有点的速度矢量，那么$t$时刻某个点的坐标就为：$(x + V_x \cdot t, y + V_y \cdot t)$。

&emsp;&emsp;假设点$i$和点$j$会在$t$时刻发生碰撞，此时，它们$t$时刻的横纵坐标就会分别相等，即：$$x_i + V_{x_i} \cdot t = x_j + V_{x_j} \cdot t$$$$y_i + V_{y_i} \cdot t = y_j + V_{y_j} \cdot t$$

&emsp;&emsp;移项得：$$x_i - x_j = V_{x_j} \cdot t  - V_{x_i} \cdot t$$$$y_i - y_j = V_{y_j} \cdot t - V_{y_i} \cdot t$$

&emsp;&emsp;因为是两个等式，所以可以将它们相比，用下面比上面得：$$\frac{y_i - y_j}{x_i - x_j} = \frac{V_{y_j} - V_{y_i}}{V_{x_j} - V_{x_i}}$$

&emsp;&emsp;因为$(x_i,y_i)$和$(x_j, y_j)$是点$i$和点$j$的初始坐标，根据题意这两个点在斜率为$a$的直线上，则有：$$\frac{y_i - y_j}{x_i - x_j} = a$$

&emsp;&emsp;代入得：$$a = \frac{V_{y_j} - V_{y_i}}{V_{x_j} - V_{x_i}}$$

&emsp;&emsp;移项得：$$a \cdot (V_{x_j} - V_{x_i}) = V_{y_j} - V_{y_i}$$$$a \cdot V_{x_j} - a \cdot V_{x_i} = V_{y_j} - V_{y_i}$$$$a \cdot V_{x_j} - V_{y_j} = a \cdot V_{x_i} - V_{y_i}$$

&emsp;&emsp;到这里，本题的做法就已经很显然了，对于某个点，其速度矢量为$(V_x,V_y)$，令这个点的特征值$\lambda = a \cdot V_x - V_y$，则对于所有特征值$\lambda$相等且速度矢量不平行的点，它们在$t\ (-\infty \leq t \leq \infty)$时刻一定会相交。

&emsp;&emsp;至于实现的思路，维护一个特征值集合，对于每个特征值，维护一个不同点的集合，然后算一算答案即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll a, b, x, y, ans, n;
std::map<ll, std::map<ll, ll>> cnt;
int main() {
    scanf("%lld%lld%lld", &n, &a, &b);
    for (int i = 0; i < n; i++) {
        scanf("%*d%lld%lld", &x, &y);
        cnt[a * x - y][x]++;
    }
    for (auto it : cnt) {
        auto map = it.second;
        ll sum = 0;
        for (auto i : map) sum += i.second;
        for (auto i : map) ans += i.second * (sum - i.second);
    }
    printf("%lld\n", ans);
    return 0;
}
```


  [1]: assets/img/posts/2018/05/03/2018-05-03-codeforces_975d_ghosts_si_wei/9143da6576fc0dc25cd0151da083642b4917796a.png