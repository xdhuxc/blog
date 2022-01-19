+++
title = "Python 常见的坑及其解决方法"
date = "2019-07-27"
lastmod = "2018-07-27"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客主要记录一些在使用 Python 语言进行开发的过程中遇到的坑，也就是那些奇奇怪怪的语法带来的问题，这种问题往往比较隐蔽，在排查过程中会耗费大量时间，但是却给我们带来很大的困扰。

<!--more-->

### 小心 list 元素的组织
如果我们有一个这样的 list，
```markdown
s = ['a', 'b', 'c', 'd', 'f']
print(s)
``` 
那么输出结果是什么呢？毫无疑问，是这样的
```markdown
['a', 'b', 'c', 'd', 'f']
```

如果我们给 list 换个写法，比如下面这样
```markdown
s = ['a', 'b', 'c' 'd' 'f']
print(s)

s = [
    'a',
    'b',
    'c' 
    'd'
    'f'
]
print(s)
```
那么输出结果会是什么样的呢？如果对这个输出结果判断错误，那么，我们的程序就会出现些意料之外的错误。其实，它的结果是这样的
```markdown
['a', 'b', 'cdf']
['a', 'b', 'cdf']
```
虽然不知道为什么，但是 python 确实是这么设计的，没有错误提示，也没有错误，将空格当成了字符串连接符来使用了。

填补此坑花了我将近三个小时的时间，要谨记此错误！

### 加载 sys 模块，设置编码的原因

以下代码中，先重新加载sys模块，再设置编码，而不是先设置编码，再加载sys模块的原因：
```markdown
import sys
reload(sys)
sys.setdefaultencoding('utf8')
```

因为 python 运行的时候首先加载了 Lib/site.py，而在 site.py 文件中有如下代码：
```markdown
if hasattr(sys, "setdefaultencoding"):
    del sys.setdefaultencoding
```
在sys模块加载后，setdefaultencoding 方法被删除了，所以我们需要通过重新导入sys模块来设置系统编码。

动态语言有时候需要静态化的设计，删除属性和方法会给其他地方的代码带来重大的错误隐患。

