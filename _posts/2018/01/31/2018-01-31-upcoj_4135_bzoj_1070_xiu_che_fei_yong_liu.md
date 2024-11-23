---
title: "UPCOJ-4135 - BZOJ-1070 - 修车 - 费用流"
date: 2018-01-31 12:59:00 +0800
last_modified_at: 2018-05-23 18:19:43 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["网络流", "题解"]
---

### 链接：

https://www.lucien.ink/go/bzoj1070/

---
### 题目：

#### Description

　　同一时刻有N位车主带着他们的爱车来到了汽车维修中心。维修中心共有M位技术人员，不同的技术人员对不同
的车进行维修所用的时间是不同的。现在需要安排这M位技术人员所维修的车及顺序，使得顾客平均等待的时间最
小。 说明：顾客的等待时间是指从他把车送至维修中心到维修完毕所用的时间。

#### Input

　　第一行有两个m,n，表示技术人员数与顾客数。 接下来n行，每行m个整数。第i+1行第j个数表示第j位技术人
员维修第i辆车需要用的时间T。

#### Output

　　最小平均等待时间，答案精确到小数点后2位。

#### Sample Input
```
2 2
3 2
1 4
```
#### Sample Output
```
1.50
```
#### HINT

数据范围: (2<=M<=9,1<=N<=60), (1<=T<=1000)

---
### 思路：

&emsp;&emsp;将一个工人拆成$n$个点，对于每个工人，第$k$个点连的点$i$代表这个工人修的倒数第$k$辆车是第$i$辆车$(1 \leq i \leq n)$，因为这个工人倒数第$k$个修这辆车的时候，就代表着之后的车都需要等这辆车修理好，所以说对费用的贡献为$k \times cost$。

&emsp;&emsp;源点向$m$个工人连边，每个工人再连$n$条边，$n \times m$个工人再向$n$辆车连边，最后$n$辆车再连汇点。

&emsp;&emsp;可以略做优化，我们会发现在实际运作的时候那$m$个点并没有什么用，所以我们索性把这代表着$m$个工人的点去掉，源点直接与拆出的$n \times m$个工人连边，然后与$n$辆车连边，然后汇点，这样的话就只有两层，共计$m + n \times m + n$条边，跑裸费用流就可以。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxm = int (5e5) + 7, inf = 0x3f3f3f3f;
struct { int next, u, v, cost, flow; } edge[maxm];
int m, n, tmp, head_edge[1007], cnt_edge, S = 0, T = 1001;
void addedge(int u, int v, int cost, int flow = 1) {
    edge[cnt_edge] = {head_edge[u], u, v, cost, flow};
    head_edge[u] = cnt_edge++;
    edge[cnt_edge] = {head_edge[v], v, u, -cost, 0};
    head_edge[v] = cnt_edge++;
}
int dist[1007], pre[1007], Cost;
bool inque[1007];
int mfmc() {
    while (true) {
        memset(dist, 0x3f, sizeof(dist));
        memset(inque, 0, sizeof(inque));
        dist[S] = 0;
        queue<int> que;
        que.push(S);
        while (!que.empty()) {
            int u = que.front();
            que.pop();
            inque[u] = false;
            for (int i = head_edge[u]; ~i; i = edge[i].next) {
                int v = edge[i].v, cost = edge[i].cost, flow = edge[i].flow;
                if (flow && dist[v] > dist[u] + cost) {
                    dist[v] = dist[u] + cost;
                    pre[v] = i;
                    if (!inque[v]) que.push(v), inque[v] = true;
                }
            }
        }
        if (dist[T] == inf) break;
        Cost += dist[T];
        for (int u = T; u != S; u = edge[pre[u]].u) {
            edge[pre[u]].flow--;
            edge[pre[u] ^ 1].flow++;
        }
    }
    return Cost;
}
int main() {
//    freopen("in.txt", "r", stdin);
    scanf("%d%d", &m, &n);
    memset(head_edge, -1, sizeof(head_edge));
    cnt_edge = 0;
    // i代表车，j代表工人
    for (int i = 1; i <= n; i++) {
        addedge(i, T, 0); // 每辆车和汇点相连
        for (int j = 1; j <= m; j++) {
            addedge(S, j * n + i, 0); // 因为偷懒就直接写在这里了，代表汇点和拆开的n * m个工人相连
            scanf("%d", &tmp);
            for (int k = 1; k <= n; k++) addedge(j * n + k, i, k * tmp);
        }
    }
    printf("%.2f\n", 1.0 * mfmc() / n); // 常规最小费最大流
    return 0;
}
```