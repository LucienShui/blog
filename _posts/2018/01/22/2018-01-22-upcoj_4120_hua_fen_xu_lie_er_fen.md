---
title: "UPCOJ-4120 - 划分序列 - 二分"
date: 2018-01-22 10:55:00 +0800
last_modified_at: 2018-01-31 16:53:48 +0800
math: false
render_with_liquid: false
categories: ["ACM", "二分"]
tags: ["二分", "题解"]
---

### 题目：

#### 题目描述
给定一个长度为n的序列Ai，现在要求把这个序列分成恰好K段，(每一段是一个连续子序列，且每个元素恰好属于一段)，并且每段至少有一个元素，使得和最大的那一段最小。

请你求出这个最小值。

#### 输入

第一行两个整数n,K，意义见题目描述。
接下来一行n个整数表示序列Ai

#### 输出

仅一行一个整数表示答案。

#### 样例输入
```
9 4
1 1 1 3 2 2 1 3 1
```
样例输出
```
5
```
提示

100% 的数据，1≤K≤n≤5×10^4,|Ai|≤3×10^4

---
### 思路：

&emsp;&emsp;素数打表，二分找答案。OJ比较慢，直接用lower_bound会TLE，需要手写二分。

---
### 实现：

```cpp
## include <cstdio>
int prime[664590];
bool check[10000102];
int process(int N) {
    int tot = 0;
    for(int i=2 ; i<=N ; ++i){
        if (! check[i]) prime[tot++] = i;
        for(int j=0 ; j<tot ; j++) {
            if(i * prime[j] > N) break;
            check [i * prime[j]] = true;
            if(i % prime[j] == 0) break;
        }
    }
    return tot;
}
int main() {
    process(10000020);
    int n, tmp;
    scanf("%d", &n);
    while (n--) {
        scanf("%d", &tmp);
        if (tmp <= 2) puts("2");
        else {
            int l = 0, r = 664579, mid;
            while (l < r) {
                mid = l + r >> 1;
                if (prime[mid] >= tmp) r = mid;
                else l = mid + 1;
            }
            if (tmp - prime[l - 1] < prime[l] - tmp) printf("%d\n", prime[l - 1]);
            else printf("%d\n", prime[l]);
        }
    }
    return 0;
}
```