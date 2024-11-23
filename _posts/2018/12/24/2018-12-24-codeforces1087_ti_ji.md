---
title: "Codeforces 1087 - 题集"
date: 2018-12-24 01:16:00 +0800
last_modified_at: 2019-01-26 01:45:58 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1087A - Right-Left Cipher

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/A

---
### 题意

给你一个字符串 $S = s_1s_2\dots s_n$，会将其一个一个地一左一右地放置为 $S' = s_5s_3s_1s_2s_4s_6$ ，现在给你 $S'$ ，让你输出 $S$ 。

---
### 思路

模拟一下即可，注意长度的奇偶。

---
### 实现

https://pasteme.cn/2801

```cpp
## include <bits/stdc++.h>
char str[int(1e5) + 7];
int main() {
    std::cin >> str;
    std::string ans = "";
    int len = int(strlen(str)), l = 0, r = len - 1;
    bool flag = !bool(len & 1);
    while (l <= r) {
        if (flag) ans = str[r--] + ans;
        else ans = str[l++] + ans;
        flag = !flag;
    }
    std::cout << ans << std::endl;
    return 0;
}
```
## Codeforces 1087B - Div Times Mod

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/B

---
### 题意

给你一个 $n$、$k$ ，找到一个最小的 $x$ 使得 $\lfloor x \div k \rfloor \cdot (x\ mod\ k) = n$ 成立。

---
### 思路

令 $x = a \cdot k + b\ (b < k)$，枚举一下 $b$ 即可。

---
### 实现

https://pasteme.cn/2802

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll n, k, ans = 0x3f3f3f3f3f3f3f3f;
    std::cin >> n >> k;
    for (ll b = k - 1; b >= 1; b--) {
        if (n % b == 0) {
            ll a = n / b;
            ans = std::min(ans, a * k + b);
        }
    }
    std::printf("%lld\n", ans);
    return 0;
}

```
## Codeforces 1087C - Connect Three

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/C

---
### 题意

有三个人在网格中，三个人的坐标互不相同，初始时所有网格都是白色的，你可以把任意多个网格染成黑色，染成黑色的网格可以相互连通（四连通），问至少需要对多少个网格进行染色，使得三个人之间两两可达。

---
### 思路

不论三个人的位置是怎样的，一定能形成一个将三个人完全覆盖的最小的矩形，且一定是两个人位于矩形的一个对角，另一个人在矩形内部。所以直接按照曼哈顿路径去随便染色就可以。

---
### 实现

https://pasteme.cn/2803

```cpp
## include <bits/stdc++.h>
struct Node {
    int x, y, index;
} node[7];
std::pair<int ,int> ans[int(1e6) + 7];
int cnt = 0;
int main() {
    for (int i = 1; i <= 3; i++) std::cin >> node[i].x >> node[i].y, node[i].index = i;
    std::sort(node + 1, node + 1 + 3, [](Node a, Node b) { return a.x < b.x; });
    int up = node[3].x, down = node[1].x, mid = node[2].x;
    std::sort(node + 1, node + 1 + 3, [](Node a, Node b) { return a.y < b.y; });
    for (int i = node[1].y; i <= node[3].y; i++) ans[++cnt] = std::make_pair(mid, i);
    for (int i = 1; i <= 3; i++) {
        if (node[i].x != mid) {
            for (int j = std::min(mid, node[i].x), upper = std::max(mid, node[i].x); j <= upper; j++)
                ans[++cnt] = std::make_pair(j, node[i].y);
        }
    }
    std::sort(ans + 1, ans + cnt + 1);
    cnt = int(std::unique(ans + 1, ans + 1 + cnt) - ans - 1);
    std::printf("%d\n", cnt);
    for (int i = 1; i <= cnt; i++) std::printf("%d %d\n", ans[i].first, ans[i].second);
    return 0;
}
```
## Codeforces 1087D - Minimum Diameter Tree

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/D

---
### 题意

你有一棵树，你可以给每条边一个非负的权值，使得整棵树的权值和为 $s$ ，定义这棵权值树的直径为权值和最大的一条路径，问最小直径为多少。

---
### 思路

翻译一下，其实就是让任意两个叶节点之间的路径权值和的最大值最小，显然均摊一下最为合适，所以答案就是 $s \div 叶节点的数量 \times 2$ 。比赛的时候想麻烦了，简单的写法明天补上来。

如果要在最小化直径的前提下让权值最大的边的权值尽可能的小，就得像我这样写了，emmm，好像 YY 出来一个新题？

---
### 实现

https://pasteme.cn/2804

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7, maxm = int(4e5) + 7;
struct Lca {
    int dep[maxn]{}, up[maxn][32]{}, cnt, head[maxn]{};
    struct { int next, to, val; } edge[maxm]{};
    void addedge(int u, int v) {
        edge[cnt] = {head[u], v};
        head[u] = cnt++;
    }
    explicit Lca() {
        cnt = 0;
        memset(head, 0xff, sizeof(head));
        memset(up, 0xff, sizeof(up));
    }
    void init(int n) {
        std::queue<int> que;
        que.emplace(dep[1] = 1);
        int u, v;
        while (!que.empty()) {
            u = que.front(), que.pop();
            for (int i = head[u]; ~i; i = edge[i].next) {
                v = edge[i].to;
                if (dep[v]) continue ;
                up[v][0] = u, dep[v] = dep[u] + 1, que.push(v);
            }
        }
        for (int j = 1; j <= 20; j++)
            for (int i = 1; i <= n; i++)
                if (~up[i][j - 1])
                    up[i][j] = up[up[i][j - 1]][j - 1];
    }
    int query(int u, int v) {
        if (dep[u] < dep[v]) std::swap(u, v);
        int tmp = dep[u] - dep[v];
        for (int j = 0; tmp; j++)
            if (tmp & (1 << j)) tmp ^= (1 << j), u = up[u][j];
        if (u == v) return v;
        for (int j = 20; j >= 0; j--) {
            if (up[u][j] != up[v][j]) {
                u = up[u][j], v = up[v][j];
            }
        }
        return up[u][0];
    }
} lca;
int deg[maxn], n, s, leaf[maxn], cnt;
int main() {
    std::scanf("%d%d", &n, &s);
    if (n == 2) return 0 * std::printf("%d\n", s);
    for (int i = 1, u, v; i < n; i++) {
        std::scanf("%d%d", &u, &v);
        deg[u]++, deg[v]++;
        lca.addedge(u, v);
        lca.addedge(v, u);
    }
    lca.init(n);
    for (int i = 1; i <= n; i++) if (deg[i] == 1) leaf[++cnt] = i;
    int pre = leaf[1], min = 0x3f3f3f3f, min_dep = lca.dep[leaf[1]];
    for (int i = 2; i <= cnt; i++) {
        pre = lca.query(pre, leaf[i]);
        min = std::min(min_dep + lca.dep[leaf[i]] - lca.dep[pre] * 2, min);
        min_dep = std::min(min_dep, lca.dep[leaf[i]]);
    }
    min >>= 1;
    printf("%.15lf\n", double(s) / double(min * cnt) * min * 2);
    return 0;
}
```