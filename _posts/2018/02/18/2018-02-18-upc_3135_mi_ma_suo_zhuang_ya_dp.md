---
title: "UPC-3135 - 密码锁 - 状压DP"
date: 2018-02-18 11:56:00 +0800
last_modified_at: 2018-02-21 16:38:15 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
---

### 链接：

https://exam.upc.edu.cn/problem.php?id=3135

---
### 题目：

#### 题目描述
hzwer有一把密码锁，由N个开关组成。一开始的时候，所有开关都是关上的。当且仅当开关x1,x2,x3,...xk为开，其他开关为关时，密码锁才会打开。
他可以进行M种的操作，每种操作有一个size[i]，表示，假如他选择了第i种的操作的话，他可以任意选择连续的size[i]个格子，把它们全部取反。（注意，由于黄金大神非常的神，所以操作次数可以无限>_<）
本来这是一个无关紧要的问题，但是，黄金大神不小心他的钱丢进去了，没有的钱他哪里能逃过被chenzeyu97 NTR的命运？>_<  于是，他为了虐爆czy，也为了去泡更多的妹子，决定打开这把锁。但是他那么神的人根本不屑这种”水题”。于是，他找到了你。
你的任务很简单，求出最少需要多少步才能打开密码锁，或者如果无解的话，请输出-1。
#### 输入
第1行，三个正整数N，K，M，如题目所述。
第2行，K个正整数，表示开关x1,x2,x3..xk必须为开，保证x两两不同。
第三行，M个正整数，表示size[i]，size[]可能有重复元素。
#### 输出
输出答案，无解输出-1。
#### 样例输入
```
10 8 2
1 2 3 5 6 7 8 9
3 5
```
#### 样例输出
```
2
```
#### 提示
对于50%的数据，1≤N≤20，1≤k≤5，1≤m≤3;
对于另外20%的数据，1≤N≤10000，1≤k≤5,1≤m≤30;
对于100%的数据，1≤N≤10000，1≤k≤10，1≤m≤100。

---
### 思路：

&emsp;&emsp;假设最终状态是：`1 1 1 0 1 0`
&emsp;&emsp;差分一下：&emsp;&emsp;&emsp;`1 0 0 1 1 1`
&emsp;&emsp;四个1分别出现在1，4，5，6四个位置，代表$[1, 4)$和$[5, 6)$这两个区间里的数都是`1`。
&emsp;&emsp;先处理出每一段区间全部变成`1`所需要的最少操作数，然后我们可以发现，取反这两个区间和取反$[1,5)$，$[4,6)$这两个区间是等价的，所以这些数可以随机两两组合来进行变换，每次变换的加起来就是这种方案的操作数。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int inf = 0x3f3f3f3f, maxn = int(1e4) + 7, maxm = int(2e6) + 7, cache = 1 << 16;
char buf[cache];
size_t curl, curr;
inline char get() {
    if (curl == curr) { curl = 0, curr = fread(buf, 1, cache, stdin); if (curr == curl) return EOF; }
    return buf[curl++];
}
inline int read(int x = 0, char c = '0') {
    do c = get(); while (!isdigit(c)); x = c ^ '0'; while (isdigit(c = get())) x = x * 10 + (c ^ '0');
    return x;
}
int n, k, m, cnt, dist[maxn], dp[maxm], mp[27][27], a[maxn], sz[maxn], num[maxn];
bool mark[maxn], vis[maxn];
std::queue<int> que;
void bfs(int x, int now = 0) {
    memset(vis, 0, sizeof(vis));
    dist[x] = 0, vis[x] = true;
    que.push(x);
    while (!que.empty()) {
        now = que.front(), que.pop();
        for (int i = 1; i <= m; i++) {
            if (now + sz[i] <= n && (!vis[now + sz[i]])) {
                vis[now + sz[i]] = true;
                dist[now + sz[i]] = dist[now] + 1;
                que.push(now + sz[i]);
            }
            if (now - sz[i] > 0 && (!vis[now - sz[i]])) {
                vis[now - sz[i]] = true;
                dist[now - sz[i]] = dist[now] + 1;
                que.push(now - sz[i]);
            }
        }
    }
    for (int i = 1; i <= n; i++) if (num[i]) mp[num[x]][num[i]] = vis[i] ? dist[i] : inf;
}
int dfs(int x, int st = 0) {
    if (!x) return 0;
    if (~dp[x]) return dp[x];
    dp[x] = inf;
    for (int i = 1; i <= cnt; i++)
        if (x & (1 << (i - 1))) {
            if (!st) st = i;
            else if (mp[st][i] != inf) dp[x] = std::min(dp[x], dfs(x ^ (1 << (st - 1)) ^ (1 << (i - 1))) + mp[st][i]);
        }
    return dp[x];
}
int main() {
//    freopen("in.txt", "r", stdin);
    memset(dp, -1, sizeof(dp));
    n = read(), k = read(), m = read();
    for (int i = 1; i <= k; i++) mark[a[i] = read()] = true;
    for (int i = 1; i <= m; i++) sz[i] = read();
    for (int i = ++n; i; i--) mark[i] ^= mark[i - 1];
    for (int i = 1; i <= n; i++) if (mark[i]) num[i] = ++cnt;
    for (int i = 1; i <= n; i++) if (mark[i]) bfs(i);
    printf("%d\n", dfs((1 << cnt) - 1) == inf ? -1 : dp[(1 << cnt) - 1]);
    return 0;
}
```