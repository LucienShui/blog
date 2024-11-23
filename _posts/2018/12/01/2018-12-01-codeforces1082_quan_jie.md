---
title: "Codeforces 1082 - 全解"
date: 2018-12-01 01:45:00 +0800
last_modified_at: 2018-12-01 01:48:23 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1082A - Vasya and Book

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/A

------

### 题目

&emsp;&emsp;Vasya is reading a e-book. The file of the book consists of $n$ pages, numbered from $1$ to $n$. The screen is currently displaying the contents of page $x$, and Vasya wants to read the page $y$. There are two buttons on the book which allow Vasya to scroll $d$ pages forwards or backwards (but he cannot scroll outside the book). For example, if the book consists of $10$ pages, and $d = 3$, then from the first page Vasya can scroll to the first or to the fourth page by pressing one of the buttons; from the second page — to the first or to the fifth; from the sixth page — to the third or to the ninth; from the eighth — to the fifth or to the tenth.

&emsp;&emsp;Help Vasya to calculate the minimum number of times he needs to press a button to move to page $y$.

------

### 题意

&emsp;&emsp;这个人有一本$n$页的书，他每次翻书可以从第$i$页翻到第$max(i - d, 1)$或$min(i + d, n)$页，问他能否从第$x$页翻到第$y$页。

------

### 思路

&emsp;&emsp;按照题意瞎搞一下。

------

### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll n, x, y, d, t;
int main() {
    std::cin >> t;
    while (t--) {
        std::cin >> n >> x >> y >> d;
        if (abs(y - x) % d == 0) printf("%lld\n", abs(y - x) / d);
        else {
            ll ans = ll(1e18);
            if ((y - 1) % d == 0) ans = std::min(ans, (y - 1) / d + (x - 1 + d - 1) / d);
            if ((n - y) % d == 0) ans = std::min(ans, (n - y) / d + (n - x + d - 1) / d);
            if (ans == ll(1e18)) puts("-1");
            else printf("%lld\n", ans);
        }
    }
    return 0;
}
```

## Codeforces 1082B - Vova and Trophies 

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/B

------

### 题目

&emsp;&emsp;Vova has won $n$ trophies in different competitions. Each trophy is either golden or silver. The trophies are arranged in a row.
&emsp;&emsp;The beauty of the arrangement is the length of the longest subsegment consisting of golden trophies. Vova wants to swap two trophies (not necessarily adjacent ones) to make the arrangement as beautiful as possible — that means, to maximize the length of the longest such subsegment.
&emsp;&emsp;Help Vova! Tell him the maximum possible beauty of the arrangement if he is allowed to do at most one swap.

------

### 题意

&emsp;&emsp;给你一串`GS`串，你至多能够将任意两个字母做一次交换，问交换一次后最长的连续的字母`G`能有多长。

------

### 思路

&emsp;&emsp;先将`G`分段，然后各种特判一下就好。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
char s[maxn];
int n, tot, cnt[maxn], sum, max;
struct Node {
    int l, r, len;
    Node(int _l = 0, int _r = 0) {
        l = _l, r = _r, len = _r - _l + 1;
        max = std::max(len, max);
    }
} node[maxn];
int main() {
    scanf("%d%s", &n, s + 1);
    s[++n] = 'S';
    for (int i = 1; i <= n; i++) {
        if (s[i] == 'G') cnt[i] = cnt[i - 1] + 1, sum++;
        else {
            cnt[i] = 0;
            if (cnt[i - 1] > 0) {
                node[++tot] = Node(i - cnt[i - 1], i - 1);
            }
        }
    }
    if (tot == 0) puts("0");
    else if (tot == 1) printf("%d\n", node[1].len);
    else {
        int ans = max + 1;
        for (int i = 1; i < tot; i++) {
            if (node[i].r == node[i + 1].l - 2) {
                ans = std::max(ans, node[i].len + node[i + 1].len + (sum - node[i].len - node[i + 1].len > 0));
            }
        }
        printf("%d\n", ans);
    }
    return 0;
}
```

## Codeforces 1082C - Multi-Subject Competition - 暴力

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/C

------

### 题目

A multi-subject competition is coming! The competition has $m$ different subjects participants can choose from. That's why Alex (the coach) should form a competition delegation among his students. 

He has $n$ candidates. For the $i$-th person he knows subject $s_i$ the candidate specializes in and $r_i$ — a skill level in his specialization (this level can be negative!). 

The rules of the competition require each delegation to choose some subset of subjects they will participate in. The only restriction is that the **number of students from the team** participating in each of the **chosen** subjects should be the **same**.

Alex decided that each candidate would participate only in the subject he specializes in. Now Alex wonders whom he has to choose to maximize the total sum of skill levels of all delegates, or just skip the competition this year if every valid non-empty delegation has negative sum.

(Of course, Alex doesn't have any spare money so each delegate he chooses must participate in the competition).

------

### 题意

&emsp;&emsp;有$n$个人，$m$个项目，每个人只对一个项目熟悉且拥有一个熟练度，熟练度可以为负，你要选择一些人，参加一些项目（某个项目可以没有人参加），使得有人参加的任意两个项目的人数都相同，且所有项目的熟练度和最大，输出这个最大值。

------

### 思路

&emsp;&emsp;所有相同的项目都存在一起，然后对于单个项目排序一下，再记一下前缀和，然后暴力就可以了。显然，抛开排序的复杂度，暴力部分的复杂度为$O(n)$。

------

### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
std::vector<int> project[maxn];
std::vector<ll> sum[maxn];
int n, m, id[maxn], max_len;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, x, y; i <= n; i++) {
        scanf("%d%d", &x, &y);
        project[x].push_back(y);
    }
    for (int j = 1; j <= m; j++) id[j] = j;
    std::sort(id + 1, id + 1 + m, [](int x, int y) { return project[x].size() > project[y].size(); });
    for (int i = 1; i <= m; i++) {
        int cur = id[i];
        if (project[cur].empty()) break;
        int len = int(project[cur].size());
        max_len = std::max(len, max_len);
        std::sort(project[cur].begin(), project[cur].end(), std::greater<int>());
        sum[cur].resize(project[cur].size());
        sum[cur][0] = project[cur][0];
        for (int j = 1; j < len; j++) sum[cur][j] = sum[cur][j - 1] + project[cur][j];
    }
    ll ans = 0;
    for (int i = 1; i <= max_len; i++) {
        ll ans_buf = 0;
        for (int j = 1; j <= m; j++) {
            int cur = id[j];
            if (project[cur].size() < i) break;
            if (sum[cur][i - 1] > 0) ans_buf += sum[cur][i - 1];
        }
        ans = std::max(ans, ans_buf);
    }
    printf("%lld\n", ans);
    return 0;
}

```

## Codeforces 1082D - Maximum Diameter Graph - 贪心

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/D

------

### 题目

Graph constructive problems are back! This time the graph you are asked to build should match the following properties.

The graph is connected if and only if there exists a path between every pair of vertices.

The diameter (aka &quot;longest shortest path&quot;) of a connected undirected graph is the maximum number of edges in the **shortest** path between any pair of its vertices.

The degree of a vertex is the number of edges incident to it.

Given a sequence of $n$ integers $a_1, a_2, \dots, a_n$ construct a **connected undirected** graph of $n$ vertices such that:

- the graph contains no self-loops and no multiple edges;
- the degree $d_i$ of the $i$-th vertex doesn't exceed $a_i$ (i.e. $d_i \le a_i$);
- the diameter of the graph is maximum possible.

Output the resulting graph or report that no solution exists.

------

### 题意

&emsp;&emsp;有$n$个点，第$i$个点的度最大为$a_i$，问将这$n$个点连通后图的最大直径是多少。

------

### 思路

&emsp;&emsp;判断是否能构造一个连通图，如果可以的话，将所有度数大于$1$的点连成一条线，剩下度为一点尽量连一下最左边和最右边的点，然后随便连即可。可以证明，这样贪心一定是最优的。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 507;
int n, sum, cnt, ans;
struct Node {
    int deg, index;
} node[maxn];
std::queue<int> que;
struct Edge {
    int u, v;
} edge[maxn << 1];
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    scanf("%d", &n);
    int len = 0;
    for (int i = 1, buf; i <= n; i++) {
        scanf("%d", &buf);
        sum += buf;
        if (buf == 1) que.push(i);
        else node[++len] = {buf, i};
    }
    if (sum < (n - 1) * 2) return 0 * puts("NO");
    for (int i = 1; i < len; i++) {
        edge[++cnt] = {node[i].index, node[i + 1].index};
        node[i].deg--;
        node[i + 1].deg--;
        ans++;
    }
    if (!que.empty()) {
        int cur = que.front();
        que.pop();
        edge[++cnt] = {cur, node[1].index};
        node[1].deg--;
        ans++;
    }
    if (!que.empty()) {
        int cur = que.front();
        que.pop();
        edge[++cnt] = {cur, node[len].index};
        node[len].deg--;
        ans++;
    }
    while (!que.empty()) {
        int cur = que.front();
        que.pop();
        for (int i = 1; i <= len; i++) {
            if (node[i].deg > 0) {
                edge[++cnt] = {node[i].index, cur};
                node[i].deg--;
                break;
            }
        }
    }
    printf("YES %d\n", ans);
    printf("%d\n", cnt);
    for (int i = 1; i <= cnt; i++) printf("%d %d\n", edge[i].u, edge[i].v);
    return 0;
}
```

## Codeforces 1082E - Increasing Frequency - 动态规划

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/E

------

### 题目

You are given array $a$ of length $n$. You can choose one segment $[l, r]$ ($1 \le l \le r \le n$) and integer value $k$ (positive, negative or even zero) and change $a_l, a_{l + 1}, \dots, a_r$ by $k$ each (i.e. $a_i := a_i + k$ for each $l \le i \le r$).

What is the maximum possible number of elements with value $c$ that can be obtained after one such operation?

------

### 题意

&emsp;&emsp;有$n$个元素，第$i$个元素的值为$a_i$，你可以选择一个区间$[l, r]$，并将这个区间的每个元素都加上$k$（$k$为任意值，包括负数），问你在最多修改一次的情况下，能让这个序列中最多存在几个值为$c$的元素。

------

### 思路

&emsp;&emsp;考虑我们将区间$[l, r]$中所有的$x$都修改为$c$，则只需让这个区间中的每一个元素都加上$c - x$，此时区间中所有的$x$都会变为$c$，而$c$则变成了非$c$的值。

&emsp;&emsp;记$sum_i$为区间$[1, i]$中有多少个元素的值为$c$，记$cnt_i$为区间$[1, i]$中有多少个元素的值为$x$。

&emsp;&emsp;则我们修改某个区间$[l, r]$中的$x$的时候，整个序列中$c$的个数由$sum_n$变为了$sum_{l - 1} + cnt_r - cnt_{l - 1} + sum_n - sum_r$。

&emsp;&emsp;而我需要对于每一个区间都求一个这样的答案，然后取最大值，即: $max\{sum_{l - 1} + cnt_r - cnt_{l - 1} + sum_n - sum_r\}\ (1 \leq l \leq r \leq n)$。

&emsp;&emsp;注意到对于每一个固定的$r$，$cnt_r$、$sum_n$、$sum_r$均为定值，问题就转化成为对于每一个$r$，求$max\{sum_{l - 1} - cnt_{l - 1}\}\ (1 \leq l \leq r)$，这样以来就可以$O(n)$进行$DP$了。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(5e5) + 7;
std::map<int, std::vector<int>> map;
int n, c, sum[maxn], a[maxn], cnt[maxn];
int main() {
    scanf("%d%d", &n, &c);
    for (int i = 1; i <= n; i++) {
        scanf("%d", a + i);
        sum[i] = sum[i - 1] + (a[i] == c);
        map[a[i]].push_back(i);
    }
    int ans = sum[n];
    for (auto cur : map) {
        const std::vector<int> &vector = cur.second;
        int num = cur.first, max = 0;
        for (const auto &pos : vector) {
            max = std::max(max, sum[pos - 1] - cnt[num]++);
            ans = std::max(ans, cnt[num] - sum[pos] + max + sum[n]);
        }
    }
    printf("%d\n", ans);
    return 0;
}
```

## Codeforces 1082F - Speed Dial - 动态规划

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/F

------

### 题目

Polycarp's phone book contains $n$ phone numbers, each of them is described by $s_i$ — the number itself and $m_i$ — the number of times Polycarp dials it in daily.

Polycarp has just bought a brand new phone with an amazing *speed dial* feature! More precisely, $k$ buttons on it can have a number assigned to it (not necessary from the phone book). To enter some number Polycarp can press one of these $k$ buttons and then finish the number using usual digit buttons (entering a number with only digit buttons is also possible).

*Speed dial* button can only be used when no digits are entered. No button can have its number reassigned.

What is the minimal total number of **digit number presses** Polycarp can achieve after he assigns numbers to *speed dial* buttons and enters each of the numbers from his phone book the given number of times in an optimal way?

------

### 题意

&emsp;&emsp;有$n$个只包含`0~9`字符串，你可以删去$k$种前缀（每个串只能被删一次），问最少能剩下多少个字符。

------

### 思路

&emsp;&emsp;字典树上$DP$，暂时还没想明白，先挖坑。

------

### 实现

```cpp
\\ 我是坑
```

## Codeforces 1082G - Petya and Graph - 网络流

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/G

------

### 题目

Petya has a simple graph (that is, a graph without loops or multiple edges) consisting of $n$ vertices and $m$ edges.

The weight of the $i$-th vertex is $a_i$.

The weight of the $i$-th edge is $w_i$.

A subgraph of a graph is some set of the graph vertices and some set of the graph edges. The set of edges must meet the condition: both ends of each edge from the set must belong to the chosen set of vertices. 

The weight of a subgraph is the sum of the weights of its edges, minus the sum of the weights of its vertices. You need to find the maximum weight of subgraph of given graph. **The given graph does not contain loops and multiple edges**.

------

### 题意

&emsp;&emsp;有$n$个点，$m$条边，每个点和每条边都有一个权值，要求你从所给的图中选出一个子图，使得$sum\{val_{edges}\} - sum\{val_{vertices}\}$的值最大。

------

### 思路

&emsp;&emsp;很裸的最大权闭合子图，注意答案开`long long`，剩下的无脑`Dinic`就行。

------

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e3) + 7, inf = 0x3f3f3f3f;
typedef long long ll;
struct { int next, v, flow; } edge[maxn << 4];
struct Graph {
    int head[maxn << 1], cnt;
    Graph() { memset(head, 0xff, sizeof(head)), cnt = 0; }
    void addedge(int u, int v, int flow) {
        edge[cnt] = {head[u], v, flow};
        head[u] = cnt++;
        edge[cnt] = {head[v], u, 0};
        head[v] = cnt++;
    }
} graph;
struct Dinic {
    int cur[maxn << 1], dist[maxn << 1];
    bool bfs(int S, int T) {
        memset(dist, 0xff, sizeof(dist));
        dist[S] = 0;
        std::queue<int> que;
        que.push(S);
        while (!que.empty()) {
            int u = que.front();
            que.pop();
            for (int i = graph.head[u]; ~i; i = edge[i].next) {
                int v = edge[i].v, flow = edge[i].flow;
                if (dist[v] == -1 && flow > 0) {
                    dist[v] = dist[u] + 1;
                    if (v == T) return true;
                    que.push(v);
                }
            }
        }
        return false;
    }
    int dfs(int u, int low, int T) {
        if (u == T || low == 0) return low;
        for (int &i = cur[u]; ~i; i = edge[i].next) {
            int v = edge[i].v, flow = edge[i].flow;
            if (flow > 0 && dist[v] == dist[u] + 1) {
                int min = dfs(v, std::min(low, flow), T);
                if (min > 0) {
                    edge[i].flow -= min;
                    edge[i ^ 1].flow += min;
                    return min;
                }
            }
        }
        return 0;
    }
    ll solve(int S, int T) {
        ll ans = 0, tmp;
        while (bfs(S, T)) {
            memcpy(cur, graph.head, sizeof(cur));
            while (tmp = dfs(S, inf, T), tmp > 0) {
                ans += tmp;
            }
        }
        return ans;
    }
} dinic;
int n, m;
ll sum;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, buf; i <= n; i++) { // [1, n] -> n + m + 1
        scanf("%d", &buf);
        graph.addedge(i, n + m + 1, buf);
    }
    for (int i = 1, u, v, cost; i <= m; i++) { // 0 -> [n + 1, n + m]
        scanf("%d%d%d", &u, &v, &cost);
        sum += cost;
        graph.addedge(0, n + i, cost);
        graph.addedge(n + i, u, inf);
        graph.addedge(n + i, v, inf);
    }
    printf("%lld\n", sum - dinic.solve(0, n + m + 1));
    return 0;
}
```