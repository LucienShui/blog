---
title: "UPCOJ-5344 - 被子 - 瞎搞"
date: 2018-01-23 15:44:00 +0800
last_modified_at: 2018-01-31 16:53:02 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["瞎搞", "题解"]
---

### 题目：

#### 题目描述
作为一只明媚的兔子,需要学会叠被子…
被子是方形的,上面有很多小写字母.可以认为被子是一个n*m的字符矩阵
被子能够被叠起来,当且仅当每一行,每一列都是回文串.
兔子可以把同一条被子上任意两个位置的字母交换位置,而且兔子不嫌麻烦,为了把被子叠起来它愿意交换任意多次.但是兔子不能交换两条不同的被子之间的字母.
现在兔子翻箱倒柜找出来了很多被子,请你帮兔子判断每条被子能否被叠起来.

#### 输入
第一行一个Q,表示被子的条数
接下来描述Q条被子.
描述每条被子时,第一行输入两个整数n,m表示由n行m列组成
接下来n行每行一个长度为m的字符串.字符串中只含小写字母.

#### 输出
Q行,依次输出对每条被子的判断结果.如果可以叠起来,输出一行“Yes”(不包括引号),如果叠不起来,输出一行“No”(不包括引号).
#### 样例输入
```
5

3 4
aabb
aabb
aacc

2 2
aa
bb

5 1
t
w
e
e
t

2 5
abxba
abyba

1 1
z
```
#### 样例输出
```
Yes
No
Yes
No
Yes
```
#### 提示

$Q<=10,n,m<=200$

---
### 思路：

&emsp;&emsp;发现对于两个都是偶数的来说，因为每行每列都要对称，那么每个字符出现的次数都应该是4的倍数。

&emsp;&emsp;对于一奇一偶的情况，只有奇中间那一行可以是%4 余 2的。因为中间那一串自己成为一个回文串即可。当然出现奇数次数的不行。同时余2的个数必须要<列/2(如果列为偶的话，其他反之)。

&emsp;&emsp;对于两个都是奇数的情况，允许一个奇数出现，拿一个作为中间那一个。其他余2的次数不能超过$\frac{n - 1 + m - 1}{2}$。

&emsp;&emsp;特判即可。

---
### 实现：

```cpp
## include <cstdio>
## include <cstring>
int cnt[30], mod[4];
char s[207];
void init(int n, int m) {
    memset(cnt, 0, sizeof(cnt));
    memset(mod, 0, sizeof(mod));
    for (int i = 0; i < n; i++) {
        scanf("%s", s);
        for (int j = 0; j < m; j++) cnt[s[j] - 'a']++;
    }
    for (int i = 0; i < 26; i++) mod[cnt[i] % 4]++;
}
bool solve(int n, int m) {
    mod[1] += mod[3], mod[2] += mod[3];
    int tmp = (n & 1) + (m & 1);
    if (tmp == 0) return !(mod[1] || mod[2]);
    else if (tmp == 1) {
        if (mod[1]) return false;
        tmp = (n & 1) ? m / 2 : n / 2;
        return mod[2] <= tmp;
    } else {
        if (mod[1] != 1) return false;
        return mod[2] <= (n + m - 2) / 2;
    }
}
int main() {
//    freopen("in.txt", "r", stdin);
    int _, n, m; scanf("%d", &_);
    while (_--) {
        scanf("%d%d", &n, &m);
        init(n, m);
        puts(solve(n, m) ? "Yes" : "No");
    }
    return 0;
}
```