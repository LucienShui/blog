---
title: "Codeforces-592C - The Big Race - 思维"
date: 2018-02-04 02:13:00 +0800
last_modified_at: 2024-04-15 02:10:37 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维"]
---

## 链接：

https://lucien.ink/go/592C/

---
## 题目：

Vector Willman and Array Bolt are the two most famous athletes of Byteforces. They are going to compete in a race with a distance of L meters today.


Willman and Bolt have exactly the same speed, so when they compete the result is always a tie. That is a problem for the organizers because they want a winner.

While watching previous races the organizers have noticed that Willman can perform only steps of length equal to w meters, and Bolt can perform only steps of length equal to b meters. Organizers decided to slightly change the rules of the race. Now, at the end of the racetrack there will be an abyss, and the winner will be declared the athlete, who manages to run farther from the starting point of the the racetrack (which is not the subject to change by any of the athletes).

Note that none of the athletes can run infinitely far, as they both will at some moment of time face the point, such that only one step further will cause them to fall in the abyss. In other words, the athlete will not fall into the abyss if the total length of all his steps will be less or equal to the chosen distance L.

Since the organizers are very fair, the are going to set the length of the racetrack as an integer chosen randomly and uniformly in range from 1 to t (both are included). What is the probability that Willman and Bolt tie again today?

### Input
The first line of the input contains three integers t, w and b (1 ≤ t, w, b ≤ 5·1018) — the maximum possible length of the racetrack, the length of Willman's steps and the length of Bolt's steps respectively.

### Output
Print the answer to the problem as an irreducible fraction . Follow the format of the samples output.

The fraction  (p and q are integers, and both p ≥ 0 and q > 0 holds) is called irreducible, if there is no such integer d > 1, that both p and q are divisible by d.

### Examples
#### input
```
10 3 2
```
#### output
```
3/10
```
#### input
```
7 1 2
```
#### output
```
3/7
```
### Note
In the first sample Willman and Bolt will tie in case 1, 6 or 7 are chosen as the length of the racetrack.

---
## 题意：

&emsp;&emsp;两个人A和B每个人每走一步的距离分别为w，b。现在给一个跑道，跑道后面是悬崖，人不能掉进悬崖。问最终A和B谁离起点越远谁获胜。 

&emsp;&emsp;问在一个长度L的范围里面，不能分出胜负的概率是多少。

---
## 思路：

&emsp;&emsp;说白了其实就是求对于$x \in [1, L]$，$x \% w == x \%b$的数目，搞一搞就行。这个数据范围C++求最小公倍数的时候会爆，Java大数写起来麻烦，就写了一发Python。

---
## 实现：

```python
def gcd(a, b):
    if b != 0: return gcd(b, a % b)
    return a
q, w, b = map(int, input().split())
lcm = (w // gcd(w, b)) * b
p = (q // lcm) * min(w, b) - 1 + min((q % lcm) + 1, min(w, b))
print(p // gcd(p, q), end = '')
print('/', end = '')
print(q // gcd(p, q))
```