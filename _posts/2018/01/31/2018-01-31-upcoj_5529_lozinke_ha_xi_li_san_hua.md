---
title: "UPCOJ-5529 - Lozinke - 哈希 + 离散化"
date: 2018-01-31 12:50:00 +0800
last_modified_at: 2018-01-31 16:51:44 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维"]
---

### 链接：

https://exam.upc.edu.cn/problem.php?id=5529

---
### 题目：

#### 题目描述
Recently, there has been a breach of user information from the mega-popular social network Secret Network. Among the confidential information are the passwords of all users.
Mihael, a young student who has been exploring computer security lately, found the whole thing really interesting. While experimenting with the social network, he found another security breach! When you input any string of characters that contains a substring equal to the actual password, the login will be successful. For example, if the user whose password is abc inputs one of the strings abc, abcd or imaabcnema, the system will successfully log him in, whereas the login will fail for axbc. 
Mihael wants to know how many ordered pairs of different users exist such that the first user, using their own password, can login as the second user. 
#### 输入
The first line of input contains the positive integer N (1 ≤ N ≤ 20 000), the number of users. 
Each of the following N lines contains the user passwords. The passwords consist of at least one and at most 10 lowercase letters of the English alphabet. 
#### 输出
The first and only line of output must contains the number of ordered pairs from the task. 
#### 样例输入
```
3
aaa
aa
abb
```
#### 样例输出
```
1
```
#### 提示
In test cases worth 40 points total, it will hold 1 ≤N≤ 2000. The first user can login as the second user, the second user can login as the first, and the third user can login as both the first and the second user. 

---
### 题意：

&emsp;&emsp;如果一个用户A的密码内含有另一个用户B的密码，那么A用户就可以登录B用户的账号。问有多少对这样的用户存在，使得前者可以登录后者的账号。

---
### 思路：

&emsp;&emsp;观察到字符串长度只有10，考虑暴力哈希出每个密码串的所有子串，统计一下数目，然后再枚举每个原密码串，如果某个原密码串在cnt数组里出现超过一次，说明这个密码串可以被别人登录，对答案的贡献就是$cnt-1$。哈希会爆`int`，所以先$O(100\times n)$离散化一下，然后再$O(100\times n \times log_{10}{(2^6)})$统计一下$cnt$，为了去重还要再加一个时间戳，最后$O(n)$统计答案，最后的总复杂度是$O(n)$再乘一个常数。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
char s[17];
unsigned long long val[20007][17], p[17], ans, lisan[2000007];
int len[20007], tot = 0, dfn[2000007], cnt[2000007], val_tmp;
unsigned long long get(int cur, int l, int r) { return val[cur][r] - val[cur][l - 1] * p[r - l + 1]; } //得到cur这个串对应l到r区间内的哈希值
int main() {
//    freopen("in.txt", "r", stdin);
    p[0] = 1; for (int i = 1; i <= 11; i++) p[i] = p[i - 1] * 117;
    int n, len_; scanf("%d", &n);
    for (int cur = 1; cur <= n; cur++) {
        scanf("%s", s + 1);
        len[cur] = len_ = int (strlen(s + 1));
        for (int i = 1; i <= len_; i++) val[cur][i] = val[cur][i - 1] * 117 + (s[i] - 'a' + 1); //哈希字符串
        for (int l = 1; l <= len_; l++) for (int r = l; r <= len_; r++) lisan[tot++] = get(cur, l, r); //离散化开始
    }
    sort(lisan, lisan + tot);
    tot = int (unique(lisan, lisan + tot) - lisan); //离散化结束
    for (int cur = 1; cur <= n; cur++) {
        len_ = len[cur];
        for (int l = 1; l <= len_; l++) for (int r = l; r <= len_; r++) {
                val_tmp = int (lower_bound(lisan, lisan + tot, get(cur, l, r)) - lisan);
                if (dfn[val_tmp] != cur) cnt[val_tmp]++, dfn[val_tmp] = cur; //如果对于cur这个串，某个子串是第一次出现
            }
    }
    for (int cur = 1; cur <= n; cur++) {
        val_tmp = int(lower_bound(lisan, lisan + tot, get(cur, 1, len[cur])) - lisan);
        ans += cnt[val_tmp] - 1;
    }
    printf("%d\n", ans);
    return 0;
}
```