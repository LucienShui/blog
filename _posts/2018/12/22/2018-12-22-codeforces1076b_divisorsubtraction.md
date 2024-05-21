---
title: "Codeforces 1076B - Divisor Subtraction"
date: 2018-12-22 17:24:43 +0800
last_modified_at: 2018-12-22 17:24:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1076B - Divisor Subtraction

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1076/problem/B

---
### 题意

你有一个程序 $f(n)$：

1. 如果 $n = 0$ 结束程序
2. 找到 $n$ 的最小质因数 $d$
3. $n = n - d$ ，然后回到步骤 $1$

问这个程序会执行多少次减法。

---
### 思路

偶数的最小质因数是 $2$ ，不论怎么减都是偶数，所以会减 $\frac{n}{2}$ 次。

奇数的最小质因数一定是一个奇数，做一次减法之后就会变成偶数。

分类讨论一下就可以了。

---
### 实现

https://pasteme.cn/2740

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
long long n;
bool prime[maxn];
bool isprime(long long x) {
    for (long long i = 2; i * i <= x; i++) if (x % i == 0) return false;
    return true;
}
int main() {
## ifdef AC
    freopen("../in", "r", stdin);
## endif
    memset(prime, true, sizeof(prime));
    for (int i = 2; i < maxn; i++) {
        if (!prime[i]) continue;
        for (int j = i + i; j < maxn; j += i) prime[j] = false;
    }
    scanf("%lld", &n);
    long long ans = n;
    if (ans & 1) {
        if (isprime(ans)) return 0 * puts("1");
        for (int i = 3; i <= ans; i++) {
            if (ans % i == 0 && prime[i]) {
                ans -= i;
                break;
            }
        }
    }
    printf("%lld\n", ans / 2 + (n & 1));
    return 0;
}
```