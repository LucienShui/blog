---
title: "C++中 sort() 的使用"
date: 2018-08-07 00:06:00 +0800
last_modified_at: 2018-08-26 19:24:17 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
---

### 摘要

需要头文件`<algorithm>`

| 函数名 | 功能描述 |
| ------------- |:-------------:|
| sort | 对给定区间所有元素进行排序 |
| stable_sort | 对给定区间所有元素进行稳定排序 |
| partial_sort | 对给定区间所有元素部分排序 |
| partial_sort_copy | 对给定区间复制并排序 |
| nth_element | 找出给定区间的某个位置对应的元素 |
| is_sorted | 判断一个区间是否已经排好序 |
| partition | 使得符合某个条件的元素放在前面 |
| stable_partition | 相对稳定的使得符合某个条件的元素放在前面 |

### 语法描述

`sort(begin, end, cmp)`，其中`begin`为指向待`sort()`的数组的第一个元素的指针，`end`为指向待`sort()`的数组的**`最后一个元素的下一个位置`**的指针，`cmp`参数为排序准则，如果没有的话，默认以非降序排序。

### 以int为例的基本数据类型的sort()使用

```cpp
## include <iostream>
## include <algorithm>
using namespace std;
int main() {
    int a[5] = {1, 3, 4, 2, 5};
    sort(a, a + 5);
    for (int i = 0; i < 5; i++) cout << a[i] << ' ';
    return 0;
}
```

输出结果为：`1 2 3 4 5 `

### 自定义cmp参数

```cpp
## include <iostream>
## include <algorithm>
using namespace std;
bool cmp(int x, int y) {
    return x > y;
}
int main() {
    int a[5] = {1, 3, 4, 2, 5};
    sort(a, a + 5, cmp);
    for (int i = 0; i < 5; i++) cout << a[i] << ' ';
    return 0;
}
```

输出结果为：`5 4 3 2 1 `

