---
title: "解决 DOM 更新时 highlight.js 高亮或行号消失"
date: 2020-02-10 10:35:00 +0800
last_modified_at: 2020-02-10 10:36:35 +0800
math: false
render_with_liquid: false
categories: ["工程", "前端"]
tags: ["工程", "前端"]
description: "PasteMe 之前使用 prism.js 来进行代码高亮，后来切至 highlight.js，发现在 DOM 内容更新后，highlight.js 的高亮效果及行号会消失。本文地址：https://blog.lucien.ink/archives/492/"
---

## 解决 DOM 更新时 highlight.js 高亮或行号消失

> 本文地址: [blog.lucien.ink/archives/492][this]

### 摘要

PasteMe 之前使用 prism.js 来进行代码高亮，后来切至 highlight.js，发现在 DOM 内容更新后，highlight.js 的高亮效果及行号会消失。

### 原因

highlight.js 会在被引入的时候进行一次高亮渲染，如果在渲染过后更新 DOM，需要手动调用一次 highlight.js 的 `highlightBlock` 方法。

行号同理。

### 代码

对于 PasteMe 来说，只有在 router 发生变化的时候才有可能更新代码，所以监听一下 router 即可。

```js
directives: {
            hljs: function (el) {
                    let blocks = el.querySelectorAll('pre code');
                    if (document.querySelectorAll('.hljs').length === 0) { // 如果没有这个类，说明没有被高亮
                        blocks.forEach(function (block) {
                            window.hljs.highlightBlock(block);
                            if (block.getAttribute('class').split(' ').indexOf('line-numbers') > -1) { // 如果没有这个类，说明行号没有被渲染
                                lineNumbersBlock(block, {
                                    singleLine: true
                                });
                            }
                        });
                    }
                }
        }
```

[this]: https://blog.lucien.ink/archives/492/
