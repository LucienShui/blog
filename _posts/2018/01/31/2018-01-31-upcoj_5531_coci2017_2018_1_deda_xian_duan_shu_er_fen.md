---
title: "UPCOJ-5531 [COCI 2017-2018-1] - Deda - 线段树 + 二分"
date: 2018-01-31 12:48:00 +0800
last_modified_at: 2018-05-23 18:20:07 +0800
math: false
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "题解"]
---

### 链接：

https://www.lucien.ink/go/UPC5531/

### 题目：

#### 题目描述
Little Marica is making up a nonsensical unusual fairy tale and is telling to her grandfather who keeps interrupting her and asking her stupid intriguing questions. 
In Marica’s fairy tale, N children, denoted with numbers from 1 to N by their age (from the youngest denoted with 1, to the oldest denoted with N), embarked on a train ride. The train leaves from the station 0 and stops in order at stations 1, 2, 3 … to infinity. 
Each of the following Marica’s statements is of the form: “At stop X, child A got out”,where the order of these statements is completely arbitrary. In other words, it does not 
depend on the station order. Her grandfather sometimes asks a question of the form: 
“Based on the statements so far, of the children denoted with a number greater than
or equal to B, who is the youngest child that rode for Y or less stops?” If at the 
moment the grandfather asks the question it hasn’t been said so far that a child is getting off the train, we assume that the child is riding for an infinite amount of stops.
Marica must give a correct answer to each of her grandfather’s questions, otherwise the  
grandfather will get mad and go to sleep. The answer must be correct in the moment when 
the grandfather asks the question, while it can change later given Marica’s new statements,but that doesn’t matter. Write a program that tracks Marica’s statements and answers her grandfather’s questions. 
#### 输入
The first line of input contains the positive integers N and Q (2 ≤ N, Q ≤ 200 000), the  number of children and the number of statements. Each of the following Q lines describes: 
● either Marica’s statement of the form “M” X A, where “M” denotes Marica, and X and A are positive integers (1 ≤ X ≤ 1 000 000 000, 1 ≤ A ≤ N ) from the task, 
● or her grandfather’s question of the form “D” Y B , where “D” denotes the grandfather,and Y and B are positive integers (1 ≤ Y ≤ 1 000 000 000, 1 ≤ B ≤ N ) from the task. 
All of Marica’s statements correspond to different children and at least one line in the input is her grandfather’s question. 
#### 输出
For each grandfather’s question, output the number of the required child in its own line. If no such child exists, output -1. 
#### 样例输入
```
3 4
M 10 3
M 5 1
D 20 2
D 5 1
```
#### 样例输出
```
3
1
```

---
### 题意：

&emsp;&emsp;有一辆车上有n个小孩，年龄为`1~n`，然后q个询问，`M X A`代表在第`X`站时年龄为`A`的小孩会下车，`D Y B`代表询问年龄大于等于`B`且在第`Y`站（包含第`Y`站）以前下车的年龄最小的小孩，如果不存在，则输出`-1`。

---
### 思路：

&emsp;&emsp;写一个长度为n的线段树，`min[i]`代表年龄为`i`的孩子在第`min[i]`站下车，初始为无穷大。这样在询问的时候就只需要关心`[B, n]`这个区间，考虑二分答案，我们通过线段树维护某个年龄段里所有孩子的最早在第几站下的车，这样就可以通过查询区间最小值并和`Y`进行比较来判断是否合法，合法的话继续向左二分找到最小的那个孩子即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
## define lson u << 1
## define rson u << 1 | 1
const int maxn = int(1e6) + 7;
int min[maxn], n, q, a, b;
char op;
void pushup(int u) { min[u] = std::min(min[lson], min[rson]); }
void update(int aim, int val, int l = 1, int r = n, int u = 1) {
    if (l == r) min[u] = val;
    else {
        int mid = l + r >> 1;
        if (aim <= mid) update(aim, val, l, mid, lson);
        else update(aim, val, mid + 1, r, rson);
        pushup(u);
    }
}
int query(int begin, int end, int l = 1, int r = n, int u = 1) {
    if (begin <= l && r <= end) return min[u];
    int mid = l + r >> 1;
    if (end <= mid) return query(begin, end, l, mid, lson);
    else if (begin > mid) return query(begin, end, mid + 1, r, rson);
    return std::min(query(begin, end, l, mid, lson), query(begin, end, mid + 1, r, rson));
}
int main() {
//    freopen("in.txt", "r", stdin);
    memset(min, 0x7f, sizeof(min));
    scanf("%d%d", &n, &q);
    while (q--) {
        scanf(" %c%d%d", &op, &a, &b);
        if (op == 'M') update(b, a);
        else {
            int l = b, r = n, mid, ans = -1;
            while (l <= r) {
                mid = l + r >> 1;
                if (query(l, mid) <= a) r = mid - 1, ans = mid;
                else l = mid + 1;
            }
            printf("%d\n", ans);
        }
    }
    return 0;
}
```