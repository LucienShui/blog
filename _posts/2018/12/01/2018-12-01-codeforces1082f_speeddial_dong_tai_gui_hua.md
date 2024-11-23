---
title: "Codeforces 1082F - Speed Dial - 动态规划"
date: 2018-12-01 01:40:00 +0800
last_modified_at: 2018-12-01 01:48:18 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解", "codeforces"]
---

## Codeforces 1082F - Speed Dial - 动态规划

### 题解链接

https://lucien.ink

---
### 题目链接

https://codeforces.com/contest/1082/problem/F

---
### 题目

Polycarp's phone book contains $n$ phone numbers, each of them is described by $s_i$ — the number itself and $m_i$ — the number of times Polycarp dials it in daily.

Polycarp has just bought a brand new phone with an amazing *speed dial* feature! More precisely, $k$ buttons on it can have a number assigned to it (not necessary from the phone book). To enter some number Polycarp can press one of these $k$ buttons and then finish the number using usual digit buttons (entering a number with only digit buttons is also possible).

*Speed dial* button can only be used when no digits are entered. No button can have its number reassigned.

What is the minimal total number of **digit number presses** Polycarp can achieve after he assigns numbers to *speed dial* buttons and enters each of the numbers from his phone book the given number of times in an optimal way?

---
### 题意

&emsp;&emsp;有$n$个只包含`0~9`字符串，你可以删去$k$种前缀（每个串只能被删一次），问最少能剩下多少个字符。

---
### 思路

&emsp;&emsp;字典树上$DP$，暂时还没想明白，先挖坑。

---
### 实现

```cpp
\\ 我是坑
```