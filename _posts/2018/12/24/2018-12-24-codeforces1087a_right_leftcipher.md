---
title: "Codeforces 1087A - Right-Left Cipher"
date: 2018-12-24 01:12:51 +0800
last_modified_at: 2018-12-24 01:12:51 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解", "codeforces"]
---

## Codeforces 1087A - Right-Left Cipher

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1087/problem/A

---
### 题意

给你一个字符串 $S = s_1s_2\dots s_n$，会将其一个一个地一左一右地放置为 $S' = s_5s_3s_1s_2s_4s_6$ ，现在给你 $S'$ ，让你输出 $S$ 。

---
### 思路

模拟一下即可，注意长度的奇偶。

---
### 实现

https://pasteme.cn/2801

```cpp
## include <bits/stdc++.h>
char str[int(1e5) + 7];
int main() {
    std::cin >> str;
    std::string ans = "";
    int len = int(strlen(str)), l = 0, r = len - 1;
    bool flag = !bool(len & 1);
    while (l <= r) {
        if (flag) ans = str[r--] + ans;
        else ans = str[l++] + ans;
        flag = !flag;
    }
    std::cout << ans << std::endl;
    return 0;
}
```