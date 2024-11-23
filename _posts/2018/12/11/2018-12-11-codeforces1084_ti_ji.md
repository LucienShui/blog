---
title: "Codeforces 1084 - 题集"
date: 2018-12-11 05:02:00 +0800
last_modified_at: 2018-12-12 00:00:05 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## 单个题目的链接

[Codeforces 1084A - The Fair Nut and Elevator](https://blog.csdn.net/xs18952904/article/details/84949307)
[Codeforces 1084B - Kvass and the Fair Nut - 二分](https://blog.csdn.net/xs18952904/article/details/84949308)
[Codeforces 1084C - The Fair Nut and String](https://blog.csdn.net/xs18952904/article/details/84949309)
[Codeforces 1084D - The Fair Nut and the Best Path - 树形DP](https://blog.csdn.net/xs18952904/article/details/84949310)
[Codeforces 1084E - The Fair Nut and Strings - 思维](https://blog.csdn.net/xs18952904/article/details/84949311)

## Codeforces 1084A - The Fair Nut and Elevator

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/A

---
### 题意

&emsp;&emsp;有一个电梯，它初始时会停留在第 $k$ 层楼，每当有一个人要从第 $a$ 楼去第 $b$ 楼，电梯就会始终按照 $k \rightarrow a \rightarrow b \rightarrow k$ 的路线去运行，而且电梯最多只会同时容纳一个人，现在有一个 $n$ 层楼的楼房，第 $i$ 层有 $a_i$ 个人，这一层的每个人每天都要按照 $i \rightarrow 1 \rightarrow i$ 的顺序使用电梯，问将电梯的 $k$ 设为多少时，每天的运行距离最少。

---
### 思路

&emsp;&emsp;注意到 $n$ 只有 $100$，暴力枚举，复杂度 $O(n ^ 2)$。

---
### 实现

https://pasteme.cn/2418

```cpp
## include <bits/stdc++.h>
typedef long long ll;
ll a[1007], n, ans = 0x3f3f3f3f;
int main() {
    scanf("%lld", &n);
    for (ll i = 1; i <= n; i++) scanf("%lld", a + i);
    for (ll i = 1; i <= n; i++) {
        ll sum = 0;
        for (ll j = 1; j <= n; j++) sum += a[j] * 2 * (abs(i - j) + abs(j - 1) + abs(1 - i));
        ans = std::min(ans, sum);
    }
    printf("%lld\n", ans);
    return 0;
}
```
## Codeforces 1084B - Kvass and the Fair Nut - 二分

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/B

---
### 题意

&emsp;&emsp;你有 $n$ 桶水，第 $i$ 桶水里初始时有 $v_i$ 升水，你需要从这 $n$ 桶水中取出 $s$ 升水，问是否能取 $s$ 升水出来，如果可以的话让 $n$ 桶水剩下水最少的那桶水尽量的多。

---
### 思路

&emsp;&emsp;直接暴力二分即可，复杂度 $O(n \cdot log_2(v_{max}))$。

---
### 实现

https://pasteme.cn/2419

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = 1007;
ll v[maxn], n, s, max, sum;
bool check(ll mid) {
    ll ret = 0;
    for (int i = 1; i <= n; i++) {
        if (v[i] < mid) return false;
        ret += v[i] - mid;
    }
    return ret >= s;
}
int main() {
    std::cin >> n >> s;
    for (int i = 1; i <= n; i++) std::cin >> v[i], sum += v[i], max = std::max(v[i], max);
    if (sum < s) return 0 * puts("-1");
    ll l = 0, r = max, ret = -1;
    while (l <= r) {
        ll mid = l + r >> 1;
        if (check(mid)) ret = mid, l = mid + 1;
        else r = mid - 1;
    }
    std::cout << ret << std::endl;
    return 0;
}
```
## Codeforces 1084C - The Fair Nut and String

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/C

---
### 题意

&emsp;&emsp;给你一串字符串，问你能选出多少个形如 `aba` 这样的子序列（任意两个 `a` 之间至少包含一个 `b`），`a` 也算，`aba` 与 `abba` 与 `ab*ba` 算同一种，`aaba` 是非法的，复杂度 $O(n)$。

---
### 思路

&emsp;&emsp;显然可以只保留 `a` 和 `b`，然后把连续的 `a` 都提取出来，剩下的类似于统计 $DAG$ 不同路径数那样统计就可以。

---
### 实现

https://pasteme.cn/2420

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7, mod = int(1e9) + 7;
char buf[maxn], str[maxn] = {'b'};
int len = 0, cnt[maxn], n = 0;
int main() {
    scanf("%s", buf);
    for (int i = 0; buf[i]; i++) if (buf[i] <= 'b') str[++len] = buf[i];
    for (int i = 1; i <= len; i++) {
        if (str[i] == 'a') {
            if (str[i - 1] == 'b') cnt[++n] = 1;
            else cnt[n]++;
        }
    }
    long long ans = 0;
    for (int i = 1; i <= n; i++) ans = (ans + (ans + 1) * cnt[i] % mod) % mod;
    printf("%lld\n", ans);
    return 0;
}

```
## Codeforces 1084D - The Fair Nut and the Best Path - 树形DP

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1084/problem/D

---
### 题意

&emsp;&emsp;给你一棵树，数上的每个点都有一个正权值，每条边都有一个负权值，让你在树中找一条简单路径，使得权值和最大。

---
### 思路

&emsp;&emsp;我们定义 $f_i$ 为从以节点 $i$ 为根的子树中出发，到达节点 $i$ 时的最大权值和，转移方程为：

$$f_u = max\{f_v - cost_{u, v} + w_u\}$$

&emsp;&emsp;这样处理的是竖着的路径，其中 $v$ 是 $u$ 的每一个儿子。穿过节点 $i$ 的横向路径的最大值为：

$$({f_{v_1} - cost_{u, v_1}})_{最大值} + ({f_{v_2} - cost_{u, v_2}})_{次大值} + w_u$$

&emsp;&emsp;答案在所有 $f_i$ 与上述表达式中取最大值，复杂度为 $O(n)$。

---
### 实现

https://pasteme.cn/2421

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
std::vector<std::pair<int, long long>> edge[maxn];
long long ans = 0, f[maxn];
int n, w[maxn];
void dfs(int u, int pre) {
    f[u] = w[u];
    long long max[2] = {0, 0};
    for (auto cur : edge[u]) {
        int v = cur.first;
        long long cost = cur.second;
        if (v != pre) {
            dfs(v, u);
            long long tmp = f[v] - cost;
            if (tmp > max[0]) std::swap(max[0], tmp);
            max[1] = std::max(max[1], tmp);
            f[u] = std::max(f[u], f[v] - cost + w[u]);
        }
    }
    ans = std::max({f[u], ans, max[0] + max[1] + w[u]});
}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) scanf("%d", w + i);
    for (int i = 1, u, v, cost; i < n; i++) {
        scanf("%d%d%d", &u, &v, &cost);
        edge[u].emplace_back(v, cost);
        edge[v].emplace_back(u, cost);
    }
    dfs(1, 1);
    printf("%lld\n", ans);
    return 0;
}
```
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
## 总结

&emsp;&emsp;前三题还算顺利，$D$ 题的时候松懈了，然后就忘了统计横向的路径，`WA` 了两发，很影响心态，$E$ 比赛的时候没想出来。

&emsp;&emsp;两个队友一个第 $6$ 名，一个 $34$ 名，只有我一个 $200$ 多名。说实话，很难受，但也无法反驳什么，他们俩都比我要努力得多，唯一能做的就是加倍努力吧。