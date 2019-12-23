+++
title = "Python 常用代码示例"
date = "2018-04-27"
lastmod = "2018-04-27"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客记录些在 Python 开发中经常会用到的代码，下次使用时就可以直接愉快地复制粘贴了。

<!--more-->

### 常用代码
1、时间戳
```markdown
import time

time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
```

2、pycharm 代码模板（Editor -> Code Style -> File and Code Template）
```markdown
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: ${USER}
# date: ${DATE}
# description:
```

3、日志
```markdown
import logging as log

log.basicConfig(level=log.INFO,
                datefmt='%Y/%m/%d %H:%M:%S',
                format='%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')
```

4、检查文件变动
```markdown
import inotify.adapters
import os

def main():
    i = inotify.adapters.Inotify()
    dir_name = os.getenv('DIR_NAME', '/etc/envoy/')
    i.add_watch(dir_name)

    os.chdir(dir_name)
    # CREATE event for a directory:
    os.system('mkdir foo')
    # CREATE event for a file:
    os.system('echo hello > test.txt')
    # MODIFY event for the file:
    os.system('echo world >> test.txt')

    for event in i.event_gen(yield_nones=False):
        (_, type_names, path, filename) = event
        if 'IN_CREATE' in type_names:
            print('the new configuration file is created.')
        if 'IN_ISDIR' in type_names:
            print('the new directory is created.')

if __name__ == '__main__':
    main()
```

5、性能分析

1）使用 `cProfile` 进行性能分析
```markdown
python -m cProfile abc.py
```

2）使用 `line_profile` 进行性能分析
在待检测的函数上面添加 `@profile` 装饰器
```markdown
@profile   # 不用管此处的提示 "unresolved reference 'profile'"
def func1():
    sum = 0
    for i in range(100000):
        sum += i
```
运行该脚本
```markdown
kernprof -l -v xdhuxc.py
```

参考资料：https://segmentfault.com/a/1190000007518598

