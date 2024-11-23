---
title: "Codeforces - 1098B - Nice table"
date: 2019-03-11 22:43:00 +0800
last_modified_at: 2019-03-11 22:45:58 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心", "codeforces"]
---

## 地址

https://codeforces.com/contest/1098/problem/B

## 原文地址

https://www.lucien.ink/archives/401/

### 题意

给你一个表格，上面只有四种字符 $ATCG$ 。

你可以把任意位置上的字符替换成这四种中的一种，问所有满足在替换之后对于每个 $2 \cdot 2$ 的正方形四种字符全部都出现的表格中，且和原表格相比替换的字符数最小值是多少，并输出任意一种替换之后的表格。

### 题解

不难证明，要么对于每一行来说，要么对于每一列来说，有且仅有两种字符，否则无法构造。

那么我们可以枚举哪两个字符在一行，然后每次构造新的一行时取最小值，那么可以保证当前排列一定是最小的，然后转置一下再搞一遍取最小就可以。

### 代码

https://pasteme.cn/4441

```cpp
## include <bits/stdc++.h>
const int maxn = int(3e5) + 7;
char buf[maxn];
struct Matrix {
	char data[maxn];
	int n, m;
	bool reversed;
	int index(int x, int y) { return (x - 1) * m + y - 1; }
	char& at(int x, int y) { return data[index(x, y)]; }
	void reverse() {
		memcpy(buf, data, sizeof(char) * n * m);
		std::swap(n, m);
		for (int i = 1; i <= n; i++)
			for (int j = 1; j <= m; j++) 
				at(i, j) = buf[(j - 1) * n + i - 1];
		reversed = !reversed;
	}
	void print() {
		if (reversed) reverse();
		for (int i = 1; i <= n; i++) 
			for (int j = 1; j <= m; j++) 
				printf("%c%s", at(i, j), j == m ? "\n" : "");
	}
	Matrix & operator = (const Matrix &tmp) {
		n = tmp.n, m = tmp.m, reversed = tmp.reversed;
        memcpy(data, tmp.data, sizeof(char) * n * m);
		return (*this);
	}

	int calc(const Matrix &mat, const char *table) {
        reversed = mat.reversed;
        n = mat.n, m = mat.m;
        int ret = 0;
        for (int i = 1; i <= n; i++) {
            int cur = (i & 1) << 1, min = 0x3f3f3f3f, best = -1;
            for (int k = 0; k < 2; k++) {
                int cnt = 0;
                for (int j = 1; j <= m; j++)
                    if (mat.data[(i - 1) * m + j - 1] != table[cur + (j & 1) ^ k]) cnt++;
                if (cnt < min) min = cnt, best = k;
            }
            ret += min;
            for (int j = 1; j <= m; j++) at(i, j) = table[cur + (j & 1) ^ best];
        }
        return ret;
    }
    void read() {
        reversed = false;
        scanf("%d%d", &n, &m);
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
                scanf(" %c", &at(i, j));
    }
} ans, input;
int min = 0x3f3f3f3f;
void calc(const Matrix &mat) {
	char table[] = "AGCT";
	Matrix ret;
	do {
		int tmp = ret.calc(mat, table);
		if (tmp < min) min = tmp, ans = ret;
	} while (std::next_permutation(table, table + 4));
}
int main() {
	input.read();
	calc(input);
	input.reverse();
	calc(input);
	ans.print();
	return 0;
}
```