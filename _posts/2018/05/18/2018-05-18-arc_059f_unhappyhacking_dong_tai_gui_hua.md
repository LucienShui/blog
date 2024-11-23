---
title: "ARC-059F - Unhappy Hacking - 动态规划"
date: 2018-05-18 00:12:00 +0800
last_modified_at: 2018-05-20 23:37:37 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接

https://arc059.contest.atcoder.jp/tasks/arc059_d

---
### 题目

#### Problem Statement
Sig has built his own keyboard. Designed for ultimate simplicity, this keyboard only has $3$ keys on it: the `0` key, the `1` key and the backspace key.

To begin with, he is using a plain text editor with this keyboard. This editor always displays one string (possibly empty). Just after the editor is launched, this string is empty. When each key on the keyboard is pressed, the following changes occur to the string:

The `0` key: a letter `0` will be inserted to the right of the string.
The `1` key: a letter `1` will be inserted to the right of the string.
The backspace key: if the string is empty, nothing happens. Otherwise, the rightmost letter of the string is deleted.
Sig has launched the editor, and pressed these keys $N$ times in total. As a result, the editor displays a string $s$. Find the number of such ways to press the keys, modulo $10^9+7$.

#### Constraints

+ $1 \leq N \leq 5000$
+ $1 \leq |s| \leq N$
+ $s$ consists of the letters `0` and `1`.

#### Partial Score
400 points will be awarded for passing the test set satisfying 1≦N≦300.

---
### 题意

&emsp;&emsp;有一个键盘只有三个按键，`0`、`1`、`Back Space`，每按一下就会在屏幕上输出一个`0`、`1`或者是删掉一个数字，屏幕上没字的时候按退格键不会发生任何事。问你按了`n`下键盘之后屏幕上显示的是字符串`s`的方案数是多少。

---
### 思路

&emsp;&emsp;应该是有$O(n)$的做法的，但是目前来说我只会$O(n^2)$的做法，讲一下$O(n^2)$的吧。

&emsp;&emsp;记$f[i][j]$为按了`i`下键盘之后产生了长度为`j`的串的方案数，初始$f[0][0] = 1$。

&emsp;&emsp;对于某个`f[i][j]`，要么按一次数字键（`0`或者`1`）变成`f[i + 1][j + 1]`，要么按一次退格键变成`f[i + 1][j - 1]`，也就是说，每一个`f[i][j]`只会对两个状态产生影响，但是一个`f[i][j]`会被很多状态影响，显然从`i`推`i + 1`会简单很多，则有：

+ `f[i + 1][j + 1] += 2 * f[i][j]`
+ `f[i + 1][max(j - 1, 0)] += f[i][j]`

&emsp;&emsp;注意`j = 0`的时候相当于屏幕上此时没有字符，此时按退格键虽然不会改变字符，但仍然是一个有效状态，所以取`max(j - 1, 0)`。

&emsp;&emsp;这样仅仅是得到了按`i`下键盘时得到了长度为`j`的串的方案数，但是题目里所给的串是一个特定的串，是所有长度为`j`的串的其中之一，又因为长度为`j`的串中每个字符要么是`0`要么是`1`，总共有$2^{\ j}$种串，所以按`n`下得到某个长度为`len`的串的方案数应为$\frac{f[n][len]}{2^j}$。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 5007, mod = int(1e9) + 7;
typedef long long ll;
char str[maxn];
int ans[maxn][maxn], len, n;
ll power_mod(ll p, int q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return ret;
}
int max(int a, int b) { return a > b ? a : b; }
void init() {
    len = int(strlen(str)), ans[0][0] = 1;
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= i; j++) {
            ans[i + 1][j + 1] = int((1ll * ans[i][j] * 2 % mod + ans[i + 1][j + 1]) % mod);
            ans[i + 1][max(j - 1, 0)] = int((0ll + ans[i][j] + ans[i + 1][max(j - 1, 0)]) % mod);
        }
    }
}

int main() {
    scanf("%d%s", &n, str);
    init();
    printf("%d\n", int(power_mod(power_mod(2, len), mod - 2) * ans[n][len] % mod));
    return 0;
}
```