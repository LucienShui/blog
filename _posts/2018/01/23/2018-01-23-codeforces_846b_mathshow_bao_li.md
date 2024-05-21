---
title: "Codeforces-846B - Math Show - 暴力"
date: 2018-01-23 16:43:00 +0800
last_modified_at: 2018-01-31 16:52:26 +0800
math: false
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目：

Polycarp takes part in a math show. He is given n tasks, each consists of k subtasks, numbered 1 through k. It takes him tj minutes to solve the j-th subtask of any task. Thus, time required to solve a subtask depends only on its index, but not on the task itself. Polycarp can solve subtasks in any order.

By solving subtask of arbitrary problem he earns one point. Thus, the number of points for task is equal to the number of solved subtasks in it. Moreover, if Polycarp completely solves the task (solves all k of its subtasks), he recieves one extra point. Thus, total number of points he recieves for the complete solution of the task is k + 1.

Polycarp has M minutes of time. What is the maximum number of points he can earn?

#### Input
The first line contains three integer numbers n, k and M (1 ≤ n ≤ 45, 1 ≤ k ≤ 45, 0 ≤ M ≤ 2·109).

The second line contains k integer numbers, values tj (1 ≤ tj ≤ 1000000), where tj is the time in minutes required to solve j-th subtask of any task.

#### Output
Print the maximum amount of points Polycarp can earn in M minutes.

#### Examples
input
```
3 4 11
1 2 3 4
```
output
```
6
```
input
```
5 5 10
1 2 4 8 16
```
output
```
7
```
#### Note
In the first example Polycarp can complete the first task and spend 1 + 2 + 3 + 4 = 10 minutes. He also has the time to solve one subtask of the second task in one minute.

In the second example Polycarp can solve the first subtask of all five tasks and spend 5·1 = 5 minutes. Also he can solve the second subtasks of two tasks and spend 2·2 = 4 minutes. Thus, he earns 5 + 2 = 7 points in total.

---
### 题意：

&emsp;&emsp;你要运行n次大程序，每个大程序里面有m个小程序，运行程序不用管顺序，可以随意运行，只要每个小程序运行不超过n次就好了。每运行完一个小程序你可以加1分，运行完一个大程序可以附加1分。问在t的时间内，最大的分数是多少？ 

---
### 思路：

&emsp;&emsp;因为数据范围比较小，所以直接暴力就好了，O(n^2)的算法。先给每个小程序的耗时排序，每次枚举完整运行多少个大程序，先把这些算完，然后剩下的就让最短时间的小程序排序去跑。最后算最大值就好了。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
int main() {
    int n, k, m, sum, a[107], result;
    while(sum = result = 0, ~scanf("%d%d%d", &n, &k, &m)) {
        for(int i=0 ; i<k ; i++) scanf("%d", a+i), sum += a[i];
        sort(a, a+k);
        if(m >= n*sum) { result = n*k+n; continue; }
        for(int cnt = 0 ; cnt < n ; cnt++) {
            if(m < sum*cnt) break;
            int t = m-sum*cnt, ans = cnt*k+cnt;
            for(int i=0 ; i<k ; i++) {
                if(t > a[i]*(n-cnt)) t -= a[i]*(n-cnt), ans += n-cnt;
                else { while(t>=0) t-=a[i], ans++; ans--; break; }
            }
            result = max(ans, result);
        }
        printf("%d\n", result);
    }
    return 0;
}
```