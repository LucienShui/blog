---
title: "Codeforces - 1166C - A Tale of Two Lands"
date: 2019-05-19 02:53:54 +0800
last_modified_at: 2019-05-19 02:53:54 +0800
math: true
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "题解", "codeforces"]
---

## Codeforces - 1166C - A Tale of Two Lands

### 地址

https://codeforces.com/contest/1166/problem/C

### 原文地址

https://www.lucien.ink/archives/432

### 题目

The legend of the foundation of Vectorland talks of two integers $x$ and $y$. Centuries ago, the array king placed two markers at points $|x|$ and $|y|$ on the number line and conquered all the land in between (including the endpoints), which he declared to be Arrayland. Many years later, the vector king placed markers at points $|x - y|$ and $|x + y|$ and conquered all the land in between (including the endpoints), which he declared to be Vectorland. He did so in such a way that the land of Arrayland was completely inside (including the endpoints) the land of Vectorland.

Here $|z|$ denotes the absolute value of $z$.

Now, Jose is stuck on a question of his history exam: "What are the values of $x$ and $y$?" Jose doesn't know the answer, but he believes he has narrowed the possible answers down to $n$ integers $a_1, a_2, \dots, a_n$. Now, he wants to know the number of **unordered** pairs formed by two **different** elements from these $n$ integers such that the legend could be true if $x$ and $y$ were equal to these two values. Note that it is possible that Jose is wrong, and that no pairs could possibly make the legend true.



### 题意

给你 $n$ 个数，问其中有多少对 `x y` 满足 $min(|x - y|, |x + y|) \leq min(|x|, |y|)$ 且 $max(|x|, |y|) \leq max(|x - y|, |x + y|)$

### 题解

分类讨论一下，不妨设 $|x| \leq |y|$

1. $0 < x,y$

$$y - x \leq x \leq y \leq x + y \Rightarrow x \leq y \leq 2x$$

2. $x < 0$, $y > 0$

$$x + y \leq -x \leq y \leq y - x \Rightarrow -x \leq y \leq -2x$$

3. $x > 0$, $y < 0$

$$-y - x \leq x \leq -y \leq x - y \Rightarrow x \leq -y \leq 2x$$

4. $0 > x, y$

$$x - y \leq -x \leq -y \leq -x - y \\ \Rightarrow 2x \leq y \leq x \\ \Rightarrow |x| \leq |y| \leq 2|x|$$

5. 只有当 $x$ 和 $y$ 同时为 $0$ 时才满足不等式

即：

找出有多少对 `x y` 满足 $|x| \leq |y| \leq 2|x|$ ，`lower_bound` 一下 `upper_bound` 一下，容斥一下即可。

#### 代码

https://pasteme.cn/8175

```cpp
## include <bits/stdc++.h>
long long ans, n;
std::vector<int> vec;
std::map<int, int> cnt;
int main() {
    scanf("%d", &n);
    for (int i = 0, buf; i < n; i++) {
        scanf("%d", &buf);
        vec.push_back(abs(buf));
		cnt[abs(buf)]++;
    }
	std::sort(vec.begin(), vec.end());
    for (auto each : vec) {
        auto l = std::lower_bound(vec.begin(), vec.end(), each);
        auto r = std::upper_bound(vec.begin(), vec.end(), each * 2);
        ans += r - l;
    }
    for (auto pair : cnt) ans -= pair.second * pair.second - pair.second * (pair.second - 1) / 2;
    printf("%lld\n", ans);
    return 0;
}
```
