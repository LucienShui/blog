---
title: "Codeforces 1080 - 全解"
date: 2018-12-09 02:03:00 +0800
last_modified_at: 2018-12-09 15:57:05 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## 单个题目的链接

[Codeforces 1080A - Petya and Origami](https://blog.csdn.net/xs18952904/article/details/84901382)
[Codeforces 1080B - Margarite and the best present](https://blog.csdn.net/xs18952904/article/details/84901385)
[Codeforces 1080C - Masha and two friends](https://blog.csdn.net/xs18952904/article/details/84901387)
[Codeforces 1080D - Olya and magical square](https://blog.csdn.net/xs18952904/article/details/84901388)
[Codeforces 1080E - Sonya and Matrix Beauty](https://blog.csdn.net/xs18952904/article/details/84901392)
[Codeforces 1080F - Katya and Segments Sets](https://blog.csdn.net/xs18952904/article/details/84901398)

## Codeforces 1080A - Petya and Origami

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/A

---
### 题目

Petya is having a party soon, and he has decided to invite his $n$ friends.

He wants to make invitations in the form of origami. For each invitation, he needs **two** red sheets, **five** green sheets, and **eight** blue sheets. The store sells an infinite number of notebooks of each color, but each notebook consists of only **one** color with $k$ sheets. That is, each notebook contains $k$ sheets of either red, green, or blue.

Find the minimum number of notebooks that Petya needs to buy to invite all $n$ of his friends.

---
### 题意

&emsp;&emsp;$2$ 张红纸 + $5$ 张绿纸 + $8$ 张蓝纸 = $1$ 一个人，每一份彩纸中包含 $k$ 张彩纸，且只有一种颜色的彩纸。现在有 $n$ 个人，问最少需要买多少份彩纸。

---
### 思路

&emsp;&emsp;模拟一下即可，复杂度 $O(1)$。

---
### 实现

https://pasteme.cn/2336

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll n, k;
    scanf("%lld%lld\n", &n, &k);
    printf("%lld\n", (n * 2 + k - 1) / k + (n * 5 + k - 1) / k + (n * 8 + k - 1) / k);
    return 0;
}
```
## Codeforces 1080B - Margarite and the best present

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/B

---
### 题目

Little girl Margarita is a big fan of competitive programming. She especially loves problems about arrays and queries on them.

Recently, she was presented with an array $a$ of the size of $10^9$ elements that is filled as follows: 

+ $a_1 = -1$ 
+ $a_2 = 2$ 
+ $a_3 = -3$ 
+ $a_4 = 4$ 
+ $a_5 = -5$ 
+ And so on ... 

That is, the value of the $i$-th element of the array $a$ is calculated using the formula $a_i = i \cdot (-1)^i$.

She immediately came up with $q$ queries on this array. Each query is described with two numbers: $l$ and $r$. The answer to a query is the sum of all the elements of the array at positions from $l$ to $r$ inclusive.

Margarita really wants to know the answer to each of the requests. She doesn't want to count all this manually, but unfortunately, she couldn't write the program that solves the problem either. She has turned to you — the best programmer.

Help her find the answers!

---
### 题意

&emsp;&emsp;给你 $q$ 次询问，每次询问一个区间 $[l, r]$，输出 $\sum_{i = l}^{r}i \cdot (-1)^i$。

---
### 思路

&emsp;&emsp;用两次等差数列求和公式，注意边界即可，单次询问复杂度为 $O(1)$。

---
### 实现

https://pasteme.cn/2337

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll calc(ll l, ll r) {
    return (r + l) / 2 * ((r - l) / 2 + 1);
}
int main() {
    int _, l, r;
    for (scanf("%d", &_); _; _--) {
        scanf("%d%d", &l, &r);
        ll ans = calc(l + (l & 1), r - (r & 1));
        ans -= calc(l | 1, r - (r % 2 == 0));
        printf("%lld\n", ans);
    }
    return 0;
}
```
## Codeforces 1080C - Masha and two friends - 容斥

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/C

---
### 题目

Recently, Masha was presented with a chessboard with a height of $n$ and a width of $m$.

The rows on the chessboard are numbered from $1$ to $n$ from bottom to top. The columns are numbered from $1$ to $m$ from left to right. Therefore, each cell can be specified with the coordinates $(x,y)$, where $x$ is the **column** number, and $y$ is the **row** number **(do not mix up)**.

Let us call a rectangle with coordinates $(a,b,c,d)$ a rectangle lower left point of which has coordinates $(a,b)$, and the upper right one — $(c,d)$.

The chessboard is painted black and white as follows:

![1.jpg](https://codeforces.com/predownloaded/63/c6/63c6cf1592f602dd174d1684054e14ab9800789b.png)

An example of a chessboard.

Masha was very happy with the gift and, therefore, invited her friends Maxim and Denis to show off. The guys decided to make her a treat — they bought her a can of white and a can of black paint, so that if the old board deteriorates, it can be repainted. When they came to Masha, something unpleasant happened: first, Maxim went over the threshold and spilled **white** paint on the rectangle $(x_1,y_1,x_2,y_2)$. Then after him Denis spilled **black** paint on the rectangle $(x_3,y_3,x_4,y_4)$.

To spill paint of color $color$ onto a certain rectangle means that all the cells that belong to the given rectangle become $color$. The cell dyeing is superimposed on each other (if at first some cell is spilled with white paint and then with black one, then its color will be black).

Masha was shocked! She drove away from the guests and decided to find out how spoiled the gift was. For this, she needs to know the number of cells of white and black color. Help her find these numbers!

---
### 题意

&emsp;&emsp;有一个 $n \cdot m$ 的黑白棋盘（第 $1$ 行第 $1$ 列的格子为白色），主人公会先将矩形 $A$ 涂成白色，然后将矩形 $B$ 涂成黑色，第二次涂色会覆盖第一次的，问最后剩下的白色格子和黑色各有多少个。

---
### 思路

&emsp;&emsp;容斥一下，单组测试用例复杂度为 $O(1)$。

---
### 实现

https://pasteme.cn/2338

```cpp
## include <bits/stdc++.h>
typedef long long ll;
struct Rec {
    ll x1, y1, x2, y2;
    ll black() {
        if (x1 > x2 || y1 > y2) return 0;
        ll buf = (x2 - x1 + 1) * (y2 - y1 + 1);
        return buf / 2 + ((x1 + y1) & 1 && (buf & 1));
    }
    ll white() {
        if (x1 > x2 || y1 > y2) return 0;
        return (x2 - x1 + 1) * (y2 - y1 + 1) - black();
    }
    Rec inter(const Rec &tmp) const {
        Rec ret;
        ret.x1 = std::max(x1, tmp.x1), ret.x2 = std::min(x2, tmp.x2);
        ret.y1 = std::max(y1, tmp.y1), ret.y2 = std::min(y2, tmp.y2);
        return ret;
    }
} rec[4];
int main() {
    int _, n, m, x1, y1, x2, y2;
    for (scanf("%d", &_); _; _--) {
        scanf("%d%d", &n, &m);
        rec[0] = {1, 1, n, m};
        for (int i = 1; i <= 2; i++) {
            scanf("%d%d%d%d", &x1, &y1, &x2, &y2);
            rec[i] = {x1, y1, x2, y2};
        }
        ll white = rec[0].white(), black = rec[0].black();
        rec[3] = rec[1].inter(rec[2]);
        white += rec[1].black() - rec[3].black();
        black -= rec[1].black() - rec[3].black();
        black += rec[2].white();
        white -= rec[2].white();
        printf("%lld %lld\n", white, black);
    }
    return 0;
}
```
## Codeforces 1080D - Olya and magical square - 思维

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/D

---
### 题目

Recently, Olya received a magical square with the size of $2^n\times 2^n$.

It seems to her sister that one square is boring. Therefore, she asked Olya to perform **exactly** $k$ *splitting operations*.

A *Splitting operation* is an operation during which Olya takes a square with side $a$ and cuts it into 4 equal squares with side $\dfrac{a}{2}$. If the side of the square is equal to $1$, then it is impossible to apply a splitting operation to it (see examples for better understanding).

Olya is happy to fulfill her sister's request, but she also wants *the condition of Olya's happiness* to be satisfied after all operations.

*The condition of Olya's happiness* will be satisfied if the following statement is fulfilled:

Let the length of the side of the lower left square be equal to $a$, then the length of the side of the right upper square should also be equal to $a$. There should also be a path between them that consists only of squares with the side of length $a$. All consecutive squares on a path should have a common side.

Obviously, as long as we have one square, these conditions are met. So Olya is ready to fulfill her sister's request only under the condition that she is satisfied too. Tell her: is it possible to perform exactly $k$ splitting operations in a certain order so that the condition of Olya's happiness is satisfied? If it is possible, tell also the size of the side of squares of which the path from the lower left square to the upper right one will consist.

---
### 题意

&emsp;&emsp;有一个初始时宽为 $2^n$ 的正方形，你每次可以对一个完整的正方形进行四等分。问是否存在一种方案，使得在恰好四等分 $k$ 次之后，存在一条等宽的路径，使得左下角的方块和右上角的方块联通（四联通），如果这种方案存在，输出路径的宽度对 $2$ 取对数的值。

---
### 思路

&emsp;&emsp;显然 $n$ 大于 $31$ 的时候我可以只切一刀，剩下的刀全切右下角的那一块，这样一来答案就是 $n - 1$。

&emsp;&emsp;在 $n$ 小于等于 $31$ 的时候可以枚举答案，枚举的同时判断一下当前状态是否可行，输出任意解即可。单组测试用例复杂度为 $O(31)$。

---
### 实现

https://pasteme.cn/2339

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll tot[37], n, k, _;
void init() {
    ll cur = 1;
    for (int i = 0; i <= 31; i++, cur *= 4) tot[i] = (cur - 1) / 3;
}
ll solve(ll n, ll k) {
    if (n > 31) return n - 1;
    for (int i = 0; i < n; i++) {
        ll tmp = n - i, need = (1ll << tmp + 1) - tmp - 2;
        if (need <= k) {
            ll last = tot[n] - ((1ll << tmp + 1) - 1) * tot[i];
            if (last >= k) return i;
        }
    }
    return -1;
}
int main() {
    init();
    for (scanf("%lld", &_); _; _--) {
        scanf("%lld%lld", &n, &k);
        ll ans = solve(n, k);
        if (~ans) printf("YES %lld\n", ans);
        else puts("NO");
    }
    return 0;
}
```
## Codeforces 1080E - Sonya and Matrix Beauty - Manacher

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1080/problem/E

---
### 题目

Sonya had a birthday recently. She was presented with the matrix of size $n\times m$ and consist of lowercase Latin letters. We assume that the rows are numbered by integers from $1$ to $n$ from bottom to top, and the columns are numbered from $1$ to $m$ from left to right. 

Let's call a submatrix $(i_1, j_1, i_2, j_2)$ $(1\leq i_1\leq i_2\leq n; 1\leq j_1\leq j_2\leq m)$ elements $a_{ij}$ of this matrix, such that $i_1\leq i\leq i_2$ and $j_1\leq j\leq j_2$. Sonya states that a submatrix is beautiful if we can **independently** reorder the characters in each **row** (not in column) so that all **rows** and columns* of this submatrix form palidroms. 

Let's recall that a string is called palindrome if it reads the same from left to right and from right to left. For example, strings $abacaba, bcaacb, a$ are palindromes while strings $abca, acbba, ab$ are not.

Help Sonya to find the number of beautiful submatrixes. Submatrixes are different if there is an element that belongs to only one submatrix.

---
### 题意

&emsp;&emsp;定一个子矩阵是完美的，当且仅当任意重排列这个字矩阵的每一行后，矩阵的每一行和每一列都是一个回文串，问给定一个 $n \cdot m$ 的矩阵，有多少个完美的子矩阵。

---
### 思路

&emsp;&emsp;首先观察一下，如果某一行能够变成回文串，当且仅当这一行奇数字母的个数小于 $2$。现在我们假设某个子矩形的每一行都可以形成回文串，那么怎么判断纵向的呢？

&emsp;&emsp;可以注意到，回文串的第一个字符等于最后一个字符，而题目里要求子矩阵的每一列都是回文串，也就是说第一行中的每一个字母都要在最后一行里找到一个相同的字母，因为每一行都可以任意排列，所以满足上述条件的充要条件就是这两行之间所有的字母出现的次数都相同，此时我们定义这两行是全等的。进一步推广，第二行全等于倒数第二行 $\dots$ 第 $i$ 行全等于第 $n - i + 1$ 行，我们发现如果把这个子矩阵的每一行看作一个字符的话，对于单个子矩阵来说，问题无非就变成了给你一个长度为 $n$ 的字符串，统计里面有多少个回文串，这个问题我们可以 $O(n)$ 通过 $Manacher$ 来求解。

&emsp;&emsp;于是我们便有了思路，首先 $m ^ 2$ 枚举左右边界，对于一个固定的左右边界，通过 $Manacher$ 进行回文计数，而由于在 $Manacher$ 中判断两个“字符”相等时其实是扫了一遍 $26$ 个字母，所以我们当前做法的复杂度为 $O(26 \cdot m ^ 2 \cdot n)$ 的，由于 $n$ 和 $m$ 同数量级，故简写为 $O(26 \cdot n ^ 3)$，通过计算发现其复杂度约为 $4 \cdot 10 ^ 8$，不是很优秀，写的稍微丑一点就会 `TLE`。

&emsp;&emsp;此时我们可以通过 ~~花式~~ 哈希来去掉 $26$ 这个常数，复杂度就可以进化到 $O(n ^ 3)$，约为 $1.5 \cdot 10 ^ 7$，这道题给了 $1.5sec$，显然已经足够了。

&emsp;&emsp;貌似是有 $O(n ^ 2 \cdot log_2(n))$ 的解法？本 `juruo` 学识短浅，还请各位 `dalao` 多多指教 `Orz`。

---
### 实现

https://pasteme.cn/2340

```cpp
## include <bits/stdc++.h>
const int maxn = 257;
char map[maxn][maxn];
int n, m, mask[maxn], e[maxn], ans, mod = 19260817, base = 257;
struct Manacher {
    int p[maxn << 1], str[maxn << 1];
    bool check(int x) {return x - (x & -x) == 0;}
    bool equal(int x, int y) {
        if ((x & 1) != (y & 1)) return false;
        return (x & 1) || (check(mask[x >> 1]) && check(mask[y >> 1]) && str[x] == str[y]);
    }
    int solve(int len) {
        int max_right = 0, pos = 0, ret = 0;
        for (int i = 1; i <= len; i++) {
            p[i] = (max_right > i ? std::min(p[pos + pos - i], max_right - i) : 1);
            if ((i & 1) || check(mask[i >> 1])) {
                while (equal(i + p[i], i - p[i])) p[i]++;
                if (max_right < i + p[i]) pos = i, max_right = i + p[i];
                ret += p[i] / 2;
            } else p[i] = 2;
        }
        return ret;
    }
} manacher;
int main() {
    scanf("%d%d", &n, &m);
    manacher.str[0] = -1, manacher.str[n * 2 + 2] = -2, e[0] = 1;
    for (int i = 1; i <= 26; i++) e[i] = int(1ll * e[i - 1] * base % mod);
    for (int i = 1; i <= n; i++) scanf("%s", map[i] + 1);
    for (int l = 1; l <= m; l++) {
        for (int i = 1; i <= n; i++) mask[i] = manacher.str[i << 1] = 0;
        for (int r = l; r <= m; r++) {
            for (int i = 1; i <= n; i++) {
                mask[i] ^= (1 << (map[i][r] - 'a'));
                manacher.str[i << 1] = (manacher.str[i << 1] + e[map[i][r] - 'a' + 1]) % mod;
            }
            ans += manacher.solve(n << 1 | 1);
        }
    }
    printf("%d\n", ans);
    return 0;
}
```
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