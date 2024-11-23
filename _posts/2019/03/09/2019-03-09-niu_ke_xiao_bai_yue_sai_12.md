---
title: "牛客小白月赛 12"
date: 2019-03-09 23:16:00 +0800
last_modified_at: 2019-03-10 07:34:21 +0800
math: true
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "动态规划", "桥"]
---

## 牛客小白月赛 12

比赛地址：https://ac.nowcoder.com/acm/contest/392

## A 华华听月月唱歌

按左端点排序之后贪心。

https://pasteme.cn/4381

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
struct Seg {
    int l, r;
    bool operator < (const Seg &tmp) const {
        return l < tmp.l;
    }
} seg[maxn];
int n, m, max[maxn];
int find(int x) {
    int l = 1, r = m, ret = -1, mid;
    while (l <= r) {
        mid = l + r >> 1;
        if (seg[mid].l > x) ret = mid, r = mid - 1;
        else l = mid + 1;
    }
    return ret;
}
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= m; i++) std::scanf("%d%d", &seg[i].l, &seg[i].r);
    seg[++m] = {int(1e9) + 7, 0};
    std::sort(seg + 1, seg + 1 + m);
    for (int i = 1; i <= m; i++) max[i] = std::max(max[i - 1], seg[i].r);
    int nxt = 1, cnt = 0;
    while (nxt <= n) {
        int index = find(nxt);
        if (index == -1 || max[index - 1] + 1 == nxt) return 0 * puts("-1");
        nxt = max[index - 1] + 1;
        cnt++;
    }
    printf("%d\n", cnt);
    return 0;
}
```

## B 华华教月月做数学

快速幂。

### C++

https://pasteme.cn/4383

```cpp
## include <bits/stdc++.h>
typedef __int128 ll;
long long qpow(ll p, ll q, ll mod) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return (long long) ret;
}
int main() {
    long long n, a, b, p;
    for (scanf("%lld", &n); n--; ) {
        scanf("%lld%lld%lld", &a, &b, &p);
        printf("%lld\n", qpow(a, b, p));
    }
    return 0;
}
```

### Python

https://pasteme.cn/4384

```python
n = int(input())
for i in range(n):
    a, b, p = map(int, input().split())
    print(pow(a, b, p))
```

## C 华华给月月出题

考虑到 $A ^ C \cdot B ^ C = (A \cdot B) ^ C$，素数筛即可，复杂度 $\frac{n}{log(n)} \cdot log(n) = O(n)$ 。

https://pasteme.cn/4382

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1.3e7 + 7), mod = int(1e9) + 7;
int qpow(ll p, ll q) {
    ll ret = 1;
    while (q) {
        if (q & 1) ret = ret * p % mod;
        p = p * p % mod;
        q >>= 1;
    }
    return int(ret);
}
int minimal_prime_factor[maxn], prime[maxn], ans[maxn], n;
int primes(int upper) {
    memset(minimal_prime_factor, 0, sizeof(minimal_prime_factor));
    int cnt_prime = 0, ret = 1;
    for (int i = 2; i <= upper; i++) {
        if (minimal_prime_factor[i] == 0) {
            minimal_prime_factor[i] = i;
            prime[++cnt_prime] = i;
            ans[i] = qpow(i, n);
        }
        int tmp = upper / i;
        for (int j = 1; j <= cnt_prime; j++) {
            if (prime[j] > minimal_prime_factor[i] || prime[j] > tmp) break;
            minimal_prime_factor[i * prime[j]] = prime[j];
            ans[i * prime[j]] = int(1ll * ans[i] * ans[prime[j]] % mod);
        }
        ret ^= ans[i];
    }
    return ret;
}
int main() {
    scanf("%d", &n);
    printf("%d\n", primes(n));
    return 0;
}
```

## E 华华给月月准备礼物

二分。

https://pasteme.cn/4385

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
int n, k, len[maxn];
bool check(int x) {
    int cnt = 0;
    for (int i = 1; i <= n && cnt < k; i++) if (len[i] >= x) cnt += len[i] / x;
    return cnt >= k;
}
int main() {
    scanf("%d%d", &n, &k);
    int l = 1, r = 0, ans = 0;
    for (int i = 1; i <= n; i++) scanf("%d", len + i), r = std::max(len[i], r);
    while (l <= r) {
        int mid = l + r >> 1;
        if (check(mid)) l = mid + 1, ans = mid;
        else r = mid - 1;
    }
    printf("%d\n", ans);
    return 0;
}
```

## G 华华对月月的忠诚

$GCD(F_N, F_{N + 1}) = GCD(F_N, F_{N - 1} + F_N) = GCD(F_{N - 1}, F_N) = \dots = GCD(F_1, F_2)$

https://pasteme.cn/4387

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll gcd(ll p, ll q) { return q ? gcd(q, p % q) : p; }
int main() {
    ll a, b;
    scanf("%lld%lld\n", &a, &b);
    printf("%lld\n", gcd(a, b));
    return 0;
}
```

## I 华华和月月逛公园

考虑一棵树上加一些非树边，所以答案就是总边数剪去割边数。

https://pasteme.cn/4386

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
std::vector<int> edge[maxn];
struct pair {
    int first, second;
    bool operator < (const pair &tmp) const {
        return first == tmp.first ? second < tmp.second : first < tmp.first;
    }
};
struct Set {
    std::set<pair> set;
    void insert(int u, int v) {
        if (u > v) std::swap(u, v);
        set.insert({u, v});
    }
} set;
int dfn[maxn], low[maxn], Time;
void findcut(int u, int pre) {
    dfn[u] = low[u] = Time++;
    for(auto v : edge[u]) {
        if(dfn[v] == -1) {
            findcut(v, u);
            low[u] = std::min(low[u], low[v]);
            if(low[v] > dfn[u]) {
                set.insert(u, v);
            }
        }
        else if(pre != v) low[u] = std::min(low[u], dfn[v]);
    }
}
int main() {
    memset(dfn, 0xff, sizeof(dfn));
    int n, m;
    scanf("%d%d", &n, &m);
    for (int i = 1, u, v; i <= m; i++) {
        scanf("%d%d", &u, &v);
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    set.set.clear();
    for(int i=1 ; i<=n ; i++) if(dfn[i] == -1) findcut(i,i);
    printf("%d\n", m - set.set.size());
    return 0;
}
```

## J 月月查华华的手机

$f[i][j]$ 表示第 $i$ 个位置之后 $j$ 第一次出现的位置。

https://pasteme.cn/4388

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e6) + 7;
int f[maxn][26], n;
void init(char *str, int len) {
    for (int i = len; i >= 1; i--) {
        str[i] -= 'a';
        for (int j = 0; j < 26; j++) {
            if (j == str[i]) f[i - 1][j] = i;
            else f[i - 1][j] = f[i][j];
        }
    }
}
bool check(char *str) {
    int cur = 0;
    for (int i = 0; str[i]; i++) {
        cur = f[cur][str[i] - 'a'];
        if (!cur) return false;
    }
    return true;
}
char str[maxn];
int main() {
    scanf(" %s", str + 1);
    init(str, strlen(str + 1));
    for (scanf("%d", &n); n--; ) {
        scanf(" %s", str);
        puts(check(str) ? "Yes" : "No");
    }
    return 0;
}
```
