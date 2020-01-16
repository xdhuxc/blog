+++
title = "Python 中的文件、输入输出流和异常"
date = "2017-09-18"
lastmod = "2017-09-18"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Python 语言中的文件、输入输出流和异常。

<!--more-->

# 一、文件I/O
> 基本的的I/O函数

## （一）打印到屏幕
最简单的输出方法是用print语句，可以给它传递零个或多个用逗号隔开的表达式。此函数把传递的表达式转换成一个字符串表达式，并将结果写到标准输出。

## （二）读取键盘输入
Python提供了两个内置函数从标准输入读入一行文本，默认的标准输入是键盘。如下：
* raw_input
* input

#### raw_input函数
raw_input([prompt]) 函数从标准输入读取一个行，并返回一个字符串（去掉结尾的换行符）：
```
#!/usr/bin/python
# -*- coding: UTF-8 -*- 
 
xdhuxc = raw_input("请输入：");
print "输入的内容是: ", xdhuxc
```
将提示输入任意字符串，然后在屏幕上显示相同的字符串。当输入"Hello Python！"，它的输出如下：
```
请输入：Hello Python！
输入的内容是:  Hello Python！
```

### input函数
input([prompt]) 函数和 raw_input([prompt]) 函数基本类似，但是 input 可以接收一个Python表达式作为输入，并将运算结果返回。
```
#!/usr/bin/python
# -*- coding: UTF-8 -*- 
 
xdhuxc = input("请输入：");
print "输入的内容是: ", xdhuxc
```
会产生如下的对应着输入的结果：
```
请输入：[x*5 for x in range(2,10,2)]
输入的内容是:  [10, 20, 30, 40]
```
## （三）打开和关闭文件
> Python 提供了必要的函数和方法进行默认情况下的文件基本操作。可以用 file 对象做大部分的文件操作。

### open函数
必须先用Python内置的open()函数打开一个文件，创建一个file对象，相关的方法才可以调用它进行读写。语法：
```
file object = open(file_name [, access_mode][, buffering])
```
各个参数的含义如下：
* file_name：file_name变量是一个包含了你要访问的文件名称的字符串值。
* access_mode：access_mode决定了打开文件的模式：只读，写入，追加等。所有可取值见如下的完全列表。这个参数是非强制的，默认文件访问模式为只读(r)。
* buffering：如果buffering的值被设为0，就不会有寄存。如果buffering的值取1，访问文件时会寄存行。如果将buffering的值设为大于1的整数，表明了这就是的寄存区的缓冲大小。如果取负值，寄存区的缓冲大小则为系统默认。

不同模式打开文件的完全列表：

模式 | 描述
---|---
r  | 以只读方式打开文件。文件的指针将会放在文件的开头。这是默认模式。
rb | 以二进制格式打开一个文件用于只读。文件指针将会放在文件的开头。这是默认模式。
r+ | 打开一个文件用于读写。文件指针将会放在文件的开头。
rb+| 以二进制格式打开一个文件用于读写。文件指针将会放在文件的开头。
W  | 打开一个文件只用于写入。如果该文件已存在则将其覆盖。如果该文件不存在，创建新文件。
wb | 以二进制格式打开一个文件只用于写入。如果该文件已存在则将其覆盖。如果该文件不存在，创建新文件。
w+ | 打开一个文件用于读写。如果该文件已存在则将其覆盖。如果该文件不存在，创建新文件。
wb+| 以二进制格式打开一个文件用于读写。如果该文件已存在则将其覆盖。如果该文件不存在，创建新文件。
a  | 打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。
ab | 以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。
a+ | 打开一个文件用于读写。如果该文件已存在，文件指针将会放在文件的结尾。文件打开时会是追加模式。如果该文件不存在，创建新文件用于读写。
ab+| 以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。如果该文件不存在，创建新文件用于读写。

### File对象的属性
一个文件被打开后，你有一个file对象，你可以得到有关该文件的各种信息。
file对象相关的所有属性的列表

属性 | 描述
---|---
file.closed | 返回true如果文件已被关闭，否则返回false
file.mode | 返回被打开文件的访问模式
file.name | 返回文件的名称
file.softspace | 如果用print输出后，必须跟一个空格符，则返回false。否则返回true

#### close()方法
File 对象的 close()方法刷新缓冲区里任何还没写入的信息，并关闭该文件，这之后便不能再进行写入。
当一个文件对象的引用被重新指定给另一个文件时，Python 会关闭之前的文件。用 close()方法关闭文件是一个很好的习惯。其语法为：
```
fileObject.close()
```
### 读写文件
file对象提供了一系列方法，能让文件访问更轻松。使用read()和write()方法来读取和写入文件。

#### write()方法
write()方法可将任何字符串写入一个打开的文件。需要重点注意的是，Python字符串可以是二进制数据，而不是仅仅是文字。
write()方法不会在字符串的结尾添加换行符('\n')，其语法为：
```
fileObject.write(string) # 在这里，被传递的参数是要写入到已打开文件的内容
```

#### read()方法
read()方法从一个打开的文件中读取一个字符串。需要重点注意的是，Python字符串可以是二进制数据，而不是仅仅是文字。其语法为：
```
fileObject.read([count]) # 在这里，被传递的参数是要从已打开文件中读取的字节计数。该方法从文件的开头开始读入，如果没有传入count，它会尝试尽可能多地读取更多的内容，很可能是直到文件的末尾。
```

### 重命名和删除文件
> Python的os模块提供了执行文件处理操作的方法，比如重命名和删除文件。

要使用这个模块，你必须先导入它，然后才可以调用相关的各种功能

1、rename()方法
rename()方法需要两个参数，当前的文件名和新文件名。其语法格式为：
```
os.rename(current_file_name, new_file_name)
```
2、remove()方法
可以用remove()方法删除文件，需要提供要删除的文件名作为参数。其语法格式为：
```
os.remove(file_name)
```

### 目录
> 所有文件都包含在各个不同的目录下，不过Python也能轻松处理。os模块有许多方法能帮你创建，删除和更改目录。

1、mkdir()方法
可以使用os模块的mkdir()方法在当前目录下创建新的目录。需要提供一个包含了要创建的目录名称的参数。其语法格式为：
```
os.mkdir("new_directory_name")
```

2、chdir()方法
可以用chdir()方法来改变当前的目录。chdir()方法需要的一个参数是你想设成当前目录的目录名称。其语法格式为：
```
os.chdir("new_directory_name")
```

3、getcwd()方法
getcwd()方法显示当前的工作目录。其语法格式为：
```
os.getcwd()
```

4、rmdir()方法
rmdir()方法删除目录，目录名称以参数传递。在删除这个目录之前，它的所有内容应该先被清除。其语法格式为：
```
os.rmdir("directory_name")
``` 
目录的完全合规的名称必须被给出，否则会在当前目录下搜索该目录。

### 文件、目录相关的方法
> 三个重要的方法来源能对Windows和Unix操作系统上的文件及目录进行一个广泛且实用的处理及操控，如下：

* File 对象方法: file对象提供了操作文件的一系列方法
* OS 对象方法: 提供了处理文件及目录的一系列方法

# 二、Python异常处理
> python提供了两个非常重要的功能来处理python程序在运行中出现的异常和错误，可以使用该功能来调试python程序。
* 异常处理
* 断言

## python标准异常
异常名称|描述
---|---|
BaseException | 所有异常的基类
SystemExit | 解释器请求退出
KeyboardInterrupt | 用户中断执行(通常是输入^C)
Exception | 常规错误的基类
StopIteration | 迭代器没有更多的值
GeneratorExit | 生成器(generator)发生异常来通知退出
StandardError | 所有的内建标准异常的基类
ArithmeticError | 所有数值计算错误的基类
FloatingPointError | 浮点计算错误
OverflowError | 数值运算超出最大限制
ZeroDivisionError | 除(或取模)零 (所有数据类型)
AssertionError | 断言语句失败
AttributeError | 对象没有这个属性
EOFError | 没有内建输入,到达EOF 标记
EnvironmentError | 操作系统错误的基类
IOError | 输入/输出操作失败
OSError | 操作系统错误
WindowsError | 系统调用失败
ImportError | 导入模块/对象失败
LookupError | 无效数据查询的基类
IndexError | 序列中没有此索引(index)
KeyError | 映射中没有这个键
MemoryError | 内存溢出错误(对于Python 解释器不是致命的)
NameError	|未声明/初始化对象 (没有属性)
UnboundLocalError | 访问未初始化的本地变量
ReferenceError | 弱引用(Weak reference)试图访问已经垃圾回收了的对象
RuntimeError|	一般的运行时错误
NotImplementedError|	尚未实现的方法
SyntaxError	| Python 语法错误
IndentationError|缩进错误
TabError | Tab 和空格混用
SystemError | 一般的解释器系统错误
TypeError | 对类型无效的操作
ValueError | 传入无效的参数
UnicodeError | Unicode 相关的错误
UnicodeDecodeError | Unicode 解码时的错误
UnicodeEncodeError | Unicode 编码时错误
UnicodeTranslateError |	Unicode 转换时错误
Warning	| 警告的基类
DeprecationWarning | 关于被弃用的特征的警告
FutureWarning | 关于构造将来语义会有改变的警告
OverflowWarning | 旧的关于自动提升为长整型(long)的警告
PendingDeprecationWarning |	关于特性将会被废弃的警告
RuntimeWarning | 可疑的运行时行为(runtime behavior)的警告
SyntaxWarning |	可疑的语法的警告
UserWarning	| 用户代码生成的警告

## 异常
异常即是一个事件，该事件会在程序执行过程中发生，影响了程序的正常执行。
一般情况下，在Python无法正常处理程序时就会发生一个异常。
异常是Python对象，表示一个错误。当Python脚本发生异常时,需要捕获处理它，否则程序会终止执行。

### 异常处理
捕捉异常可以使用try/except语句。try/except语句用来检测try语句块中的错误，从而让except语句捕获异常信息并处理。
如果不想在异常发生时结束程序，只需在try里捕获它。

简单的try....except...else的语法
```
try:
<语句>        #运行别的代码
except <名字>：
<语句>        #如果在try部份引发了'name'异常
except <名字>，<数据>:
<语句>        #如果引发了'name'异常，获得附加的数据
else:
<语句>        #如果没有异常发生
```
try的工作原理是，当开始一个try语句后，python就在当前程序的上下文中作标记，这样当异常出现时就可以回到这里，try子句先执行，接下来会发生什么依赖于执行时是否出现异常。
* 当try后的语句执行时发生异常，python就跳回到try并执行第一个匹配该异常的except子句，异常处理完毕，控制流就通过整个try语句（除非在处理异常时又引发新的异常）。
* 如果在try后的语句里发生了异常，却没有匹配的except子句，异常将被递交到上层的try，或者到程序的最上层（这样将结束程序，并打印缺省的出错信息）。
* 如果在try子句执行时没有发生异常，python将执行else语句后的语句（如果有else的话），然后控制流通过整个try语句。

#### 使用except而不带任何异常类型
可以不带任何异常类型使用except，如下实例：
```
try:
    正常的操作
   ......................
except:
    发生异常，执行这块代码
   ......................
else:
    如果没有异常执行这块代码
```
以上方式try-except语句捕获所有发生的异常。但这不是一个很好的方式,不能通过该程序识别出具体的异常信息。因为它捕获所有的异常。

#### 使用except而带多种异常类型
可以使用相同的except语句来处理多个异常信息，如下所示：
```
try:
    正常的操作
   ......................
except(Exception1[, Exception2[,...ExceptionN]]]):
   发生以上多个异常中的一个，执行这块代码
   ......................
else:
    如果没有异常执行这块代码
```

#### try-finally 语句
try-finally 语句无论是否发生异常都将执行最后的代码。
```
try:
<语句>
finally:
<语句>    #退出try时总会执行
raise
```
当在try块中抛出一个异常，立即执行finally块代码。
finally块中的所有语句执行后，异常被再次触发，并执行except块代码。
参数的内容不同于异常。

### 异常的参数
一个异常可以带上参数，可作为输出的异常信息参数。可以通过except语句来捕获异常的参数，如下所示：
```
try:
    正常的操作
   ......................
except ExceptionType, Argument:
    你可以在这输出 Argument 的值...
```
变量接收的异常值通常包含在异常的语句中。在元组的表单中变量可以接收一个或者多个值。
元组通常包含错误字符串，错误数字，错误位置。

### 触发异常
可以使用raise语句自己触发异常，raise语法格式如下：
```
raise [Exception [, args [, traceback]]]
```
语句中Exception是异常的类型（例如，NameError）参数是一个异常参数值。该参数是可选的，如果不提供，异常的参数是"None"。
最后一个参数是可选的（在实践中很少使用），如果存在，是跟踪异常对象。

一个异常可以是一个字符串，类或对象。 Python的内核提供的异常，大多数都是实例化的类，这是一个类的实例的参数。

定义一个异常非常简单，如下所示：
```
def functionName( level ):
    if level < 1:
        raise Exception("Invalid level!", level)
        # 触发异常后，后面的代码就不会再执行
```
注意：为了能够捕获异常，"except"语句必须有用相同的异常来抛出类对象或者字符串。
例如捕获以上异常，"except"语句如下所示：
```
try:
    正常逻辑
except "Invalid level!":
    触发自定义异常    
else:
    其余代码
```

### 用户自定义异常
通过创建一个新的异常类，程序可以命名它们自己的异常。异常应该是典型的继承自Exception类，通过直接或间接的方式。

以下为与RuntimeError相关的实例,实例中创建了一个类，基类为RuntimeError，用于在异常触发时输出更多的信息。
在try语句块中，用户自定义的异常后执行except块语句，变量 e 是用于创建NetworkError类的实例。
```
class NetworkError(RuntimeError):
    def __init__(self, arg):
        self.args = arg
```
在定义以上类后，可以触发该异常，如下所示：
```
try:
    raise Networkerror("Bad hostname")
except Networkerror,e:
    print e.args
```
