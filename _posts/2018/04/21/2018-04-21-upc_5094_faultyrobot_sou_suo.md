---
title: "UPC-5094 - Faulty Robot - 搜索"
date: 2018-04-21 23:44:00 +0800
last_modified_at: 2018-05-23 18:15:09 +0800
math: false
render_with_liquid: false
categories: ["ACM", "搜索"]
tags: ["搜索"]
img_path: /assets/img/posts/2018/04/21/2018-04-21-upc_5094_faultyrobot_sou_suo/
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5094

---
### 题目：

#### 题目描述
As part of a CS course, Alice just ﬁnished programming her robot to explore a graph having n nodes, labeled 1, 2, . . . , n, and m directed edges. Initially the robot starts at node 1.
While nodes may have several outgoing edges, Alice programmed the robot so that any node may have a forced move to a speciﬁc one of its neighbors. For example, it may be that node 5 has outgoing edges to neighbors 1, 4, and 6 but that Alice programs the robot so that if it leaves 5 it must go to neighbor 4.
If operating correctly, the robot will always follow forced moves away from a node, and if reaching a node that does not have a forced move, the robot stops. Unfortunately, the robot is a bit buggy, and it might violate those rules and move to a randomly chosen neighbor of a node (whether or not there had been a designated forced move from that node). However, such a bug will occur at most once (and might never happen). 
Alice is having trouble debugging the robot, and would like your help to determine what are the possible nodes where the robot could stop and not move again.
We consider two sample graphs, as given in Figures G.1 and G.2. In these ﬁgures, a red arrow indicate an edge corresponding to a forced move, while black arrows indicate edges to other neighbors. The circle around a node is red if it is a possible stopping node.

![20171204160448_35652.jpg][1]

In the ﬁrst example, the robot will cycle forever through nodes 1, 5, and 4 if it does not make a buggy move.
A bug could cause it to jump from 1 to 2, but that would be the only buggy move, and so it would never move on from there. It might also jump from 5 to 6 and then have a forced move to end at 7.
In the second example, there are no forced moves, so the robot would stay at 1 without any buggy moves. It might also make a buggy move from 1 to either 2 or 3, after which it would stop.
#### 输入
The ﬁrst line contains two integers n and m, designating the number of nodes and number of edges such that 1 ≤ n ≤ 103, 0 ≤ m ≤ 104. The next m lines will each have two integers a and b, 1 ≤ |a|, b ≤ n and |a| ≠ b. If a > 0, there is a directed edge between nodes a and b that is not forced. If a < 0, then there is a forced directed edge from −a to b. There will be at most 900 such forced moves. No two directed edges will be the same. No two starting nodes for forced moves will be the same.
#### 输出
Display the number of nodes at which the robot might come to a rest.
#### 样例输入
```
7 9
1 2
2 3
-1 5
2 6
5 1
-4 1
5 6
-6 7
-5 4
```
#### 样例输出
```
2
```


---
### 题意：

&emsp;&emsp;给你一个`n`个点`m`条边的有向图，初始时机器人在`1`这个顶点，默认情况下机器人只能沿着红色的边走。但是这个机器人可能会出BUG，至多出BUG一次，出BUG时机器人会从当前点随机地沿着有向图的边走到一个相邻的点，忽略这条边的颜色。问这个机器人可能最终停留的点的数目。

---
### 思路：

&emsp;&emsp;从节点`1`开始按照正常路径走，枚举在每个点发生BUG时所有可能的最终归属，加到`set`里，最后输出`set.size()`即可。需要注意的是有可能在`1`这个点就出BUG，所以要先`check(1)`一下，因为这个`WA`了一次。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(1e4) + 7, maxm = int(1e5) + 7;
bool red[maxn], vis[maxn], checked[maxn];
struct {
    int next, to;
    bool col; // true: red
} edge[maxm];
int n, m, head_edge[maxn], cnt_edge;

void addedge(int u, int v, bool col) {
    edge[cnt_edge] = {head_edge[u], v, col};
    head_edge[u] = cnt_edge++;
}

std::set<int> ans;

void check(int u) { // check以u这个点为起点时不出BUG机器人最终会停在哪里
    checked[u] = true;
    if (!red[u] || head_edge[u] == -1) {
        ans.insert(u);
        return ;
    }
    for (int i = head_edge[u]; ~i; i = edge[i].next) {
        int v = edge[i].to;
        if (edge[i].col && !checked[v]) check(v);
    }
}

void dfs(int u) {
    vis[u] = true;
    for (int i = head_edge[u]; ~i; i = edge[i].next) {
        int v = edge[i].to;
        if (!edge[i].col && !checked[v]) check(v);
        if (edge[i].col && !vis[v]) dfs(v);
    }
}

int main() {
//    freopen("in.txt", "r", stdin);
    memset(head_edge, 0xff, sizeof(head_edge));
    scanf("%d%d", &n, &m);
    for (int i = 0, u, v; i < m; i++) {
        scanf("%d%d", &u, &v);
        int tmp = abs(u);
        if (u < 0) red[tmp] = true;
        addedge(tmp, v, u < 0);
    }
    check(1);
    dfs(1);
    printf("%d\n", (int)ans.size());
    return 0;
}
```


  [1]: assets/img/posts/2018/04/21/2018-04-21-upc_5094_faultyrobot_sou_suo/20171204160448_35652.jpg