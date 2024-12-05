---
title: "从零开始实践大模型 - 模型推理"
date: 2024-12-06 01:08:52 +0800
last_modified_at: 2024-12-06 01:08:52 +0800
math: true
render_with_liquid: false
categories: ["机器学习"]
tags: ["机器学习", "llm"]
description: "本文介绍了如何使用Qwen2.5-0.5B-Instruct模型快速启动一个模型服务，包括下载模型、安装git-lfs、使用git clone下载模型、编写推理代码、使用vLLM加速推理，并通过Docker部署服务。同时也分享了部署时的一些经验。"
---

> 本文地址：[blog.lucien.ink/archives/550][this]

以 Qwen2 为例，本章节将介绍在配置好环境后，如何快速启动一个模型服务，并将简单介绍面向生产的模型服务应该怎样部署。

## 下载模型

> 以 [Qwen2.5-0.5B-Instruct][qwen25_0_5b] 为例，因为它的尺寸很小，架构也和 [Qwen2.5-72B-Instruct][qwen25_72b] 一样。

在这里，我们首先将 `Qwen2.5-0.5B-Instruct` 模型下载至本地，而在此之前，还需要再做一些准备。

在大部分情况下我都推荐使用 `git clone` 的方式，而不是使用官方提供的 Toolkit，因为 `git clone` 出来的文件夹可以通过 `git pull` 来追踪模型的每一次更改，而不用重新下载。

而 git 擅长管理的是可以用纯文本来表示的文件，而对于模型权重、可执行程序、Word、Excel 等这类不太文本友好的文件来说，一般会用 `git-lfs` 来进行管理，在这里我们不深入了解 `git-lfs` 是什么，仅仅简单描述如何正确使用 `git pull` 来下载一个模型。

### 安装 git-lfs

我们前往 [Releases git-lfs][git_lfs_release] 页面获取 git-lfs 的下载地址：

```shell
wget 'https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz'
tar -xzvf 'git-lfs-linux-amd64-v3.5.1.tar.gz' -C /usr/local/
bash /usr/local/git-lfs-3.5.1/install.sh
git lfs install
```

### 使用 git clone 下载模型

Qwen2 目前在两个模型平台上可以下载到，一个是 HuggingFace，另一个是 ModelScope，对于大陆来说 ModelScope 是更快的。

```shell
git clone https://modelscope.cn/models/qwen/Qwen2.5-0.5B-Instruct
```

## 第一段推理代码

> 在这里我们使用 [从零开始实践大模型 - 配置环境][env_config_blog] 中创建的 `python3` 环境

```shell
pip install transformers
```

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

device = "cuda"
model_path = "Qwen2.5-0.5B-Instruct"  # 本地模型的路径

model = AutoModelForCausalLM.from_pretrained(model_path, torch_dtype="auto").to(device)
tokenizer = AutoTokenizer.from_pretrained(model_path)

prompt = "介绍一下大模型"
messages = [{"role": "user", "content": prompt}]
text = tokenizer.apply_chat_template(
    messages,
    tokenize=False,
    add_generation_prompt=True
)
model_inputs = tokenizer([text], return_tensors="pt").to(model.device)

generated_ids = model.generate(
    **model_inputs,
    max_new_tokens=512
)
generated_ids = [
    output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
]

response = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
print(response)
```

如果环境配置正确，能得到类似的输出：

```shell
$ python main.py 
大模型是人工智能领域的一个重要概念。大模型是指那些能够处理和理解大量复杂数据、具有高度抽象能力和大规模特征表示的大规模预训练模型。这些模型通常使用大量的标注数据进行训练，并且可以学习到更复杂的模式和关系。

在实际应用中，大模型被广泛应用于自然语言处理、计算机视觉、语音识别、推荐系统等多个领域。例如，在自然语言处理中，大模型可以用于提高机器翻译的准确性和效率；在计算机视觉中，它们可以增强图像识别和目标检测的能力；在语音识别中，大模型可以帮助实现更加精准的人工智能对话体验。

此外，大模型还被用于生成内容的创作，如文字生成、音乐合成等。随着计算能力的提升和算法的进步，大模型在未来可能会成为推动技术进步的重要力量之一
```

## 推理加速

上述代码实现了最基本的 `Hello World!`，但是存在效率问题，主要体现在两点：

1. TTFT，Time to first token，也就是首字响应时长
2. 吞吐量，每秒的 Token 数量，单位：tokens/s

有许多优化方法能缓解这些问题，开源社区有很多推理加速的方案，比如：

+ [vLLM][vllm_gh]
+ [SGLang][sglang_gh]
+ [TensorRT-LLM][tensorrt_llm_gh]
+ [lmdeploy][lmdeploy_gh]

还有一些面向易用性的方案，比如：

+ [ollama][ollama_gh]
+ [llama.cpp][llama_cpp_gh]
+ [xinference][xinference_gh]

个人在这里最推荐的是 vLLM，稳定、易用、性能这几个方面的表现较为均衡，没有明显的短板。

在这里也小小的安利一下 SGLang，它的吞吐相比 vLLM 有优势，Benchmark 见：[Achieving Faster Open-Source Llama3 Serving with SGLang Runtime (vs. TensorRT-LLM, vLLM)][sglang_blog]。

接下来我将基于上一篇博客配置的环境来讲一讲较为便捷的部署方式，以及一些面向生产部署的经验。

### Docker 部署

> [Deploying with docker - vLLM][vllm_docker_deploy_doc]

基于 vLLM 的官方文档，不难写出 `compose.yaml`：

```yaml
services:
  vllm:
    image: vllm/vllm-openai:v0.6.4.post1
    volumes:
      - ${PWD}/Qwen2.5-0.5B-Instruct:/model:ro
    ports:
      - 8000:8000
    restart: always
    entrypoint: ["python3", "-m", "vllm.entrypoints.openai.api_server"]
    command: ["--host", "0.0.0.0", "--port", "8000", "--model", "/model", "--served-model-name", "qwen2.5-0.5b-instruct"]
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              device_ids: ["0"]
              capabilities: [gpu]
```

然后执行 `docker compose up -d`，就能快速启动一个 `vLLM` 的服务，通过 `curl` 验证：

```shell
$ curl localhost:8000/v1/chat/completions \
    -d '{"model":"qwen2.5-0.5b-instruct","messages":[{"role":"user","content":"介绍一下大模型"}]}'
    -H 'Content-Type: application/json'
```

可以得到类似的输出：

```json
{"id":"chatcmpl-f1114b6c0184443da2efb51758c77bfe","object":"chat.completion","created":1733416711,"model":"qwen2.5-0.5b-instruct","choices":[{"index":0,"message":{"role":"assistant","content":"大模型通常指的是在自然语言处理（NLP）、计算机视觉等领域中，具有大量参数的深度学习模型。这些模型通过在大规模数据集上进行训练，能够学习到丰富的表示能力，从而在各种任务上表现出色。大模型的概念逐渐成为人工智能研究和应用的一个重要方向。下面是一些关于大模型的关键点：\n\n1. **参数量大**：大模型通常包含数亿甚至上百亿的参数，这使得模型能够捕捉到数据中的复杂模式和关系。\n\n2. **预训练与微调**：大模型通常首先在大规模语料库上进行预训练，然后在特定任务的数据集上进行微调，以适应具体的应用场景。\n\n3. **零样本学习与少样本学习能力**：得益于其强大的泛化能力，大模型在没有或仅有少量标注数据的情况下，也能表现得很出色。\n\n4. **提升任务性能**：在多项自然语言处理和计算机视觉任务中，大模型往往能够提供比传统模型更好的性能。\n\n5. **挑战与限制**：虽然大模型在性能上有显著提升，但它们也带来了计算资源消耗大、训练时间长、模型解释性差等问题。\n\n6. **发展趋势**：随着技术的进步，研究者们正在探索更高效、更节能的训练方法，以及如何减少模型的环境影响。\n\n大模型的发展正在推动人工智能技术的进步，并在各个领域展现出巨大的潜力，但同时，如何平衡性能提升与资源消耗、如何提高模型的可解释性等问题也是当前研究的热点。","tool_calls":[]},"logprobs":null,"finish_reason":"stop","stop_reason":null}],"usage":{"prompt_tokens":32,"total_tokens":355,"completion_tokens":323,"prompt_tokens_details":null},"prompt_logprobs":null}
```

### 一些经验

1. 监控和灾备很重要，尤其是对于一个实时业务系统来说，相比 CPU、硬盘、内存、电源，GPU 的故障率尤其高。
2. 降低 TTFT 和提升吞吐可以同时通过增加并行度来实现（多卡推理），但超过一个甜点值提升就很微弱了，对于 72B 的模型来说，4 卡 SXM 是一个比较有显著收益的选择。
3. 对于显卡较多或比较分散的小伙伴来说，比较建议的是通过 Kubernetes 来管理所有的显卡，会省去很多的工作量。
4. 需要根据业务场景和模型大小在 PCIe 与 SXM 之间做出选择，如果对推理效率没有过高的要求，3090 或 A100 能满足大部分的场景。如果需要推理超长上下文或很大的模型，建议 SXM，PCIe 的卡间通信是个灾难。

[this]: https://blog.lucien.ink/archives/550/
[qwen25_0_5b]: https://modelscope.cn/models/qwen/Qwen2.5-0.5B-Instruct
[qwen25_72b]: https://modelscope.cn/models/qwen/Qwen2.5-72B-Instruct
[git_lfs_release]: https://github.com/git-lfs/git-lfs/releases
[env_config_blog]: https://blog.lucien.ink/archives/549/
[vllm_gh]: https://github.com/vllm-project/vllm
[tensorrt_llm_gh]: https://github.com/NVIDIA/TensorRT-LLM
[sglang_gh]: https://github.com/sgl-project/sglang
[lmdeploy_gh]: https://github.com/InternLM/lmdeploy
[ollama_gh]: https://github.com/ollama/ollama
[llama_cpp_gh]: https://github.com/ggerganov/llama.cpp
[xinference_gh]: https://github.com/xorbitsai/inference
[vllm_docker_deploy_doc]: https://docs.vllm.ai/en/latest/serving/deploying_with_docker.html
[sglang_blog]: https://lmsys.org/blog/2024-07-25-sglang-llama3/
