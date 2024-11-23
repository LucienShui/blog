---
title: "使用 300 元的显卡推理 Qwen1.5-14B"
date: 2024-03-17 23:26:00 +0800
last_modified_at: 2024-03-18 01:55:18 +0800
math: false
render_with_liquid: false
categories: ["机器学习"]
tags: ["llm"]
description: "一直以来模型推理成本对于想要使用大模型却又注重隐私的用户来说都是个难题，本文探索了如何使用一张 300 元的显卡借助 llama.cpp 来推理 Qwen1.5-14B-Chat 的 q2_k 量化模型，获得不慢的推理速度与不俗的性能表现。"
---

> 本文地址：[blog.lucien.ink/archives/546][this]

一直以来模型推理成本对于想要使用大模型却又注重隐私的用户来说都是个难题，今天在这里探讨一下如何用尽可能低的成本去获得尽可能高的模型性能。

曾经尝试过用 Tesla P4（目前市场价 300 元，7.5G 显存）使用 vllm 去跑 GPTQ 量化版本的 Qwen 7B，提示显卡太旧无法支持 GPTQ，后来这张卡就被我拉去跑 Stable Diffusion 了。

现如今 Qwen1.5 问世，同时 Qwen 团队也放出了 gguf 格式的模型，从 0.5B 至 72B 都有，甚至从 q2_k 到 q8_0 都有，还很贴心的放了 **模型大小** 与 **量化方法** 的困惑度矩阵，这令我狠狠地心动了，果断掏出我的 P4 再战一回。

在这篇文章中，我将借助 [llama.cpp][llama-cpp] 采用 GPU + CPU 混合计算的形式，使用 Tesla P4 来推理 Qwen1.5-14B-Chat，支持 2048 上下文并且达到 11 tokens/s 左右的速度。

|Size    | fp16    | q8_0    | q6_k    | q5_k_m  | q5_0    | q4_k_m  | q4_0    | q3_k_m  | q2_k    |
|--------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|0.5B    | 34.20   | 34.22   | 34.31   | 33.80   | 34.02   | 34.27   | 36.74   | 38.25   | 62.14   |
|1.8B    | 15.99   | 15.99   | 15.99   | 16.09   | 16.01   | 16.22   | 16.54   | 17.03   | 19.99   |
|4B      | 13.20   | 13.21   | 13.28   | 13.24   | 13.27   | 13.61   | 13.44   | 13.67   | 15.65   |
|7B      | 14.21   | 14.24   | 14.35   | 14.32   | 14.12   | 14.35   | 14.47   | 15.11   | 16.57   |
|14B     | 10.91   | 10.91   | 10.93   | 10.98   | 10.88   | 10.92   | 10.92   | 11.24   | 12.27   |
|72B     | 7.97    | 7.99    | 7.99    | 7.99    | 8.01    | 8.00    | 8.01    | 8.06    | 8.63    |

## 部署

运行环境参考之前写的 [Debian 下 CUDA 生产环境配置笔记][previous]，不赘述。在这里简述下电脑配置：CPU i3-12100、8G RAM DDR4、Tesla P4（7.5GB 显存）。

再次强调下，最便宜的就是这张显卡了，市场价 300 块。

### 下载模型文件

前往 [Qwen1.5-14B-Chat-GGUF/files][14b-gguf-download] 选择心仪的量化模型。

在这里选择的是 [qwen1_5-14b-chat-q2_k.gguf][14b-q2_k]，虽然是 q2_k 量化，但其在维基百科数据集上的困惑度仍旧是小于 fp16 的 7B，所以其实际表现 **可能** 是要更好。

### 使用 docker compose 部署

> [LLaMA.cpp HTTP Server][llama-cpp-http-server]

这 3 个参数会直接决定模型能不能跑起来，以及跑起来的效果，在这里我直接放出适用于 Tesla P4 的参数，可以直接抄作业：

+ `--n-gpu-layers 40` 代表有 40 层模型将被加载进 VRAM（14B-Chat 总共有 41 层）。
+ `-c 2048` 代表模型总上下文长度（模型本身支持 32K，但在这里限定 2K）。
+ `--batch-size 256` 代表在处理 Prompt 时的 batch size，比如你的 prompt 拥有 768 个 token，那么就会被分为 3 个 batch 去 inferece。这个数值默认是 512，在这里为了节省显存，调整为 256（会拖慢服务处理 prompt 的速度）。

其它的参数官方文档写的较为清晰，有啥不明白的直接 `--help` 一下就行，在这里直接贴出 `compose.yml` 文件，不赘述。

```yaml
version: "3"

services:
  qwen2-llama-cpp:
    container_name: qwen2-llama-cpp
    image: ghcr.io/ggerganov/llama.cpp:server-cuda
    volumes:
      - /mnt/nas/huggingface/model/nlp/Qwen/Qwen1.5-14B-Chat-GGUF/qwen1_5-14b-chat-q2_k.gguf:/model.gguf:ro
    command: "-m /model.gguf --host 0.0.0.0 --port 8000 --n-gpu-layers 40 -c 2048 --batch-size 256 --threads 4 --alias this_is_a_model_name --api-key this_is_a_api_key"
    shm_size: 8GB
    restart: always
    ports:
      - 8000:8000
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              device_ids: ["0"]
              capabilities: [gpu]
```

## 调用

llama.cpp 官方支持了非常多样化的 API 调用形式，为了缩短篇幅，在这里我只列举 OpenAI API 格式的调用，因为围绕 OpenAI API 的社区产品会更加多样化一些。

```python
from openai import OpenAI

client = OpenAI(base_url="https://192.168.1.2:8000/v1", api_key="this_is_a_api_key")

stream = client.chat.completions.create(
    model="this_is_a_model_name",
    messages=[{"role": "user", "content": "给我讲一个故事。"}],
    stream=True,
)
for chunk in stream:
    print(chunk.choices[0].delta.content or "", end="", flush=True)
```

## 推理速度

在这里简单测试一下推理速度：

| | Token 数量 | 耗时 | 速率 |
| --- | --- | --- | --- |
| prompt | 1672 | 13.43 s | 124.46 tokens/s |
| predict | 511 | 45.18 s | 11.31 tokens/s |

视频：[用 300 元的显卡推理 Qwen1.5-14B 效果展示][bilibili]

## 总结

本文探索了如何使用一张 300 元的显卡借助 llama.cpp 来推理 Qwen1.5-14B-Chat 的 q2_k 量化模型，获得不慢的推理速度与不俗的性能表现。

值得注意的是，可以观察到视频中在 predict 期间，GPU 计算的利用率是没有达到 100% 的，原因是因为我们将一部分计算交给了 CPU，数据交换以及 CPU 运算增大了 GPU 的数据等待时间。

解决这个问题也有几个改进点：
1. 换用性能更强的 CPU
2. 换用带宽更高的 RAM
3. 将所有模型都进 VRAM
    3.1 换用更小的上下文长度，比如 1024
    3.2 换用更大的显存

从工业的角度讲，Tesla P4 可能是目前市面上能买到的 价格/显存 性价比较高的一款显卡了，8 张 P4（2400 元，60G 显存，600W 功耗）能推理精度较高的 72B 的模型，如果不在意功耗的话，配合退役的服务器能将整机成本控制在 3000 元左右，对于工业上自建推理服务还算一个不错的选择。

但其缺点也较为明显，主要来自于其年代久远，sm 版本较低、不支持 GPTQ 等依赖新 op 的 方法、不支持 bf16 等等。得益于 llama.cpp 这样的项目存在，这张卡才能在现如今的深度学习环境下焕发新春。

## 相关资料

1. [llama.cpp][llama-cpp]
2. [Debian 下 CUDA 生产环境配置笔记][previous]
3. [modelscope.cn/qwen/Qwen1.5-14B-Chat-GGUF](https://modelscope.cn/models/qwen/Qwen1.5-14B-Chat-GGUF/summary)

[this]: https://blog.lucien.ink/archives/546/
[llama-cpp]: https://github.com/ggerganov/llama.cpp
[previous]: https://blog.lucien.ink/archives/534/
[14b-gguf-download]: https://modelscope.cn/models/qwen/Qwen1.5-14B-Chat-GGUF/files
[14b-q2_k]: https://modelscope.cn/api/v1/models/qwen/Qwen1.5-14B-Chat-GGUF/repo?Revision=master&FilePath=qwen1_5-14b-chat-q2_k.gguf
[llama-cpp-http-server]: https://github.com/ggerganov/llama.cpp/tree/master/examples/server
[bilibili]: https://www.bilibili.com/video/BV1dy421v7aF