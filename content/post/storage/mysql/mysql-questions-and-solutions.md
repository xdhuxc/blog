+++
title = "MySQL 常见问题及解决"
date = "2018-08-01"
lastmod = "2019-07-29"
tags = [
    "MySQL",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了一些使用 MySQL 过程中常见的问题及解决方式，留作后查。

<!--more-->

### 常见问题及解决
1、能看到数据库和表，但是select时报不存在
```markdown
mysql> select * from sys_prompt limit 5;
ERROR 1146 (42S02): Table 'xdhuxc.sys_prompt' doesn't exist
```
或
```markdown
mysql> drop database yhtdb;
ERROR 1010 (HY000): Error dropping database (can't rmdir './yhtdb', errno: 39)
```
解决：在`/var/lib/mysql`下，删除该数据库对应的目录，重新导入sql文件。

2、 mysql 服务启动失败
可能原因：
```markdown
1、可能是端口号被占用。
2、可能是 mysql 配置文件修改错误，导致某些配置参数名称错误。
```

3、向数据库表中插入数据时，报错如下：
```markdown
(1265, "Data truncated for column 'income' at row 1")
```
数据库表定义时，定义的字段 income 长度太短，更改该数据类型，增大其长度。

4、在 Mac 上安装的 MySQL 8.0.1，使用 DbVisualizer 连接时，报错如下：
```markdown
Product: DbVisualizer Free 10.0.17 [Build #2882]
OS: Mac OS X
OS Version: 10.14.3
OS Arch: x86_64
Java Version: 1.8.0_191
Java VM: Java HotSpot(TM) 64-Bit Server VM
Java Vendor: Oracle Corporation
Java Home: /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
DbVis Home: /Applications/DbVisualizer.app/Contents/Resources/app
User Home: /Users/wanghuan
PrefsDir: /Users/wanghuan/.dbvis
SessionId: 112
BindDir: null

An error occurred while establishing the connection:

Long Message:
Unable to load authentication plugin 'caching_sha2_password'.
```

解决：使用 root 用户登录进去，执行如下命令：
```markdown
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root@20190322';
```

5、连接 MySQL 时，报错如下：
```markdown
Long Message:
Access denied for user 'root'@'localhost' (using password: YES)
```
解决：可能是 mysql 密码配置错误，重新修改 mysql 密码。
```markdown
use mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'wh19940423';
flush privileges;
```

6、更新数据时，报错如下：
```markdown
Error 1062: Duplicate entry '23viewer12fgdfdsgsd' for key 'name'
```
检查数据库，确实没有重复的名称，删除数据库表，重新创建表结构。

7、使用 GORM 框架时，插入含时间戳类型的结构体字段时，报错如下：
```markdown
Error 1292: Incorrect datetime value: '0000-00-00' for column 'create_time' at row 1
```
原因：时间戳类型字段 CreateTime，UpdateTime 没有赋值，导致类型为 datetime类型，从而报错。

