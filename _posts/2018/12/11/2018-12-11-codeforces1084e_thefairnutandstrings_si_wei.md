---
title: "Codeforces 1084E - The Fair Nut and Strings - 思维"
date: 2018-12-11 04:58:18 +0800
last_modified_at: 2018-12-11 04:58:18 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维", "codeforces"]
---

## Codeforces 1084E - The Fair Nut and Strings - 思维

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/E

---
### 题意

&emsp;&emsp;给你一个区间 $[s, t]$，其中 $s$ 和 $t$ 都是字符串，且长度为 $n$，只包含 `ab` 两种字符，问从这个区间内长度为 $n$ 的字符串中挑出 $k$ 个，最多可以有多少个不同的前缀。

---
### 思路

&emsp;&emsp;翻译一下，其实就是给你一个有左右边界且叶子数量必须小于等于 $k$ 个的字典树，最多能有多少个节点，模拟一下即可。

---
### 实现

https://pasteme.cn/2422

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(5e5) + 7;
ll n, k, ans;
char a[maxn], b[maxn];
bool flag = true;
int main() {
    scanf("%lld%lld%s%s", &n, &k, a + 1, b + 1);
    ll sum = -1, cur = 1;
    while (cur <= n && a[cur] == b[cur]) cur++, ans++;
    for (ll i = cur; i <= n && flag; i++) {
        sum = sum * 2 + 'b' - a[i] + b[i] - 'a';
        if (sum + 2 >= k) ans += (n - i + 1) * k, flag = false;
        else ans += sum + 2;
    }
    printf("%lld\n", ans);
    return 0;
}
```