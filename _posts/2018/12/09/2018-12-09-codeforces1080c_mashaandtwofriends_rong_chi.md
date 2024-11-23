---
title: "Codeforces 1080C - Masha and two friends - 容斥"
date: 2018-12-09 01:49:50 +0800
last_modified_at: 2018-12-09 01:49:50 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "codeforces", "容斥"]
---

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

Let us call a rectangle with coordinates $(a,b,c,d)$ a rectangle lower left point of which has coordinates $(a,b)$, and the upper right one — $(c,d)$.

The chessboard is painted black and white as follows:

![1.jpg](https://codeforces.com/predownloaded/63/c6/63c6cf1592f602dd174d1684054e14ab9800789b.png)

An example of a chessboard.

Masha was very happy with the gift and, therefore, invited her friends Maxim and Denis to show off. The guys decided to make her a treat — they bought her a can of white and a can of black paint, so that if the old board deteriorates, it can be repainted. When they came to Masha, something unpleasant happened: first, Maxim went over the threshold and spilled **white** paint on the rectangle $(x_1,y_1,x_2,y_2)$. Then after him Denis spilled **black** paint on the rectangle $(x_3,y_3,x_4,y_4)$.

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