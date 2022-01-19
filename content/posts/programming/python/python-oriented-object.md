+++
title = "Python 面向对象"
date = "2017-09-26"
lastmod = "2017-09-26"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客介绍了 Python 中的面向对象 和网络编程。

<!--more-->

### 面向对象技术的基本概念

* 类(Class): 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
* 类变量：类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
* 数据成员：类变量或者实例变量用于处理类及其实例对象的相关的数据。
* 方法重写：如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
* 实例变量：定义在方法中的变量，只作用于当前实例的类。
* 继承：即一个派生类继承基类的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。
* 实例化：创建一个类的实例，类的具体对象。
* 方法：类中定义的函数。
* 对象：通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。


### 类
使用 class 语句来创建一个新类，class 之后为类的名称并以冒号结尾，如下实例:
```markdown
class ClassName:
   '类的帮助信息'   #类文档字符串，帮助信息可以通过ClassName.__doc__查看。
   class_suite  #类体，由类成员，方法，数据属性组成。
```

一个简单的Python类实例：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
class Employee:
   '所有员工的基类'
   empCount = 0
 
   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1
   
   def displayCount(self):
     print "Total Employee %d" % Employee.empCount
 
   def displayEmployee(self):
      print "Name : ", self.name,  ", Salary: ", self.salary
```
* empCount 变量是一个类变量，它的值将在这个类的所有实例之间共享。你可以在内部类或外部类使用 Employee.empCount 访问。
* 第一种方法__init__()方法是一种特殊的方法，被称为类的构造函数或初始化方法，当创建了这个类的实例时就会调用该方法
* self 代表类的实例，self 在定义类的方法时是必须有的，虽然在调用时不必传入相应的参数。

#### self代表类的实例，而非类

类的方法与普通的函数只有一个特殊的区别——它们必须有一个额外的第一个参数名称, 按照惯例它的名称是 self。
```markdown
class Xdhuxc:
    def xdhuxc(self):
        print self
        print self.__class__
        print self.__doc__
        print self.__module__

x = Xdhuxc()
x.xdhuxc()
```
以上程序执行结果为：
```markdown
<__main__.Xdhuxc instance at 0x02190940>
__main__.Xdhuxc
None
__main__
```
从执行结果可以看出，self 代表的是类的实例，代表当前对象的地址，而 self.__class__ 则指向类。
self 不是 python 关键字，将它换成 xdhuxc 也是可以正常执行的

#### 创建实例对象

在 Python 中，类的实例化类似函数调用方式。使用类的名称 Employee 来实例化，并通过 __init__ 方法接受参数。

```markdown
"创建 Employee 类的第一个对象"
emp1 = Employee("Zara", 2000)
"创建 Employee 类的第二个对象"
emp2 = Employee("Manni", 5000)
```

#### 访问属性

可以使用点(.)来访问对象的属性。使用如下类的名称访问类变量：
```markdown
emp1.displayEmployee()
emp2.displayEmployee()
print "Total Employee %d" % Employee.empCount
```

可以添加，删除，修改类的属性，如下所示：
```markdown
emp1.age = 7  # 添加一个 'age' 属性
emp1.age = 8  # 修改 'age' 属性
del emp1.age  # 删除 'age' 属性
```

可以使用以下函数的方式来访问属性：

* getattr(obj, name[, default]) : 访问对象的属性。
* hasattr(obj,name) : 检查是否存在一个属性。
* setattr(obj,name,value) : 设置一个属性。如果属性不存在，会创建一个新属性。
* delattr(obj, name) : 删除属性。

使用方式如下所示：
```markdown
hasattr(emp1, 'age')    # 如果存在 'age' 属性返回 True。
getattr(emp1, 'age')    # 返回 'age' 属性的值
setattr(emp1, 'age', 8) # 添加属性 'age' 值为 8
delattr(empl, 'age')    # 删除属性 'age'
```
#### 内置类属性
* __dict__ : 类的属性（包含一个字典，由类的数据属性组成）
* __doc__ :类的文档字符串
* __name__: 类名
* __module__: 类定义所在的模块（类的全名是'__main__.className'，如果类位于一个导入模块module_name中，那么className.__module__ 等于 module_name）
* __bases__ : 类的所有父类构成元素（包含了一个由所有父类组成的元组）



### 对象销毁(垃圾回收)
Python 使用了引用计数这一简单技术来跟踪和回收垃圾。
在 Python 内部记录着所有使用中的对象各有多少引用。
一个内部跟踪变量，称为一个引用计数器。
当对象被创建时， 就创建了一个引用计数， 当这个对象不再需要时， 也就是说， 这个对象的引用计数变为0 时， 它被垃圾回收。但是回收不是"立即"的， 由解释器在适当的时机，将垃圾对象占用的内存空间回收。

垃圾回收机制不仅针对引用计数为0的对象，同样也可以处理循环引用的情况。循环引用指的是，两个对象相互引用，但是没有其他变量引用他们。这种情况下，仅使用引用计数是不够的。Python 的垃圾收集器实际上是一个引用计数器和一个循环垃圾收集器。作为引用计数的补充， 循环垃圾收集器也会留心被分配的总量很大（及未通过引用计数销毁的那些）的对象。 在这种情况下， 解释器会暂停下来， 试图清理所有未引用的循环。

析构函数 __del__ ，__del__在对象销毁的时候被调用，当对象不再被使用时，__del__方法运行。


### 类的继承

面向对象的编程带来的主要好处之一是代码的重用，实现这种重用的方法之一是通过继承机制。继承完全可以理解成类之间的类型和子类型关系。

需要注意的地方：继承语法 class 派生类名（基类名）：//... 基类名写在括号里，基本类是在类定义的时候，在元组之中指明的。

Python 继承中的若干特点：

* 在继承中基类的构造（__init__()方法）不会被自动调用，它需要在其派生类的构造中亲自专门调用。
* 在调用基类的方法时，需要加上基类的类名前缀，且需要带上self参数变量。区别于在类中调用普通函数时并不需要带上self参数
* Python总是首先查找对应类型的方法，如果它不能在派生类中找到对应的方法，它才开始到基类中逐个查找。（先在本类中查找调用的方法，找不到才去基类中找）。

如果在继承元组中列了一个以上的类，那么它就被称作"多重继承" 。

派生类的声明，与他们的父类类似，继承的基类列表跟在类名之后，语法：
```markdown
class SubClassName (ParentClass1[, ParentClass2, ...]):
   'Optional class documentation string'
   class_suite
```

可以使用issubclass()或者isinstance()方法来检测。

* issubclass() - 布尔函数判断一个类是另一个类的子类或者子孙类，语法：issubclass(sub,sup)
* isinstance(obj, Class) 布尔函数如果obj是Class类的实例对象或者是一个Class子类的实例对象则返回true。

#### 方法重写

如果父类方法的功能不能满足需求，可以在子类重写父类的方法。

基础重载方法：

下表列出了一些通用的功能，你可以在自己的类重写：

序号 | 方法|描述|简单调用
---|---|---|---
 1 | __init__ ( self [,args...] )|构造函数|简单的调用方法: obj = className(args)
 2 | __del__( self )|析构方法, 删除一个对象|简单的调用方法 : del obj
 3 | __repr__( self )|转化为供解释器读取的形式|简单的调用方法 : repr(obj)
 4 | __str__( self )|用于将值转化为适于人阅读的形式|简单的调用方法 : str(obj)
 5 | __cmp__ ( self, x )| 对象比较 | 简单的调用方法 : cmp(obj, x)

#### 运算符重载
Python同样支持运算符重载，实例如下：
```markdown
#!/usr/bin/python
 
class Vector:
   def __init__(self, a, b):
      self.a = a
      self.b = b
 
   def __str__(self):
      return 'Vector (%d, %d)' % (self.a, self.b)
   
   def __add__(self,other):
      return Vector(self.a + other.a, self.b + other.b)
 
v1 = Vector(2,10)
v2 = Vector(5,-2)
print v1 + v2
```

#### 类属性与方法

##### 类的私有属性

__private_attrs：两个下划线开头，声明该属性为私有，不能在类的外部被使用或直接访问。在类内部的方法中使用时 self.__private_attrs。

##### 类的方法

在类的内部，使用 def 关键字可以为类定义一个方法，与一般函数定义不同，类方法必须包含参数 self,且为第一个参数

##### 类的私有方法

__private_method：两个下划线开头，声明该方法为私有方法，不能在类地外部调用。在类的内部调用 self.__private_methods
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
class JustCounter:
    __secretCount = 0  # 私有变量
    publicCount = 0    # 公开变量
 
    def count(self):
        self.__secretCount += 1
        self.publicCount += 1
        print self.__secretCount
 
counter = JustCounter()
counter.count()
counter.count()
print counter.publicCount
print counter.__secretCount  # 报错，实例不能访问私有变量
```
Python不允许实例化的类访问私有数据，但可以使用 object._className__attrName 访问属性


### 单下划线、双下划线、头尾双下划线说明

* __foo__: 定义的是特列方法，类似 __init__() 之类的。
* _foo: 以单下划线开头的表示的是 protected 类型的变量，即保护类型只能允许其本身与子类进行访问，不能用于 from module import *
* __foo: 双下划线的表示的是私有类型(private)的变量, 只能是允许这个类本身进行访问了。


