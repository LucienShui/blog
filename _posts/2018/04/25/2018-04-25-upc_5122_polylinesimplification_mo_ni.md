---
title: "UPC-5122 - Polyline Simplification - 模拟"
date: 2018-04-25 00:11:00 +0800
last_modified_at: 2018-05-23 18:14:15 +0800
math: true
render_with_liquid: false
categories: ["ACM", "模拟"]
img_path: /assets/img/posts/2018/04/25/2018-04-25-upc_5122_polylinesimplification_mo_ni/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5122

---
### 题目：

#### 题目描述
Mapping applications often represent the boundaries of countries, cities, etc. as polylines, which are connected sequences of line segments. Since fine details have to be shown when the user zooms into the map,these polylines often contain a very large number of segments. When the user zooms out, however, these fine details are not important and it is wasteful to process and draw the polylines with so many segments. In this problem, we consider a particular polyline simplification algorithm designed to approximate the original polyline with a polyline with fewer segments.
A polyline with n segments is described by n + 1 points p0 = (x0, y0),... , pn = (xn, yn), with the ith line segment being $\overline{p_{i-1}p_i}$. The polyline can be simplified by removing an interior point pi (1≤i≤n-1),so that the line segments $\overline{p_{i-1}p_i}$ and $\overline{p_ip_{i+1}}$ are replaced by the line segment $\overline{p_{i-1}p_{i+1}}$. To select the point to be removed, we examine the area of the triangle formed by pi-1, pi, and pi+1 (the area is 0 if the three points are colinear), and choose the point pi such that the area of the triangle is smallest. Ties are broken by choosing the point with the lowest index. This can be applied again to the resulting polyline, until the desired number m of line segments is reached. 
Consider the example below.

![20171207151120_15764.jpg][1]

The original polyline is shown at the top. The area of the triangle formed by p2, p3, and p4 is considered (middle), and p3 is removed if the area is the smallest among all such triangles. The resulting polyline after p3 is removed is shown at the bottom.
#### 输入
The first line of input contains two integers n (2≤n≤200 000) and m (1≤m < n). The next n+1 lines specify p0,..., pn. Each point is given by its x and y coordinates which are integers between -5000 and 5000 inclusive. You may assume that the given points are strictly increasing in lexicographical order. That is, xi < xi+1, or xi = xi+1 and yi < yi+1 for all 0≤i < n.
#### 输出
Print on the kth line the index of the point removed in the kth step of the algorithm described above (use the index in the original polyline).
#### 样例输入
```
10 7
0 0
1 10
2 20
25 17
32 19
33 5
40 10
50 13
65 27
75 22
85 17
```
#### 样例输出
```
1
9
6
```

---
### 题意：

&emsp;&emsp;给你`n+1`个点，每三个连续的点会构成一个三角形，然后要求你删`n-m`次，每次会删掉一个面积最小的三角形所对应的那个中间的点，然后剩下的点会重新形成三角形，问你每次删除的顶点的编号。

---
### 思路：

&emsp;&emsp;用一个$list$和一个$set$维护一下即可，需要注意一下细节，比赛的时候思路有点慢敲的也慢，结果我敲完的那一瞬间刚好结束。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(2e5) + 7;
struct Point { int x, y; } node[maxn];
int CrossProduct(Point i, Point j, Point k) {
    return abs((k.x - i.x) * (j.y - i.y) - (k.y - i.y) * (j.x - i.x));
}
int area[maxn];
struct Triangle {
    int area, index;
    Triangle(int area = 0, int index = 0):area(area), index(index) {}
    bool operator < (const Triangle &tmp) const {
        return area == tmp.area ? index < tmp.index : area < tmp.area;
    }
};
std::set<Triangle> set;
std::set<int> list;
void solve() {
    auto cur = set.begin();
    Triangle min = *cur;
    set.erase(cur);
    printf("%d\n", min.index);
    auto mid = list.lower_bound(min.index);
    auto tmp = mid, l = --tmp;
    tmp = mid;
    auto r = ++tmp;
    if (l != list.begin()) {
        set.erase(set.lower_bound({area[*l], *l}));
        tmp = l;
        auto ll = --tmp;
        set.emplace(area[*l] = CrossProduct(node[*ll], node[*l], node[*r]), *l);
    }
    if (r != --list.end()) {
        set.erase(set.lower_bound({area[*r], *r}));
        tmp = r;
        auto rr = ++tmp;
        set.emplace(area[*r] = CrossProduct(node[*l], node[*r], node[*rr]), *r);
    }
    list.erase(mid);
}
int main() {
//    freopen("in.txt", "r", stdin);
    int n, m;
    scanf("%d%d", &n, &m);
    m = n - m;
    for (int i = 0; i <= n; i++) scanf("%d%d", &node[i].x, &node[i].y), list.insert(i);
    for (int i = 1; i < n; i++) set.emplace(area[i] = CrossProduct(node[i - 1], node[i], node[i + 1]), i);
    while (m--) solve();
    return 0;
}
```


  [1]: assets/img/posts/2018/04/25/2018-04-25-upc_5122_polylinesimplification_mo_ni/20171207151120_15764.jpg