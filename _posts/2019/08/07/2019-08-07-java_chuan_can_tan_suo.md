---
title: "Java 传参探索"
date: 2019-08-07 20:44:00 +0800
last_modified_at: 2019-08-07 20:44:59 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "Java"]
tags: ["java"]
---

## Java 传参探索

本文地址：https://blog.lucien.ink/archives/463/

### 结论

> 对于复杂类来说，Java 在传参时实际上传递的是这个类的地址，但是对于基本类型，如 `Integer` 和 `String` ，在传参时传递的是一个拷贝。

### 代码

#### TestStruct.java

```java
public class TestStruct {
    public Integer num;
    private String str;

    public TestStruct() {
        num = 0;
        str = "";
    }

    public void setStr(String str) {
        this.str = str;
    }

    public String getStr() {
        return str;
    }
}
```

#### Main.java

```java
public class Main {
    private static void foo(Integer bar) {
        bar = 10086;
    }

    private static void foo(String str) {
        str = "Hello World!";
    }

    private static void foo(TestStruct bar) {
        bar.num = 10086;
        bar.setStr("Hello World!");
    }

    public static void main(String[] args) {
        TestStruct test = new TestStruct();
        Integer num = 0;
        String str = "";

        foo(num);
        foo(str);
        System.out.println("Num: " + num + "\nStr: " + str);

        foo(test);
        System.out.println("Num: " + test.num + "\nStr: " + test.getStr());
    }
}
```

### 输出

```plain
Num: 0
Str: 
Num: 10086
Str: Hello World!
```
