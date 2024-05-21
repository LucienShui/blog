---
title: "ECNU 3653 - 她的名字 - 动态规划"
date: 2018-12-07 23:18:35 +0800
last_modified_at: 2018-12-07 23:18:35 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

## ECNU 3653 - 她的名字 - 动态规划

### 题解链接

https://lucien.ink

---
### 题目链接

https://acm.ecnu.edu.cn/problem/3653/

---
### 题目

“他走过一个又一个星球，
却始终放不下对她的思念。“
”深情终究是一趟孤独的旅程，
她是他永远的牵绊。”

![1.jpg](https://acm.ecnu.edu.cn/upload/3653/111.Lp74Q3HL.jpeg)

我们每个人心中都有一只小狐狸。我们渴望被自己喜欢的人驯服。

爱情是彼此之间至为甜蜜的臣服。我们都是傻痴痴的小狐狸，徒具一副精明的外表。

就像你走到哪都挂念着她，想把她写进自己的歌里，成为你们共同的记忆。

你想从她全部由数字构成的名字里取出其中的 $N$ 个数字，维持原来的顺序，组成结尾为数字 $XY$ 的新词。

你自然希望自己的歌能够很长很长，歌词的每一句都能饱含甜蜜。

所以你想知道，她的名字能够组成多少个长度为 $N$ 且结尾为数字 $XY$ 的新词（如果从她名字中取出的任意一个数字位置不同，两个词就被认为是不同的）。

---
### 题意

&emsp;&emsp;给你一个只包含数字的字符串，问有多少个长度为 $N$ 的子序列，以 $XY$ 结尾。

---
### 思路

&emsp;&emsp;考虑离线答案， $ans[len][x][y]$ 代表长度为 $len$ 的子序列且末尾为 $XY$ 的答案，此外定义一个辅助函数： $f[pos][x]$ ，代表下标 $pos$ 的右边有多少个数字 $x$ ，然后枚举一个 $x$、$y$，再枚举长度 $len$ ，转移方程就很显而易见了。

$$ans[len][x][y] = sum\{C_{pos - 1}^{len - 2} \cdot f[pos][y]\}\ (\forall str[pos] = x)$$

---
### 实现

https://pasteme.cn/2286

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = 2007, mod = int(1e9) + 7;
ll f[maxn][10], ans[maxn][10][10], C[maxn][maxn];
char str[maxn], query[maxn];
int q, n, len;
std::vector<int> pos[10];
void init() {
    C[0][0] = 1;
    for (int i = 1; i <= 2000; i++) {
        C[i][0] = C[i][i] = 1;
        for (int j = 1; j < i; j++) C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % mod;
    }
    for (int i = n - 1; i; i--) {
        for (int j = 0; j < 10; j++) f[i][j] = f[i + 1][j] + (str[i + 1] - '0' == j);
        pos[str[i] - '0'].push_back(i);
    }
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 10; y++) {
            if (pos[x].empty() || f[*pos[x].rbegin()][y] == 0) continue;
            for (int p : pos[x]) {
                if (f[p][y]) {
                    for (int i = 2; i <= n; i++) {
                        if (p - 1 < i - 2) break;
                        ans[i][x][y] = (ans[i][x][y] + f[p][y] * C[p - 1][i - 2] % mod) % mod;
                    }
                }
            }
        }
    }
}
int main() {
    scanf(" %s", str + 1);
    n = int(strlen(str + 1));
    init();
    for (scanf("%d", &q); q; q--) {
        scanf("%d %s", &len, query);
        if (len > n) puts("0");
        else {
            int x = query[0] - '0', y = query[1] - '0';
            printf("%lld\n", ans[len][x][y]);
        }
    }
    return 0;
}
```