---
title: "UPC-5791  - 骑士之战 - 线段树"
date: 2018-02-27 22:03:00 +0800
last_modified_at: 2018-03-01 22:04:48 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["线段树"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5791

---
### 题目：

#### 题目描述
有n位骑士想要通过淘汰赛决出他们当中最强大的一个。所有的骑士由1到n编号，他们总共进行了m场比赛，在第i场比赛中，所有编号在li到ri之间且尚未出局的骑士进行了一场比赛，决出了获胜者xi，其他参加比赛的骑士就出局了；我们称这些骑士被骑士xi打败了。m场比赛过后，只有一位骑士还没有出局，他就是最终的获胜者，我们希望知道其他所有骑士分别是被谁打败了。
#### 输入
第一行包含两个正整数n和m，表示骑士和比赛的数量。
接下来m行，每行三个数l，r和x，表示参与比赛的骑士编号范围，以及获胜者的编号。

#### 输出
输出n个由空格分隔的整数，第i个表示打败骑士i的骑士的编号。如果骑士i是获胜者，就在对应位置输出0。
#### 样例输入
```
5 3
2 4 3
1 3 1
1 5 5
```
#### 样例输出
```
5 3 1 3 0
```
#### 提示
第一场比赛中，骑士3打败了骑士2和4。 第二场比赛中，骑士1打败了骑士3。 第三场比赛中，骑士5打败了骑士1。 最终的胜利者是骑士5。

对于30%的数据，n ≤ 1000；
对于100%的数据，1 ≤ m < n ≤ 3×106, 1 ≤ l ≤ x ≤ r ≤ n,保证l到r之间至少有两位尚未出局的骑士，且骑士x一定尚未出局。

---
### 思路：

&emsp;&emsp;注意到被打败之后就再也不能上场了，容易得到：从最后一轮比赛开始，每次用上一轮比赛区间去掉x这个点之后去覆盖这一轮，然后就可以得到答案，用线段树实现的复杂度是$O(nlgn)$。

&emsp;&emsp;官方题解给的$O(n)$做法是维护一个长度为n的链表，每次从x点向左向右删除，对于每个将要删除的点将其标记为x即可，这样可以保证每个点只访问一遍，复杂度为$O(n)$。

---
### 线段树实现：

```cpp
## include <bits/stdc++.h>
## define lson (u << 1)
## define rson (u << 1 | 1)
using namespace std;
struct Query { int l, r, x; } q[int(1e6) + 7];
int node[int(1e7) + 7], n, m;
bool lazy[int(1e7) + 7];
void pushdown(int u) {
    node[lson] = node[rson] = node[u];
    lazy[lson] = lazy[rson] = true;
    lazy[u] = false;
}
void update(int b, int e, int val, int u = 1, int l = 1, int r = n) {
    if (b <= l && r <= e) {
        node[u] = val;
        lazy[u] = true;
        return ;
    }
    int mid = (l + r) >> 1;
    if (lazy[u]) pushdown(u);
    if (b <= mid) update(b, e, val, lson, l, mid);
    if (e > mid) update(b, e, val, rson, mid + 1, r);
}
int query(int aim, int u = 1, int l = 1, int r = n) {
    if (l == r) return node[u];
    int mid = (l + r) >> 1;
    if (lazy[u]) pushdown(u);
    if (aim <= mid) return query(aim, lson, l, mid);
    return query(aim, rson, mid + 1, r);
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= m; i++) {
        scanf("%d%d%d", &q[i].l, &q[i].r, &q[i].x);
        if (q[i].l > q[i].r) std::swap(q[i].l, q[i].r);
    }
    for (int i = m; i >= 1; i--) {
        if (q[i].l < q[i].x) update(q[i].l, q[i].x - 1, q[i].x);
        if (q[i].x < q[i].r) update(q[i].x + 1, q[i].r, q[i].x);
    }
    for (int i = 1; i <= n; i++) printf("%d%c", query(i), i == n ? '\n' : ' ');
    return 0;
}

```

---
### 链表实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(5e6) + 7;
struct { int l, r; } node[maxn];
void remove(int cur) {
    node[node[cur].l].r = node[cur].r;
    node[node[cur].r].l = node[cur].l;
}
int ans[maxn], n, m, l, r, x, cur;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) node[i] = {i - 1, i + 1};
    while (m--) {
        scanf("%d%d%d", &l, &r, &x);
        cur = node[x].l;
        while (cur >= l) {
            ans[cur] = x;
            remove(cur);
            cur = node[cur].l;
        }
        cur = node[x].r;
        while (cur <= r) {
            ans[cur] = x;
            remove(cur);
            cur = node[cur].r;
        }
    }
    for (int i = 1; i <= n; i++) printf("%d%c", ans[i], i == n ? '\n' : ' ');
    return 0;
}
```