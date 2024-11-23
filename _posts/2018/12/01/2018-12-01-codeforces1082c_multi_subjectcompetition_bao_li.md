---
title: "Codeforces 1082C - Multi-Subject Competition - 暴力"
date: 2018-12-01 01:30:06 +0800
last_modified_at: 2018-12-01 01:30:06 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "codeforces"]
---

## Codeforces 1082C - Multi-Subject Competition - 暴力

### 题解链接

https://lucien.ink

------

### 题目链接

https://codeforces.com/contest/1082/problem/C

------

### 题目

A multi-subject competition is coming! The competition has $m$ different subjects participants can choose from. That's why Alex (the coach) should form a competition delegation among his students. 

He has $n$ candidates. For the $i$-th person he knows subject $s_i$ the candidate specializes in and $r_i$ — a skill level in his specialization (this level can be negative!). 

The rules of the competition require each delegation to choose some subset of subjects they will participate in. The only restriction is that the **number of students from the team** participating in each of the **chosen** subjects should be the **same**.

Alex decided that each candidate would participate only in the subject he specializes in. Now Alex wonders whom he has to choose to maximize the total sum of skill levels of all delegates, or just skip the competition this year if every valid non-empty delegation has negative sum.

(Of course, Alex doesn't have any spare money so each delegate he chooses must participate in the competition).

------

### 题意

&emsp;&emsp;有$n$个人，$m$个项目，每个人只对一个项目熟悉且拥有一个熟练度，熟练度可以为负，你要选择一些人，参加一些项目（某个项目可以没有人参加），使得有人参加的任意两个项目的人数都相同，且所有项目的熟练度和最大，输出这个最大值。

------

### 思路

&emsp;&emsp;所有相同的项目都存在一起，然后对于单个项目排序一下，再记一下前缀和，然后暴力就可以了。显然，抛开排序的复杂度，暴力部分的复杂度为$O(n)$。

------

### 实现

```cpp
## include <bits/stdc++.h>
typedef long long ll;
const int maxn = int(1e5) + 7;
std::vector<int> project[maxn];
std::vector<ll> sum[maxn];
int n, m, id[maxn], max_len;
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, x, y; i <= n; i++) {
        scanf("%d%d", &x, &y);
        project[x].push_back(y);
    }
    for (int j = 1; j <= m; j++) id[j] = j;
    std::sort(id + 1, id + 1 + m, [](int x, int y) { return project[x].size() > project[y].size(); });
    for (int i = 1; i <= m; i++) {
        int cur = id[i];
        if (project[cur].empty()) break;
        int len = int(project[cur].size());
        max_len = std::max(len, max_len);
        std::sort(project[cur].begin(), project[cur].end(), std::greater<int>());
        sum[cur].resize(project[cur].size());
        sum[cur][0] = project[cur][0];
        for (int j = 1; j < len; j++) sum[cur][j] = sum[cur][j - 1] + project[cur][j];
    }
    ll ans = 0;
    for (int i = 1; i <= max_len; i++) {
        ll ans_buf = 0;
        for (int j = 1; j <= m; j++) {
            int cur = id[j];
            if (project[cur].size() < i) break;
            if (sum[cur][i - 1] > 0) ans_buf += sum[cur][i - 1];
        }
        ans = std::max(ans, ans_buf);
    }
    printf("%lld\n", ans);
    return 0;
}

```