---
title: "洛谷P2471 - 降雨量 - 线段树 + 离散化"
date: 2018-02-01 23:49:00 +0800
last_modified_at: 2018-05-23 18:18:55 +0800
math: false
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["线段树", "题解"]
---

### 链接：

https://www.lucien.ink/go/P2471/

---
### 题目：

#### 题目描述
我们常常会说这样的话：“X年是自Y年以来降雨量最多的”。它的含义是X年的降雨量不超过Y年，且对于任意Y＜Z＜X，Z年的降雨量严格小于X年。例如2002，2003，2004和2005年的降雨量分别为4920，5901，2832和3890，则可以说“2005年是自2003年以来最多的”，但不能说“2005年是自2002年以来最多的”由于有些年份的降雨量未知，有的说法是可能正确也可以不正确的。
#### 输入
输入仅一行包含一个正整数n，为已知的数据。以下n行每行两个整数yi和ri，为年份和降雨量，按照年份从小到大排列，即yi＜yi+1。下一行包含一个正整数m，为询问的次数。以下m行每行包含两个数Y和X，即询问“X年是自Y年以来降雨量最多的。”这句话是必真、必假还是“有可能”。
#### 输出
对于每一个询问，输出true，false或者maybe。
#### 样例输入
```
6
2002 4920
2003 5901
2004 2832
2005 3890
2007 5609
2008 3024
5
2002 2005
2003 2005
2002 2007
2003 2007
2005 2008
```
#### 样例输出
```
false
true
false
maybe
false
```
#### 提示
100%的数据满足：1<=n<=50000, 1<=m<=10000, -10^9<=yi<=10^9, 1<=ri<=10^9

---
### 思路：

&emsp;&emsp;首先把年份离散化一下，建立一个维护最大值的线段树，根据题目所给的条件判一判就可以了。

---
### 实现：

```cpp
## include <cstdio>
## include <map>
## include <algorithm>
## define lson t << 1
## define rson t << 1 | 1
const int maxn = 50007;
int max[maxn << 2], num[maxn], year[maxn], n, m;
std::map<int, int> index;
void pushup(int t) { max[t] = std::max(max[lson], max[rson]); }
void build(int t = 1, int l = 1, int r = n) {
    if (l == r) {
        max[t] = num[l];
        return ;
    }
    int mid = l + r >> 1;
    build(lson, l, mid);
    build(rson, mid + 1, r);
    pushup(t);
}
int query(int begin, int end, int t = 1, int l = 1, int r = n) { // 查询区间最大值
    if (begin > end) return -1;
    if (begin <= l && r <= end) return max[t];
    int mid = l + r >> 1;
    if (begin > mid) return query(begin, end, rson, mid + 1, r);
    if (end <= mid) return query(begin, end, lson, l, mid);
    return std::max(query(begin, end, rson, mid + 1, r), query(begin, end, lson, l, mid));
}
int judge(int y, int x) {
    int l = int(std::upper_bound(year + 1, year + 1 + n, y) - year);
    int r = int(std::lower_bound(year + 1, year + 1 + n, x) - year) - 1;
    int maxnum = query(l, r), num_y = num[index[y]], num_x = num[index[x]];
    if (num_x && maxnum >= num_x) return 0; // (y, x)里的左右年降雨量都要严格小于x和y
    if (num_y && maxnum >= num_y) return 0;
    if (num_y && num_y < num_x) return 0; // x年的降雨量不能超过y年
    if (num_y == 0 || num_x == 0) return -1;
    if (r - l + 2 != x - y) return -1; // 如果x和y之间的区间长度和离散化后的区间长度不同，说明有未知年份
    return 1;

}
int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) {
        scanf("%d%d", year + i, num + i); // num代表降雨量
        index[year[i]] = i; // 离散化
    }
    build();
    scanf("%d", &m);
    for (int i = 0, y, x; i < m; i++) {
        scanf("%d%d", &y, &x);
        switch (judge(y, x)) {
            case -1: puts("maybe"); break;
            case 0: puts("false"); break;
            case 1: puts("true"); break;
            default: break;
        }
    }
    return 0;
}
```