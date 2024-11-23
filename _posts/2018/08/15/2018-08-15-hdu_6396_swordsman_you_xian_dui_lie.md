---
title: "HDU-6396 - Swordsman - 优先队列"
date: 2018-08-15 23:35:00 +0800
last_modified_at: 2018-08-15 23:53:44 +0800
math: true
render_with_liquid: false
categories: ["ACM", "贪心"]
tags: ["题解", "思维", "贪心"]
---

### 题目链接

https://acm.hdu.edu.cn/showproblem.php?pid=6396

---

### 题目

Lawson is a magic swordsman with k kinds of magic attributes v1,v2,v3,…,vk. Now Lawson is faced with n monsters and the i-th monster also has k kinds of defensive attributes ai,1,ai,2,ai,3,…,ai,k. If v1≥ai,1 and v2≥ai,2 and v3≥ai,3 and … and vk≥ai,k, Lawson can kill the i-th monster (each monster can be killed for at most one time) and get EXP from the battle, which means vj will increase bi,j for j=1,2,3,…,k.
Now we want to know how many monsters Lawson can kill at most and how much Lawson's magic attributes can be maximized.

#### 输入
There are multiple test cases. The first line of input contains an integer T, indicating the number of test cases. For each test case:
The first line has two integers n and k (1≤n≤105,1≤k≤5).
The second line has k non-negative integers (initial magic attributes) v1,v2,v3,…,vk.
For the next n lines, the i-th line contains 2k non-negative integers ai,1,ai,2,ai,3,…,ai,k,bi,1,bi,2,bi,3,…,bi,k.
It's guaranteed that all input integers are no more than 109 and  for j=1,2,3,…,k.
It is guaranteed that the sum of all n ≤5×105.
The input data is very large so fast IO (like `fread`) is recommended.

#### 输出
For each test case:
The first line has one integer which means the maximum number of monsters that can be killed by Lawson.
The second line has k integers  and the i-th integer means maximum of the i-th magic attibute.

---

### 题意

&emsp;&emsp;有n只怪兽，每只怪兽有k个防御力和k个增幅。有一个剑客，他有k个攻击力，他只有当他的k个攻击力都严格大于某只怪兽的k个防御力时，他才能杀死这只怪兽，同时他的k个攻击力会从他杀死的这只怪兽这里获得增幅，问他最多能杀死多少只怪兽，此时他的k个攻击力分别是多少。

---

### 思路

&emsp;&emsp;对于$k$种防御属性，对于每一种属性建$1$个以该属性为关键字的堆，一开始将所有$monster$放入第一个堆。然后依次检查每一个堆，对于第$i$个堆的堆顶$monster$，若其第$i$个属性满足被杀死的条件，则将其弹出并放入第$i+1$个堆，循环往复直至无法移动$monster$。每个怪兽最多进堆$k$次，出堆$k$次，时间复杂度$O(k\times n\times log_2n)$

---

### 实现

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
struct Tmp {
	int hp, index;
	bool operator < (const Tmp &tmp) const {
		return hp > tmp.hp;
	}
} buf;
typedef std::priority_queue<Tmp> priority_queue;
struct Monster {
	int hp[7], ad[7], index;
} m[maxn];
int t, n, k, ad[7];
int main() {
	for (scanf("%d", &t); t; t--) {
		scanf("%d%d", &n, &k);
		for (int i = 1; i <= k; i++) scanf("%d", ad + i);
		for (int i = 1; i <= n; i++) {
			for (int j = 1; j <= k; j++) scanf("%d", m[i].hp + j);
			for (int j = 1; j <= k; j++) scanf("%d", m[i].ad + j);
			m[i].index = i;
		}
		priority_queue que[7];
		for (int i = 1; i <= n; i++) que[1].push({m[i].hp[1], i});
		int pre = 0, ans = 0;
		while (true) {
			for (int i = 1; i < k; i++) {
				while (!que[i].empty() && (buf = que[i].top(), buf.hp <= ad[i])) {
					int index = buf.index;
					que[i + 1].push({m[index].hp[i + 1], index});
					que[i].pop();
				}
			}
			while (!que[k].empty() && (buf = que[k].top(), buf.hp <= ad[k])) {
				ans++;
				int index = buf.index;
				for (int i = 1; i <= k; i++) ad[i] += m[index].ad[i];
				que[k].pop();
			}
			if (ans == pre) break;
			pre = ans;
		}
		printf("%d\n", ans);
		for (int i = 1; i <= k; i++) printf("%d%c", ad[i], i == k ? '\n' : ' ');
	}
	return 0;
}
```