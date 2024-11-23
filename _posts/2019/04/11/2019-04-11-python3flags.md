---
title: "Python3 flags"
date: 2019-04-11 16:14:00 +0800
last_modified_at: 2019-04-11 16:15:24 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "其它"]
tags: ["其它", "程序人生"]
---

https://pasteme.cn/5872

```python
## main.py
from absl import app, flags
 
FLAGS = flags.FLAGS
flags.DEFINE_string('test', None, 'comma separated list of GPU(s) to use.')
 
 
def main(argv):
    del argv
    if FLAGS.test:
        print(FLAGS.test)
    else:
        print('test is not set')
 
 
if __name__ == '__main__':
    app.run(main)

```

```sh
Macbook Pro:~ LucienShui$ python3 main.py --test 1
1
Macbook Pro:~ LucienShui$ python3 main.py -test 1
1
Macbook Pro:~ LucienShui$ python3 main.py --test=1
1
Macbook Pro:~ LucienShui$ python3 main.py -test=1
1
```

`main.py --help` 或 `main.py -help` 获取帮助信息。