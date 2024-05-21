---
title: "打印 Go Test 的代码覆盖"
date: 2021-07-25 23:04:00 +0800
last_modified_at: 2022-04-11 11:29:40 +0800
math: true
render_with_liquid: false
categories: ["工程"]
tags: ["go", "单元测试"]
description: "在 Go Package 种执行 cover，检测每行代码的测试情况"
img_path: /assets/img/posts/2021/07/25/2021-07-25-da_yin_gotest_de_dai_ma_fu_gai/
---

## 打印 Go Test 的代码覆盖

> 本文地址：[blog.lucien.ink/archives/520][this]

### 使用方法

将这段代码复制进 `~/.zshrc` 或者是 `~/.bashrc` 等文件中（取决于你的命令行），然后在任何一个 Go Package 中执行 `cover` 即可。

```shell
cover() { 
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}
```

![代码覆盖截图][screenshot]

### 参考资料

1. [How to measure test coverage in Go][stackoverflow]

[this]: https://blog.lucien.ink/archives/520/
[stackoverflow]: https://stackoverflow.com/questions/10516662/how-to-measure-test-coverage-in-go
[screenshot]: assets/img/posts/2021/07/25/2021-07-25-da_yin_gotest_de_dai_ma_fu_gai/jie_ping_2021_07_25_xia_wu_10.57.55.png
