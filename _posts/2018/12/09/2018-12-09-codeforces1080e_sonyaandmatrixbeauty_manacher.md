---
title: "Codeforces 1080E - Sonya and Matrix Beauty - Manacher"
date: 2018-12-09 01:52:59 +0800
last_modified_at: 2018-12-09 01:52:59 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["题解", "codeforces", "字符串", "manacher"]
---

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