---
title: "洛谷P3942 - 入阵曲 - 二维版k倍区间"
date: 2018-02-01 00:05:00 +0800
last_modified_at: 2018-05-23 18:19:27 +0800
math: true
render_with_liquid: false
categories: ["ACM", "思维"]
tags: ["题解", "思维"]
img_path: /assets/img/posts/2018/02/01/2018-02-01-luo_gu_p3942_ru_zhen_qu_er_wei_ban_k_bei_qu_jian/
---

### 链接：

https://www.lucien.ink/go/P3942/

---
### 题目：

#### 题目描述
丹青千秋酿，一醉解愁肠。
无悔少年枉，只愿壮志狂。小F很喜欢数学，但是到了高中以后数学总是考不好。有一天，他在数学课上发起了呆；他想起了过去的一年。一年前，当他初识算法竞赛的时候，觉得整个世界都焕然一新。这世界上怎么会有这么多奇妙的东西？曾经自己觉得难以解决的问题，被一个又一个算法轻松解决。小F当时暗自觉得，与自己的幼稚相比起来，还有好多要学习的呢。一年过去了，想想都还有点恍惚。他至今还能记得，某天晚上听着入阵曲，激动地睡不着觉，写题写到鸡鸣时分都兴奋不已。也许，这就是热血吧。

![20180116202950_35491.jpg][1]

也就是在那个时候，小F学会了矩阵乘法。让两个矩阵乘几次就能算出斐波那契数列的第10100项，真是奇妙无比呢。不过，小F现在可不想手算矩阵乘法——他觉得好麻烦。取而代之的，是一个简单的小问题。他写写画画，画出了一个n×m的矩阵，每个格子里都有一个不超过k的正整数。
小F想问问你，这个矩阵里有多少个不同的子矩形中的数字之和是k的倍数？如果把一个子矩形用它的左上角和右下角描述为(x1,y1,x2,y2)，其中x1≤x2,y1≤y2；
那么，我们认为两个子矩形是不同的，当且仅当他们以(x1,y1,x2,y2)表示时不同；也就是说，只要两个矩形以(x1,y1,x2,y2)表示时相同，就认为这两个矩形是同一个矩形，你应该在你的答案里只算一次。

#### 输入
输入第一行，包含三个正整数n,m,k。输入接下来n行，每行包含m个正整数，第
#### 输出
输入一行一个非负整数，表示你的答案。
#### 样例输入
```
2 3 2
1 2 1
2 1 2
```
#### 样例输出
```
6
```
#### 提示
这些矩形是符合要求的：(1,1,1,3)，(1,1,2,2)，(1,2,1,2)，(1,2,2,3)，(2,1,2,1)，(2,3,2,3)。

![20180116203446_99214.jpg][2]

---
### 思路：

&emsp;&emsp;[k倍区间](https://lucien.ink/archives/63/)的二维版，i、j枚举子矩阵的上下边界，k枚举处理到了第几列，把i、j行之间，右边界是第k列的这个矩阵和取模统计一下，具体原理在[链接](https://lucien.ink/archives/63/)里说的很详细，$O(n^3)$可过。

---
### 实现：

```cpp
## include <cstdio>
typedef long long ll;
const int maxn = 507;
ll ans = 0;
int cnt[int(1e6) + 7], num[maxn], sum[maxn][maxn];
int main() {
    int n, m, k, tmp;
    scanf("%d%d%d", &n, &m, &k);
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            scanf("%d", &tmp);
            sum[i][j] = sum[i - 1][j] + sum[i][j - 1] + tmp - sum[i - 1][j - 1];
            if (sum[i][j] >= k) sum[i][j] -= k;
        }
    }
    for (int i = 1; i <= n; i++) {
        for (int j = i; j <= n; j++) {
            cnt[0] = 1;
            for (int cur = 1; cur <= m; cur++) {
                num[cur] = (sum[j][cur] - sum[i - 1][cur]) % k;
                if (num[cur] < 0) num[cur] += k;
                ans += cnt[num[cur]];
                cnt[num[cur]]++;
            }
            for (int cur = 1; cur <= m; cur++) cnt[num[cur]] = 0;
        }
    }
    printf("%lld\n", ans);
    return 0;
}
```


  [1]: assets/img/posts/2018/02/01/2018-02-01-luo_gu_p3942_ru_zhen_qu_er_wei_ban_k_bei_qu_jian/20180116202950_35491.jpg
  [2]: assets/img/posts/2018/02/01/2018-02-01-luo_gu_p3942_ru_zhen_qu_er_wei_ban_k_bei_qu_jian/20180116203446_99214.jpg