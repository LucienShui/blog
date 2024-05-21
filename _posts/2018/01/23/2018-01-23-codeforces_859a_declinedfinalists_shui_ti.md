---
title: "Codeforces-859A - Declined Finalists - 水题"
date: 2018-01-23 18:07:00 +0800
last_modified_at: 2018-01-31 16:51:57 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目：
This year, as in previous years, MemSQL is inviting the top 25 competitors from the Start[c]up qualification round to compete onsite for the final round. Not everyone who is eligible to compete onsite can afford to travel to the office, though. Initially the top 25 contestants are invited to come onsite. Each eligible contestant must either accept or decline the invitation. Whenever a contestant declines, the highest ranked contestant not yet invited is invited to take the place of the one that declined. This continues until 25 contestants have accepted invitations.

After the qualifying round completes, you know K of the onsite finalists, as well as their qualifying ranks (which start at 1, there are no ties). Determine the minimum possible number of contestants that declined the invitation to compete onsite in the final round.

#### Input
The first line of input contains K (1 ≤ K ≤ 25), the number of onsite finalists you know. The second line of input contains r1, r2, ..., rK (1 ≤ ri ≤ 106), the qualifying ranks of the finalists you know. All these ranks are distinct.

#### Output
Print the minimum possible number of contestants that declined the invitation to compete onsite.

#### Examples
input
```
25
2 3 4 5 6 7 8 9 10 11 12 14 15 16 17 18 19 20 21 22 23 24 25 26 28
```
output
```
3
```
input
```
5
16 23 8 15 4
```
output
```
0
```
input
```
3
14 15 92
```
output
```
67
```
#### Note
In the first example, you know all 25 onsite finalists. The contestants who ranked 1-st, 13-th, and 27-th must have declined, so the answer is 3.


---
### 题意：

&emsp;&emsp;输入n个数字，求出这些数字里面的最大值，如果这个值小于25，输出0，否则输出这个值减去25。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
int main() {
	int n, a, tmp; while(a = 0, ~scanf("%d", &n)) {
		while(n--) scanf("%d", &tmp), a = max(a, tmp);
		printf("%d\n", max(a-25, 0));
	}
	return 0;
}
```