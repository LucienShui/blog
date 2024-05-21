---
title: "Codeforces-989B - A Tide of Riverscape - 思维"
date: 2018-06-13 19:55:00 +0800
last_modified_at: 2018-06-13 19:56:32 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

### 题目链接

[https://codeforces.com/contest/989/problem/B](https://www.lucien.ink/go/cf989b/)

---
### 题目

The records are expressed as a string s of characters '0', '1' and '.', where '0' denotes a low tide, '1' denotes a high tide, and '.' denotes an unknown one (either high or low).

You are to help Mino determine whether it's possible that after replacing each '.' independently with '0' or '1', a given integer p is not a period of the resulting string. In case the answer is yes, please also show such a replacement to Mino.
In this problem, a positive integer p is considered a period of string s, if for all 1 ≤ i ≤ |s| − p, the i-th and (i + p)-th characters of s are the same. Here |s| is the length of s.
#### Input
The first line contains two space-separated integers n and p (1 ≤ p ≤ n ≤ 2000) — the length of the given string and the supposed period, respectively.
The second line contains a string s of n characters — Mino's records. s only contains characters '0', '1' and '.', and contains at least one '.' character.
#### Output
Output one line — if it's possible that p is not a period of the resulting string, output any one of such strings; otherwise output "No" (without quotes, you can print letters in any case (upper or lower)).

---
### 题意

&emsp;&emsp;给你一个串，其中包含`0`、`1`、`.`种字符，你可以在`.`的位置填入`0`或`1`，问你能不能不让这个串的循环周期为`p`，能的话输出填满之后的串，不能的话输出`No`。

---
### 思路

&emsp;&emsp;扫一遍，看看能不能使$x$和$x+p$这两个位置的值不同即可。

---
### 实现

```cpp
## include <bits/stdc++.h>
char str[2007];
int main() {
	int n, p;
	std::cin >> n >> p >> str;
	bool flag = false;
	for (int l = 0, r; (r = l + p) < n; l++) {
	    if (str[l] != str[r]) {
	        if (str[l] == '.') str[l] = ('1' - str[r]) + '0';
	        else if (str[r] == '.') str[r] = ('1' - str[l]) + '0';
	        flag = true;
	        break;
	    } else if (str[l] == '.') {
	        str[l] = '1', str[r] = '0';
	        flag = true;
	        break;
	    }
	}
	if (flag) {
        for (int i = 0; i < n; i++) {
            if (str[i] == '.') putchar('0');
            else putchar(str[i]);
        }
        putchar('\n');
    } else puts("No");
	return 0;
}
```