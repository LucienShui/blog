---
title: "Codeforces-846A - Curriculum Vitae - LCS"
date: 2018-01-23 16:30:00 +0800
last_modified_at: 2018-01-31 16:52:40 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目：
Hideo Kojima has just quit his job at Konami. Now he is going to find a new place to work. Despite being such a well-known person, he still needs a CV to apply for a job.

During all his career Hideo has produced n games. Some of them were successful, some were not. Hideo wants to remove several of them (possibly zero) from his CV to make a better impression on employers. As a result there should be no unsuccessful game which comes right after successful one in his CV.

More formally, you are given an array s1, s2, ..., sn of zeros and ones. Zero corresponds to an unsuccessful game, one — to a successful one. Games are given in order they were produced, and Hideo can't swap these values. He should remove some elements from this array in such a way that no zero comes right after one.

Besides that, Hideo still wants to mention as much games in his CV as possible. Help this genius of a man determine the maximum number of games he can leave in his CV.

#### Input
The first line contains one integer number n (1 ≤ n ≤ 100).

The second line contains n space-separated integer numbers s1, s2, ..., sn (0 ≤ si ≤ 1). 0 corresponds to an unsuccessful game, 1 — to a successful one.

#### Output
Print one integer — the maximum number of games Hideo can leave in his CV so that no unsuccessful game comes after a successful one.

#### Examples
input
```
4
1 1 0 1
```
output
```
3
```
input
```
6
0 1 0 0 1 0
```
output
```
4
```
input
```
1
0
```
output
```
1
```

---
### 题意：

&emsp;&emsp;给n个只含0 1的数列，可以删去任意位置的数，使的数列满足0在1的左边（即没有1在0左边），求满足条件的序列的最大长度。

---
### 思路：

&emsp;&emsp;求一下最长上升子序列就可以。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
int main() {
    int n, s[107], ans[107], len;
    while(len = 1, ~scanf("%d", &n)) {
        for(int i=0 ; i<n ; i++) scanf("%d", s+i);
        ans[0] = s[0];
        for(int i=1 ; i<n ; i++) {
            if(s[i] >= ans[len-1]) ans[len++] = s[i];
            else ans[upper_bound(ans, ans+len, s[i])-ans] = s[i];
        }
        printf("%d\n", len);
    }
    return 0;
}
```