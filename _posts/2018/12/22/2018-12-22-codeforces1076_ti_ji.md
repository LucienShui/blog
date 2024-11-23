---
title: "Codeforces 1076 - 题集"
date: 2018-12-22 17:31:00 +0800
last_modified_at: 2018-12-23 13:20:42 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1076A - Minimizing the String

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/A

---
### 题意

你有一个字符串，你最多可以删掉一个字母，使得剩下的字符串的字典序最小。

---
### 思路

从左向右找到第一个当前字母小于下一个字母的位置，删掉这个字母即可。

---
### 实现

https://pasteme.cn/2739

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
char str[maxn];
int n, ans = -1;
int main() {
    scanf("%d %s", &n, str + 1);
    for (int i = 1; i <= n && ans == -1; i++) if (str[i] > str[i + 1]) ans = i;
    for (int i = 1; i <= n; i++) if (i != ans) printf("%c", str[i]);
    return 0;
}
```
## Codeforces 1076B - Divisor Subtraction

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/B

---
### 题意

你有一个程序 $f(n)$：

1. 如果 $n = 0$ 结束程序
2. 找到 $n$ 的最小质因数 $d$
3. $n = n - d$ ，然后回到步骤 $1$

问这个程序会执行多少次减法。

---
### 思路

偶数的最小质因数是 $2$ ，不论怎么减都是偶数，所以会减 $\frac{n}{2}$ 次。

奇数的最小质因数一定是一个奇数，做一次减法之后就会变成偶数。

分类讨论一下就可以了。

---
### 实现

https://pasteme.cn/2740

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
long long n;
bool prime[maxn];
bool isprime(long long x) {
    for (long long i = 2; i * i <= x; i++) if (x % i == 0) return false;
    return true;
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    memset(prime, true, sizeof(prime));
    for (int i = 2; i < maxn; i++) {
        if (!prime[i]) continue;
        for (int j = i + i; j < maxn; j += i) prime[j] = false;
    }
    scanf("%lld", &n);
    long long ans = n;
    if (ans & 1) {
        if (isprime(ans)) return 0 * puts("1");
        for (int i = 3; i <= ans; i++) {
            if (ans % i == 0 && prime[i]) {
                ans -= i;
                break;
            }
        }
    }
    printf("%lld\n", ans / 2 + (n & 1));
    return 0;
}
```
## Codeforces 1076C - Meme Problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/C

---
### 题意

给你一个非负整数 $d$ ，你要找到两个非负的自然数 $a$、$b$，使得 $a + b = d$ 和 $a \cdot b = d$ 同时成立，问是否存在这样的一对 $a$、$b$，不存在输出 `N`，存在的话输出 `Y a b`。

---
### 思路

$$\begin{cases}a + b = d\\a \ \cdot \  b = d\end{cases}$$

$$\Rightarrow a \cdot (d - a) = d$$

$$\Rightarrow a ^ 2 - d \cdot a + d = 0$$

解一下这个方程即可。

---
### 实现

https://pasteme.cn/2741

```cpp
## include <bits/stdc++.h>
std::vector<double> solve(double a, double b, double c) {
    std::vector<double> ret;
    double delta = b * b - a * c * 4;
    if (delta < 0) return ret;
    delta = sqrt(delta);
    double x[2] = {(-b - delta) / 2 / a, (-b + delta) / 2 / a};
    for (double i : x) if (i > 0) ret.push_back(i);
    return ret;
}
int solve(std::vector<double> ans, int d) {
    for (auto i : ans) if (fabs((d - i) * i - d) < 1e-9) return printf("Y %.9lf %.9lf\n", i, d - i);
    return 0 * puts("N");
}
int main() {
    int t, d;
    for (std::cin >> t; t; t--) {
        std::cin >> d;
        if (d != 0) solve(solve(1, -d, d), d);
        else puts("Y 0.000000000 0.000000000");
    }
    return 0;
}
/*
 * a + b = d
 * a * b = d
 * b = d - a
 * a * (d - a) = d
 * a * d - a * a = d
 * a * a - d * a + d = 0
 */

```
## Codeforces 1076D - Edge Deletion - 思维

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/D

---
### 题意

有一个 $n$ 个点 $m$ 条边的无向图 $G<n, m>$，定义 $dist(i)$ 为从 $1$ 号点出发到 $i$ 号点的最短路。

你最多可以保留 $k$ 条边，得到一个新的无向图 $G'<n, x>\ (x \leq k)$。

对于某个点 $i$ 来说，如果在 $G'$ 中的 $dist(i)$ 与 $G$ 中的 $dist(i)$ 相等，那么这个点就会产生一次贡献。

问在贡献最大化的情况下，需要保留哪些边。

---
### 思路

先跑出一棵最短路树，然后贪心选边即可。

---
### 实现

https://pasteme.cn/2742

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
typedef long long ll;
std::pair<int, int> pre[maxn];
std::vector<std::pair<int, int>> tree[maxn];
std::vector<int> ans;
struct { int next, v, cost, index; } edge[maxn << 1];
struct Graph {
    int head[maxn], cnt;
    Graph() { memset(head, 0xff, sizeof(head)), cnt = 0; }
    void addedge(int u, int v, int cost, int index) {
        edge[cnt] = {head[u], v, cost, index};
        head[u] = cnt++;
    }
} graph;
int n, m, k, cnt;
namespace Dijkstra {
    ll dist[maxn];
    bool vis[maxn];
    struct Node {
        int u;
        ll dist;
        Node(int u, ll dist):u(u), dist(dist) {}
        bool operator < (const Node &tmp) const {
            return dist > tmp.dist;
        }
    };
    void run() {
        std::priority_queue<Node> que;
        que.emplace(1, 0);
        memset(dist, 0x3f, sizeof(dist));
        dist[1] = 0;
        while (!que.empty()) {
            int u = que.top().u;
            que.pop();
            if (vis[u]) continue;
            vis[u] = true;
            for (int i = graph.head[u]; ~i; i = edge[i].next) {
                int v = edge[i].v, cost = edge[i].cost, index = edge[i].index;
                if (dist[v] > dist[u] + cost) {
                    dist[v] = dist[u] + cost;
                    que.emplace(v, dist[v]);
                    pre[v] = std::make_pair(u, index);
                }
            }
        }
    }
}
void dfs(int u) {
    for (auto it : tree[u]) {
        if (cnt++ < k) {
            ans.push_back(it.second);
            dfs(it.first);
        }
    }
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    std::cin >> n >> m >> k;
    for (int i = 1, u, v, cost; i <= m; i++) {
        std::cin >> u >> v >> cost;
        graph.addedge(u, v, cost, i);
        graph.addedge(v, u, cost, i);
    }
    Dijkstra::run();
    for (int i = 2; i <= n; i++) tree[pre[i].first].emplace_back(i, pre[i].second);
    dfs(1);
    std::cout << ans.size() << std::endl;
    for (auto i : ans) std::cout << i << ' ';
    return 0;
}

```
## Codeforces 1076E - Vasya and a Tree - 树状数组

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/E

---
### 题意

给你一棵有根树，有 $m$ 次操作，每次操作为 `v d x`，代表着把以 $v$ 为根深度不超过 $d$ 的所有点的权值都加上 $x$，问所有操作都进行完之后，每个点的权值是多少。

---
### 思路

维护一个以深度为下标的树状数组 `bit`，考虑 `dfs`，进入一个点时把这个节点对其它节点的影响全都加到树状数组中，查询一个点 $u$ 时直接 `bit.query(dep[u])` 即可，`dfs` 退出当前节点时再将这个节点对其它节点的影响在树状数组中消去即可。

---
### 实现

https://pasteme.cn/2743

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
typedef long long ll;
int n, m, max_dep, dep[maxn];
std::vector<int> edge[maxn];
std::vector<std::pair<int, int>> query[maxn];
struct Bit {
    ll data[maxn];
    void add(int pos, int val) {
        while (pos <= n) data[pos] += val, pos += pos & -pos;
    }
    ll query(int pos) {
        ll ret = 0;
        while (pos) ret += data[pos], pos -= pos & -pos;
        return ret;
    }
} bit;
void dfs(int u, int pre) {
    max_dep = std::max(dep[u] = dep[pre] + 1, max_dep);
    for (int v : edge[u]) if (v != pre) dfs(v, u);
}
ll ans[maxn];
void solve(int u, int pre) {
    for (auto pair : query[u]) {
        bit.add(dep[u], pair.second);
        bit.add(pair.first + 1, -pair.second);
    }
    ans[u] = bit.query(dep[u]);
    for (int v : edge[u]) if (v != pre) solve(v, u);
    for (auto pair : query[u]) {
        bit.add(dep[u], -pair.second);
        bit.add(pair.first + 1, pair.second);
    }
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    std::cin >> n;
    for (int i = 1, u, v; i < n; i++) {
        std::cin >> u >> v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1, 1);
    std::cin >> m;
    for (int i = 1, u, d, x; i <= m; i++) {
        std::cin >> u >> d >> x;
        query[u].emplace_back(std::min(dep[u] + d, max_dep), x);
    }
    solve(1, 1);
    for (int i = 1; i <= n; i++) printf("%lld%c", ans[i], i == n ? '\n' : ' ');
    return 0;
}

```