---
title: "第十届山东省赛 - H - Tokens on the Segments"
date: 2019-05-14 13:19:00 +0800
last_modified_at: 2019-05-14 13:19:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心"]
---

## 题目链接

https://acm.zju.edu.cn/onlinejudge/showProblem.do?problemId=6022

## 原文地址

https://www.lucien.ink/archives/427/

## 题意

一维坐标轴上有 $n$ 条线段，你可以在每个线段的整点上放任意多个标记，但是任意两个标记不能重合，问最多有多少条线段可以拥有标记。

## 题解

### 思路

最原始的想法是二分图，但看了眼范围放弃了，考虑贪心。简单的贪心想法就是按照左右端点的升序进行二级排序，然后贪心地依次靠左放点，这种思路显然不对，提供一组 `hack`：

```
1
3
1 2
2 2
1 3
```

还有一种想法是按照长度升序和左端点升序进行二级排序，然后扫一遍，每次给当前线段分配一个坐标最小的标记，这种思路也是错的，提供一组 `hack`：

```
1
4
1 3
1 3
1 3
3 4
```

仔细思考一下，对于一个标记 $x$ ，如果一个线段集合 $s$ 中的所有线段都可以被这个标记所覆盖，可以被发现其实是要优先将 $x$ 分配给 $s$ 中右端点最小的线段，可以证明这样一定是最优的，证明过程待系统地学习一下贪心之后再补上吧。

### 代码

https://pasteme.cn/7981

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
struct Seg {
    int l, r;
    bool operator < (const Seg &tmp) const {
        return r > tmp.r;
    }
} seg[maxn];
int t, n;
int main() {
    for (scanf("%d", &t); t; t--) {
        scanf("%d", &n);
        for (int i = 0; i < n; i++) scanf("%d%d", &seg[i].l, &seg[i].r);
        std::sort(seg, seg + n, [](Seg x, Seg y){ return x.l < y.l; });
        std::priority_queue<Seg> que;
        int cur = seg[0].l, ans = 0;
        seg[n].l = 1000000001;
        for (int i = 0; i <= n; i++) {
            if (seg[i].l != cur) {
                while (!que.empty() && cur < seg[i].l) {
                    if (cur <= que.top().r) cur++, ans++;
                    que.pop();
                }
                cur = seg[i].l;
            }
            que.push(seg[i]);
        }
        printf("%d\n", ans);
    }
    return 0;
}
```