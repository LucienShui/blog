---
title: "UPC-5252 - Triangle to Hexagon - 计算几何"
date: 2018-05-02 20:48:00 +0800
last_modified_at: 2018-05-23 18:12:32 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["计算几何"]
img_path: /assets/img/posts/2018/05/02/2018-05-02-upc_5252_triangletohexagon_ji_suan_ji_he/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5252

---
### 题目：

#### 题目描述
Given a triangle ABC with incenter (center of its inscribed circle), I, and circumscribed circle O, let M, N and P be the second points of intersection of the lines through A and I, B and I resp. C and I with the circle O. 

![20171230170204_57299.jpg][1]

Let E and F be the intersections of the line NP with AB and AC respectively. Similarly, let G and H be the intersections of the line MN with AC and BC respectively and let J and K be the intersections of the line MP with BC and AB respectively. 
Write a program which takes as input the coordinates of the vertices A, B and C of the triangle and outputs the lengths of the segments EF, FG, GH, HJ, JK and KE. Supposedly, |EF| + |GH| + |JK| <= |KE| + |FG| + |HJ|. 
Computations should be done in double precision floating point. 
#### 输入
The first line of input contains a single integer P, (1≤P≤10000), which is the number of data sets that follow.  Each data set should be processed identically and independently.  
Each data set consists of one line of input.  The line contains the data set number, K, followed by three floating point values: the x coordinate of B, Bx, the x coordinate of C, Cx and the y coordinate of C, Cy.  A will always be the origin (0,0) and B will always be on the x-axis so By = 0. 
#### 输出
For each data set there is a single line of output.  The single output line consists of the data set number, K followed by the 6 decimal values to 4 decimal places separated by spaces.  The values are the lengths of EF, FG, GH, HJ, JK and KE in that order. 
#### 样例输入
```
3
1 3 2.5 3
2 3 2 3
3 3 4 3

```
#### 样例输出

```
1 0.9992 1.5332 0.9954 0.9300 1.1859 0.9048
2 1.0450 1.3309 1.0257 1.0238 1.1358 0.9214
3 0.8499 2.2397 0.8447 0.8959 1.3790 0.8063
```

---
### 题意：

&emsp;&emsp;如图，$A$点的坐标为$(0, 0)$，$B$点的坐标是$(0,a)$，$C$点坐标为$(c,d)$，三角形$ABC$的外接圆为$O$，内心为点$I$，$N$为$BI$的延长线与圆$O$的交点，$M$点和$P$点同理，问$EF、FG、GH、HJ、JK、KE$的长度分别为多少。

---
### 思路：

&emsp;&emsp;无脑套计算机和的模板即可，注意精度。

---
### 实现：

```cpp
## include <bits/stdc++.h>

double eps = 1e-9;

int cmp(double a, double b) {
    if (fabs(a - b) < eps) return 0;
    return a < b ? -1 : 1;
}

struct Point { // 点
    double x, y;
    Point(double x = 0, double y = 0):x(x), y(y) {}
    bool operator != (const Point &tmp) const {
        return (cmp(x, tmp.x) != 0 || cmp(y, tmp.y) != 0);
    }
    double dist(const Point point) const {
        return sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y));
    }
} a, b, c, e, f, g, h, i, j, k, m, n, p;

struct Line { // 线
    Point u, v;
    Line(Point a = 0, Point b = 0):u(a), v(b) {}
    Point intersection(const Line &line) const {
        Point ret = u;
        double tmp = ((u.x - line.u.x) * (line.u.y - line.v.y) - (u.y - line.u.y) * (line.u.x - line.v.x))
                     / ((u.x - v.x) * (line.u.y - line.v.y) - (u.y - v.y) * (line.u.x - line.v.x));
        ret.x += (v.x - u.x) * tmp;
        ret.y += (v.y - u.y) * tmp;
        return ret;
    }
};

struct Triangle { // 三角形
    Point a, b, c;
    Triangle(Point a = 0, Point b = 0, Point c = 0):a(a), b(b), c(c) {}
    Point outCenter() {
        Line u, v;
        u.u.x = (a.x + b.x) / 2;
        u.u.y = (a.y + b.y) / 2;
        u.v.x = u.u.x - a.y + b.y;
        u.v.y = u.u.y + a.x - b.x;
        v.u.x = (a.x + c.x) / 2;
        v.u.y = (a.y + c.y) / 2;
        v.v.x = v.u.x - a.y + c.y;
        v.v.y = v.u.y + a.x - c.x;
        return u.intersection(v);
    }
    Point inCenter() {
        Point ua, ub, va, vb;
        double m, n;
        ua = a;
        m = atan2(b.y - a.y, b.x - a.x);
        n = atan2(c.y - a.y, c.x - a.x);
        ub.x = ua.x + cos((m + n) / 2.0);
        ub.y = ua.y + sin((m + n) / 2.0);
        va = b;
        m = atan2(a.y - b.y, a.x - b.x);
        n = atan2(c.y - b.y, c.x - b.x);
        vb.x = va.x + cos((m + n) / 2.0);
        vb.y = va.y + sin((m + n) / 2.0);
        return Line(ua, ub).intersection({va, vb});
    }

};

struct Circle { // 圆
    Point center;
    double r;
    Circle(Point center = 0, double r = 0):center(center), r(r) {}
    std::pair<Point, Point> intersection(const Line &line) const {
        Point p = center, p1, p2;
        double tmp;
        p.x += line.u.y - line.v.y;
        p.y += line.v.x - line.u.x;
        p = line.intersection({p, center});
        tmp = sqrt(r * r - p.dist(center) * p.dist(center)) / line.u.dist(line.v);
        p1.x = p.x + (line.v.x - line.u.x) * tmp;
        p1.y = p.y + (line.v.y - line.u.y) * tmp;
        p2.x = p.x - (line.v.x - line.u.x) * tmp;
        p2.y = p.y - (line.v.y - line.u.y) * tmp;
        return std::make_pair(p1, p2);
    };
} o;

void read() {
    b.y = a.x = a.y = 0.0;
    scanf("%*d%lf%lf%lf", &b.x, &c.x, &c.y);
}

Point myIntersection(Circle circle, Line line) {
    auto tmp = circle.intersection(line);
    return (tmp.first != line.u && tmp.first != line.v) ? tmp.first : tmp.second;
}

void init() {
    o.center = Triangle(a, b, c).outCenter();
    o.r = o.center.dist(a);
    i = Triangle(a, b, c).inCenter();

    n = myIntersection(o, Line(b, i));
    m = myIntersection(o, Line(a, i));
    p = myIntersection(o, Line(c, i));

    e = Line(a, b).intersection(Line(p, n));
    f = Line(a, c).intersection(Line(p, n));
    g = Line(m, n).intersection(Line(a, c));
    h = Line(m, n).intersection(Line(b, c));
    j = Line(p, m).intersection(Line(b, c));
    k = Line(a, b).intersection(Line(p, m));
}

void print(Point a, Point b) {
    printf(" %.4f", a.dist(b));
}

void out() {
    print(e, f);
    print(f, g);
    print(g, h);
    print(h, j);
    print(j, k);
    print(k, e);
    putchar('\n');
}

int main() {
    int t;
    scanf("%d", &t);
    for (int i = 1; i <= t; i++) printf("%d", i), read(), init(), out();
    return 0;
}
```


  [1]: assets/img/posts/2018/05/02/2018-05-02-upc_5252_triangletohexagon_ji_suan_ji_he/20171230170204_57299.jpg