---
title: "Codeforces - 1153A - Serval and Bus"
date: 2019-04-15 00:01:00 +0800
last_modified_at: 2019-04-15 00:01:49 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## 地址

https://codeforces.com/contest/1153/problem/A

## 原文地址

https://www.lucien.ink/archives/413

### 代码

https://pasteme.cn/6247

```cpp
## include <bits/stdc++.h>
int main() {
    int n, m, min = 0x3f3f3f3f, ans, buf;
    scanf("%d%d", &n, &m);
    for (int i = 1, a, d; i <= n; i++) {
        scanf("%d%d", &a, &d);
        if (a >= m) buf = a - m;
        else {
            buf = d - (m - a) % d;
            if (buf >= d) buf -= d;
        }
        if (buf < min) min = buf, ans = i;
    }
    printf("%d\n", ans);
    return 0;
}
```