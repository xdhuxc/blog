+++
title = "Python 基础语法"
date = "2017-09-12"
lastmod = "2017-09-12"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Python 编程的基础语法。

<!--more-->

### Python编程

Python编程方式

#### 交互式编程

交互式编程不需要创建脚本文件，是通过 Python 解释器的交互模式进来编写代码。

在 linux上，只需要在命令行中输入 Python 命令即可启动交互式编程，提示窗口如下：
```markdown
$ python
Python 2.7.6 (default, Sep  9 2014, 15:04:36) 
[GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.39)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```
在 Windows 上，安装 Python 时已经安装了默认的交互式编程客户端。

#### 脚本式编程

通过脚本参数调用解释器开始执行脚本，直到脚本执行完毕。当脚本执行完成后，解释器不再有效。

所有 Python 文件将以 `.py` 为扩展名。

假设已经设置了 Python 解释器 PATH 变量。

`xdhuxc.py` 文件的内容为：
```markdown
# -*- coding: utf-8 -*- 

print "Hello,Python!"
```

使用以下命令运行程序：
```markdown
$ python xdhuxc.py
```
使用另外一种方式来执行Python脚本，修改 `xdhuxc.py` 文件，内容如下：
```markdown
#!/usr/bin/python
# -*- coding: utf-8 -*-

print "Hello, Python!"
```

这里，假定 Python 解释器在 `/usr/bin` 目录中，使用以下命令执行脚本：
```markdown
$ chmod +x xdhuxc.py # 为脚本xdhuxc.py添加可执行权限
$ ./xdhuxc.py
```

### Python 标识符

在 Python 里，标识符由字母、数字、下划线组成。

在 Python 中，所有标识符可以包括英文、数字以及下划线 `_`，但不能以数字开头。

在 Python 中，标识符是区分大小写的。

以 `下划线开头` 的标识符是有特殊意义的：

* 以单下划线开头 `_foo` 的代表不能直接访问的类属性，需通过类提供的接口进行访问，不能用 `from xxx import *` 而导入；
* 以双下划线开头的 `__foo` 代表类的私有成员；
* 以双下划线开头和结尾的 `__foo__` 代表 `Python` 里特殊方法专用的标识，如 `__init__()` 代表类的构造函数。


### Python 保留字

Python 的保留字不能用作常数或变量，或任何其他标识符名称。

所有 Python 的关键字只包含小写字母。

and    | exec    | not
---    |---      |---
assert | finally | or
break  | for     | pass
class  | from    | print
continue | global  | raise
def    | if      | return
del    | import  | try
elif   | in      | while
else   | is      | with
except | lambda  | yield

### 行和缩进

Python 与其他语言最大的区别就是：Python 的代码块不使用大括号 {} 来控制类，函数以及其他逻辑判断。

python 最具特色的就是用缩进来写模块。

缩进的空白数量是可变的，但是所有代码块语句必须包含相同的缩进空白数量，这个必须严格执行。

在 Python 的代码块中，必须使用相同数量的行首缩进空格数。建议在每个缩进层次使用 单个制表符 或 两个空格 或 四个空格 , 切记不能混用

### 多行语句

Python语句中一般以新行作为为语句的结束符。

在 Python 中，可以在同一行显示多条语句，方法是用分号 `;` 分开。

可以使用斜杠（ \）将一行的语句分为多行显示，如下所示：
```markdown
total = item_one + \
        item_two + \
        item_three
```
语句中包含 [], {} 或 () 括号就不需要使用多行连接符，如下所示：
```markdown
days = ['Monday', 'Tuesday', 'Wednesday',
        'Thursday', 'Friday']
```

### Python 引号

Python 可以使用单引号 `'`、双引号 `"`、三引号 `'''` 或 `"""` 来表示字符串，引号的开始与结束必须是相同的类型。

其中三引号可以由多行组成，是编写多行文本的快捷语法，常用于文档字符串，在文件的特定位置，被当做注释。
```markdown
word = 'word'
sentence = "这是一个句子。"
paragraph = """这是一个段落。
包含了多个语句"""
```

### Python 注释

python 中单行注释采用 `# `开头。

注释可以在语句或表达式行末；

Python 中多行注释使用三个单引号 `'''` 或三个双引号 `"""`。
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 文件名：test.py


'''
这是多行注释，使用单引号。
这是多行注释，使用单引号。
这是多行注释，使用单引号。
'''

"""
这是多行注释，使用双引号。
这是多行注释，使用双引号。
这是多行注释，使用双引号。
"""
```

### 空行

函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。

空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。

注意：空行也是程序代码的一部分。

### 代码组

缩进相同的一组语句构成一个代码块，称之代码组。

像 `if`、`while`、`def` 和 `class` 这样的复合语句，首行以关键字开始，以冒号 `:` 结束，该行之后的一行或多行代码构成代码组。

将首行及后面的代码组称为一个子句。
如下所示：
```markdown
if expression : 
   suite 
elif expression :  
   suite  
else :  
   suite 
```

### 其他

1、print 默认输出是换行的，如果要实现不换行需要在变量末尾加上逗号。

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

x="a"
# 换行输出
print x

print '---------'
# 不换行输出
print x,
```

2、`#!/usr/bin/python` 的含义

脚本语言的第一行，目的就是指出，你想要你的这个文件中的代码用什么可执行程序去运行它，

`#!/usr/bin/python` : 是告诉操作系统执行这个脚本的时候，调用 /usr/bin 下的 python 解释器；

`#!/usr/bin/env `：python(推荐）: 这种用法是为了防止操作系统用户没有将 python 装在默认的 /usr/bin 路径里。当系统看到这一行的时候，首先会到 env 设置里查找 python 的安装路径，再调用对应路径下的解释器程序完成操作。
