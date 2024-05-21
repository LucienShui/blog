---
title: "UPC-5155 - Security Badges - 思维"
date: 2018-04-30 21:57:00 +0800
last_modified_at: 2018-05-01 01:25:55 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5155

---
### 题目：

#### 题目描述
You are in charge of the security for a large building. The building has a map, consisting of rooms, and doors between the rooms. Each door has a security code, which consists of a range of numbers, specified by a lower bound and an upper bound. Each employee has a uniquely numbered security badge. Only a security badge with a number within a door’s range can go through that door. 
Your boss wants a quick check of the security of the building. Given a starting room and a  destination  room,  how  many  security  badge  numbers  can  go  from  the  start  to  the destination?  
#### 输入
Each input will consist of a single test case. Note that your program may be run multiple times on different inputs. Each test case will begin with a line containing three integers integer n (1 ≤ n ≤ 1,000), m (1 ≤ m ≤ 5,000) and k (1 ≤ k ≤ 109 ), where n is the number of rooms,  m  is  the  number  of  doors,  and  k  is  the  number  of  badges.  The  rooms  are numbered 1..n and the badges are numbered 1..k. 
The next line will contain two integers, s and d (1 ≤ s,d ≤ n), which indicate the starting room and destination room. 
Each of the next m lines will contain four integers, a, b (1 ≤ a,b ≤ n, a≠b), min and max (1 ≤ min ≤ max ≤ k) describing a door, where the door from room a to room b (and not back), and the badges range for the door is min..max, inclusive.  
#### 输出
Output a single integer, which is the number of badges that can go from the start room to the destination room. 
#### 样例输入
```
4 5 10
3 2
1 2 4 7
3 1 1 6
3 4 7 10
2 4 3 5
4 2 8 9
```
#### 样例输出
```
5
```

---
### 题意：

&emsp;&emsp;有`n`个点，`m`条边，还有一个总上界`k`，你需要从`s`点走到`t`点，对于每条边`u v l r`，你手中持有的权值需要在`[l, r]`的范围内才能从`u`走到`v`，问有多少种不同的权值可以成功地从`s`点走到`t`。

---
### 思路：

&emsp;&emsp;刚开始想的是让手里的权值也变为一个范围`[0, k]`，这样从`s`点走到`t`点之后剩下的范围就是最终的范围，可是这样无法解决环路的问题，考虑其它做法。对于所有给出上下界，最终的权值所在的范围的端点一定在这些数值里，所以我们把所有的上下界都存在一个边界数组里，排序去重，这样就得到了一个升序数组，数组中的每两个相邻的元素都是可能从起点走到终点的最小范围。

&emsp;&emsp;考虑两个相邻的边界$a_i$，$a_{i + 1}$，按照我当时的思路，`check()`一下$[a_i, a_{i + 1}]$是不是一个可行解，考虑：

```
3 2 6
1 2 1 4
2 3 3 5
```

&emsp;&emsp;边界数组为：$\{1, 3, 4, 5\}$，所有的最小可能可行区间为：$[1,3]、[3,4]、[4,5]$，分别对其`check()`之后发现$[3,4]$可以通过，即答案是这个区间的长度：2。

&emsp;&emsp;再考虑这个样例：

```
3 2 6
1 2 1 4
2 3 4 5
```

&emsp;&emsp;边界数组为：$\{1,4,5\}$所有的最小可能可行区间为：$[1,4]、[4,5]$，分别对其`check()`之后发现都不可以通过，但是发现这个样例应该答案为1，即：4是一个可行解。

&emsp;&emsp;可以发现，某个区间无法通过的时候，其端点仍有可能可以独立通过，于是考虑将区间拆开：

&emsp;&emsp;将所有的闭区间拆为左端点，右端点，中间的开区间三部分，即：$[a,b]$拆为$[a,a]、(a,b)、[b,b]$，这样就比较完善了。

&emsp;&emsp;考虑优化，在我们`check()`一个点的时候，常规做法是将其置为一个左右区间相等的闭区间，事实上直接`check()`单点的时候效率更高，那么开区间能不能也转化为单点呢？对于本题来说是可以的。

&emsp;&emsp;考虑对于一个区间$(a, b)$，发现只要我们只要`check()`这个区间内的任意一个点，就能知道这个区间是否可行，下面给出证明：

&emsp;&emsp;设有一区间$(a,b)$不能通过`check()`，但是其中某个独立的点$x$可以通过`check()`，那么就一定存在一个点`x`存在于上文提到的边界数组中，且$a \leq x \leq b$，但$a、b$两个点在边界数组中一定是两个相邻的点，矛盾。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = 1007, maxm = 5007;
struct Edge {
    int next, to, l, r;
} edge[maxm];
int head_edge[maxn], cnt_edge, n, m, k, S, T, ans, point[maxm << 2], tot;
bool vis[maxn], flag;
void addedge(int u, int v, int l, int r) {
    edge[cnt_edge] = {head_edge[u], v, l, r};
    head_edge[u] = cnt_edge++;
}
bool dfs(int u, int x) {
    if (u == T) return (flag = true);
    for (int i = head_edge[u], v; ~i; i = edge[i].next) {
        v = edge[i].to;
        if (vis[v] || x < edge[i].l || x > edge[i].r) continue;
        vis[v] = true;
        if (dfs(v, x), flag) return true;
    }
}
bool check(int x) {
    memset(vis, 0, sizeof(vis));
    flag = false;
    return dfs(S, x), flag;
}
 
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d%d%d%d", &n, &m, &k, &S, &T);
    memset(head_edge, 0xff, sizeof(head_edge));
    point[tot++] = 1, point[tot++] = k + 17;
    for (int i = 0, u, v, l, r; i < m; i++) {
        scanf("%d%d%d%d", &u, &v, &l, &r);
        point[tot++] = l, point[tot++] = r;
        addedge(u, v, l, r);
    }
    std::sort(point, point + tot);
    tot = int(std::unique(point, point + tot) - point);
    for (int i = 0; i < tot; i++) {
        if (check(point[i])) ans++;
        if (i + 1 < tot && point[i] + 1 < point[i + 1] && check(point[i] + 1))
            ans += point[i + 1] - point[i] - 1;
    }
    printf("%d\n", ans);
    return 0;
}
```