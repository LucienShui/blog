---
title: "UPC3992 - 寻宝游戏 - 虚树"
date: 2018-02-21 16:11:00 +0800
last_modified_at: 2018-02-21 16:34:34 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["虚树"]
---

### 链接：

https://lucien.ink/go/upc3992/

---
### 题目：

#### 题目描述
 小B最近正在玩一个寻宝游戏，这个游戏的地图中有N个村庄和N-1条道路，并且任何两个村庄之间有且仅有一条路径可达。游戏开始时，玩家可以任意选择一个村庄，瞬间转移到这个村庄，然后可以任意在地图的道路上行走，若走到某个村庄中有宝物，则视为找到该村庄内的宝物，直到找到所有宝物并返回到最初转移到的村庄为止。小B希望评测一下这个游戏的难度，因此他需要知道玩家找到所有宝物需要行走的最短路程。但是这个游戏中宝物经常变化，有时某个村庄中会突然出现宝物，有时某个村庄内的宝物会突然消失，因此小B需要不断地更新数据，但是小B太懒了，不愿意自己计算，因此他向你求助。为了简化问题，我们认为最开始时所有村庄内均没有宝物
#### 输入
第一行，两个整数N、M，其中M为宝物的变动次数。
接下来的N-1行，每行三个整数x、y、z，表示村庄x、y之间有一条长度为z的道路。
接下来的M行，每行一个整数t，表示一个宝物变动的操作。若该操作前村庄t内没有宝物，则操作后村庄内有宝物；若该操作前村庄t内有宝物，则操作后村庄内没有宝物。
#### 输出
M行，每行一个整数，其中第i行的整数表示第i次操作之后玩家找到所有宝物需要行走的最短路程。若只有一个村庄内有宝物，或者所有村庄内都没有宝物，则输出0。
#### 样例输入
```
4 5
1 2 30
2 3 50
2 4 60
2
3
4
2
1
```
#### 样例输出
```
0
100
220
220
280
```
#### 提示
1<=N<=100000,1<=M<=100000,对于全部的数据，1<=z<=10^9

---
### 思路：

&emsp;&emsp;可以证明，从任意一个有宝物的节点出发时，最后所需要的权都是相等的。所以我们直接动态维护关键点的虚树，答案就是$dist(id[1],id[2])+dist(id[2],id[3])+···+dist(id[k-1],id[k])+dist(id[k],id[1])$，`k`为当前有宝藏的村庄数，`id`数组存放着按dfs序排序过后的有宝藏的村庄，那么每一次加一个点只要在原基础上删掉它按dfs序的前一个点和后一个点的距离、加上自己与那两个点的距离就好了（注意边界情况，即dfs序是最小的或者是最大的），删除同理。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, inf = 0x3f3f3f3f;
typedef long long ll;
std::set<int> st;
int n, m, cnt_edge, Top, fa[maxn][17], id[maxn], dfn[maxn], deep[maxn], head_edge[maxn];
ll dist[maxn], ans, delta;
bool mark[maxn];
inline void read(int &x, int ch = 0) {
    x = 0;
    do ch = getchar(); while (!isdigit(ch));
    while (isdigit(ch)) x = x * 10 + (ch ^ '0'), ch = getchar();
}
struct {
    int next, to, val;
} edge[maxn << 1];
inline void insert(int u, int v, int w) {
    edge[cnt_edge] = {head_edge[u], v, w};
    head_edge[u] = cnt_edge++;
}
inline void dfs(int u, int pre, int v = 0) {
    dfn[u] = ++Top, id[dfn[u]] = u, fa[u][0] = pre;
    for (int i = 1; (1 << i) <= deep[u]; i++) fa[u][i] = fa[fa[u][i - 1]][i - 1];
    for (int i = head_edge[u]; ~i; i = edge[i].next) {
        v = edge[i].to;
        if (v != pre) deep[v] = deep[u] + 1, dist[v] = dist[u] + edge[i].val, dfs(v, u);
    }
}
inline int lca(int x, int y) {
    if (deep[x] < deep[y]) std::swap(x, y);
    int t = deep[x] - deep[y];
    for (int i = 0; i <= 16; i++) if ((1 << i) & t) x = fa[x][i];
    for (int i = 16; i >= 0; i--) if (fa[x][i] != fa[y][i]) x = fa[x][i], y = fa[y][i];
    return x == y ? x : fa[x][0];
}
inline ll dis(int x, int y) { return dist[x] + dist[y] - 2 * dist[lca(x, y)]; }
int main() {
//    freopen("in.txt", "r", stdin);
    memset(head_edge, -1 ,sizeof(head_edge));
    read(n), read(m);
    int u, v, w;
    for (int i = 1; i < n; i++) read(u), read(v), read(w), insert(u, v, w), insert(v, u, w);
    dfs(1, 0);
    st.insert(inf), st.insert(-inf);
    for (int i = 1, flag = 1; i <= m; i++) {
        read(u), delta = 0, flag = 1;
        if (mark[u]) st.erase(dfn[u]), flag = -1;
        else st.insert(dfn[u]);
        mark[u] ^= 1;
        int l = *--st.lower_bound(dfn[u]), r = *st.upper_bound(dfn[u]);
        if (r < inf) ans += flag * dis(id[r], u);
        if (l > -inf) ans += flag * dis(id[l], u);
        if (r < inf && l > -inf) ans -= flag * dis(id[l], id[r]);
        if (st.size() > 2) l = *++st.begin(), r = *----st.end(), delta = dis(id[l], id[r]);
        printf("%lld\n", ans + delta);
    }
}
```