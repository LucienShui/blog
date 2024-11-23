---
title: "highlight.js 添加行号"
date: 2020-02-10 10:20:00 +0800
last_modified_at: 2020-02-10 10:22:06 +0800
math: false
render_with_liquid: false
categories: ["工程", "前端"]
tags: ["工程", "前端"]
description: "使用现成的轮子为 highlight.js 添加行号，略作调整。本文地址：blog.lucien.ink/archives/491"
---

## highlight.js 添加行号

> 本文地址：[blog.lucien.ink/archives/491][this]

### 现成的轮子

GitHub 上有一个为 highlight.js 添加行号的项目 [github.com/wcoder/highlightjs-line-numbers.js][github.com/wcoder/highlightjs-line-numbers.js]。

可以直接将 [src/highlightjs-line-numbers.js][src/highlightjs-line-numbers.js] 下载下来魔改一下。

#### CSS

为了适配 PasteMe，对作者的 CSS 略作修改。

```css
/* for block of numbers */
.hljs-ln-numbers {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;

    text-align: center;
    color: #ccc;
    vertical-align: top;
    padding-right: 5px;

    /* your custom style here */
}

/* for block of code */
.hljs-ln-code {
    padding-left: 1em;
}

```

### 最终效果

[pasteme.cn/105][pasteme.cn/105]

[src/highlightjs-line-numbers.js]: https://github.com/wcoder/highlightjs-line-numbers.js/blob/master/src/highlightjs-line-numbers.js
[github.com/wcoder/highlightjs-line-numbers.js]: https://github.com/wcoder/highlightjs-line-numbers.js
[pasteme.cn/105]: https://pasteme.cn/105
[this]: https://blog.lucien.ink/archives/491/