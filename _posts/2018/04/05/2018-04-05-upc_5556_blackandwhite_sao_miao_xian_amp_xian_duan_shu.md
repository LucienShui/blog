---
title: "UPC-5556 - Black and White - 扫描线 &amp; 线段树"
date: 2018-04-05 19:29:00 +0800
last_modified_at: 2018-05-23 18:16:21 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数据结构"]
tags: ["线段树", "扫描线"]
img_path: /assets/img/posts/2018/04/05/2018-04-05-upc_5556_blackandwhite_sao_miao_xian_amp_xian_duan_shu/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5556

---
### 题目：

#### 题目描述
Consider a square map with N × N cells. We indicate the coordinate of a cell by (i, j), where 1 ≤ i, j ≤ N . Each cell has a color either white or black. The color of each cell is initialized to white. The map supports the operation
flip([xlow , xhigh], [ylow , yhigh]), which flips the color of each cell in the rectangle [xlow , xhigh] × [ylow , yhigh]. Given
a sequence of flip operations, our problem is to count the number of black cells in the final map. We illustrate this in the following example. Figure (a) shows the initial map. Next, we call flip([2, 4], [1, 3]) and obtain Figure (b). Then, we call flip([1, 5], [3, 5]) and obtain Figure (c). This map contains 18 black cells.

![20180127200402_88520.jpg][1]

#### 输入
The first line contains the number of test cases T (T < 10). Each test case begins with a line containing two integers N and K (1 < N, K < 10000), where N is the parameter of the map size and K is the number of flip operations. Each subsequent line corresponds to a flip operation, with four integers: xlow , xhigh, ylow , yhigh.
#### 输出
For each test case, output the answer in a line.
#### 样例输入
```
1
5 2
2 4 1 3
1 5 3 5
```
#### 样例输出
```
18
```

---
### 题意：

&emsp;&emsp;先是样例组数，对于每组样例，先给一个`n`，代表有一个$n\times n$的矩阵，初始情况下全是白色，然后是`k`和`k`次操作，每次操作的格式为`xlow xhigh ylow yhigh`，代表把以$(xlow, ylow)、(xhigh, yhigh)$为对角线的矩阵内所有的格子进行翻转（黑色变白色，白色变黑色），问执行完`k`次操作后有多少个黑格子。

---
### 思路：

&emsp;&emsp;用线段树维护一个扫描线（这里我维护的是一条从x轴的左端扫向右端的扫描线），代表扫到当前位置上的时候有几个黑色块，累加求和即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
## define lson (t << 1)
## define rson (t << 1 | 1)
const int maxn = int(2e4) + 7;
std::vector<std::pair<int, int>> dif[maxn];
int sum[maxn << 2], n, k;
bool lazy[maxn << 2];
void pushup(int t) { sum[t] = sum[lson] + sum[rson]; }
void pushdown(int t, int len) {
    lazy[lson] = !lazy[lson];
    lazy[rson] = !lazy[rson];
    sum[lson] = (len - (len >> 1)) - sum[lson];
    sum[rson] = (len >> 1) - sum[rson];
    lazy[t] = false;
}
void build(int t = 1, int l = 1, int r = n) {
    lazy[t] = false;
    if (l == r) {
        sum[t] = 0;
        return;
    }
    if (lazy[t]) pushdown(t, r - l + 1);
    int mid = (l + r) >> 1;
    build(lson, l, mid);
    build(rson, mid + 1, r);
    pushup(t);
}

void update(int b, int e, int t = 1, int l = 1, int r = n) {
    if (b <= l && r <= e) {
        lazy[t] = !lazy[t];
        sum[t] = r - l + 1 - sum[t];
        return;
    }
    if (lazy[t]) pushdown(t, r - l + 1);
    int mid = (l + r) >> 1;
    if (e <= mid) update(b, e, lson, l, mid);
    else if (b > mid) update(b, e, rson, mid + 1, r);
    else update(b, e, lson, l, mid), update(b, e, rson, mid + 1, r);
    pushup(t);
}

int main() {
//    freopen("in.txt", "r", stdin);
    int _;
    scanf("%d", &_);
    while (_--) {
        long long ans = 0;
        scanf("%d%d", &n, &k);
        for (int i = 1; i <= n; i++) dif[i].clear();
        for (int i = 1, xl, xh, yl, yh; i <= k; i++) {
            scanf("%d%d%d%d", &xl, &xh, &yl, &yh);
            dif[xl].emplace_back(yl, yh);
            dif[xh + 1].emplace_back(yl, yh);
        }
        build();
        for (int i = 1; i <= n; i++) {
            for (auto it : dif[i]) update(it.first, it.second);
            ans += sum[1];
        }
        printf("%lld\n", ans);
    }
    return 0;
}

```


  [1]: assets/img/posts/2018/04/05/2018-04-05-upc_5556_blackandwhite_sao_miao_xian_amp_xian_duan_shu/20180127200402_88520.jpg