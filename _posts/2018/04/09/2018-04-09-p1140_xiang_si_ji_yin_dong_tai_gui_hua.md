---
title: "P1140 - 相似基因 - 动态规划"
date: 2018-04-09 23:20:00 +0800
last_modified_at: 2018-05-23 18:16:01 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
img_path: /assets/img/posts/2018/04/09/2018-04-09-p1140_xiang_si_ji_yin_dong_tai_gui_hua/
---

### 题目链接：

https://www.luogu.org/problemnew/show/P1140

---
### 题目：

#### 题目描述

两个基因的相似度的计算方法如下：

对于两个已知基因，例如AGTGATG和GTTAG，将它们的碱基互相对应。当然，中间可以加入一些空碱基-，例如：

![41.png.jpeg][1]

这样,两个基因之间的相似度就可以用碱基之间相似度的总和来描述，碱基之间的相似度如下表所示：

![40.png.jpeg][2]

那么相似度就是：(-3)+5+5+(-2)+(-3)+5+(-3)+5=9。因为两个基因的对应方法不唯一，例如又有：

![42.png.jpeg][3]

相似度为：(-3)+5+5+(-2)+5+(-1)+5=14。规定两个基因的相似度为所有对应方法中，相似度最大的那个。

#### 输入格式：
共两行。每行首先是一个整数，表示基因的长度；隔一个空格后是一个基因序列，序列中只含A,C,G,T四个字母。1<=序列的长度<=100。

#### 输出格式：
仅一行，即输入基因的相似度。

#### 输入样例#1：
```
7 AGTGATG
5 GTTAG
```
#### 输出样例#1：
```
14
```

---
### 思路：

&emsp;&emsp;对于两个串中的每个字符来说，与之配对的对象只有两种可能：1.和另一个串中的某个碱基进行配对，2.和空碱基进行配对。于是就可以利用二维动态规划来求解。

&emsp;&emsp;记$dp[i][j]$为处理到`a`串的第`i`个碱基和`b`串的第`j`个碱基时的最优解，那么有：$dp[i][j] = max(dp[i - 1][j - 1] + val[a[i]][b[i]], dp[i][j - 1] + val[null][b[j]] + dp[i-1][j] + val[a[i]][null])$

---
### 实现：

```cpp
## include <bits/stdc++.h>
int val[5][5] = {{5, -1, -2, -1, -3}, {-1, 5, -3, -2, -4}, {-2, -3, 5, -2, -2}, {-1, -2, -2, 5, -1}, {-3, -4, -2, -1, 0}}, mp[133], dp[107][107], len[2];
char str[2][107];
int main() {
//    freopen("in.txt", "r", stdin);
    mp['A'] = 0, mp['C'] = 1, mp['G'] = 2, mp['T'] = 3;
    memset(dp, -0x3f, sizeof(dp));
    dp[0][0] = 0;
    for (int i = 0; i < 2; i++) scanf("%d %s", len + i, str[i] + 1);
    for (int i = 0; i <= len[0]; i++)
        for (int j = 0; j <= len[1]; j++) {
            if (i) dp[i][j] = std::max(dp[i][j], dp[i - 1][j] + val[mp[str[0][i]]][4]);
            if (j) dp[i][j] = std::max(dp[i][j], dp[i][j - 1] + val[4][mp[str[1][j]]]);
            if (i && j) dp[i][j] = std::max(dp[i][j], dp[i - 1][j - 1] + val[mp[str[0][i]]][mp[str[1][j]]]);
        }
    printf("%d\n", dp[len[0]][len[1]]);
    return 0;
}
```


  [1]: assets/img/posts/2018/04/09/2018-04-09-p1140_xiang_si_ji_yin_dong_tai_gui_hua/41.png.jpeg
  [2]: assets/img/posts/2018/04/09/2018-04-09-p1140_xiang_si_ji_yin_dong_tai_gui_hua/40.png.jpeg
  [3]: assets/img/posts/2018/04/09/2018-04-09-p1140_xiang_si_ji_yin_dong_tai_gui_hua/42.png.jpeg