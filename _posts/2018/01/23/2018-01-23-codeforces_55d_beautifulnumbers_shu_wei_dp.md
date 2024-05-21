---
title: "CodeForces-55D - Beautiful numbers - 数位DP"
date: 2018-01-23 16:19:00 +0800
last_modified_at: 2018-01-31 16:52:48 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划", "题解"]
---

### 题目：

Volodya is an odd boy and his taste is strange as well. It seems to him that a positive integer number is beautiful if and only if it is divisible by each of its nonzero digits. We will not argue with this and just count the quantity of beautiful numbers in given ranges.

#### Input
The first line of the input contains the number of cases t (1 ≤ t ≤ 10). Each of the next t lines contains two natural numbers li and ri (1 ≤ li ≤ ri ≤ 9 ·1018).

Please, do not use %lld specificator to read or write 64-bit integers in C++. It is preffered to use cin (also you may use %I64d).

#### Output
Output should contain t numbers — answers to the queries, one number per line — quantities of beautiful numbers in given intervals (from li to ri, inclusively).

#### Examples
input
```
1
1 9
```
output
```
9
```
input
```
1
12 15
```
output
```
2
```

---
### 题意：

&emsp;&emsp;求一个区间内的Beautiful numbers有多少个。Beautiful numbers指：一个数能整除所有组成它的非0数字。 
&emsp;&emsp;例如15可以被1和5整除，所以15是Beautiful numbers。

---
### 思路：

&emsp;&emsp;Beautiful numbers指：一个数能整除所有组成它的非0数字。等同于一个数能整除所有组成它的非0数字的最小公倍数。 我们看到数据的范围是$1 ≤ l_i ≤ r_i ≤ 9 \times 10^{18}$，根本无法记录。所以，缩小范围成为第一要做的事。

$$sum\%(x \times n)\%x == sum\%x$$

证明：

设$sum ＝ k\times x+b$

代入左边得：$$sum\%(x\times n)\%x = (k\times x+b)\%(x\times n)\%x$$

令$$k = k_a\times n + k_b$$

代入得
$$(k_a\times n\times x+k_b\times x+b)\%(x\times n)\%x\\
= (kb*x+b)\%x \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \\\
= b\%x \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \\\
=b \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ $$
左右相等，证明成立

&emsp;&emsp;那么我们就可以用上式中的x*n对num进行取余，记录其取余后的值，显然，1～9的最小公倍数2520是最合理的x*n。 

&emsp;&emsp;而在逐位统计时，可以直接由前面位取余后的值来得到包含新一位的新数字取余后的值。 

例如$R\times x$(R是已知前面位取余后的值)，那么$$R\times x\%2520 == (R\times 10+x)\%2520$$就不在此废话证了。 

我们使用记忆化搜索。 

`dfs(len, num, lcm, flag)`

`len`表示迭代的长度

`num`为截止当前位的数对2520取余后的值。 

`lcm`为截止当前位的所有数的最小公倍数。 

`flag`表示当前数是否可以任意取值(对取值上限进行判断)

则可用`dp[len][num][lcm]`来对其进行记录。 

&emsp;&emsp;但`lcm`按$2520$取值根本开不下，所以对`lcm`进行离散化，因为`lcm`一定可以整除$2520$，所以将$1～2520$可以整除$2520$的数进行标记即可，测试后发现只有48个，满足当前情况。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int mod = 2520;
long long dp[27][57][2527];
int dis[20], Hash[2527];
int gcd(int p, int q) {return q ? gcd(q, p%q) : p;}
long long dfs(int pos, int num, int lcm, bool limit) {
    if(pos == -1) return num%lcm == 0;
    if(!limit && ~dp[pos][Hash[lcm]][num]) return dp[pos][Hash[lcm]][num];
    long long ans = 0;
    int up = limit ? dis[pos] : 9;
    for(int i=0 ; i<=up ; i++)
        ans += dfs(pos-1, (num*10+i)%mod, i ? lcm*i/gcd(lcm, i) : lcm, limit && i == up);
    if(!limit) dp[pos][Hash[lcm]][num] = ans;
    return ans;
}
long long solve(long long n) {
    int pos = 0;
    while(n) dis[pos++] = n%10, n /= 10;
    return dfs(pos-1, 0, 1, true);
}
int main() {
//    freopen("in.txt","r",stdin);
    int _, cnt = 0; scanf("%d", &_);
    for(int i=1 ; i<=mod ; i++) if(mod%i == 0) Hash[i] = cnt++;
    memset(dp, -1, sizeof(dp));
    while(_--) {
        long long l, r;
        scanf("%lld%lld", &l, &r);
        printf("%lld\n", solve(r)-solve(l-1));
    }
    return 0;
}
```