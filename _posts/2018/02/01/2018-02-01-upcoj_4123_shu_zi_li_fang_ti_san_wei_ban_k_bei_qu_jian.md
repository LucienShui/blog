---
title: "UPCOJ-4123 - 数字立方体 - 三维版k倍区间"
date: 2018-02-01 00:13:00 +0800
last_modified_at: 2018-05-23 18:19:18 +0800
math: false
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维"]
---

### 链接：

https://www.lucien.ink/go/UPC4123/

---
### 题目：

#### 题目描述
有一个立方体被分成n*n*n的单位，坐标用(X,Y,Z)表示（1<=X,Y,Z<=n<=40）。每个单位立方体内有一个绝对值不超过1e9的整数。统计有多少个子立方体的所有数之和是m的倍数。子立方体即满足x1<=X<=x2, y1<=Y<=y2, z1<=Z<=z2的所有单位立方体集合，其中1<=x1,x2,y1,y2,z1,z2<=n。
#### 输入
第一行有两个整数n, m，表示立方体的边长和作除数的正整数。以下n*n行，每行有n个整数。首先是X=1, Y=1的n个单位立方体，然后是X=1, Y=2的n个, …最后是X=n, Y=n-1的n个和X=n和Y=n的n个，共n3个整数。（ 1<=m<=1000000）
#### 输出
仅包含一个数，即所有整数和为m的倍数的子立方体的个数。
#### 样例输入
```
2 5
1 2
3 4
5 6
7 8
```
#### 样例输出
```
5
```

---
### 思路：

&emsp;&emsp;三维版的[k倍区间](https://blog.lucien.ink/archives/63/)，此外还有二维版的：[洛谷P3941 - 入阵曲 - 二维版k倍区间](https://blog.lucien.ink/archives/65/)，思路都差不多，都是记录前缀和，暴利枚举，然后统计答案。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
long long sum[47][47][47];
int n, mod, ans, tmp, cnt[int(1e6) + 7], num[47];
int fun(int lx, int ly, int rx, int ry, int z) {
    return int((sum[rx][ry][z] - sum[lx - 1][ly - 1][0] - sum[lx - 1][ry][z] - sum[rx][ly - 1][z] - sum[rx][ry][0] +
                sum[lx - 1][ly - 1][z] + sum[lx - 1][ry][0] + sum[rx][ly - 1][0] + mod) % mod);
}

int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d %d", &n, &mod);
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            for (int k = 1; k <= n; k++) {
                scanf("%d", &tmp);
                sum[i][j][k] = (tmp + sum[i - 1][j - 1][k - 1] + sum[i][j][k - 1] + sum[i][j - 1][k] +
                        sum[i - 1][j][k] - sum[i - 1][j - 1][k] - sum[i - 1][j][k - 1] - sum[i][j - 1][k - 1]) % mod;
            }
    for (int lx = 1; lx <= n; lx++)
        for (int rx = lx; rx <= n; rx++)
            for (int ly = 1; ly <= n; ly++)
                for (int ry = ly; ry <= n; ry++) {
                    cnt[0] = 1;
                    for (int i = 1; i <= n; i++) {
                        num[i] = (fun(lx, ly, rx, ry, i) + mod) % mod;
                        ans += cnt[num[i]]++;
                    }
                    for (int i = 1; i <= n; i++) cnt[num[i]] = 0;
                }
    printf("%d\n", ans);
    return 0;
}
```