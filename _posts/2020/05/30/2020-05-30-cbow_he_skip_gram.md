---
title: "CBOW 和 Skip-Gram"
date: 2020-05-30 16:54:00 +0800
last_modified_at: 2022-04-24 02:21:38 +0800
math: true
render_with_liquid: false
categories: ["机器学习", "自然语言处理"]
tags: ["机器学习", "自然语言处理"]
description: "在 Word2Vec 中，Embedding 是一个映射，将词从原先所属的空间映射到新的多维空间中，也就是把词从原先所在空间嵌入到一个新的空间中去。本文介绍的 CBOW 和 Skip-Gram 是生成 Embedding 矩阵比较著名的两种无监督训练方法。"
img_path: /assets/img/posts/2020/05/30/2020-05-30-cbow_he_skip_gram/
---

## CBOW 和 Skip-Gram

> 本文地址：[blog.lucien.ink/archives/501][this]
> 参考文章：[（二）通俗易懂理解——Skip-gram和CBOW算法原理][zhihu_url]

Word2Vec 是从大量文本语料中以无监督的方式学习语义知识的一种模型，它被大量地用在 NLP 中。其本质是将所有词嵌入一个高维空间，使得语义上相似的词在该空间内的距离很近。

Embedding 是一个映射，将词从原先所属的空间映射到新的多维空间中，也就是把词从原先所在空间嵌入到一个新的空间中去。

一般地，一个词原先所在空间的维度要大于嵌入的空间的维度，所以形象地称之为“嵌入”。

本文介绍的 CBOW 和 Skip-Gram 是生成 Embedding 矩阵比较著名的两种无监督训练方法。

### 1. 词的表示

定义一个只有两句话的数据集 $S$：

1. `Hello World`
2. `Hello Machine learning`

那么数据集 $S$ 的词典就是 `["hello", "world", "machine", "learning"]`，规定其对应的下标为 `[1, 2, 3, 4]`。

对每个词进行 One-Hot 编码：

| Word | One Hot Vector |
| :---: | --- |
| `hello` | `[1, 0, 0, 0]` |
| `world` | `[0, 1, 0, 0]` |
| `machine` | `[0, 0, 1, 0]` |
| `learning` | `[0, 0, 0, 1]` |

可以看到，在 Embedding 之前，数据集 $S$ 的词向量空间的维度是 4 维。而对于更大的数据集来说，一般 Embedding 之前的维度会高达 $10 ^ 4$ 维甚至更多，通过 Embedding 可以将每个词嵌入至低维空间中（比如 300 维）。

### 2. 词嵌入

> 为了书写方便，将 $1 \times N$ 的矩阵成为 $N$ 维向量。

假设我们要将数据集 $S$ 中的每个词嵌入一个 2 维空间。

我们定义一个神经网络，输入层的 `shape` 是 `[1, 4]`，和每个单词的 One Hot Vector 的维度一致；Embedding 层的 `shape` 是 `[4, 2]`；输出层的 `shape` 是 `[2, 4]`。

最后的输出结果为一个 `shape` 为 `[1, 4]` 的 Matrix，也就是一个 4 维的 Vector。

![图 2][model_network]

其中，One Hot Vector 和 Embedding Layer 做矩阵乘法之后得到的 2 维向量就是嵌入后的词向量。

### 3. 伪代码

在给出伪代码之前，先定义两个函数。

#### 3.1 one_hot(x)

1. 当 `x` 是一个单词时，那么 `one_hot(x)` 就是单词 `x` 对应的 One Hot Vector。
2. 当 `x` 是一个句子时，那么 `one_hot(x)` 就是这个句子中每个单词的 One Hot Vector 的加和。

也就是说，第一句话的 One Hot Vector 是：`[1, 1, 0, 0]`，第二句话的 One Hot Vector 是：`[1, 0, 1, 1]`。

#### 3.2 fit(x, y)

类似 `keras` 中的 `Model.fit()` 函数，在本文特指对第 2 节中定义的神经网络进行监督训练，其中 Embedding Layer 和 Output Layer 是 Trainable 的。

#### 3.3 CBOW

CBOW 的理念就是用中心词的上下文去预测中心词。

举个例子，对于句子 `Hello Machine learning` 来说，使用 CBOW 时的 Training Dataset 为：

```py
[
    [["machine", "learning"], "hello"],  # 中心词为 "hello"
    [["hello", "learning"], "machine"],  # 中心词为 "machine"
    [["hello", "machine"], "learning"]  # 中心词为 "learning"
]
```

**伪代码：**

```py
for sentence in dataset_s:
    for word in sentence:
        input_data = one_hot(sentence) - one_hot(word)
        label = one_hot(word)

        fit(x=input_data, y=label)
```

假设有 $N$ 个句子，平均每个句子有 $M$ 个单词，那么 CBOW 的复杂度为 $O(NM)$。

#### 3.4 Skip-Gram

Skip-Gram 的理念就是用中心词去预测中心词的上下文。

举个例子，对于句子 `Hello Machine learning` 来说，使用 Skip-Gram 时的 Training Dataset 为：

```py
[
    ["hello", "machine"],  # 中心词为 "hello"
    ["hello", "learning"],  # 中心词为 "hello"
    ["machine", "hello"],  # 中心词为 "machine"
    ["machine", "learning"],  # 中心词为 "machine"
    ["learning", "hello"],  # 中心词为 "learning"
    ["learning", "machine"]  # 中心词为 "learning"
]
```

**伪代码：**

```py
for sentence in dataset_s:
    for i, word in enumerate(sentence):
        for j, target_word in enumerate(sentence):
            if i == j:
                continue
            input_data = one_hot(word)
            label = one_hot(target_word)

            fit(x=input_data, y=label)
```

假设有 $N$ 个句子，平均每个句子有 $M$ 个单词，那么朴素的 Skip-Gram 的复杂度为 $O(NM ^ 2)$。

##### 3.4.1 复杂度优化

###### 3.4.1.1 引入 window_size

引入 `window_size` 的目的就是缩短中心词周围的上下文，减少 `fit` 的次数。

举个例子，对于句子 `See you next time` 来说，令 `window_size = 1`，使用 Skip-Gram 时的 Training Dataset 为：

```py
[
    ["see", "you"],  # 中心词为 "see"
    ["you", "see"],  # 中心词为 "you"
    ["you", "next"],  # 中心词为 "you"
    ["next", "you"],  # 中心词为 "next"
    ["next", "time"],  # 中心词为 "next"
    ["time", "next"]  # 中心词为 "time"
]
```

**伪代码：**

规定：
1. `len(sentence)` 为 `sentence` 中单词的数量。
2. `sentence[i]` 为 `sentence` 中的第 `i` 的单词，下标从 `0` 开始。

```py
for sentence in dataset_s:
    for i, word in enumerate(sentence):
        for j in range(
            max(0, i - window_size),
            min(len(sentence), i + window_size)
        ):
            if i == j:
                continue
            input_data = one_hot(word)
            label = one_hot(sentence[i])

            fit(x=input_data, y=label)
```

假设有 $N$ 个句子，平均每个句子有 $M$ 个单词，记 `window_size` 的值为 $K$，那么引入 `window_size` 的 Skip-Gram 的复杂度为 $O(NMK)$。

###### 3.4.1.2 引入负采样

> 摘自文章：[理解 Word2Vec 之 Skip-Gram 模型][skip_gram_url]，稍作修改和整理。

训练一个神经网络意味着要输入训练样本并且不断调整神经元的权重，从而不断提高对目标的准确预测。每当神经网络经过一个训练样本的训练，它的权重就会进行一次调整。

正如我们上面所讨论的，词典的大小决定了我们的 Skip-Gram 神经网络将会拥有大规模的权重矩阵，所有的这些权重需要通过我们数以亿计的训练样本来进行调整，这是非常消耗计算资源的，并且实际中训练起来会非常慢。

负采样（Negative Sampling）解决了这个问题，它是用来提高训练速度并且改善所得到词向量的质量的一种方法。不同于原本每个训练样本更新所有的权重，负采样每次让一个训练样本仅仅更新一小部分的权重，这样就会降低梯度下降过程中的计算量。

当我们用训练样本 `{x: "hello"，y: "world"}` 来训练我们的神经网络时，`"hello"` 和 `"world"` 都是经过 One Hot 编码的。当我们的词典大小为 $10 ^ 4$ 时，在输出层，我们期望对应 `"world"` 单词的那个神经元结点输出 `1`，其余 `9999` 个都应该输出 `0`。在这里，这 `9999` 个我们期望输出为 `0` 的神经元结点所对应的单词我们称为 Negative Word。

当使用负采样时，我们将随机选择一小部分的 Negative Words（比如选 5 个 Negative Words）来更新对应的权重。当然，我们也会对我们的 Positive Word 进行权重更新（在我们上面的例子中，这个单词指的是 `"world"`）。

> 在论文中，作者指出指出对于小规模数据集，选择 5-20 个 Negative Words 会比较好，对于大规模数据集可以仅选择 2-5 个 Negative Words。

举个例子，假设词典大小为 $10 ^ 4$，Embedding 空间的维度为 $300$，那么输出层权重矩阵的 `shape` 便为 `[300, 10000]`，节点数量为 $300 \times 10 ^ 4 = 3 \times 10 ^ 6$ 个。

如果使用了负采样的方法我们仅仅去更新我们的 Positive Word 的和我们选择的其他 5 个 Negative Words 所对应的权重，共计 6 个神经元，相当于每次只更新 $300 \times 6 = 1800$ 个节点的权重。

如此一来，相比不使用 Negative Sampling 时只计算了 $\frac{ 300 \times 6 }{ 300 \times 10 ^ 4} \times 100\% = 0.06\%$ 的权重，这样一来计算效率就可以大幅度提高。

### 4. 对 Embedding 层的解释

在对上述神经网络训练完毕后，得到一个 `shape` 为 `[4, 2]` 的 Embedding Layer，记 Embedding Layer 的权重矩阵为 $W$，即 $W$ 是一个 $4 \times 2$ 的矩阵，第 `i` 行对应了词典中第 `i` 个词的词向量。

#### 4.1 为什么

Skip-Gram 时，对于第 `i` 个词来说，输入的 One Hot Vector 里只有第 `i` 维是 `1`，其余都是 `0`，这样一来，在反向传播时 $W$ 中只有第 $i$ 行的权重会被更新，其它行的权重都在前向传播时被 One Hot Vector 里的 `0` Mask 掉了。

CBOW 同理，反向传播时会更新上下文里所有的词对应的权重。

[this]: https://blog.lucien.ink/archives/501/
[zhihu_url]: https://zhuanlan.zhihu.com/p/39562499
[skip_gram_url]: https://zhuanlan.zhihu.com/p/27234078
[model_network]: assets/img/posts/2020/05/30/2020-05-30-cbow_he_skip_gram/model_network.drawio.svg
