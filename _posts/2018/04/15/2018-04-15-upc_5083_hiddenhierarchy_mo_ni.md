---
title: "UPC-5083 - Hidden Hierarchy - 模拟"
date: 2018-04-15 19:51:00 +0800
last_modified_at: 2018-04-15 19:52:46 +0800
math: false
render_with_liquid: false
categories: ["ACM", "模拟"]
tags: ["模拟"]
---

### 题目链接：

https://exam.upc.edu.cn/problem.php?id=5083

---
### 题目：

#### 题目描述
You are working on the user interface for a simple text-based file explorer. One of your tasks is to build a navigation pane displaying the directory hierarchy. As usual, the filesystem consists of directories which may contain files and other directories, which may, in turn, again contain files and other directories etc. Hence, the directories form a hierarchical tree structure. The top-most directory in the hierarchy is called the root directory. If directory d directly contains directory e we will say that d is the parent directory of e while e is a subdirectory od d. Each file has a size expressed in bytes. The directory size is simply the total size of all files directly or indirectly contained inside that directory.
All files and all directories except the root directory have a name — a string that always starts with a letter and consists of only lowercase letters and “.” (dot) characters. All items (files and directories) directly inside the same parent directory must have unique names. Each item (file and directory) can be uniquely described by its path — a string built according to the following rules:
• Path of the root directory is simply “/” (forward slash).
• For a directory d, its path is obtained by concatenating the directory names top to bottom along the hierarchy from the root directory to d, preceding each name with the “/” character and placing another “/” character at the end of the path.
• For a file f , its path is the concatenation of the parent directory path and the name of file f .
We display the directory hierarchy by printing the root directory. We print a directory d by outputting a line of the form “md pd sd” where pd and sd are the path and size of directory d respectively, while md is its expansion marker explained shortly. If d contains other directories we must choose either to collapse it or to expand it. If we choose to expand d we print (using the same rules) all of its subdirectories in lexicographical order by name. If we choose to collapse directory d, we simply ignore its contents. 
The expansion marker md is a single blank character when d does not have any subdirectories, “+” (plus) character when we choose to collapse d or a “-” (minus) character when we choose expand d. 
Given a list of files in the filesystem and a threshold integer t, display the directory hierarchy ensuring that each directory of size at least t is printed. Additionally, the total number of directories printed should be minimal. Assume there are no empty directories in the filesystem — the entire hierarchy can be deduced from the provided file paths. Note that the root directory has to be printed regardless of its size. Also note that a directory of size at least t only has to be printed, but not necessarily expanded.
#### 输入
The ﬁrst line contains an integer n (1 ≤ n ≤ 1 000) — the number of ﬁles. Each of the following n lines contains a string f and an integer s (1 ≤ s ≤ 106) — the path and the size of a single ﬁle. Each path is at most 100 characters long and is a valid ﬁle path according to the rules above. All paths will be different.
The following line contains an integer t (1 ≤ t ≤ 109) — the threshold directory size.
#### 输出
Output the minimal display of the ﬁlesystem hierarchy for the given threshold as described above.
#### 样例输入
```
9
/sys/kernel/notes 100
/cerc/problems/a/testdata/in 1000000
/cerc/problems/a/testdata/out 8
/cerc/problems/a/luka.cc 500
/cerc/problems/a/zuza.cc 5000
/cerc/problems/b/testdata/in 15
/cerc/problems/b/testdata/out 4
/cerc/problems/b/kale.cc 100
/cerc/documents/rules.pdf 4000
10000
```
#### 样例输出
```
- / 1009727
- /cerc/ 1009627
  /cerc/documents/ 4000
- /cerc/problems/ 1005627
- /cerc/problems/a/ 1005508
  /cerc/problems/a/testdata/ 1000008
+ /cerc/problems/b/ 119
+ /sys/ 100
```

---
### 题意：

&emsp;&emsp;给你`n`个文件的地址，让你从根目录开始展开文件夹直到这个文件夹里面所有文件的大小小于所给的阈值`t`或者是没有子目录可以展开。

---
### 思路：

&emsp;&emsp;把所有路径都哈希一下，建一颗树，然后前序遍历即可，对于同一层的节点需要按照节点的字典序从小到大输出。

---
### 实现：

```cpp
## include <bits/stdc++.h>
const int maxn = int(5e4) + 7;
int pre, cur_idx, pre_idx, n, tot = -1;
long long num, t, cnt[maxn];
char path[maxn][107] = {"/"};
std::map<std::string, int> idx;
struct Node {
    int index;
    bool operator < (const Node &tmp) const { return strcmp(path[index], path[tmp.index]) < 0; }
};
std::map<int, std::set<Node>> tree;
void dfs(int u) {
    if (tree[u].empty()) printf("  %s %lld\n", path[u], cnt[u]);
    else {
        if (cnt[u] >= t) {
            bool flag = false;
            for (auto i : tree[u])
                if (cnt[i.index] >= t) {
                    flag = true;
                    break;
                }
            if (flag) {
                printf("- %s %lld\n", path[u], cnt[u]);
                for (auto i : tree[u]) dfs(i.index);
            } else printf("+ %s %lld\n", path[u], cnt[u]);
        } else printf("+ %s %lld\n", path[u], cnt[u]);
    }
}

int main() {
//    freopen("in.txt", "r", stdin);
    char s[1007], tmp[1007], ch_tmp, ch_s;
    idx[path[0]] = ++tot;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
        scanf(" %s %lld", s, &num);
        strcpy(tmp, s);
        pre_idx = pre = 0;
        cnt[0] += num;
        for (int j = 1; s[j]; j++) {
            if (s[j] == '/') {
                ch_tmp = tmp[pre + 1], ch_s = s[j + 1];
                tmp[pre + 1] = s[j + 1] = '\0';
                if (!idx.count(s)) {
                    cur_idx = idx[s] = ++tot;
                    strcpy(path[tot], s);
                } else cur_idx = idx[s];
                tree[pre_idx].insert({cur_idx});
                cnt[cur_idx] += num, s[j + 1] = ch_s, tmp[pre + 1] = ch_tmp, pre = j, pre_idx = cur_idx;
            }
        }
    }
    scanf("%lld", &t);
    dfs(0);
    return 0;
}
```