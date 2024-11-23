---
title: "Codeforces-975B - Mancala - 思维"
date: 2018-05-03 09:08:00 +0800
last_modified_at: 2018-05-03 09:10:41 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接：

https://codeforces.com/contest/975/problem/B

---
### 题目：

Mancala is a game famous in the Middle East. It is played on a board that consists of 14 holes.


Initially, each hole has $a_i$ stones. When a player makes a move, he chooses a hole which contains a positive number of stones. He takes all the stones inside it and then redistributes these stones one by one in the next holes in a counter-clockwise direction.

Note that the counter-clockwise order means if the player takes the stones from hole $i$, he will put one stone in the $(i+1)$-th hole, then in the $(i+2)$-th, etc. If he puts a stone in the $14$-th hole, the next one will be put in the first hole.

After the move, the player collects all the stones from holes that contain even number of stones. The number of stones collected by player is the score, according to Resli.

Resli is a famous Mancala player. He wants to know the maximum score he can obtain after one move.

#### Input
The only line contains 14 integers $a_1,a_2,\dots ,a_{14}$ — the number of stones in each hole.

It is guaranteed that for any $i(1 \leq i \leq 14)\ a_i$ is either zero or odd, and there is at least one stone in the board.

#### Output
Output one integer, the maximum possible score after one move.

#### Examples
##### input
```
0 1 1 0 0 0 0 0 0 7 0 0 0 0
```
##### output
```
4
```
##### input
```
5 1 1 1 1 0 0 0 0 0 0 0 0 0
```
##### output
```
8
```
#### Note
In the first test case the board after the move from the hole with 7 stones will look like 1 2 2 0 0 0 0 0 0 0 1 1 1 1. Then the player collects the even numbers and ends up with a score equal to 4.

---
### 题意：

&emsp;&emsp;桌子上有$14$堆石头，初始时每堆石头要么有$0$个要么有奇数个，现在你必须选择一堆石头全部取走，假设选择了第$i$堆，然后把这些被拿走的石头分给第$(i + 1),(i+2),\dots ,(i+14),(i+1),(i+2),\dots$堆石头，每次分一个，直到你手里的石头全部分完，操作完之后桌子上所有石子数为偶数的堆所包含的石子数就是你的成绩，问最大能获得的成绩是多少。

---
### 思路：

&emsp;&emsp;`n`只有$14$，直接暴力枚举即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int num[17];
int main() {
//    freopen("in.txt", "r", stdin);
    for (int i = 0; i < 14; i++) scanf("%d", num + i);
    long long ans = 0, sum = 0;
    for (int i = 0, pre, tmp, left; i < 14; i++, sum = 0) {
        if (num[i]) {
            pre = num[i], tmp = num[i] / 14, left = num[i] % 14, num[i] = 0;
            for (int j = 1; j <= left; j++) {
                int cur = (j + i) % 14;
                if ((num[cur] + tmp + 1) % 2 == 0) {
                    sum += num[cur] + tmp + 1;
                }
            }
            for (int j = left + 1; j <= 14; j++) {
                int cur = (j + i) % 14;
                if ((num[cur] + tmp) % 2 == 0) {
                    sum += num[cur] + tmp;
                }
            }
            num[i] = pre;
            ans = std::max(ans, sum);
        }
    }
    printf("%lld\n", ans);
    return 0;
}
```