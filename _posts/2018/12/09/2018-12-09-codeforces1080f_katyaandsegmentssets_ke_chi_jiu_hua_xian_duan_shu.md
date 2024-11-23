---
title: "Codeforces 1080F - Katya and Segments Sets - 可持久化线段树"
date: 2018-12-09 01:54:36 +0800
last_modified_at: 2018-12-09 01:54:36 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["题解", "codeforces", "可持久化数据结构"]
---

## Codeforces 1080F - Katya and Segments Sets - 可持久化线段树
 

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/F

---
### 题目

It is a very important day for Katya. She has a test in a programming class. As always, she was given an interesting problem that she solved very fast. Can you solve that problem?

You are given $n$ ordered segments sets. Each segment can be represented as a pair of two integers $[l, r]$ where $l\leq r$. Each set can contain an arbitrary number of segments (even $0$). It is possible that some segments are equal.

You are also given $m$ queries, each of them can be represented as four numbers: $a, b, x, y$. For each segment, find out whether it is true that each set $p$ ($a\leq p\leq b$) contains at least one segment $[l, r]$ that lies entirely on the segment $[x, y]$, that is $x\leq l\leq r\leq y$. 

Find out the answer to each query.

Note that you need to solve this problem **online**. That is, you will get a new query only after you print the answer for the previous query.

---
### 题意

&emsp;&emsp;你有 $n$ 个集合，$k$ 条线段，每条线段都只属于一个集合，集合的编号为 $1 \dots n$，允许存集合为空（为了叙述方便，在这里我们将编号为 $i$ 的集合中的第 $j$ 条线段简记为 $seg[i][j]$）。有 $m$ 次询问，每次询问有四个值 `a b x y`，问：

+ $\forall\ i \in [a, b]$
+ $\exists\ j$，使得 $seg[i][j] \subseteq segnment[x, y]$

&emsp;&emsp;是否成立。

---
### 思路

&emsp;&emsp;先从忽略时间、空间复杂度的角度去考虑问题。

&emsp;&emsp;对于单个集合，考虑如何快速的求解答案。我们可以借助动态规划的思想，处理出左端点坐标大于等于 $x$ 的所有线段的右端点的最小值 $f[x]$，这样对于单次询问 `x y`，只需要判断 $f[x] \leq y$ 是否成立即可。

&emsp;&emsp;对于多个集合，我们将每个集合的 $f$ 函数都预处理出来，记 $f[i][x]$ 为编号为 $i$ 的集合中左端点坐标大于等于 $x$ 的所有线段的右端点的最小值，对于单次询问 `a b x y`，我们只需要判断$max\{f[a][x], f[a + 1][x] \dots f[b][x]\} \leq y$ 是否成立即可。

&emsp;&emsp;这样一来，我们就从逻辑上得出了一种看似可行的做法，开始考虑优化。

&emsp;&emsp;对于单次询问 `a b x y`，我们判断$max\{f[a][x], f[a + 1][x] \dots f[b][x]\} \leq y$ 是否成立时，可以观察到，$max\{f[a][x] \dots f[b][x]\}$ 可以通过维护一颗叶节点 $i$ 代表 $f[i][x]$ 的最大值线段树来在 $O(log_2(n))$ 的时间内得到，可每次询问的时候，我都需要将线段树先清空，再将所有涉及到询问的集合中左端点的坐标大于等于 $x$ 的线段都一一重新插入，此时单次询问的复杂度为$O(n \cdot log_2(n))$。

&emsp;&emsp;优化重构问题，显然需要用到可持久化数据结构，也就是可持久化线段树了。

&emsp;&emsp;我们将所有线段都按左端点进行一次从大到小的 $sort$，右端点可以忽略，我们按照左端点从大到小的顺序将右端点插到可持久化线段树中，这样一来我们对某个拷贝进行查询的时候，就可以得到 $max\{f[a][x] \dots f[b][x]\}$ 的值了，将其与 $y$ 作比较即可。单次询问复杂度为$O(log_2(n))$。

---
### 实现

https://pasteme.cn/2341

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, inf = 0x3f3f3f3f;
int n, m, k, key[maxn << 2], value[maxn << 2], len;
struct SegmentTree {
    struct Node {
        int val, l, r;
        Node():val(inf), l(0), r(0) {}
    } node[maxn << 6];
    int root[maxn << 2], size, cnt;
    SegmentTree():size(0), cnt(0) {}
    void pushup(int cur) {
        node[cur].val = std::max(node[node[cur].l].val, node[node[cur].r].val);
    }
    void update(int pos, int val, int &cur, int pre, int l, int r) {
        node[cur = ++size] = node[pre];
        if (l == r) {
            node[cur].val = std::min(node[cur].val, val);
            return ;
        }
        int mid = l + r >> 1;
        if (pos <= mid) update(pos, val, node[cur].l, node[pre].l, l, mid);
        else update(pos, val, node[cur].r, node[pre].r, mid + 1, r);
        pushup(cur);
    }
    int query(int ql, int qr, int cur, int l, int r) {
        if (cur == 0) return inf;
        if (ql <= l && r <= qr) return node[cur].val;
        int mid = l + r >> 1, ret = 0;
        if (ql <= mid) ret = std::max(ret, query(ql, qr, node[cur].l, l, mid));
        if (qr > mid) ret = std::max(ret, query(ql, qr, node[cur].r, mid + 1, r));
        return ret ? ret : inf;
    }
    void update(int pos, int val) {
        ++cnt;
        update(pos, val, root[cnt], root[cnt - 1], 1, n);
    }
    int query(int l, int r, int cur) {
        return query(l, r, root[cur], 1, n);
    }
} htj;
struct Segment { int l, r, p; } segment[maxn << 2];
int main() {
    scanf("%d%d%d", &n, &m, &k);
    for (int i = 1; i <= k; i++) scanf("%d%d%d", &segment[i].l, &segment[i].r, &segment[i].p);
    std::sort(segment + 1, segment + 1 + k, [](Segment x, Segment y) { return x.l == y.l ? x.r > y.r : x.l > y.l; });
    for (int i = 1; i <= k; i++) {
        if (segment[i].l != segment[i - 1].l) key[++len] = segment[i].l;
        value[len] = i;
        htj.update(segment[i].p, segment[i].r);
    }
    for (int i = 1, a, b, x, y; i <= m; i++) {
        scanf("%d%d%d%d", &a, &b, &x, &y);
        int pos = value[int(std::upper_bound(key + 1, key + 1 + len, x, std::greater<int>()) - key) - 1];
        puts(htj.query(a, b, pos) <= y ? "yes" : "no");
        fflush(stdout);
    }
    return 0;
}
```