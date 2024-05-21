---
title: "UPC-5573 - Rental Service - 枚举"
date: 2018-03-12 22:23:22 +0800
last_modified_at: 2018-03-12 22:23:41 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["思维", "枚举"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5573

---
### 题目：

#### 题目描述
Farmer John realizes that the income he receives from milk production is insufficient to fund the growth of his farm, so to earn some extra money, he launches a cow-rental service, which he calls "USACOW" (pronounced "Use-a-cow").
Farmer John has N cows (1≤N≤100,000), each capable of producing some amount of milk every day. The M stores near FJ's farm (1≤M≤100,000) each offer to buy a certain amount of milk at a certain price. Moreover, Farmer John's RR (1≤R≤100,000) neighboring farmers are each interested in renting a cow at a certain price.

Farmer John has to choose whether each cow should be milked or rented to a nearby farmer. Help him find the maximum amount of money he can make per day.
#### 输入
The first line in the input contains N, M, and R. The next N lines each contain an integer cici (1≤ci≤1,000,000), indicating that Farmer John's iith cow can produce cici gallons of milk every day. The next M lines each contain two integers qi and pi (1≤qi,pi≤1,000,000), indicating that the ith store is willing to buy up to qi gallons of milk for pi cents per gallon. Keep in mind that Farmer John can sell any amount of milk between zero and qiqi gallons to a given store. The next RR lines each contain an integer ri (1≤ri≤1,000,000), indicating that one of Farmer John's neighbors wants to rent a cow for ri cents per day.
#### 输出
The output should consist of one line containing the maximum profit Farmer John can make per day by milking or renting out each of his cows. Note that the output might be too large to fit into a standard 32-bit integer, so you may need to use a larger integer type like a "long long" in C/C++.
#### 样例输入
```
5 3 4
6
2
4
7
1
10 25
2 10
15 15
250
80
100
40
```
#### 样例输出
```
725
```
#### 提示
Farmer John should milk cows #1 and #4, to produce 13 gallons of milk. He should completely fill the order for 10 gallons, earning 250 cents, and sell the remaining three gallons at 15 cents each, for a total of 295 cents of milk profits.

Then, he should rent out the other three cows for 250, 80, and 100 cents, to earn 430 more cents. (He should leave the request for a 40-cent rental unfilled.) This is a total of 725 cents of daily profit.

---
### 题意：

&emsp;&emsp;Farmer John有$n$头牛，每头牛每天的产奶量为$c_i$升，每天有$m$个人想要买牛奶，第$i$个人最多买$q_i$升，每升愿意出$p_i$元，有$r$个人愿意租牛，第$i$个人愿意花$r_i$元买一头牛，且每头牛要么卖牛奶，要么被出租。问Farmer John一天最多能赚多少钱。

---
### 思路：

&emsp;&emsp;假设有$i$头牛用来卖牛奶，那么剩下的$n - i$头牛用来出租，直接枚举$i$即可。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e5) + 7;
int cow_milk[maxn], rent[maxn], n, m, r, cur_sale = 1;
long long money_rent[maxn], sum_cow_milk, money_sale, sum_sale_milk, ans;
struct Sale {
    int amount, price;
    bool operator < (const Sale &tmp) const {
        return price > tmp.price;
    }
} sale[maxn];

int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d%d", &n, &m, &r);
    for (int i = 1; i <= n; i++) scanf("%d", cow_milk + i);
    for (int i = 1; i <= m; i++) scanf("%d%d", &sale[i].amount, &sale[i].price);
    for (int i = 1; i <= r; i++) scanf("%d", rent + i);
    std::sort(cow_milk + 1, cow_milk + 1 + n, std::greater<int>());
    std::sort(sale + 1, sale + 1 + m);
    std::sort(rent + 1, rent + 1 + r, std::greater<int>());
    for (int i = 1; i <= r; i++) money_rent[i] = money_rent[i - 1] + rent[i];
    for (int i = 0; i <= n; i++) {
        sum_cow_milk += cow_milk[i];
        if (i < n - r) continue ;
        while (sum_sale_milk < sum_cow_milk && cur_sale <= m) {
            if (sum_cow_milk - sum_sale_milk >= sale[cur_sale].amount) {
                money_sale += 1ll * sale[cur_sale].amount * sale[cur_sale].price;
                sum_sale_milk += sale[cur_sale].amount;
                cur_sale++;
            } else {
                sale[cur_sale].amount -= sum_cow_milk - sum_sale_milk;
                money_sale += 1ll * sale[cur_sale].price * (sum_cow_milk - sum_sale_milk);
                sum_sale_milk = sum_cow_milk;
            }
        }
        ans = std::max(ans, money_sale + money_rent[n - i]);
    }
    printf("%lld\n", ans);
    return 0;
}
```