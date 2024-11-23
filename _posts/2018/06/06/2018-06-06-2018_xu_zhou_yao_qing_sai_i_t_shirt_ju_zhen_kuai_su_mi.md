---
title: "2018徐州邀请赛I - T-shirt - 矩阵快速幂"
date: 2018-06-06 15:06:00 +0800
last_modified_at: 2018-06-06 15:07:32 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["矩阵快速幂"]
---

### 题目

#### 题目描述
JSZKC is going to spend his vacation! 
His vacation has N days. Each day, he can choose a T-shirt to wear. Obviously, he doesn’t want to wear a singer color T-shirt since others will consider he has worn one T-shirt all the time. 
To avoid this problem, he has M different T-shirt with different color. If he wears A color T-shirt this day and B color T-shirt the next day, then he will get the pleasure of f[A][B].(notice: He is able to wear one T-shirt in two continuous days but may get a low pleasure) 
Please calculate the max pleasure he can get. 
#### 输入
The input file contains several test cases, each of them as described below. 
The first line of the input contains two integers N,M (2 ≤ N≤ 100000, 1 ≤ M≤ 100), giving the length of vacation and the T-shirts that JSZKC has.   
The next follows M lines with each line M integers. The jth integer in the ith line means f\[i\]\[j\]\(1<=f\[i\]\[j\]<=1000000\). 
There are no more than 10 test cases. 
#### 输出
One line per case, an integer indicates the answer 
#### 样例输入
```
3 2
0 1
1 0
4 3
1 2 3
1 2 3
1 2 3
```
#### 样例输出
```
2
9
```

---
### 题意

&emsp;&emsp;有`n`天，`m`件衣服，如果某一天穿了第`i`件衣服，第二天穿了第`j`件衣服，那么就会获得`f[i][j]`的权值。然后给你矩阵`f`，每件衣服可以穿无限多次，问第`n`天能获得的最大权值是多少。

---
### 思路

&emsp;&emsp;设$dp[t][i][j]$为第`1`天穿第`i`件衣服第`t`天穿第`j`件衣服时能获得的最大的权值。假设$a + b = t$显然有$dp[t][i][j] = max_{1 \leq k \leq m}(dp[a][i][k] + dp[b][k][j])$，考虑矩阵快速幂。

---
### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = 107;
typedef long long ll;
ll max(ll a, ll b) { return a > b ? a : b; }
int n, m;
struct Matrix {
	ll data[maxn][maxn];
	Matrix operator * (const Matrix &tmp) const {
		Matrix ret;
		memset(ret.data, 0, sizeof(ret.data));
		for (int i = 1; i <= m; i++)
			for (int j = 1; j <= m; j++)
				for (int k = 1; k <= m; k++)
					ret.data[i][j] = max(ret.data[i][j], data[i][k] + tmp.data[k][j]);
		return ret;
	}
} tmp;
Matrix qpow(Matrix p, int q) {
	Matrix ret;
	memset(ret.data, 0, sizeof(ret.data));
	for (; q; q >>= 1) {
		if (q & 1) ret = ret * p;
		p = p * p;
	}
	return ret;
}
ll solve() {
	Matrix result = qpow(tmp, n - 1);
	ll ans = 0;
	for (int i = 1; i <= m; i++)
		for (int j = 1; j <= m; j++)
			ans = max(ans, result.data[i][j]);
	return ans;
}
int main() {
	while (~scanf("%d%d", &n, &m)) {
		for (int i = 1; i <= m; i++)
			for (int j = 1; j <= m; j++)
				scanf("%lld", tmp.data[i] + j);
		printf("%lld\n", solve());
	}
	return 0;
}
```