---
title: "HD玩具 - 背包"
date: 2019-07-08 17:56:00 +0800
last_modified_at: 2019-07-13 08:50:06 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

## HD玩具

### 原文链接

https://blog.lucien.ink/archives/455/

### 题目地址

https://icpc.upc.edu.cn/problem.php?id=12163

### 题目

商店正在出售小C最喜欢的系列玩具，在接下来的n周中，每周会出售其中的一款，同一款玩具不会重复出现。 
由于是小C最喜欢的系列，他希望尽可能多地购买这些玩具，但是同一款玩具小C只会购买一个。同时，小C的预算只有m元，因此他无法将每一款都纳入囊中。此外，小C不能连续两周都购买玩具，否则他会陷入愧疚。现在小C想知道，他最多可以买多少款不同的玩具呢？ 

### 题解

$f[i][j]$ 代表第 $i$ 天有 $j$ 元的时候最多可以买多少个，可以比较容易得出转移方程：

$$f[i][j] = max(f[i - 2][j - cost[i]] + 1, f[i - 1][j])$$

需要注意的是，如果买不起（$j < cost[i]$）的话，有：

$$f[i][j] = f[i - 1][j]$$

$i$ 对应的那一维可以用滚动数组优化，整体时间复杂度为 $O(NM)$ ，空间复杂度为 $O(M)$ 。

#### 实现

```cpp
## include <bits/stdc++.h>
const int maxm = int(5e4) + 7;
int n, m, f[2][maxm];
int main() {
    scanf("%d%d", &n, &m);
    for (int i = 1, cost, cur, pre; i <= n; i++) {
        scanf("%d", &cost);
        cur = i & 1, pre = cur ^ 1;
        for (int j = m; j >= 0; j--) {
            if (j >= cost) f[cur][j] = std::max(f[cur][j], f[cur][j - cost] + 1);
            f[cur][j] = std::max(f[cur][j], f[pre][j]);
        }
    }
    printf("%d\n", f[n & 1][m]);
    return 0;
}
```
