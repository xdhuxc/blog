+++
title = "MySQL 常用操作"
date = "2018-08-09"
lastmod = "2019-03-19"
tags = [
    "MySQL",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了一些使用 MySQL 时经常会用到的操作，留作后查。

<!--more-->

### 赋权操作
1、创建只读账户
```markdown
mysql> grant select on *.* to 'xdhuxc'@'%' identified by 'Xdhuxc163';  # 创建只读账户xdhuxc，密码为：Xdhuxc63
mysql> flush privileges;
```
查看其权限
```markdown
mysql> show grants for 'xdhuxc'@'%';
```

2、授予权限
```markdown
grant select, insert, update, delete on 'user.*' to 'xdhuxc'@'%'
```

### 忘记密码修改密码

#### Linux 系统
1、停止数据库服务。
```markdown
systemctl stop mysqld
```

2、向 /etc/my.cnf 中添加如下内容
```markdown
[mysqld]
skip-grant-tables
```

3、重启 mysql 服务
```markdown
systemctl restart mysqld
```

4、修改密码
```markdown
mysql> use mysql;
mysql> update user set authentication_string=password('Xdhuxc163') where user='root';
mysql> flush privileges;
mysql> quit
```
5、注释掉 skip-grant-tables，重启 mysqld 服务。

#### Windows 系统
1、关闭MySQL服务
```markdown
net stop mysql57
```

2、进入 MySQL 的 bin 目录下，执行如下命令：
```markdown
mysqld --default-file="E:\Work\MySQL\MySQL Server 5.7 Data\my.ini" --console --skip-grant-tables
```
说明：

* --default-file：启动 MySQL 服务时的配置文件；
* --skip-grant-tables：启动 MySQL 服务的时候跳过权限表认证；

3、新打开DOS窗口，进入MySQL的bin目录下，执行如下命令：
```markdown
mysql -uroot -p # 回车后，让输入密码，直接回车
```

4、更改root用户密码
```markdown
# MySQL 5.7以前
update mysql.user
set password=password('123456')
 where user='root';
# MySQL 5.7
update mysql.user
set authentication_string=password('123456')
 where user='root';
```

5、更新权限
```markdown
flush privileges;
```

6、退出当前MySQL回话并启动MySQL服务
```markdown
net start mysql57
```

### 修改默认时区

#### 方法一
1、查看 mysql 系统时间
```markdown
mysql> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | UTC    |
| time_zone        | +08:00 |
+------------------+--------+
2 rows in set

mysql> select now();
+---------------------+
| now()               |
+---------------------+
| 2018-07-09 13:59:16 |
+---------------------+
1 row in set
```
mysql 的系统时区已经是东八区，系统时间也是当前时间了，

2、设置时区为东八区
```markdown
set global time_zone = '+8:00';
```

3、刷新权限
```markdown
flush privileges;
```
#### 方法二
或者直接在 my.cnf 文件中添加如下内容：
```markdown
[mysqld]
default-time_zone = '+8:00'
```
然后重启 mysql 服务

