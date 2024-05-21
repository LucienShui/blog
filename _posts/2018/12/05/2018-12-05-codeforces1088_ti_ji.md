---
title: "Codeforces 1088 - 题集"
date: 2018-12-05 03:47:00 +0800
last_modified_at: 2018-12-05 12:41:29 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1088A - Ehab and another construction problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/A

---
### 题目

Given an integer $x$, find 2 integers $a$ and $b$ such that: 

+ $1 \le a,b \le x$ 
+ $b$ divides $a$ ($a$ is divisible by $b$). 
+ $a \cdot b > x$. 
+ $\frac{a}{b} < x$. 

---
### 题意

&emsp;&emsp;给你一个$x$，让你找一对$a$、$b$，使得$a$、$b$满足上述条件。

---
### 思路

&emsp;&emsp;显然$x$等于$1$的时候无解，故特判掉，之后虽然可以观察出来解，但还是证明一下吧。

&emsp;&emsp;令：$a = k \cdot b\ (k \in Z)$

&emsp;&emsp;则有：$k \cdot b \cdot b > x$、$k < x$同时成立。

&emsp;&emsp;不妨设：$k = 1$，则有：$b ^ 2 > x$，此时$a = b$，

&emsp;&emsp;即：取$a = b = x$即可。

---
### 实现

https://pasteme.cn/2207

```cpp
## include <bits/stdc++.h>
typedef long long ll;
int main() {
    ll x;
    std::cin >> x;
    if (x == 1) puts("-1");
    else printf("%lld %lld\n", x, x);
    return 0;
}
```
## Codeforces 1088B - Ehab and subtraction 

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/B

---
### 题目

You're given an array $a$. You should repeat the following operation $k$ times: find the minimum non-zero element in the array, print it, and then subtract it from all the non-zero elements of the array. If all the elements are 0s, just print 0.

---
### 题意

&emsp;&emsp;你有一个数组$a[n]$，你每次需要找出一个非$0$最小值$min\{a[n]\}$，然后输出这个最小值，并将这个数组中的每一个非$0$元素的值都减去这个最小值。如果这个最小值不存在则输出$0$。

---
### 思路

&emsp;&emsp;根据题意模拟即可。

---
### 实现

https://pasteme.cn/2208

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll base = 0;
std::priority_queue<ll, std::vector<ll>, std::greater<ll>> que;
int main() {
    ll n, k;
    std::cin >> n >> k;
    for (int i = 1, buf; i <= n; i++) std::cin >> buf, que.push(buf);
    while (k--) {
        while (!que.empty() && que.top() == base) que.pop();
        if (que.empty()) puts("0");
        else {
            printf("%lld\n", que.top() - base);
            base += que.top() - base;
            que.pop();
        }
    }
    return 0;
}
```
## Codeforces 1088C - Ehab and a 2-operation task

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/C

---
### 题目

You're given an array $a$ of length $n$. You can perform the following operations on it:

+ choose an index $i$ $(1 \le i \le n)$, an integer $x$ $(0 \le x \le 10^6)$, and replace $a_j$ with $a_j+x$ for all $(1 \le j \le i)$, which means add $x$ to all the elements in the prefix ending at $i$. 
+ choose an index $i$ $(1 \le i \le n)$, an integer $x$ $(1 \le x \le 10^6)$, and replace $a_j$ with $a_j \% x$ for all $(1 \le j \le i)$, which means replace every element in the prefix ending at $i$ with the remainder after dividing it by $x$. 

Can you make the array **strictly increasing** in no more than $n+1$ operations?

---
### 题意

&emsp;&emsp;初始时你有一个元素个数为$n$的数组，第$i$个元素的初始值为$a_i$，你有两种操作：

+ 将区间$[1, i]$中所有的数字都加上$x$
+ 将区间$[1, i]$中所有的数字都对$x$取模

&emsp;&emsp;问能否在$n + 1$步之内将这个序列变成一个严格递增的序列。

---
### 思路

&emsp;&emsp;考虑让$n$个数分别变为模意义下的$1 \dots n$，随便取一个大于$n$的模数，比如说$mod = n + 1$，也就是对于第$i$个数来说，我让其变为$k \cdot mod + i$，这样在进行了$n$次修改之后，第$n + 1$次修改我进行一次取模操作，第$i$个数就会变为$i$了。

---
### 实现

https://pasteme.cn/2209

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = 2007;
ll a[maxn], base = 0, cnt = 1;
int n, mod;
std::queue<std::pair<int, ll>> ans;
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%lld", a + i);
    mod = n + 1;
    for (int i = n; i >= 1; i--) {
        if ((a[i] + base) % mod == i) continue;
        cnt++;
        ll cur = a[i] + base, add = (mod - cur % mod) + i;
        base += add;
        ans.emplace(i, add);
    }
    printf("%lld\n", cnt);
    while (!ans.empty()) printf("1 %d %lld\n", ans.front().first, ans.front().second), ans.pop();
    printf("2 %d %d\n", n, mod);
    return 0;
}
```
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
## Codeforces 1088E - Ehab and a component choosing problem

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1088/problem/E

---
### 题目

You're given a tree consisting of $n$ nodes. Every node $u$ has a weight $a_u$. You want to choose an integer $k$ $(1 \le k \le n)$ and then choose $k$ connected components of nodes that don't overlap (i.e every node is in at most 1 component). Let the set of nodes you chose be $s$. You want to maximize:

$$\frac{\sum\limits_{u \in s} a_u}{k}$$

In other words, you want to maximize the sum of weights of nodes in $s$ divided by the number of connected components you chose. Also, if there are several solutions, you want to **maximize $k$**.

Note that adjacent nodes **can** belong to different components. Refer to the third sample.

---
### 题意

&emsp;&emsp;你有一个拥有 $n$ 个节点的树，你要选 $k$ 个联通块出来，使得这 $k$ 个联通块中所有点的权值总和 $sum$ 与联通块个数 $k$ 的比值最大，多解时应使联通块的数量尽可能地多。

---
### 思路

&emsp;&emsp;考虑贪心，先求出权值和最大的联通块的权值和，记为 $max$ ，然后统计有多少个联通块的权值和与 $max$ 相等即可，显然，这样的贪心策略是最优的。

---
### 实现

https://pasteme.cn/2211

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
int n, a[maxn], cnt;
std::vector<int> edge[maxn];
long long max = -(int(1e9) + 7);
long long dfs(int u, int pre, bool flag) {
    long long sum = a[u];
    for (int v : edge[u]) if (v != pre) sum += std::max(0ll, dfs(v, u, flag));
    if (!flag) max = std::max(max, sum);
    else if (sum == max) cnt++, sum = 0;
    return sum;
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", a + i);
    for (int i = 1, u, v; i < n; i++) {
        scanf("%d%d", &u, &v);
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1, 1, false), dfs(1, 1, true);
    printf("%lld %d\n", cnt * max, cnt);
    return 0;
}
```