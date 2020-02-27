+++
title = "Python 运算符"
date = "2017-09-13"
lastmod = "2017-09-13"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Python 语言中的运算符。

<!--more-->

Python 语言支持以下类型的运算符：

* 算术运算符
* 关系运算符
* 赋值运算符
* 逻辑运算符
* 位运算符
* 成员运算符
* 身份运算符

* 运算符优先级

### Python 算术运算符

算术运算符实现对数字的运算。

运算符 | 描述
---|---
+ | 加 - 两个对象相加
- | 减 - 得到负数或是一个数减去另一个数
* | 乘 - 两个数相乘或是返回一个被重复若干次的字符串
/ | 除 - x除以y
% | 取模 - 返回除法的余数
**| 幂 - 返回x的y次幂
//| 取整除 - 返回商的整数部分

注意：Python2.x 里，整数除整数，只能得出整数。如果要得到小数部分，把其中一个数改成浮点数即可。


### Python 比较运算符

比较运算符用于数字的比较。

运算符 | 描述
---|---
== | 等于   - 比较对象是否相等
!= | 不等于 - 比较两个对象是否不相等
<> | 不等于 - 比较两个对象是否不相等
>  | 大于   - 返回x是否大于y
<  | 小于   - 返回x是否小于y
>= | 大于等于	- 返回x是否大于等于y
<= | 小于等于 -	返回x是否小于等于y

注意：所有比较运算符返回1表示真，返回0表示假。这分别与特殊的变量True和False等价。注意，这些变量名的大写。

### Python 赋值运算符

赋值运算符用于为变量赋值。

运算符 | 描述 | 实例
---|---|---
=  | 简单的赋值运算符 | c = a + b 将 a + b 的运算结果赋值为 c
+= | 加法赋值运算符   | c += a 等效于 c = c + a
-= | 减法赋值运算符   | c -= a 等效于 c = c - a
*= | 乘法赋值运算符   | c *= a 等效于 c = c * a
/= | 除法赋值运算符   | c /= a 等效于 c = c / a
%= | 取模赋值运算符   | c %= a 等效于 c = c % a
**=| 幂赋值运算符     | c **= a 等效于 c = c ** a
//=| 取整除赋值运算符 | c //= a 等效于 c = c // a

### Python 位运算符

按位运算符是把数字看作二进制来进行计算的。

Python中的按位运算法则如下：

运算符 | 描述
---|---
& | 按位与运算符：参与运算的两个值,如果两个相应位都为1,则该位的结果为1,否则为0
| | 按位或运算符：只要对应的二个二进位有一个为1时，结果位就为1
^ | 按位异或运算符：当两对应的二进位相异时，结果为1
~ | 按位取反运算符：对数据的每个二进制位取反,即把1变为0,把0变为1 。~x 类似于 -x-1
<<| 左移动运算符：运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。
>>| 右移动运算符：把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数

### Python 逻辑运算符

逻辑运算符用于对操作数进行逻辑运算。

运算符 | 逻辑表达式 | 描述
---|---|---
and | x and y | 布尔"与" - 如果 x 为 False，x and y 返回 False，否则它返回 y 的计算值
or  | x or y  | 布尔"或"	- 如果 x 是非 0，它返回 x 的值，否则它返回 y 的计算值
not | not x   | 布尔"非" - 如果 x 为 True，返回 False 。如果 x 为 False，它返回 True

### Python 成员运算符

Python支持成员运算符，包含了一系列的成员，例如字符串，列表或元组。


运算符 | 描述 | 实例
---|---|---
in | 如果在指定的序列中找到值返回 True，否则返回 False | x 在 y 序列中 , 如果 x 在 y 序列中返回 True
not in | 如果在指定的序列中没有找到值返回 True，否则返回 False | x 不在 y 序列中 , 如果 x 不在 y 序列中返回 True

### Python 身份运算符

身份运算符用于比较两个对象的存储单元。

id() 函数用于获取对象内存地址。

运算符 | 描述 | 实例
---|---|---
is | is 是判断两个标识符是不是引用自一个对象 | x is y, 类似 id(x) == id(y) , 如果引用的是同一个对象则返回 True，否则返回 False
is not | is not 是判断两个标识符是不是引用自不同对象 | x is not y ， 类似 id(a) != id(b)。如果引用的不是同一个对象则返回结果 True，否则返回 False

### is 和 == 的区别

is 用于判断两个变量引用对象是否为同一个。

== 用于判断引用变量的值是否相等。

### Python 运算符优先级

以下表格列出了从最高到最低优先级的所有运算符：

运算符 | 描述
---|---
** | 指数 (最高优先级)
~+- | 按位翻转, 一元加号和减号 (最后两个的方法名为 +@ 和 -@)
* / % // | 乘，除，取模和取整除
+ - | 加法减法
>> << | 右移，左移运算符
& | 位 'AND'
^ \| | 位运算符
<= < > >= | 比较运算符
<> == != | 等于运算符
= %= /= //= -= += *= **= | 赋值运算符
is not is | 身份运算符
in not in | 成员运算符
not or and| 逻辑运算符