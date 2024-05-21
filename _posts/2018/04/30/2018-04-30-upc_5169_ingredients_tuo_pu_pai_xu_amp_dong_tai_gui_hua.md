---
title: "UPC-5169 - Ingredients - 拓扑排序 &amp; 动态规划"
date: 2018-04-30 20:47:16 +0800
last_modified_at: 2018-04-30 20:47:28 +0800
math: true
render_with_liquid: false
categories: ["ACM", "动态规划"]
tags: ["动态规划"]
---

### 题目链接：

https://codeforces.com/gym/101635/attachments

---
### 题目：

#### 题目描述
The chef of a restaurant aspiring for a Michelin star wants to display a selection of her signature dishes for inspectors. For this, she has allocated a maximum budget B for the cumulated cost, and she wants to maximize the cumulated prestige of the dishes that she is showing to the inspectors.
To measure the prestige of her dishes, the chef maintains a list of recipes, along with their costs and ingredients. For each recipe, a derived dish is obtained from a base dish by adding an ingredient. The recipe mentions two extra pieces of information: the cost of applying the recipe, on top of the cost of the base dish, and the prestige the recipe adds to the prestige of the base dish. The chef measures the prestige by her own units, called “prestige units.”
For example, a recipe list for making pizza looks like:
• pizza_tomato pizza_base tomato 1 2
• pizza_classic pizza_tomato cheese 5 5
Here, pizza_base is an elementary dish, a dish with no associated recipe, a dish so simple that its cost is negligible (set to 0) and its prestige also 0. The chef can obtain the derived dish pizza_tomato by adding the ingredient tomato to the base dish pizza_base, for a cost of 1 euro and a gain of 2 prestige units. A pizza_classic is obtained from a pizza_tomato by adding cheese, for an added cost of 5, and a prestige of 5 added to the prestige of the base dish; this means the total cost of pizza_classic is 6 and its total prestige is 7.
A signature dish selection could for instance include both a pizza_tomato and a pizza_classic.
Such a selection would have cumulated total prestige of 9, and cumulated total cost of 7.
Armed with the list of recipes and a budget B, the chef wants to provide a signature dish selection to Michelin inspectors so that the cumulated total prestige of the dishes is maximized, keeping their   cumulated   total cost at most B.
Important Notes
• No dish can appear twice in the signature dish selection.
• Any dish that does not appear as a derived dish in any recipe is considered to be an elementary dish, with cost 0 and prestige 0.
• A dish can appear more than once as a resulting dish in the recipe list; if there is more than one way to obtain a dish, the one yielding the smallest total cost is always chosen; if the total costs are equal, the one yielding the highest total prestige should be chosen.
• The recipes are such that no dish D can be obtained by adding one or more ingredients to D itself.
#### 输入
• The ﬁrst line consists of the budget B, an integer.
• The second line consists of the number N of recipes, an integer.
• Each of the following N lines describes a recipe, as the following elements separated by single  spaces:    the derived dish name (a string); the base dish name (a string); the added ingredient (a string); the added price (an integer); the added prestige (an integer).
Limits
• 0≤B≤10 000;
• 0≤N≤1 000 000;
• there can be at most 10 000 different dishes (elementary or derived);
• costs and prestiges in recipes are between 1 and 10 000 (inclusive);
• strings contain at most 20 ASCII characters (letters, digits, and ’_’ only).

#### 输出
The output should consist of two lines, each with a single integer. On the first line: the maximal cumulated prestige within the budget. On the second line: the minimal cumulated cost corresponding to the maximal cumulated prestige, necessarily less than or equal to the budget.
#### 样例输入
```
15
6
pizza_tomato pizza_base tomato 1 2
pizza_cheese pizza_base cheese 5 10
pizza_classic pizza_tomato cheese 5 5
pizza_classic pizza_cheese tomato 1 2
pizza_salami pizza_classic salami 7 6
pizza_spicy pizza_tomato chili 3 1

```
#### 样例输出
```
25
15
```

---
### 题意：

&emsp;&emsp;你有$B$元钱，有六种菜，`A B C cost val`代表做出`A`这道菜需要`B`和`C`两种菜，花费为`cost`元，获得的权值为`val`点声望，其中`C`的花费和权值一定都为$0$，问你最大能获得的声望是多少。

---
### 思路：

&emsp;&emsp;题目里说道最多有$10^4$元钱，菜单最多会有$10^4$道不同的菜，显然可以通过$O(10^8)$背包解决。

&emsp;&emsp;首先我们可以通过带回溯的拓扑排序求出做出每种菜的最小花费，然后背包即可，但是比赛的时候很坑的一点是，原题目给的是4秒和512M，但是我们学校的OJ只有3秒和128M，又加上我们学校的服务器不是很快，导致写的不优的话就会TLE。

&emsp;&emsp;进行字符串哈希的时候用到了`std::map`，但是一直超时，换成了`std::unordered_map`果断就过了。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e6) + 7, inf = 0x3f3f3f3f;

struct tuple {
    int cost, val;
    bool operator<(const tuple &tmp) const {
        return cost == tmp.cost ? val > tmp.val : cost < tmp.cost;
    }
    void update(tuple tmp) {
        if (tmp < *this) *this = tmp;
    }
} item[maxn << 2];

namespace graph {
    int head[maxn << 2], cnt;
    struct { int next, to, cost, val; } edge[maxn];
    inline void addedge(int u, int l, int cost, int val) {
        edge[cnt] = {head[u], l, cost, val};
        head[u] = cnt++;
    }
    inline void init() {
        cnt = 0;
        memset(head, 0xff, sizeof(head));
    }
}

namespace hash {
    int cnt;
    std::unordered_map<std::string, int> unordered_map;
    void init() {
        cnt = 0;
        unordered_map.clear();
    }
    inline int index(char *s) {
        if (unordered_map.count(s)) return unordered_map[s];
        return (unordered_map[s] = cnt++);
    }
}

int B, n;

namespace process {
    bool isGoal[maxn << 2], vis[maxn << 2];
    int dp[int(1e4) + 7];

    tuple dfs(int u) {
        if (vis[u]) return item[u];
        vis[u] = true;
        if (!isGoal[u]) return {0, 0};
        tuple ret = {inf, 0}, a;
        for (int i = graph::head[u]; ~i; i = graph::edge[i].next) {
            a = dfs(graph::edge[i].to);
            ret.update({graph::edge[i].cost + a.cost, graph::edge[i].val + a.val});
        }
        return (item[u] = ret);
    }
    void init() {
        hash::init();
        graph::init();
        scanf("%d%d", &B, &n);
        char aim[107], a[107], b[107];
        for (int i = 0, cost, val, cur; i < n; i++) {
            scanf("%s%s%s%d%d", aim, a, b, &cost, &val);
            cur = hash::index(aim);
            isGoal[cur] = true;
            graph::addedge(cur, hash::index(a), cost, val);
        }
        for (int i = 0; i < hash::cnt; i++) {
            if (isGoal[i] && !vis[i]) dfs(i);
        }
    }
    tuple solve() {
        int ans_val = 0, ans_cost = 0;
        for (int i = 0; i < hash::cnt; i++) if (isGoal[i]) {
                int cost = item[i].cost, val = item[i].val;
                for (int j = B; j >= cost; j--) dp[j] = std::max(dp[j], dp[j - cost] + val);
            }
        for (int i = 0; i <= B; i++)
            if (dp[i] > ans_val) {
                ans_val = dp[i];
                ans_cost = i;
            }
        return {ans_cost, ans_val};
    }
}

int main() {
//    freopen("in.txt", "r", stdin);
    process::init();
    tuple ans = process::solve();
    printf("%d\n%d\n", ans.val, ans.cost);
    return 0;
}
```