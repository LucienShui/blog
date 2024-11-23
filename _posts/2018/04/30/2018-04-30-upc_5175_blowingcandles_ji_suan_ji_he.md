---
title: "UPC-5175 - Blowing Candles - 计算几何"
date: 2018-04-30 21:22:00 +0800
last_modified_at: 2018-04-30 21:27:25 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["计算几何"]
---

### 题目链接：

https://codeforces.com/gym/101635/attachments

---
### 题目：

#### 题目描述
As Jacques-Édouard really likes birthday cakes, he celebrates his birthday every hour, instead of every year. His friends ordered him a round cake from a famous pastry shop, and placed candles on its top surface. The number of candles equals the age of Jacques-Édouard in hours. As a result, there is a huge amount of candles burning on the top of the cake. Jacques-Édouard wants to blow all the candles out in one single breath.
You can think of the flames of the candles as being points in the same plane, all within a disk of radius R (in nanometers) centered at the origin. On that same plane, the air blown by Jacques-Édouard follows a trajectory that can be described by a straight strip of width W, which comprises the area between two parallel lines at distance W, the lines themselves being included in that area. What is the minimum width W such that Jacques-Édouard can blow all the candles out if he chooses the best orientation to blow?
#### 输入
The ﬁrst line consists of the integers N and R, separated with a space, where N is Jacques-Édouard’s age in hours. Then N lines follow, each of them consisting of the two integer coordinates xi and yi of the ith candle in nanometers, separated with a space.
Limits
$3 \leq N \leq 2\times 10^5$
$10 \leq R \leq 2\times 10^8$
$for\ 1 \leq i \leq N, x_i^2+y_i^2 \leq R^2$
all points have distinct coordinates


#### 输出
Print the value W as a ﬂoating point number. An additive or multiplicative error of 10−5 is tolerated: if y is the answer, any number either within [y − 10−5,y + 10−5] or within [(1 − 10−5)y,(1 + 10−5)y] is accepted.
#### 样例输入
```
3 10
0 0
10 0
0 10
```
#### 样例输出
```
7.0710678118654755
```

---
### 题意：

&emsp;&emsp;给你点的数量`n`，和一个`r`，（`r`没用，直接忽略即可），然后再给你`n`个点的坐标，问如果要用一张无限长的纸条盖住它们，纸条的宽度最少是多少。

---
### 思路：

&emsp;&emsp;问题等价于求凸包的最小直径，不难推出，最小的直径一定是某个点到和它最远的一条线段的距离，用旋转卡壳法即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>

double R;
int n;

struct Point {
    double x, y;
} point[int(2e5) + 7];

double dist(Point p1, Point p2) { // 两点间距离
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

Point intersection(Point u1, Point u2, Point v1, Point v2) { // 求两直线交点
    Point ret = u1;
    double tmp = ((u1.x - v1.x) * (v1.y - v2.y) - (u1.y - v1.y) * (v1.x - v2.x))
                / ((u1.x - u2.x) * (v1.y - v2.y) - (u1.y - u2.y) * (v1.x - v2.x));
    ret.x += (u2.x - u1.x) * tmp;
    ret.y += (u2.y - u1.y) * tmp;
    return ret;
}

Point ptoline(Point p, Point line1, Point line2) { // 求垂点
    Point t = p;
    t.x += line1.y - line2.y, t.y += line2.x - line1.x;
    return intersection(p, t, line1, line2);
}

double dist(Point a, Point l1, Point l2) { // 点到线之间的垂直距离
    return dist(a, ptoline(a, l1, l2));
}

double cross_product(Point p0, Point p1, Point p2) { // 叉乘
    return (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y);
}

bool cmp(const Point &p1, const Point &p2) { // 按极角排序的比较函数
    double temp = cross_product(point[0], p1, p2);
    if (fabs(temp) < 1e-6) return dist(point[0], p1) < dist(point[0], p2);
    return temp > 0;
}

std::vector<Point> graham_scan(int n) { // 求凸包
    std::vector<Point> ch;
    int top = 2;
    int index = 0;
    for (int i = 1; i < n; ++i) {
        if (point[i].y < point[index].y || (point[i].y == point[index].y && point[i].x < point[index].x)) index = i;
    }
    std::swap(point[0], point[index]);
    ch.push_back(point[0]);
    std::sort(point + 1, point + n, cmp);
    ch.push_back(point[1]);
    ch.push_back(point[2]);
    for (int i = 3; i < n; ++i) {
        while (top > 0 && cross_product(ch[top - 1], point[i], ch[top]) >= 0) {
            --top;
            ch.pop_back();
        }
        ch.push_back(point[i]);
        ++top;
    }
    return ch;
}

double solve(std::vector<Point> v) { // 旋转卡壳法
    double min_dis = 1e9;
    int n = int(v.size());
    v.push_back(v[0]);
    int j = 2;
    for (int i = 0; i < n; ++i) {
        while (cross_product(v[i], v[i + 1], v[j]) < cross_product(v[i], v[i + 1], v[j + 1])) {
            j = (j + 1) % n;
        }
        min_dis = std::min(min_dis, dist(v[j], v[i], v[i + 1]));
    }
    return min_dis;
}

int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%lf", &n, &R);
    for (int i = 0; i < n; i++) scanf("%lf%lf", &point[i].x, &point[i].y);
    printf("%.16f\n", solve(graham_scan(n)));
    return 0;
}
```