---
title: "洛谷P3943 - 星空 - spfa + 状压DP"
date: 2018-03-11 01:01:00 +0800
last_modified_at: 2018-05-23 18:17:19 +0800
math: true
render_with_liquid: false
categories: ["ACM", "图论"]
tags: ["动态规划", "最短路"]
img_path: /assets/img/posts/2018/03/11/2018-03-11-luo_gu_p3943_xing_kong_spfa_zhuang_ya_dp/
---

### 题目链接：

https://www.luogu.org/problemnew/show/P3943

---
### 题目：

#### 题目描述
逃不掉的那一天还是来了，小 F 看着夜空发呆。

天上空荡荡的，没有一颗星星——大概是因为天上吹不散的乌云吧。

心里吹不散的乌云，就让它在那里吧，反正也没有机会去改变什么了。

小 C 拿来了一长串星型小灯泡，假装是星星，递给小 F，想让小 F 开心一点。不过，有 着强迫症的小 F 发现，这串一共 n 个灯泡的灯泡串上有 k 个灯泡没有被点亮。小 F 决定 和小 C 一起把这个灯泡串全部点亮。

不过，也许是因为过于笨拙，小 F 只能将其中连续一段的灯泡状态给翻转——点亮暗灯 泡，熄灭亮灯泡。经过摸索，小 F 发现他一共能够翻转 m 种长度的灯泡段中灯泡的状态。

小 C 和小 F 最终花了很长很长很长很长很长很长的时间把所有灯泡给全部点亮了。他 们想知道他们是不是蠢了，因此他们找到了你，让你帮忙算算：在最优的情况下，至少需要 几次操作才能把整个灯泡串给点亮？ 
#### 输入
输入第1行三个正整数$n,k,m$。输入第2行$k$个正整数，第$i$个数表示第$i$个被没点亮的灯泡的位置$a_i$。输入第3行$m$个正整数，第$i$个数表示第i种操作的长度$b_i$。保证所有$b_i$互不相同；保证对于$1≤i<k$，有$a_i<a_i+1$；保证输入数据有解。
#### 输出
输出一行一个非负整数，表示最少操作次数。
#### 样例输入
```
5 2 2
1 5
3 4
```
#### 样例输出
```
2
```

![20180116211247_73366.jpg][1]

---
### 思路：

&emsp;&emsp;看到成段修改01串，考虑先差分一下，发现对于一次区间操作，如果区间两端同为1，那么这两个1就会消失，如果一端是0一端是1，那么就会交换。

&emsp;&emsp;考虑对于某个1，一次以其为端点的区间操作实际上就是把这个1挪到了另一个端点上去，再和那个端点上原有的数字进行异或操作。这样就可以进行类bfs操作预处理出所有的状态，然后进行状压DP。

---
### 实现：

```cpp
## include <bits/stdc++.h>
using namespace std;
const int maxn = 40005, maxm = 70, maxk = 20;
int n, k, m, a[maxn], len[maxm], number[maxn], dist[maxk][maxk], step[maxn], cnt = 0, idx[maxn], g[(1 << maxk)];
void spfa(int u) {
    memset(step, -1, sizeof(step));
    queue<int> que;
    que.push(idx[u]);
    step[idx[u]] = 0;
    while (!que.empty()) {
        int tmp_u = que.front();
        for (int k = 1; k <= m; k++)
            for (int j = -1; j <= 1; j += 2) {
                int tmp_v = tmp_u + len[k] * j;
                if (tmp_v <= 0 || tmp_v > n || step[tmp_v] != -1) continue;
                step[tmp_v] = step[tmp_u] + 1;
                que.push(tmp_v);
            }
        que.pop();
    }
    for (int v = 1; v <= n; v++) if (number[v] != 0) dist[u][number[v]] = step[v];
}
int read() {
    int x = 0, ch;
    do ch = getchar(); while (!isdigit(ch));
    do x = x * 10 + (ch ^ '0'); while (ch = getchar(), isdigit(ch));
    return x;
}
int main() {
    scanf("%d%d%d", &n, &k, &m);
    for (int i = 1; i <= k; i++) a[read()] = 1;
    for (int i = 1; i <= m; i++) len[i] = read();
    n++;
    for (int i = 1; i <= n; i++) if (a[i] ^ a[i - 1]) number[i] = ++cnt, idx[cnt] = i;
    memset(dist, -1, sizeof(dist));
    for (int i = 1; i <= cnt; i++) spfa(i);
    memset(g, 0x3f, sizeof(g));
    g[0] = 0;
    for (int u = 0; u < (1 << cnt); u++) {
        for (int i = 1; i <= cnt; i++) if ((u & (1 << i - 1)) == 0)
                for (int j = i + 1; j <= cnt; j++) if ((u & (1 << j - 1)) == 0)
                        if (dist[i][j] != -1) {
                            int v = ((u | (1 << i - 1)) | (1 << j - 1));
                            g[v] = min(g[v], g[u] + dist[i][j]);
                        }
    }
    printf("%d\n", g[(1 << cnt) - 1]);
    return 0;
}
```


  [1]: assets/img/posts/2018/03/11/2018-03-11-luo_gu_p3943_xing_kong_spfa_zhuang_ya_dp/20180116211247_73366.jpg