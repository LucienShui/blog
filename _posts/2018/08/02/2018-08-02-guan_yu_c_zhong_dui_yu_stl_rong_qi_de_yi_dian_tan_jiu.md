---
title: "关于C++中对于STL容器的一点探究"
date: 2018-08-02 10:37:00 +0800
last_modified_at: 2018-08-02 10:41:18 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

### 原文

https://www.lucien.ink/archives/309/

### 起因

&emsp;&emsp;很久以前遇到过一个Bug，就是在`for`循环中使用`iterator`遍历容器时`erase`这个指针，导致了一些意想不到的`Bug`，今天突然想起来，做了点探究。

### 过程

#### std::set

&emsp;&emsp;对于`set`，执行以下代码：

```cpp
## include <bits/stdc++.h>
std::set<int> set;
void show(std::set<int> &tmp) {
    for (int i : tmp) std::cout << i << ' ';
    std::cout << std::endl;
}
int main() {
    for (int i = 1; i <= 5; i++) set.insert(i);
    for (auto it = set.begin(); it != set.end(); it++) {
        std::cout << "Delete: " << *it << std::endl;
        set.erase(it);
        std::cout << "Current iterator: " <<  *it << std::endl << "Content: ";
        show(set);
        std::cout << std::endl;
    }
    return 0;
}
```

&emsp;&emsp;输出为：

```bash
Delete: 1
Current iterator: 1
Content: 2 3 4 5 

Delete: 2
Current iterator: 2
Content: 3 4 5 

Delete: 3
Current iterator: 3
Content: 4 5 

Delete: 4
Current iterator: 4
Content: 5 

Delete: 5
Current iterator: 5
Content: 

Process finished with exit code 0
```

#### std::vector

&emsp;&emsp;对于`vector`，执行以下代码：

```cpp
## include <bits/stdc++.h>
std::vector<int> vector;
void show(std::vector<int> &tmp) {
    for (int i : tmp) std::cout << i << ' ';
    std::cout << std::endl;
}
int main() {
    for (int i = 1; i <= 5; i++) vector.push_back(i);
    for (auto it = vector.begin(); it != vector.end(); it++) {
        std::cout << "Delete: " << *it << std::endl;
        vector.erase(it);
        std::cout << "Current iterator: " <<  *it << std::endl << "Content: ";
        show(vector);
        std::cout << std::endl;
    }
    return 0;
}
```

&emsp;&emsp;输出为：

```bash
Delete: 1
Current iterator: 2
Content: 2 3 4 5 

Delete: 3
Current iterator: 4
Content: 2 4 5 

Delete: 5
Current iterator: 5
Content: 2 4 

Delete: 5

Process finished with exit code 11
```

### 结论

&emsp;&emsp;可以观察到，`erase`掉`std::set`的指针后这个指针不变，且指向的内容仍然有效，并且能正确的获得中序遍历的后继。

&emsp;&emsp;`erase`掉`std::vector`的指针后这个指针会自动指向被`erase`掉的内容的下一个元素，并且由于容器中的元素为奇数个，上文的代码`exit code`为$11$，可以预见的是，如果容器中的元素为偶数个，那么我们的这一段代码就不会出错，即`exit code`为$0$。