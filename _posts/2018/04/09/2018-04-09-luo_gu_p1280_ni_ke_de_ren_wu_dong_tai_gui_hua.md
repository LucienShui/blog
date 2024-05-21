---
title: "洛谷P1280 - 尼克的任务 - 动态规划"
date: 2018-04-09 20:26:35 +0800
last_modified_at: 2018-04-09 20:26:35 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1280

---
### 题目：

#### 题目描述

尼克每天上班之前都连接上英特网，接收他的上司发来的邮件，这些邮件包含了尼克主管的部门当天要完成的全部任务，每个任务由一个开始时刻与一个持续时间构成。

尼克的一个工作日为N分钟，从第一分钟开始到第N分钟结束。当尼克到达单位后他就开始干活。如果在同一时刻有多个任务需要完成，尼克可以任选其中的一个来做，而其余的则由他的同事完成，反之如果只有一个任务，则该任务必需由尼克去完成，假如某些任务开始时刻尼克正在工作，则这些任务也由尼克的同事完成。如果某任务于第P分钟开始，持续时间为T分钟，则该任务将在第P+T-1分钟结束。

写一个程序计算尼克应该如何选取任务，才能获得最大的空暇时间。

#### 输入格式：
输入数据第一行含两个用空格隔开的整数N和K(1≤N≤10000，1≤K≤10000)，N表示尼克的工作时间，单位为分钟，K表示任务总数。

接下来共有K行，每一行有两个用空格隔开的整数P和T，表示该任务从第P分钟开始，持续时间为T分钟，其中1≤P≤N，1≤P+T-1≤N。

#### 输出格式：
输出文件仅一行，包含一个整数，表示尼克可能获得的最大空暇时间。

#### 输入样例#1：
```
15 6
1 2
1 6
4 11
8 5
8 1
11 5
```
#### 输出样例#1：
```
4
```

---
### 思路：

&emsp;&emsp;本来想强行写一发正着DP的，$dp[i]$代表到第`i`时刻时的最大空闲时间，可是发现并不能得到正确的答案。因为拿来DP的条件只有`假如某些任务开始时刻尼克正在工作，则这些任务也由尼克的同事完成`，也就是说一旦有任务开始，那么他就不可能再得到新的工作，所以某个任务开始前的最优解一定可以从结束前的最优解直接更新过来。于是便可以分为两种情况：

&emsp;&emsp;如果此刻没有任务：$dp[i] = dp[i + 1] + 1$

&emsp;&emsp;如果此刻有任务：$dp[i] = max(dp[i], dp[i + t[j]])$，$t[j]$表示这个任务的持续时间。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
int n, k, cnt[maxn], dp[maxn], cur = 1;
struct Node {
    int begin, len;
    bool operator < (const Node &tmp) const { return begin > tmp.begin; }
} job[maxn];
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d", &n, &k);
    for (int i = 1; i <= k; i++) {
        scanf("%d%d", &job[i].begin, &job[i].len);
        cnt[job[i].begin]++;
    }
    std::sort(job + 1, job + 1 + k);
    for (int i = n; i >= 1; i--) {
        if (cnt[i]) for (int j = 1; j <= cnt[i]; j++) dp[i] = std::max(dp[i], dp[i + job[cur++].len]);
        else dp[i] = dp[i + 1] + 1;
    }
    printf("%d\n", dp[1]);
    return 0;
}
```