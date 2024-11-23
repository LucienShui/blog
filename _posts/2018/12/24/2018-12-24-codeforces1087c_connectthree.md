---
title: "Codeforces 1087C - Connect Three"
date: 2018-12-24 01:15:09 +0800
last_modified_at: 2018-12-24 01:15:09 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1087C - Connect Three

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/C

---
### 题意

有三个人在网格中，三个人的坐标互不相同，初始时所有网格都是白色的，你可以把任意多个网格染成黑色，染成黑色的网格可以相互连通（四连通），问至少需要对多少个网格进行染色，使得三个人之间两两可达。

---
### 思路

不论三个人的位置是怎样的，一定能形成一个将三个人完全覆盖的最小的矩形，且一定是两个人位于矩形的一个对角，另一个人在矩形内部。所以直接按照曼哈顿路径去随便染色就可以。

---
### 实现

https://pasteme.cn/2803

```cpp
## include <bits/stdc++.h>
struct Node {
    int x, y, index;
} node[7];
std::pair<int ,int> ans[int(1e6) + 7];
int cnt = 0;
int main() {
    for (int i = 1; i <= 3; i++) std::cin >> node[i].x >> node[i].y, node[i].index = i;
    std::sort(node + 1, node + 1 + 3, [](Node a, Node b) { return a.x < b.x; });
    int up = node[3].x, down = node[1].x, mid = node[2].x;
    std::sort(node + 1, node + 1 + 3, [](Node a, Node b) { return a.y < b.y; });
    for (int i = node[1].y; i <= node[3].y; i++) ans[++cnt] = std::make_pair(mid, i);
    for (int i = 1; i <= 3; i++) {
        if (node[i].x != mid) {
            for (int j = std::min(mid, node[i].x), upper = std::max(mid, node[i].x); j <= upper; j++)
                ans[++cnt] = std::make_pair(j, node[i].y);
        }
    }
    std::sort(ans + 1, ans + cnt + 1);
    cnt = int(std::unique(ans + 1, ans + 1 + cnt) - ans - 1);
    std::printf("%d\n", cnt);
    for (int i = 1; i <= cnt; i++) std::printf("%d %d\n", ans[i].first, ans[i].second);
    return 0;
}
```