---
title: "ChatGPT 相关资料收集"
date: 2023-04-02 23:01:00 +0800
last_modified_at: 2023-04-23 16:16:47 +0800
math: true
render_with_liquid: false
categories: ["机器学习", "自然语言处理"]
tags: ["生成式模型"]
description: "本文用来收集各种和生成式模型相关的内容，由于 ChatGPT 是其代表，也是会被写入人类历史进程的一个名字，所以便用 ChatGPT 作为标题的一部分，以表示我对 OpenAI 团队由衷的敬佩。"
---

> 本文地址：[blog.lucien.ink/archives/538][this]

本文用来收集各种和生成式模型相关的内容，由于 ChatGPT 是其代表，也是会被写入人类历史进程的一个名字，所以便用 ChatGPT 作为标题的一部分，以表示我对 OpenAI 团队由衷的敬佩。

## 2023-04-02 更新

+ Improving Language Understanding by Generative Pre-Training (2018)
    + 介绍了 GPT 的结构和训练方式，文章提到未来可以继续拓展的几个方向。其中一个便是模型在 ZERO-SHOT 的设定下，模型的表现与堆叠的解码器层数有直接的正相关性。

+ Language Models are Unsupervised Multitask Learners (2019)
    + 文章认为对单任务单领域的训练是模型缺乏泛化能力的主要原因，实践验证仅靠预训练 + 提示 + 预测就在8/9个任务里达到了SOTA。

+ Language Models are Few-Shot Learners (2020)
    + 继续探索了在不对下游任务进行适配（模型结构不更改、参数不更新）的情况下，模型的表现。

+ Training language models to follow instructions with human feedback (2022)
    + 探索了指示学习和基于人工反馈的强化学习训练，基本上约等于 ChatGPT。

+ [LoRA: Low-Rank Adaptation of Large Language Models][lora] (2021)
    + 提出通过训练一个低秩参数矩阵来进行模型微调，相较于直接微调整个模型，能在损失较少精度的情况下大幅降低训练成本。

+ [Self-Instruct: Aligning Language Model with Self Generated Instructions][self-instruct]（2022）
    + 让模型尝试通过半监督的方式自己去生成指令样本，能取得不错的效果。

+ [LLaMA: Open and Efficient Foundation Language Models][llama]
    + 训练了从 7B 到 65B 的一组模型，全部贡献给开源社区，且 LLaMA-13B 在多数基准测试中优于 GPT-3(175B)。
    + 验证了公开数据集的可行性，以及小模型（相比 OpenAI 的规模）的潜力。
    + 开源模型地址：[huggingface.co/decapoda-research][llama_model]

+ [Stanford Alpaca: An Instruction-following LLaMA Model][alpaca]
    + 花了 \$500 去调用 OpenAI 的 `text-davinci-003` 并收集数据，然后用这些数据花了 \$100 来微调 [LLaMA-7B][llama_7b] 模型，得到了一个效果还不错的模型，取名为 Alpaca，模型未开源。
    + 公开了生成数据的代码，以及对应的数据集：[alpaca_data.json][alpaca_data]
+ [Guanaco: A Multilingual Instruction-Following Language Model Based on LLaMA 7B][guanaco]
    + 同样是对 [LLaMA-7B][llama_7b] 进行微调，不同的是在 [alpaca_data.json][alpaca_data] 的基础上增加了对繁简体中文及日语的指令，共计 534530 条，数据集地址：[Guanaco Dataset][guanaco_data]。
+ [Vicuna: An Open-Source Chatbot Impressing GPT-4 with 90%* ChatGPT Quality][vicuna]
    + 花了 \$300 左右，使用 [用户共享的数据][ShareGPT] 来对 [LLaMA-13B][llama_13b] 进行微调，可以在 [GPT-4 的评测][gpt_4_eval] 下达到 ChatGPT 90% 的水平。
    + Demo: [Vicuna Online Demo][vicuna_demo]，源码：[FastChat][fast_chat]，暂未公开模型。
    + ShareGPT Github: [domeccleston/sharegpt]
+ [BELLE: Be Everyone's Large Language model Engine][belle]
    + 来自 **链家** 的技术团队，提供了训练代码、数据、模型，包含一些中文改进。HuggingFace 主页：[BelleGroup][belle_hf]
+ [Chinese-Vicuna: A Chinese Instruction-following LLaMA-based Model][chinese_vicuna]
    + 在 LLaMA 的基础上使用 BELLE 和 Guanaco 训练了 lora，提供了代码和训练过的 Lora。HuggingFace 主页：[Chinese-Vicuna][chinese_vicuna_hf]


暂时先收集这些，总结下来就一句话：**OpenAI 不够体面，开源社区帮他体面**。以及作为马后炮，我认为在对 GPT 现代化改进的加持下，于多数日常任务来说，10B 左右的规模应该是足够的。

## 2023-04-04 更新

+ 今天 vicuna 放出了他们的模型：[lmsys/vicuna-13b-delta-v0][vicuna_13b_delta]

## 2023-04-06 更新

+ [Koala: A Dialogue Model for Academic Research][koala]
    + 主要是使用 EasyLM 提升了训练速度，使用 8 张 A100 完成两轮 epoch 只需要 6 个小时，大大降低了训练成本。评测效果优于 Alpaca，达到 ChatGPT 50% 的性能。

## 2023-04-09 更新

+ 链家放出了 13B 的模型：[BelleGroup/BELLE-LLAMA-13B-2M][belle_model]
    + 同时还放出了更多的数据集
+ 一个跟进 LLM 的 Repo：[Awesome-LLM: a curated list of Large Language Model][llm_repo]

## 2023-04-22 更新

> 当前的开源社区大致有 3 个方向：
> 1. 复现 ChatGPT 的效果
> 2. 加速（模型轻量化、更底层的训练/推理加速）
> 3. 应用（插件、Auto-GPT、ViedoChat、提示魔法）

+ [Auto-GPT: An Autonomous GPT-4 Experiment][auto_gpt]
    + 会上网、使用工具，能根据人类给出的任务，自己定目标、思考、执行。
    + 在线 DEMO：[AgentGPT][auto_gpt_online_demo]
+ [MiniGPT-4: Enhancing Vision-language Understanding with Advanced Large Language Models][minigpt4_repo]
    + 用小模型复现了 GPT-4 的多模态能力，已开源
    + 项目主页：[MiniGPT-4][minigpt4_home]
    + 模型：[Vision-CAIR/MiniGPT-4][minigpt4_model]
+ [Generative Agents: Interactive Simulacra of Human Behavior][auto_game]
    + 令若干个独立的基于 GPT 的 Agent “生活”在一起，会产生很多类似人类的社会行为
    + DEMO 在国内打不开，在这里只放出论文
+ [ChatGPT 中文指南][prompt_set]
    + 这是一个很早以前就有的项目，只是每次都得根据回忆去重新搜出来，不如就直接记在这里
+ [复旦大学的 MOSS][MOSS]
    + 昨天（4 月 22 日）刚刚开源，给出了模型、数据、代码
    + 并且 MOSS 支持插件，如科学计算、上网、绘图，据我了解这是开源社区的首次支持
    + 关于插件如何使用，可参考这里：[plugin模型，有用python代码写的使用例子吗？而非只是动态图片][MOSS_plug_issue]，截止到写下这行文字，作者还没有实际测试过。

## 2023-04-23 更新

+ [Awesome ChatGPT Prompts][prompt_set_en]
    + ChatGPT 中文指南 的英文版本
+ [ChatGPT 学术优化][chatgpt_academic]
    + 科研工作专用ChatGPT/GLM拓展，特别优化学术Paper润色体验，模块化设计支持自定义快捷按钮&函数插件，支持代码块表格显示，Tex公式双显示，新增Python和C++项目剖析&自译解功能，PDF/LaTex论文翻译&总结功能，支持并行问询多种LLM模型，支持gpt-3.5/gpt-4/chatglm
+ [Chat with any PDF][chat_pdf]
    + 可以将 PDF GPT 作为上下文，然后可以问他任何问题，比如摘要、理解、建议等。

[this]: https://blog.lucien.ink/archives/538/
[lora]: https://arxiv.org/abs/2106.09685
[ShareGPT]: https://sharegpt.com/
[domeccleston/sharegpt]: https://github.com/domeccleston/sharegpt
[alpaca]: https://github.com/tatsu-lab/stanford_alpaca
[self-instruct]: https://arxiv.org/abs/2212.10560
[llama]: https://arxiv.org/abs/2302.13971v1
[llama_model]: https://huggingface.co/decapoda-research
[llama_7b]: https://huggingface.co/decapoda-research/llama-7b-hf
[llama_13b]: https://huggingface.co/decapoda-research/llama-13b-hf
[alpaca]: https://github.com/tatsu-lab/stanford_alpaca
[alpaca_data]: https://github.com/tatsu-lab/stanford_alpaca/blob/main/alpaca_data.json
[guanaco]: https://guanaco-model.github.io/
[guanaco_data]: https://huggingface.co/datasets/JosephusCheung/GuanacoDataset
[vicuna]: https://vicuna.lmsys.org/
[vicuna_demo]: https://chat.lmsys.org/
[gpt_4_eval]: https://github.com/lm-sys/FastChat/tree/main/fastchat/eval
[fast_chat]: https://github.com/lm-sys/FastChat
[belle]: https://github.com/LianjiaTech/BELLE
[belle_hf]: https://huggingface.co/BelleGroup
[chinese_vicuna]: https://github.com/Facico/Chinese-Vicuna
[chinese_vicuna_hf]: https://huggingface.co/Chinese-Vicuna

[vicuna_13b_delta]: https://huggingface.co/lmsys/vicuna-13b-delta-v0

[koala]: https://bair.berkeley.edu/blog/2023/04/03/koala/

[belle_model]: https://huggingface.co/BelleGroup/BELLE-LLAMA-13B-2M
[llm_repo]: https://github.com/Hannibal046/Awesome-LLM


[auto_gpt]: https://github.com/Significant-Gravitas/Auto-GPT
[auto_gpt_online_demo]: https://agentgpt.reworkd.ai/
[minigpt4_repo]: https://github.com/Vision-CAIR/MiniGPT-4
[minigpt4_home]: https://minigpt-4.github.io/
[minigpt4_model]: https://huggingface.co/Vision-CAIR/MiniGPT-4
[auto_game]: https://arxiv.org/abs/2304.03442
[prompt_set]: https://github.com/PlexPt/awesome-chatgpt-prompts-zh
[MOSS]: https://github.com/OpenLMLab/MOSS
[MOSS_plug_issue]: https://github.com/OpenLMLab/MOSS/issues/51

[prompt_set_en]: https://github.com/f/awesome-chatgpt-prompts
[chatgpt_academic]: https://github.com/binary-husky/chatgpt_academic
[chat_pdf]: https://www.chatpdf.com/