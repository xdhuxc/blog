+++
title = "Python 数据库操作"
date = "2017-09-26"
lastmod = "2017-09-26"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客介绍了 Python 中的数据库操作。

<!--more-->

DB-API 是一个规范，它定义了一系列必须的对象和数据库存取方式, 以便为各种各样的底层数据库系统和多种多样的数据库接口程序提供一致的访问接口 。

Python 的 DB-API，为大多数的数据库实现了接口，使用它连接各数据库后，就可以用相同的方式操作各数据库。

Python DB-API使用流程：

* 引入 API 模块
* 获取与数据库的连接
* 执行SQL语句和存储过程
* 关闭数据库连接


### MySQLdb
MySQLdb 是用于Python连接Mysql数据库的接口，它实现了 Python 数据库 API 规范 V2.0，基于 MySQL C API 上建立的。


#### 连接 MySQL 数据库

以下代码演示了连接 MySQL 数据库的方法：
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


#### 创建数据库表

以下代码演示了创建数据库表的方法：
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

使用变量向 SQL 语句中传递参数：
```markdown
user_name = "root"
password = "root456"

cursor.execute('insert into login values ("%s", "%s")' % (user_name, password))
```


#### 数据库查询操作

Python 查询 MySQL 使用 `fetchone()` 方法获取单条数据, 使用 `fetchall()` 方法获取多条数据。

* fetchone(): 该方法获取下一个查询结果集，结果集是一个对象。
* fetchall():接收全部的返回结果行。
* rowcount: 这是一个只读属性，并返回执行execute()方法后影响的行数。

查询 employee 表中 salary 字段大于 1000 的所有数据：
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


#### 数据库更新操作

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


#### 删除操作

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


#### 执行事务

事务机制可以确保数据一致性。

事务应该具有4个属性：原子性、一致性、隔离性、持久性。这四个属性通常称为ACID特性。

* 原子性（atomicity）。一个事务是一个不可分割的工作单位，事务中包括的诸操作要么都做，要么都不做。
* 一致性（consistency）。事务必须是使数据库从一个一致性状态变到另一个一致性状态。一致性与原子性是密切相关的。
* 隔离性（isolation）。一个事务的执行不能被其他事务干扰。即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
* 持久性（durability）。持续性也称永久性（permanence），指一个事务一旦提交，它对数据库中数据的改变就应该是永久性的。接下来的其他操作或故障不应该对其有任何影响。

对于支持事务的数据库， 在Python数据库编程中，当游标建立之时，就自动开始了一个隐形的数据库事务。
commit() 方法提交当前游标的所有更新操作，rollback() 方法回滚当前游标的所有操作。每一个方法都开始了一个新的事务。

#### 错误处理

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

