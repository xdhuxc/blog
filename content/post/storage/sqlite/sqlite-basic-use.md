+++
title = "sqlite 基本使用"
date = "2019-08-16"
tags = [
    "SQL",
    "sqlite",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了 sqlite 的基本使用方法，以备后需。

<!--more-->

### sqlite 安装
Mac 和 Linux 已经默认安装，使用命令 `which sqlite3` 即可查到安装目录，一般为：
```markdown
/usr/bin/sqlite3
```

### 基本命令
1、创建数据库
```markdown
sqlite3 share.db
```
2、查看数据库
```markdown
wanghuans-MacBook-Pro:~ wanghuan$ sqlite3 /Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/share/sql/share.db # 打开数据库 share.db
SQLite version 3.24.0 2018-06-04 14:10:15
Enter ".help" for usage hints.
sqlite> .databases
main: /Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/share/sql/share.db
sqlite>
```
3、创建数据库表
```markdown
sqlite> .tables
sqlite> CREATE TABLE `xdhuxc` (
   ...>     `id` INT PRIMARY KEY NOT NULL,
   ...>     `name` VARCHAR(50) NOT NULL,
   ...>     `code` CHAR(6) NOT NULL,
   ...>     `level` CHAR(5) NOT NULL,
   ...>     `buy_price` REAL NOT NULL,
   ...>     `sell_price` REAL NOT NULL
   ...> );
sqlite> .tables
share
```
4、退出 sqlite
```markdown
sqlite> .exit
wanghuans-MBP:~ wanghuan$
```

### 可视化
可以使用 DBeaver，TablePlus 等可视化工具操作之。

### 参考资料
https://www.runoob.com/sqlite/sqlite-create-table.html
