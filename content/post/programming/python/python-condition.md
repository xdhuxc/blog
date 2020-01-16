+++
title = "Python 中的条件语句"
date = "2017-09-16"
lastmod = "2017-09-16"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Python 语言中的条件语句。

<!--more-->

### Python 条件语句

Python 条件语句是通过一条或多条语句的执行结果（True或者False）来决定执行的代码块

Python 程序语言指定任何非0和非空（null）值为true，0 或者 null为false

Python 编程中 if 语句用于控制程序的执行，基本形式为：
```markdown
if 判断条件:
    执行语句...
else:
    执行语句...
```
其中"判断条件"成立时（非零），则执行后面的语句，而执行内容可以多行，以缩进来区分表示同一范围。
else 为可选语句，当需要在条件不成立时执行内容则可以执行相关语句

if 语句的判断条件可以用>（大于）、<(小于)、==（等于）、>=（大于等于）、<=（小于等于）来表示其关系。

当判断条件为多个值时，可以使用以下形式：
```markdown
if 判断条件1:
    执行语句1……
elif 判断条件2:
    执行语句2……
elif 判断条件3:
    执行语句3……
else:
    执行语句4……
```

多个条件判断时，使用 elif 来实现，如果判断需要多个条件需同时判断时，可以使用 or （或），表示两个条件有一个成立时判断条件成功；使用 and （与）时，表示只有两个条件同时成立的情况下，判断条件才成功。

当if有多个条件时可使用括号来区分判断的先后顺序，括号中的判断优先执行，此外 and 和 or 的优先级低于>（大于）、<（小于）等判断符号，即大于和小于在没有括号的情况下会比与或要优先判断。

python 复合布尔表达式计算采用短路规则，即如果通过前面的部分已经计算出整个表达式的值，则后面的部分不再计算。

### Python 循环语句

循环语句允许我们执行一个语句或语句组多次

#### while循环

在给定的判断条件为 true 时执行循环体，否则退出循环体。

Python 编程中 while 语句用于循环执行程序，即在某条件下，循环执行某段程序，以处理需要重复处理的相同任务。其基本形式为：
```markdown
while 判断条件：
    执行语句……
```
执行语句可以是单个语句或语句块。判断条件可以是任何表达式，任何非零、或非空（null）的值均为true。
当判断条件假false时，循环结束。
执行流程图如下：
![image](http://www.runoob.com/wp-content/uploads/2013/11/python_while_loop.jpg)

Python while语句执行过程
![image](http://www.runoob.com/wp-content/uploads/2013/11/loop-over-python-list-animation.gif)

while 语句还有另外两个重要的命令 continue、break 来跳过循环，continue 用于跳过该次循环，break 则是用于退出循环，此外"判断条件"还可以是个常值，表示循环必定成立。

如果条件判断语句永远为 true，循环将会无限的执行下去。

注意：以上的无限循环你可以使用 CTRL+C 来中断循环。

在 python 中，while … else 在循环条件为 false 时执行 else 语句块

类似 if 语句的语法，如果你的 while 循环体中只有一条语句，你可以将该语句与while写在同一行中

#### for循环

重复执行语句

Python for循环可以遍历任何序列的项目，如一个列表或者一个字符串。

for循环的语法格式如下：
```markdown
for iterating_var in sequence:
   statements(s)
```

遍历字符串和列表
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
for letter in 'Python':     # 第一个实例
   print '当前字母 :', letter
 
fruits = ['banana', 'apple',  'mango']
for fruit in fruits:        # 第二个实例
   print '当前水果 :', fruit
 
print "Good bye!"
```

通过序列索引迭代（一种执行循环的遍历方式是通过索引）
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

fruits = ['banana', 'apple',  'mango']
# 函数 len() 返回列表的长度，即元素的个数
# 函数 range()返回一个序列的数
for index in range(len(fruits)):
   print '当前水果 :', fruits[index]
 
print "Good bye!"
```

在 python 中，for … else 表示这样的意思，for 中的语句和普通的没有区别，else 中的语句会在循环正常执行完（即 for 不是通过 break 跳出而中断的）的情况下执行，while … else 也是一样。

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
for num in range(10,20):  # 迭代 10 到 20 之间的数字
   for i in range(2,num): # 根据因子迭代
      if num%i == 0:      # 确定第一个因子
         j=num/i          # 计算第二个因子
         print '%d 等于 %d * %d' % (num,i,j)
         break            # 跳出当前循环
   else:                  # 循环的 else 部分
      print num, '是一个质数'
```

#### 嵌套循环

Python 语言允许在一个循环体里面嵌入另一个循环。

Python for 循环嵌套语法
```markdown
for iterating_var in sequence:
   for iterating_var in sequence:
      statements(s)
   statements(s)
```

Python while 循环嵌套语法
```markdown
while expression:
   while expression:
      statement(s)
   statement(s)
```

可以在循环体内嵌入其他的循环体，如在while循环中可以嵌入for循环， 反之，你可以在for循环中嵌入while循环

### 循环控制语句

循环控制语句可以更改语句执行的顺序

Python支持以下循环控制语句：

#### break语句

在语句块执行过程中终止循环，并且跳出整个循环

break语句用来终止循环语句，即循环条件没有False条件或者序列还没被完全递归完，也会停止执行循环语句。

break语句用在while和for循环中。

如果使用嵌套循环，break语句将停止执行最深层的循环，并开始执行下一行代码。

Python语言 break语句语法
```markdown
break
```

#### continue语句

在语句块执行过程中终止当前循环，跳出该次循环，执行下一次循环

Python continue 语句跳出本次循环，而break跳出整个循环。

continue 语句用来告诉Python跳过当前循环的剩余语句，然后继续进行下一轮循环。

continue语句用在while和for循环中。

Python 语言 continue 语句语法格式如下：
```
continue
```

#### pass语句

pass是空语句，是为了保持程序结构的完整性

Python pass是空语句，是为了保持程序结构的完整性。pass 不做任何事情，一般用做占位语句。

Python 语言 pass 语句语法格式如下：
```markdown
pass
```
