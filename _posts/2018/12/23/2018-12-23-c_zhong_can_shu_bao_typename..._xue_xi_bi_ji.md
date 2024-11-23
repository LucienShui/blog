---
title: "C++ 中 参数包 (typename ...) 学习笔记"
date: 2018-12-23 13:14:00 +0800
last_modified_at: 2018-12-23 13:17:33 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

## C++ 中 参数包 (typename ...) 学习笔记

## 本文所属地址

https://www.lucien.ink

## 起因

突然好奇 `STL` 的 `std::tuple` 是怎么实现不定参数的，遂搜了搜，发现了 `template <typename ...>` 这个东西，继续搜了一下，发现中文资料很少，在 $Google$ 上用英文搜了一下才找到比较好的资料。

其实 [cppreference](https://en.cppreference.com/w/cpp/language/parameter_pack) 上有比较详尽的说明，但是我太菜了，自己捣鼓了一阵才弄明白这个 ~~大概~~ 是怎么一回事。

## 例子

### 例1

https://pasteme.cn/2780

```cpp
## include <bits/stdc++.h>

template <typename Type>
void print(Type x) {
    std::cout << x << ", 233333" << std::endl;
}

template <typename Type, typename... Targs>
void print(Type x, Targs... args) {
    std::cout << x << std::endl;
    print(args...);
}

int main() {
    print('1', 1.5, "Hello World");
    return 0;
}

```

#### 输出

```python
1
1.5
Hello World, 233333
```

#### 分析

可以注意到我写了两个同名函数，一个是只有单一参数的，另一个是前面有一个参数，后面有一个参数包。

这样一来实现了一个不定参数个数的输出函数。

调用过程大概是这样的（$\{\}$ 指代参数包）：

$$print(\{a, b, c\}) \Rightarrow print(a, \{b, c\})$$

$$\downarrow$$

$$print(\{b, c\}) \Rightarrow print(b, \{c\})$$

$$\downarrow$$

$$print(\{c\}) \Rightarrow print(c, \{\}) \Rightarrow print(c)$$ 

我个人的理解是，每一次调用的时候参数包就会默认把最左边的参数挪到外面去变成一个显式参数供函数调用。

可以发现调用到最后参数包为空，就等价于直接调用了 `print(x)` 这个函数，所以在这里我们要显式声明一个不包含参数包的同名函数，这样一来包含参数包的同名函数才可以正常结束，否则会报 `no matching function` 的 `error` 。

我在不含有参数包的同名函数中加了一个额外的输出，可以看到只有最后一个参数的输出后面带上了一个 `233333` ，证明前面的分析是（~~完全~~）正确的（吧）。

### 例2

https://pasteme.cn/2781

```cpp
## include <bits/stdc++.h>

template <typename ... Tail> class Tuple;

template<> class Tuple<> {};

template <typename Value, typename ... Tail>
class Tuple<Value, Tail ...> : Tuple<Tail ...> {
    Value Val;
public:
    Tuple() {}
    Tuple(Value value, Tail ... tail) : Val(value), Tuple<Tail ...>(tail ...) {}
    Value value() { return Val; }
    Tuple<Tail ...> next() { return *this; }
};

int main() {
    Tuple<char, double, std::string> tuple('1', 1.5, "Hello World");
    std::cout << tuple.value() << std::endl;
    std::cout << tuple.next().value() << std::endl;
    std::cout << tuple.next().next().value() << std::endl;
    return 0;
}
```

#### 输出

```python
1
1.5
Hello World
```

#### 分析

在这里我们很简单地实现了一个 `std::tuple` ，初始化的时候和 `例1` 中讲的递归调用类似，就不细说了。

关键在于第 $14$ 行的 `next()` 函数，在这里直接返回了父类对象，在我看来是十分巧妙的，希望各位看官能够着重理解一下这里。

## 总结

参数包看起来是一个十分强大的功能（特性），但是像我这样手写的话过于依赖递归调用，效率不会很高，至于 `std::tuple` 实际上是怎么实现的我并没有深究，但至少在平时的比赛中可以明显感觉出来 `std::tuple` 的速度比手写要慢一些，配合 `std::tie` 用起来的感觉就更慢了。

以我目前的认知来看，这种结构除了书写起来快且方便之外并没有其它太多的优点，所以如果不是追求书写方便的话尽量还是避免这种结构吧。
