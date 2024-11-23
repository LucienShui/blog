---
title: "一道有关极大似然估计和贝叶斯估计的题目"
date: 2020-02-29 00:22:00 +0800
last_modified_at: 2022-04-24 02:21:07 +0800
math: true
render_with_liquid: false
categories: ["数学"]
tags: ["数学"]
description: "记录一道有关极大似然估计和贝叶斯估计的题目。本文地址：blog.lucien.ink/archives/500"
---

## 一道有关极大似然估计和贝叶斯估计的题目

> 本文地址：[blog.lucien.ink/archives/500][this]

### 0. 题目

数据 $x_1, \dots, x_n$ 来自正态分布 $N(\mu, \sigma ^ 2)$，其中 $\sigma ^ 2$ 已知。

1. 根据样本 $x_1, \dots, x_n$ 写出 $\mu$ 的极大似然估计。
2. 假设 $\mu$ 的先验分布是正态分布 $N(0, \tau ^ 2)$，根据样本 $x_1, \dots, x_n$ 写出 $\mu$ 的贝叶斯估计。

### 1. 极大似然估计

正态分布概率密度函数为 ${ f(x) = { \frac { 1 }{ \sigma { \sqrt { 2 \pi } } } } e ^{ - { \frac {( x - \mu )^{ 2 } }{ 2 \sigma^{ 2 } } } } }$，则

$$L(\mu) = \prod \limits_{ i = 1 }^{ n } f(x_i) = (\frac { 1 }{ \sigma \sqrt { 2 \pi } }) ^ n \cdot e ^ { - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2  } \propto - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2$$

则有 $$\frac{ \partial [- \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2] }{ \partial \mu } = \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } 2 \cdot (x_i - \mu) = \frac { 1 }{ \sigma ^ 2 } \sum \limits_{ i = 1 }^{ n } (x_i - \mu)$$

令 $$\frac { 1 }{ \sigma ^ 2 } \sum \limits_{ i = 1 }^{ n } (x_i - \mu) = 0$$

得 $$\widehat \mu = \frac { \sum \limits_{ i = 1 }^{ n } x_i }{ n } = \bar x$$

### 2. 贝叶斯估计

> 大佬说这一问严格来讲是求最大后验概率估计

$$P(\mu) = { \frac { 1 }{ \tau { \sqrt { 2 \pi } } } } e^{ - { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } }$$

$$P(\mu | x_1, \dots, x_n) = \frac{ P(\mu) \cdot P( x_1, \dots, x_n | \mu) }{ P(x_1, \dots, x_n) } = \frac{ P(\mu) \cdot \prod \limits_{ i = 1 }^{ n } P(x_i | \mu) }{ \int P(\mu, x_1, \dots, x_n) \mathrm{ d } \mu }$$$$\propto P(\mu) \cdot \prod \limits_{ i = 1 }^{ n } P(x_i | \mu) = { \frac { 1 }{ \tau { \sqrt { 2 \pi } } } } \cdot e ^{ - { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } } \cdot (\frac { 1 }{ \sigma \sqrt { 2 \pi } }) ^ n \cdot e ^ { - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2  }$$

取对数得 $$\ln({ \frac { 1 }{ \tau { \sqrt { 2 \pi } } } } \cdot e ^{ - { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } } \cdot (\frac { 1 }{ \sigma \sqrt { 2 \pi } }) ^ n \cdot e ^ { - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2  })$$$$ = \ln{ \frac { 1 }{ \tau { \sqrt { 2 \pi } } } } - { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } + n \cdot \ln \frac { 1 }{ \sigma \sqrt { 2 \pi } } - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2$$$$\propto - { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2$$

则有 $$\frac { \partial [- { \frac { \mu ^ 2 }{ 2 \tau ^ 2 } } - \frac { 1 }{ 2 \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) ^ 2 ] }{ \partial \mu } = - { \frac { \mu }{ \tau ^ 2 } } + \frac { 1 }{ \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu)$$

令 $$- { \frac { \mu }{ \tau ^ 2 } } + \frac { 1 }{ \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } (x_i - \mu) = 0$$

则有 $$\frac { 1 }{ \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } x_i - \frac { n }{ \sigma ^ 2 } \mu = \frac { \mu }{ \tau ^ 2}$$$$\Rightarrow \frac { 1 }{ \sigma ^ 2 }\sum \limits_{ i = 1 }^{ n } x_i = (\frac { 1 }{ \tau ^ 2} + \frac { n }{ \sigma ^ 2 }) \cdot \mu = \frac { \sigma ^ 2 + n \tau ^ 2 }{ \tau ^ 2 \sigma ^ 2 } \mu$$

得 $$\widehat \mu = \frac{ \tau ^ 2 \sum \limits_{ i = 1 }^{ n } x_i }{ \sigma ^ 2 + n \tau ^ 2 } = \frac{ \sum \limits_{ i = 1 }^{ n } x_i }{ \frac{ \sigma ^ 2 }{ \tau ^ 2  } + n }$$

### 3. 疑问与解答

#### 3.1 $\mu$ 是个参数，为什么会有分布函数

考虑这样一种情况，总共有 $1000$ 个随机数字，每次有放回从中抽出 $10$ 个数字，抽 $100$ 次，就有 $100$ 个 $\mu$，这些 $\mu$ 服从同一种且拥有相同参数的分布。

#### 3.2 如何理解 $P(x_1, \cdots, x_n | \mu)$ 和 $P(\mu | x_1, \cdots, x_n)$ 里 $\mu$ 所表达的含义

$\mu$ 取某个值发生的概率。

[this]: https://blog.lucien.ink/archives/500/
