---
title: "Codeforces-987A - Infinity Gauntlet - 水题"
date: 2018-05-30 01:57:00 +0800
last_modified_at: 2024-04-15 02:11:21 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目链接

https://codeforces.com/contest/987/problem/A

---
### 题目

You took a peek on Thanos wearing Infinity Gauntlet. In the Gauntlet there is a place for six Infinity Gems:

+ the Power Gem of purple color, 
+ the Time Gem of green color, 
+ the Soul Gem of orange color, 
+ the Reality Gem of red color, 
+ the Mind Gem of yellow color.

Using colors of Gems you saw in the Gauntlet determine the names of absent Gems. 
#### Input
In the first line of input there is one integer n (0 ≤ n ≤ 6) — the number of Gems in Infinity Gauntlet.

In next n lines there are colors of Gems you saw. Words used for colors are: purple, green, blue, orange, red, yellow. It is guaranteed that all the colors are distinct. All colors are given in lowercase English letters. 
#### Output
In the first line output one integer m (0 ≤ m ≤ 6) — the number of absent Gems.

Then in m lines print the names of absent Gems, each on its own line. Words used for names are: Power, Time, Space, Soul, Reality, Mind.

Names can be printed in any order. Keep the first letter uppercase, others lowercase.

---
### 题意

&emsp;&emsp;六种颜色对应六种原石，给你n种颜色，保证每种颜色都不相同，问你缺少哪些原石。

---
### 实现

```cpp
## include <bits/stdc++.h>
using namespace std;
string str1[17] = {"purple", "green", "blue", "orange", "red", "yellow"}, str2[17] = {"Power", "Time", "Space", "Soul", "Reality", "Mind"}, tmp;
bool vis[17];
int main() {
	int n;
	cin >> n;
	for (int i = 0; i < n; i++) {
	    cin >> tmp;
	    for (int i = 0; i < 6; i++) if (str1[i] == tmp) vis[i] = true;
	}
	cout << (6 - n) << endl;
	for (int i = 0; i < 6; i++) if (!vis[i]) cout << str2[i] << endl;
	return 0;
}
```