---
title: "适用于 ACM 程序设计竞赛的 vimrc"
date: 2019-07-27 09:11:00 +0800
last_modified_at: 2019-07-27 09:15:48 +0800
math: false
render_with_liquid: false
categories: ["ACM"]
tags: ["vimrc", "acm"]
---

## 适用于 ACM 程序设计竞赛的 vimrc

本文地址：https://blog.lucien.ink/archives/458/

### 说明

这是我所在的队伍三个人达成共识之后共同使用的 `.vimrc` 文件，涵盖了自动缩进，自动补全花括号，输入文件重定向等

自认为我们的 `.vimrc` 比较短，真正需要手打的只有 8 行，一般可以在 30 秒左右敲完

+ `F9` 是运行程序（从控制台读取输入）
+ `F5` 是运行程序（将同目录下 `in` 文件的内容作为输入，效果等于 `freopen("in", "r", stdin)`)

### Source

```bash
set nu sts=4 ts=4 sw=4 cin
map <F5> :call CR()<CR>
func CR()
	exec "w"
	exec "!clear && g++ % -std=c++11 -W -o a && ./a < in"
endfunc
map <F9> :call CRr()<CR>
func CRr()
	exec "w"
	exec "!clear && g++ % -std=c++11 -W -o a && ./a"
endfunc
imap {<CR> {<CR>}<C-O>O<left><right>
syn on
```

### 其它技巧

在 `Normal` 模式下，输入 `:20vsp in` 可以快速分屏并打开 `in` 文件以进行编辑

关于分屏的操作，详见 [VIM分屏常用指令](https://blog.lucien.ink/archives/317/)
