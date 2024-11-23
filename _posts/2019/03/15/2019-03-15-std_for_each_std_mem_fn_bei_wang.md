---
title: "std::for_each、std::mem_fn 备忘"
date: 2019-03-15 10:37:29 +0800
last_modified_at: 2019-03-15 10:37:29 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

```cpp
## include <iostream>
## include <thread>
## include <vector>
## include <algorithm>
## include <functional>

int main() {
    std::vector<std::thread> threads;
    for (int i = 0; i < 10; i++) {
        threads.emplace_back([i] {
            for (int j = 0; j < 3; j++) printf("%d\n", i);
        });
    }
    std::for_each(threads.begin(), threads.end(), std::mem_fn(&std::thread::join));
    return 0;
}
```