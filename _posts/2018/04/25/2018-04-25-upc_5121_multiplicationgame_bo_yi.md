---
title: "UPC-5121 - Multiplication Game - 博弈"
date: 2018-04-25 00:27:00 +0800
last_modified_at: 2018-04-25 00:27:54 +0800
math: true
render_with_liquid: false
categories: ["ACM", "博弈"]
tags: ["博弈"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5121

---
### 题目：

#### 题目描述
Alice and Bob are in their class doing drills on multiplication and division. They quickly get bored and instead decide to play a game they invented.
The game starts with a target integer N≥2, and an integer M = 1. Alice and Bob take alternate turns. At each turn, the player chooses a prime divisor p of N, and multiply M by p. If the player’s move makes the value of M equal to the target N, the player wins. If M > N, the game is a tie.
Assuming that both players play optimally, who (if any) is going to win?
#### 输入
The first line of input contains T (1≤T≤10000), the number of cases to follow. Each of the next T lines describe a case. Each case is specified by N (2≤N≤231-1) followed by the name of the player making the first turn. The name is either Alice or Bob.
#### 输出
For each case, print the name of the winner (Alice or Bob) assuming optimal play, or tie if there is no winner.
#### 样例输入
```
10
10 Alice
20 Bob
30 Alice
40 Bob
50 Alice
60 Bob
70 Alice
80 Bob
90 Alice
100 Bob
```
#### 样例输出
```
Bob
Bob
tie
tie
Alice
tie
tie
tie
tie
Alice
```

---
### 题意：

&emsp;&emsp;初始的时候有一个数字$m = 1$，然后给你一个数字`n`，每次你可以从`n`的所有素因子中拿出一个乘到$m$上去，如果谁乘完之后$m$刚好等于$n$，则获胜，给你先手的人，然后输出谁能赢，如果$m>n$则输出`tie`。

---
### 思路：

&emsp;&emsp;先预处理出每个数字的所有素因子，然后开始判断，如果素因子的个数大于2则一定是平局，因为两个人都没有必胜的方法。

&emsp;&emsp;如果等于2，则比较一下这两个素因子出现次数，如果相差大于1，则是平局，原因同上。如果相等则后手必胜，不管每次先手选什么，后手就选和先手相对的那个，这样的话就一定可以后手必胜，相当于是一个奇异局势。不相等就先手必胜，因为两种素因子只相差一个，拿掉多的那一个，就转化成了奇异局势。

&emsp;&emsp;如果只有一个素因子的话判断一下出现的奇偶次数，奇数次就先手必胜，否则后手必胜。

---
### 实现：

```cpp
## include <bits/stdc++.h>
int prime[18000], a[18000], len;
std::map<int, int> cnt;
bool check[int(2e5) + 7];
int printprime(int N) {
    memset(check, false, sizeof(check));
    int tot = 0;
    for(int i=2 ; i<=N ; ++i){
        if (! check[i]) prime[tot++] = i;
        for(int j=0 ; j<tot ; j++) {
            if(i * prime[j] > N) break;
            check [i * prime[j]] = true;
            if(i % prime[j] == 0) break;
        }
    }
    return tot;
}
char s[2][107] = {"Alice", "Bob"}, name[107];

int main() {
//    freopen("in.txt", "r", stdin);
    int tot = printprime(int(2e5));
    int _, n, fis, sec;
    scanf("%d", &_);
    while (_--) {
        cnt.clear();
        len = 0;
        scanf("%d %s", &n, name);
        if (name[0] == 'A') fis = 0, sec = 1;
        else fis = 1, sec = 0;
        int tmp = n;
        for (int i = 0; i < tot && tmp != 1; i++)
            if (tmp % prime[i] == 0)
                while (tmp % prime[i] == 0) {
                    if (cnt[prime[i]] == 0) a[len++] = prime[i];
                    cnt[prime[i]]++;
                    tmp /= prime[i];
                }
        if (tmp != 1) a[len++] = tmp, cnt[tmp]++;
        if (len == 1) {
            if (cnt[a[0]] & 1) puts(s[fis]);
            else puts(s[sec]);
            continue;
        } else if (len == 2) {
            int l = cnt[a[0]], r = cnt[a[1]];
            int x = abs(r - l);
            if (x > 1) puts("tie");
            else {
                if (l == r) puts(s[sec]);
                else puts(s[fis]);
            }
        } else puts("tie");
    }
    return 0;
}
```