---
title: "Codeforces - 1153C - Serval and Parenthesis Sequence"
date: 2019-04-15 00:06:12 +0800
last_modified_at: 2019-04-15 00:06:12 +0800
math: false
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心", "codeforces"]
---

## 地址

https://codeforces.com/contest/1153/problem/C

## 原文地址

https://www.lucien.ink/archives/415

### 代码

https://pasteme.cn/6250

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e6) + 7;
int len, left, right;
char str[maxn];
bool check() {
    std::stack<char> stack;
    if (len % 2 != 0) return false;
    left = right = len / 2;
    for (int i = 1; i <= len; i++) {
        if (str[i] == '(') left--;
    }
    for (int i = 1; i <= len; i++) {
        if (str[i] == '?') {
            if (left > 0) {
                str[i] = '(';
                left--;
            } else {
                str[i] = ')';
                right--;
            }
        } else {
            if (str[i] == ')') right--;
        }
    }
    if (left != 0 || right != 0) return false;
    for (int i = 1; i <= len; i++) {
        if (str[i] == '(') stack.push('(');
        else {
            if (stack.empty()) return false;
            if (stack.top() == '(') stack.pop();
        }
        if (i != len && stack.empty()) return false;
    }
    return stack.empty();
}
int main() {
    scanf("%d%s", &len, str + 1);
    if (check()) puts(str + 1);
    else puts(":(");
    return 0;
}
```