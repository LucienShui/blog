---
title: "解决 deeplearning4j 报错 Symbol not found: ___emutls_get_address"
date: 2019-12-06 15:22:00 +0800
last_modified_at: 2019-12-06 15:22:38 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "Java"]
tags: ["java", "deep learning"]
---

## 解决 `deeplearning4j` 报错 `Symbol not found: ___emutls_get_address`

本文地址：[blog.lucien.ink/archives/486](https://blog.lucien.ink/archives/486/
)

使用 [deeplearning4j](https://github.com/eclipse/deeplearning4j) 加载模型的时候报了下面这个错。

```bash
dyld: lazy symbol binding failed: Symbol not found: ___emutls_get_address
  Referenced from: ~/.javacpp/cache/nd4j-native-1.0.0-beta5-macosx-x86_64.jar/org/nd4j/nativeblas/macosx-x86_64/libnd4jcpu.dylib
  Expected in: /usr/lib/libSystem.B.dylib
```

在 [issues](https://github.com/eclipse/deeplearning4j/issues/8217#issuecomment-531629284) 找到了答案，安装 `gcc-8` 即可。

```bash
brew install gcc@8
```