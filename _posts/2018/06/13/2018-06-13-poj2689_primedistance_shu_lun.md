---
title: "POJ2689 - Prime Distance - 数论"
date: 2018-06-13 19:09:00 +0800
last_modified_at: 2018-06-13 19:11:17 +0800
math: true
render_with_liquid: false
categories: ["ACM", "数学类"]
tags: ["数论"]
---

### 题目链接

[https://poj.org/problem?id=2689](https://www.lucien.ink/go/poj2689/)

---
### 题目

#### Description

The branch of mathematics called number theory is about properties of numbers. One of the areas that has captured the interest of number theoreticians for thousands of years is the question of primality. A prime number is a number that is has no proper factors (it is only evenly divisible by 1 and itself). The first prime numbers are 2,3,5,7 but they quickly become less frequent. One of the interesting questions is how dense they are in various ranges. Adjacent primes are two numbers that are both primes, but there are no other prime numbers between the adjacent primes. For example, 2,3 are the only adjacent primes that are also adjacent numbers. 
Your program is given 2 numbers: L and U (1<=L< U<=2,147,483,647), and you are to find the two adjacent primes C1 and C2 (L<=C1< C2<=U) that are closest (i.e. C2-C1 is the minimum). If there are other pairs that are the same distance apart, use the first pair. You are also to find the two adjacent primes D1 and D2 (L<=D1< D2<=U) where D1 and D2 are as distant from each other as possible (again choosing the first pair if there is a tie).
#### Input

Each line of input will contain two positive integers, L and U, with L < U. The difference between L and U will not exceed 1,000,000.
#### Output

For each L and U, the output will either be the statement that there are no adjacent primes (because there are less than two primes between the two given numbers) or a line giving the two pairs of adjacent primes.

---
### 题意

&emsp;&emsp;给定两个整数`L R`，输出闭区间$[L,R]$中相差最多的两个相邻的质数和相差最小的两个相邻的质数。

---
### 思路

&emsp;&emsp;注意到R的上限是$2^{31}-1$，但是$R-L \leq 10^6$，每个合数$x$必定包含一个不超过$\sqrt{x}$的质因子，所以我们只需要求出$[2,\sqrt{R}]$中的所有质数，然后就能筛出$[L,R]$中的所有素数，枚举每对相邻的素数就可以了。

&emsp;&emsp;时间复杂度为$O(\sqrt{R}\log \log\sqrt{R}+(R-L)\log\log R)$。

---
### 实现

```cpp
## include <cstdio>
## include <cstring>
## include <cmath>
## include <algorithm>
const int maxn = 65536 + 7, maxm = int(2e6) + 7;
int minimal_prime_factor[maxn], prime[maxn], cnt_prime;
void primes(int upper) {
    for (int i = 2; i <= upper; i++) {
        if (minimal_prime_factor[i] == 0) {
            minimal_prime_factor[i] = i;
            prime[++cnt_prime] = i;
        }
        int tmp = upper / i;
        for (int j = 1; j <= cnt_prime; j++) {
            if (prime[j] > minimal_prime_factor[i] || prime[j] > tmp) break;
            minimal_prime_factor[i * prime[j]] = prime[j];
        }
    }
}
bool composite[maxm];
int tmp[maxm], len_tmp, l, r;
int main() {
    primes(50000);
    while (~scanf("%d%d", &l, &r)) {
        int upper = int(sqrt(r)) + 1;
        memset(composite, 0, sizeof(composite));
        if (l == 1) composite[0] = true;
        for (int i = 1; prime[i] <= upper; i++) {
            long long j = l / prime[i];
            for (; j * prime[i] <= r; j++) {
                if (j < 2 || j * prime[i] < l) continue;
                composite[j * prime[i] - l] = true;
            }
        }
        len_tmp = 0;
        for (unsigned int i = l, cur = 0; i <= r; i++, cur++) if (!composite[cur]) tmp[++len_tmp] = i;
        if (len_tmp > 1) {
            int max_dist = -1, min_dist = 0x3f3f3f3f;
            std::pair<int, int> max_pair, min_pair;
            for (int i = 2; i <= len_tmp; i++) {
                int diff = tmp[i] - tmp[i - 1];
                if (diff < min_dist) {
                    min_pair.first = tmp[i - 1], min_pair.second = tmp[i];
                    min_dist = diff;
                }
                if (diff > max_dist) {
                    max_pair.first = tmp[i - 1], max_pair.second = tmp[i];
                    max_dist = diff;
                }
            }
            printf("%d,%d are closest, %d,%d are most distant.\n", min_pair.first, min_pair.second, max_pair.first, max_pair.second);
        } else puts("There are no adjacent primes.");
    }
    return 0;
}
```