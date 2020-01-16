+++
title = "Python 面向对象"
date = "2017-09-26"
lastmod = "2017-09-26"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 Python 中的面向对象，数据库和网络编程。

<!--more-->

### 面向对象技术

* 类(Class): 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
* 类变量：类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
* 数据成员：类变量或者实例变量用于处理类及其实例对象的相关的数据。
* 方法重写：如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
* 实例变量：定义在方法中的变量，只作用于当前实例的类。
* 继承：即一个派生类继承基类的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。
* 实例化：创建一个类的实例，类的具体对象。
* 方法：类中定义的函数。
* 对象：通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。

#### 创建类
使用class语句来创建一个新类，class之后为类的名称并以冒号结尾，如下实例:
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
```
"创建 Employee 类的第一个对象"
emp1 = Employee("Zara", 2000)
"创建 Employee 类的第二个对象"
emp2 = Employee("Manni", 5000)
```

#### 访问属性
可以使用点(.)来访问对象的属性。使用如下类的名称访问类变量
```
emp1.displayEmployee()
emp2.displayEmployee()
print "Total Employee %d" % Employee.empCount
```

可以添加，删除，修改类的属性，如下所示：
```
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
```
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

#### 单下划线、双下划线、头尾双下划线说明
* __foo__: 定义的是特列方法，类似 __init__() 之类的。
* _foo: 以单下划线开头的表示的是 protected 类型的变量，即保护类型只能允许其本身与子类进行访问，不能用于 from module import *
* __foo: 双下划线的表示的是私有类型(private)的变量, 只能是允许这个类本身进行访问了。

### 正则表达式

正则表达式是一个特殊的字符序列，它能方便地检查一个字符串是否与某种模式匹配。

re 模块使 Python 语言拥有全部的正则表达式功能。

compile 函数根据一个模式字符串和可选的标志参数生成一个正则表达式对象。该对象拥有一系列方法用于正则表达式匹配和替换。

re 模块也提供了与这些方法功能完全一致的函数，这些函数使用一个模式字符串做为它们的第一个参数。

#### 正则表达式修饰符 - 可选标志
正则表达式可以包含一些可选标志修饰符来控制匹配的模式。修饰符被指定为一个可选的标志。多个标志可以通过按位 OR(|) 它们来指定。如 re.I | re.M 被设置成 I 和 M 标志：

修饰符 | 描述
---|---
re.I | 使匹配对大小写不敏感
re.L | 做本地化识别（locale-aware）匹配
re.M | 多行匹配，影响 ^ 和 $
re.S | 使 . 匹配包括换行在内的所有字符
re.U | 根据Unicode字符集解析字符。这个标志影响 \w, \W, \b, \B.
re.X | 该标志通过给予更灵活的格式以便将正则表达式写得更易于理解。

#### 正则表达式模式

模式字符串使用特殊的语法来表示一个正则表达式

1、字母和数字表示他们自身。一个正则表达式模式中的字母和数字匹配同样的字符串。

2、多数字母和数字前加一个反斜杠时会拥有不同的含义。

3、标点符号只有被转义时才匹配自身，否则它们表示特殊的含义。

4、反斜杠本身需要使用反斜杠转义。

5、由于正则表达式通常都包含反斜杠，所以你最好使用原始字符串来表示它们。模式元素(如 r'\t'，等价于 '\\t')匹配相应的特殊字符。

正则表达式模式语法中的特殊元素：

模式 | 描述
---|---
^ | 匹配字符串的开头
$ | 匹配字符串的末尾
. | 匹配任意字符，除了换行符，当re.DOTALL标记被指定时，则可以匹配包括换行符的任意字符
[...]|用来表示一组字符,单独列出：[amk] 匹配 'a'，'m'或'k'
[^...]|不在[]中的字符：[^abc] 匹配除了a,b,c之外的字符
\w|匹配字母数字及下划线
\W|匹配非字母数字及下划线
\s|匹配任意空白字符，等价于 [\t\n\r\f]
\S|匹配任意非空字符
\d|匹配任意数字，等价于 [0-9]
\D|匹配任意非数字
\A|匹配字符串开始
\Z|匹配字符串结束，如果是存在换行，只匹配到换行前的结束字符串
\z|匹配字符串结束
\G|匹配最后匹配完成的位置
re* | 匹配0个或多个的表达式
re+ | 匹配1个或多个的表达式
re? | 匹配0个或1个由前面的正则表达式定义的片段，非贪婪方式
re {n,}|精确匹配n个前面表达式。
re {n,m}|匹配 n 到 m 次由前面的正则表达式定义的片段，贪婪方式
a|b | 匹配a或b
(re)|G匹配括号内的表达式，也表示一个组
(?imx)|正则表达式包含三种可选标志：i, m, 或 x 。只影响括号中的区域。
(?-imx)|正则表达式关闭 i, m, 或 x 可选标志。只影响括号中的区域。
(?:re)|类似 (...), 但是不表示一个组
(?imx:re)|在括号中使用i, m, 或 x 可选标志
(?-imx:re)|在括号中不使用i, m, 或 x 可选标志
(?#...)|注释

### 操作数据库

DB-API 是一个规范. 它定义了一系列必须的对象和数据库存取方式, 以便为各种各样的底层数据库系统和多种多样的数据库接口程序提供一致的访问接口 。

Python的DB-API，为大多数的数据库实现了接口，使用它连接各数据库后，就可以用相同的方式操作各数据库。

Python DB-API使用流程：

* 引入 API 模块
* 获取与数据库的连接
* 执行SQL语句和存储过程
* 关闭数据库连接

#### MySQLdb
MySQLdb 是用于Python连接Mysql数据库的接口，它实现了 Python 数据库 API 规范 V2.0，基于 MySQL C API 上建立的。

##### 连接MySQL数据库
```markdown
#!/usr/bin/python
# -*- conding: utf-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost", "root", "root456", "xdhuxc")

# 使用cursor()方法获取操作游标
cursor = db.cursor()

# 使用execute方法执行SQL语句
cursor.execute("select version()")

# 使用fetchone()方法获取一条数据库记录
data = cursor.fetchone()

print "Database version: %s" % data

# 关闭数据库连接
db.close()
```
##### 创建数据库表
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost","root","root456","xdhuxc" )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# 如果数据表已经存在使用 execute() 方法删除表。
cursor.execute("drop table if exists employee")

# 创建数据表SQL语句
sql = """create table employee (
         first_name char(20) not null,
         last_name  char(20),
         age int,  
         sex char(1),
         income float 
         )
      """
# 执行SQL语句
cursor.execute(sql)

# 关闭数据库连接
db.close()
```
##### 数据库插入操作
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost","root","root456","xdhuxc" )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# SQL 插入语句
sql = """
         insert into employee(first_name,
         last_name, age, sex, income)
         values ('Mac', 'Mohan', 20, 'M', 2000)
      """
#sql = """
#         insert into employee(first_name, \
#         last_name, age, sex, income) \
#         values ('%s', '%s', '%d', '%c', '%d' )" % \
#         ('Mac', 'Mohan', 20, 'M', 2000)      
#      """
      
try:
   # 执行sql语句
   cursor.execute(sql)
   # 提交到数据库执行
   db.commit()
except:
   # 如果有错误，则回滚
   db.rollback()

# 关闭数据库连接
db.close()
```

使用变量向SQL语句中传递参数：
```markdown
user_name = "root"
password = "root456"

cursor.execute('insert into login values ("%s", "%s")' % (user_name, password))
```
##### 数据库查询操作
Python查询Mysql使用 fetchone() 方法获取单条数据, 使用fetchall() 方法获取多条数据。

* fetchone(): 该方法获取下一个查询结果集，结果集是一个对象。
* fetchall():接收全部的返回结果行。
* rowcount: 这是一个只读属性，并返回执行execute()方法后影响的行数。

查询employee表中salary（工资）字段大于1000的所有数据：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost","root","root456","xdhuxc" )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# SQL 查询语句
sql = "select * from employee where income > '%d'" % (1000)
try:
   # 执行SQL语句
   cursor.execute(sql)
   # 获取所有记录列表
   results = cursor.fetchall()
   for row in results:
      first_name = row[0]
      last_name = row[1]
      age = row[2]
      sex = row[3]
      income = row[4]
      # 打印结果
      print "first_name=%s,last_name=%s,age=%d,sex=%s,income=%d" % \
             (first_name, last_name, age, sex, income )
except:
   print "Error: unable to fecth data"

# 关闭数据库连接
db.close()
```
##### 数据库更新操作

更新操作用于更新数据表的的数据

将 EMPLOYEE 表中的 SEX 字段为 'M' 的 AGE 字段递增 1：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost", "root", "root456", "xdhuxc" )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# SQL 更新语句
sql = "update employee set age = age + 1 where sex = '%c'" % ('M')
try:
   # 执行SQL语句
   cursor.execute(sql)
   # 提交到数据库执行
   db.commit()
except:
   # 发生错误时回滚
   db.rollback()

# 关闭数据库连接
db.close()
```
##### 删除操作

删除操作用于删除数据表中的数据

删除数据表 employee 中 age 大于 20 的所有数据：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("localhost", "root", "root456", "xdhuxc")

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# SQL 删除语句
sql = "delete from employee where age > '%d'" % (20)
try:
   # 执行SQL语句
   cursor.execute(sql)
   # 提交修改
   db.commit()
except:
   # 发生错误时回滚
   db.rollback()

# 关闭连接
db.close()
```
##### 执行事务

事务机制可以确保数据一致性。

事务应该具有4个属性：原子性、一致性、隔离性、持久性。这四个属性通常称为ACID特性。

* 原子性（atomicity）。一个事务是一个不可分割的工作单位，事务中包括的诸操作要么都做，要么都不做。
* 一致性（consistency）。事务必须是使数据库从一个一致性状态变到另一个一致性状态。一致性与原子性是密切相关的。
* 隔离性（isolation）。一个事务的执行不能被其他事务干扰。即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
* 持久性（durability）。持续性也称永久性（permanence），指一个事务一旦提交，它对数据库中数据的改变就应该是永久性的。接下来的其他操作或故障不应该对其有任何影响。

对于支持事务的数据库， 在Python数据库编程中，当游标建立之时，就自动开始了一个隐形的数据库事务。
commit()方法提交当前游标的所有更新操作，rollback()方法回滚当前游标的所有操作。每一个方法都开始了一个新的事务。

##### 错误处理

DB API中定义了一些数据库操作的错误及异常

下表列出了这些错误和异常：

异常 | 描述
---|---
Warning | 当有严重警告时触发，例如插入数据是被截断等等。必须是 StandardError 的子类
Error | 警告以外所有其他错误类。必须是 StandardError 的子类
InterfaceError|当有数据库接口模块本身的错误（而不是数据库的错误）发生时触发。 必须是Error的子类
DatabaseError|和数据库有关的错误发生时触发。 必须是Error的子类
DataError | 当有数据处理时的错误发生时触发，例如：除零错误，数据超范围等等。 必须是DatabaseError的子类
OperationalError | 指非用户控制的，而是操作数据库时发生的错误。例如：连接意外断开、 数据库名未找到、事务处理失败、内存分配错误等等操作数据库是发生的错误。 必须是DatabaseError的子类
IntegrityError| 完整性相关的错误，例如外键检查失败等。必须是DatabaseError子类
InternalError | 数据库的内部错误，例如游标（cursor）失效了、事务同步失败等等。 必须是DatabaseError子类
ProgrammingError|程序错误，例如数据表（table）没找到或已存在、SQL语句语法错误、 参数数量错误等等。必须是DatabaseError的子类
NotSupportedError | 不支持错误，指使用了数据库不支持的函数或API等。例如在连接对象上 使用.rollback()函数，然而数据库并不支持事务或者事务已关闭。 必须是DatabaseError的子类

### 网络编程
Python 提供了两个级别访问的网络服务：
* 低级别的网络服务支持基本的 Socket，提供了标准的 BSD Sockets API，可以访问底层操作系统Socket接口的全部方法。
* 高级别的网络服务模块 SocketServer， 它提供了服务器中心类，可以简化网络服务器的开发。

#### Socket
Socket，又称“套接字”，应用程序通常通过“套接字”向网络发出请求或者应答网络请求，使主机间或者一台计算机上的进程间可以通讯。

#### socket()函数
Python 中，我们用 socket（）函数来创建套接字，语法格式如下：
```markdown
socket.socket([family[, type[, proto]]])
```
参数：

* family: 套接字家族可以使AF_UNIX或者AF_INET
* type: 套接字类型可以根据是面向连接的还是非连接分为SOCK_STREAM或SOCK_DGRAM
* protocol: 一般不填默认为0.

#### Socket 对象(内建)方法
（1）服务端套接字

函数 | 描述
---|---
s.bind() | 绑定地址（host,port）到套接字， 在AF_INET下,以元组（host,port）的形式表示地址。
s.listen() | 开始TCP监听。backlog指定在拒绝连接之前，操作系统可以挂起的最大连接数量。该值至少为1，大部分应用程序设为5就可以了。
s.accept() | 被动接受TCP客户端连接,(阻塞式)等待连接的到来

（2）客户端套接字

函数 | 描述
---|---
s.connect() | 主动初始化TCP服务器连接。一般address的格式为元组（hostname,port），如果连接出错，返回socket.error错误。
s.connect_ex() | connect()函数的扩展版本,出错时返回出错码,而不是抛出异常

（3）公共用途的套接字函数

函数 | 描述
---|---
s.recv() | 接收TCP数据，数据以字符串形式返回，bufsize指定要接收的最大数据量。flag提供有关消息的其他信息，通常可以忽略
s.send() | 发送TCP数据，将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小
s.sendall() | 完整发送TCP数据，完整发送TCP数据。将string中的数据发送到连接的套接字，但在返回之前会尝试发送所有数据。成功返回None，失败则抛出异常
s.recvfrom()|接收UDP数据，与recv()类似，但返回值是（data,address）。其中data是包含接收数据的字符串，address是发送数据的套接字地址
s.sendto()|发送UDP数据，将数据发送到套接字，address是形式为（ipaddr，port）的元组，指定远程地址。返回值是发送的字节数
s.close()|关闭套接字
s.getpeername()|返回连接套接字的远程地址。返回值通常是元组（ipaddr,port）
s.getsockname()|返回套接字自己的地址。通常是一个元组(ipaddr,port)
s.setsockopt(level,optname,value)|设置给定套接字选项的值
s.getsockopt(level,optname[.buflen])|返回套接字选项的值
s.settimeout(timeout)|设置套接字操作的超时期，timeout是一个浮点数，单位是秒。值为None表示没有超时期。一般，超时期应该在刚创建套接字时设置，因为它们可能用于连接的操作（如connect()）
s.gettimeout()|返回当前超时期的值，单位是秒，如果没有设置超时期，则返回None
s.fileno()|返回套接字的文件描述符
s.setblocking(flag)|如果flag为0，则将套接字设为非阻塞模式，否则将套接字设为阻塞模式（默认值）。非阻塞模式下，如果调用recv()没有发现任何数据，或send()调用无法立即发送数据，那么将引起socket.error异常
s.makefile()|创建一个与该套接字相关连的文件

#### 示例

##### 服务器端

1、使用 socket 模块的 socket 函数来创建一个 socket 对象。socket 对象可以通过调用其他函数来设置一个 socket 服务。

2、可以通过调用 bind(hostname, port) 函数来指定服务的 port(端口)。

3、调用 socket 对象的 accept 方法。该方法等待客户端的连接，并返回 connection 对象，表示已连接到客户端。

代码如下：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 文件名：server.py

import socket               # 导入 socket 模块

s = socket.socket()         # 创建 socket 对象
host = socket.gethostname() # 获取本地主机名
port = 12345                # 设置端口
s.bind((host, port))        # 绑定端口

s.listen(5)                 # 等待客户端连接
while True:
    c, addr = s.accept()     # 建立客户端连接。
    print '连接地址：', addr
    c.send('欢迎访问菜鸟教程！')
    c.close()                # 关闭连接
```
##### 客户端
一个简单的客户端实例连接到以上创建的服务。端口号为 12345。

socket.connect(hosname, port ) 方法打开一个 TCP 连接到主机为 hostname 端口为 port 的服务商。连接后我们就可以从服务端后期数据，记住，操作完成后需要关闭连接。

代码如下：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 文件名：client.py

import socket               # 导入 socket 模块

s = socket.socket()         # 创建 socket 对象
host = socket.gethostname() # 获取本地主机名
port = 12345                # 设置端口好

s.connect((host, port))
print s.recv(1024)
s.close()  
```
##### 运行该程序
1、打开两个终端，第一个终端执行 server.py 文件：
```
$ python server.py
```
2、第二个终端执行 client.py 文件：
```
$ python client.py
It is python language
```
3、再打开第一个终端，就会看到有以下信息输出：
```
连接地址： ('192.168.0.118', 62461)
```
#### Internet 模块
Python网络编程的一些重要模块

协议 | 功能|端口号|Python模块
---|---|---|---
HTTP  | 网页访问|80|httplib, urllib, xmlrpclib
NNTP  | 阅读和张贴新闻文章，俗称为"帖子"|119|nntplib
FTP	  | 文件传输|20 |	ftplib, urllib
SMTP  |发送邮件	|25	|   smtplib
POP3  |	接收邮件|110|	poplib
IMAP4 |	获取邮件|143|	imaplib
Telnet|	命令行	|23	|   telnetlib
Gopher|	信息查找|70	|   gopherlib, urllib
