---
title: "UPCOJ-4124 - SCOI2006 - 动态最值 - 线段树"
date: 2018-01-22 09:41:00 +0800
last_modified_at: 2018-02-05 19:41:32 +0800
math: false
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["线段树", "题解"]
img_path: /assets/img/posts/2018/01/22/2018-01-22-upcoj_4124_scoi2006_dong_tai_zui_zhi_xian_duan_shu/
---

### 题目：

#### 题目描述

有一个包含n个元素的数组，要求实现以下操作：

DELETE k：删除位置k上的数。右边的数往左移一个位置。

QUERY i j：查询位置i~j上所有数的最小值和最大值。

例如有10个元素：

![20170713155700_42386.jpg][1]

QUERY 2 8的结果为2 9。依次执行DELETE 3和DELETE 6（注意这时删除的是原始数组的元素7）后数组变为：

![20170713155708_19070.jpg][2]

QUERY 2 8的结果为1 7。

#### 输入

第一行包含两个数n, m，表示原始数组的元素个数和操作的个数。第二行包括n个数，表示原始数组。以下m行，每行格式为1 k或者2 i j，其中第一个数为1表示删除操作，为2表示询问操作。

#### 输出

对每个询问操作输出一行，包括两个数，表示该范围内的最小值和最大值。

样例输入

```
10 4
1 5 2 6 7 4 9 3 1 5
2 2 8
1 3
1 6
2 2 8
```

#### 样例输出

```
2 9
1 7
```

#### 提示

100%的数据满足1<=n, m<=10^6, 1<=m<=10^6

对于所有的数据，数组中的元素绝对值均不超过10^9

---
### 思路：

线段树对应的区间是静态的，但出现题目中所属情况乍一看比较不好处理。结合名次树不难想到，可以通过维护相对位置来实现动态查询的功能。

---
### 实现：

```cpp
## include <cstdio>
## include <algorithm>
## define lson (t << 1)
## define rson (t << 1 | 1)
int read() {
    int ret = 0, c, flag = 0;
    do { c = getchar(); if (c == '-') flag = 1; } while (c < '0' || c > '9');
    while (c <= '9' && c >= '0') ret = ret * 10 + (c ^ '0'), c = getchar();
    return flag ? -ret : ret;
}
int n, m, x, y;
struct Segment {
    int up, low, len;
} node[int(4e6) + 7];

void update(Segment &t, const Segment &a, const Segment &b) {
    t.up = std::max(a.up, b.up);
    t.low = std::min(a.low, b.low);
    t.len = a.len + b.len;
}
void build (int l = 1, int r = n, int t = 1) {
    if (l == r) {
        node[t].up = node[t].low = read();
        node[t].len = 1;
        return ;
    }
    int mid = l + r >> 1;
    build(l, mid, lson);
    build(mid + 1, r, rson);
    update(node[t], node[lson], node[rson]);
}
void remove(int index, int t = 1) {
    if (--node[t].len == 0) {
        node[t].low = 0x3f3f3f3f;
        node[t].up = -0x3f3f3f3f;
        return ;
    }
    int mid = node[lson].len;
    if (index <= mid) remove(index, lson);
    else remove(index - mid, rson);
    update(node[t], node[lson], node[rson]);
}
Segment query(int l, int r, int t = 1) {
    if (r - l + 1 == node[t].len) return node[t];
    int mid = node[lson].len;
    if (r <= mid && node[lson].len) return query(l, r, lson);
    if (mid < l && node[rson].len) return query(l - mid, r - mid, rson);
    Segment ret, ls = query(l, mid, lson), rs = query(1, r - mid, rson);
    update(ret, ls, rs);
    return ret;
}
void init() {
    n = read(), m = read();
    build();
}
void solve() {
    while (m--) {
        switch (read()) {
            case 1: remove(read()); break;
            case 2:
                x = read(), y = read();
                if (x > y) std::swap(x, y);
                Segment ans = query(x, y);
                printf("%d %d\n", ans.low, ans.up);
                break;
        }
    }
}
int main() {
    init();
    solve();
    return 0;
}
```


  [1]: assets/img/posts/2018/01/22/2018-01-22-upcoj_4124_scoi2006_dong_tai_zui_zhi_xian_duan_shu/20170713155700_42386.jpg
  [2]: assets/img/posts/2018/01/22/2018-01-22-upcoj_4124_scoi2006_dong_tai_zui_zhi_xian_duan_shu/20170713155708_19070.jpg