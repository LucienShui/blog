---
title: "Codeforces 1088D - Ehab and another another xor problem - 交互题"
date: 2018-12-05 03:44:19 +0800
last_modified_at: 2018-12-05 03:44:19 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces", "交互题"]
---

## Codeforces 1088D - Ehab and another another xor problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/D

---
### 题目

**This is an interactive problem!**

Ehab plays a game with Laggy. Ehab has 2 hidden integers $(a,b)$. Laggy can ask a pair of integers $(c,d)$ and Ehab will reply with:

+ 1 if $a \oplus c>b \oplus d$. 
+ 0 if $a \oplus c=b \oplus d$. 
+ -1 if $a \oplus c<b \oplus d$. 
</ul>
Operation $a \oplus b$ is the <a href="https://en.wikipedia.org/wiki/Bitwise_operation#XOR">bitwise-xor operation</a> of two numbers $a$ and $b$.

Laggy should guess $(a,b)$ with **at most 62 questions**. You'll play this game. You're Laggy and the interactor is Ehab.

**It's guaranteed that $0 \le a,b<2^{30}$.**

---
### 题意

&emsp;&emsp;对方隐藏了两个数$a$、$b$，你可以做一次询问`? c d`，对方会返回`cmp(a ^ c, b ^ c)`的值，要你在62步之内询问出$a$、$b$的值是多少。

---
### 思路

&emsp;&emsp;总共有$30$位，给了$62$次机会，显然要逐个二进制搞一搞。对于最高位的二进制来说，不难发现，我们`query`一下`1 0`和`query`一下`0 1`的返回值会很有意思：

1. 如果当前最高位同为`1`，那么两次`query`的返回值一定为`-1`和`1`。
2. 如果当前最高位同为`0`，那么两次`query`的返回值一定为`1`和`-1`。
3. 如果当前最高位不同，那么两次`query`的返回值一定相同。

&emsp;&emsp;对于第三种情况看起来似乎有点难办？其实只要在最开始`query`一下`0 0`，根据返回值即可判断两个数的大小，那么最高位不同的时候大的那个数的最高位一定是`1`，另一个数则一定是`0`。随后更新一下两个数的大小关系即可。

&emsp;&emsp;对于如何取最高位的问题，其实我们只要把前面已经得到的部分二进制和原数`query`一下，那么比当前位高的二进制位就自然变为`0`了。

---
### 实现

https://pasteme.cn/2210

```cpp
## include <bits/stdc++.h>
int query(int a, int b, int ret = 0) {
    printf("? %d %d\n", a, b);
    fflush(stdout);
    scanf("%d", &ret);
    return ret;
}
int main() {
    int a = 0, b = 0;
    bool aIsBigger = true;
    if (query(a, b) < 0) aIsBigger = false;
    for (int i = 29; ~i; i--) {
        int x = query(a ^ (1 << i), b), y = query(a, b ^ (1 << i));
        if (x == y) {
            if (aIsBigger) a ^= (1 << i);
            else b ^= (1 << i);
            aIsBigger = (x == 1);
        } else if (x == -1 && y == 1) a ^= (1 << i), b ^= (1 << i);
    }
    printf("! %d %d\n", a, b);
    return 0;
}
```