+++
title = "MySQL 常用命令"
date = "2018-07-29"
lastmod = "2019-07-29"
description = ""
tags = [
    "MySQL",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了一些 MySQL 常用命令，方便查找。

<!--more-->

### 数据库管理命令
1、显示当前 MySQL 的连接数
```markdown
show processlist
或
show full processlist
```

2、显示 MySQL 的环境变量
```markdown
show variables
```

3、查找最大连接数或服务器响应的最大连接数
```markdown
show variables like "%conn%"
或
show global status like 'Max_used_connections' # 查询服务器响应的最大连接数
```

4、临时设置最大连接数
```markdown
set global max_connections=200  # 在 mysql 终端中临时设置最大连接数为：200
```
或者在 /etc/my.cnf 中添加如下内容：
```markdown
[mysqld]
max_connections=200
```

5、查询缓存的参数说明
```markdown
show global variables like "query_cache%"
```

6、查询 MySQL 运行产生的状态值
```markdown
show global status like 'qcache%'
```

7、采用直接重置 autoIncrement 值的方法重置 auto_increment
```markdown
alter table marathon auto_increment = 1
```

8、查询数据库权限
```markdown
show grants for 'root'@'localhost'
```

### 字段操作
1、修改字段类型
```markdown
ALTER TABLE `users` MODIFY COLUMN name varchar(30)
```

2、修改字段类型
```markdown
ALTER TABLE `users` CHANGE COLUME name SET DEFAULT NULL
```

3、修改字段的数据
```markdown
UPDATE `users` SET name='wangxin', age=24 WHERE user_id=13
```

4、增加新字段
```markdown
ALTER TABLE `users` ADD `country` varchar(20) NOT NULL
```

### 键操作
1、查询某张表中存在的键
```markdown
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE t WHERE t.TABLE_NAME ='users'
```

2、添加唯一键
```markdown
ALTER TABLE `users` ADD UNIQUE KEY `name` (`name`)
```

3、删除唯一键
```markdown
ALTER TABLE `users` DROP INDEX `name`
ALTER TABLE `users` ADD UNIQUE INDEX iam_cloud_uk (`name`, `display_name`) # 注意，主键名中不能包含中划线
```

4、添加主键
```markdown
ALTER TABLE `users` ADD PRIMARY KEY `id` (`id`)
```

5、删除主键
```markdown
ALTER TABLE `users` DROP PRIMARY KEY
```

### 数据导出命令
1、导出数据库中的数据表结构及数据
```markdown
mysqldump -uroot -pAdmin369 xdhuxc > /tmp/xdhuxc.sql
或
mysqldump -uroot -p xdhuxc > /tmp/xdhuxc.sql，敲回车后，会提示输入密码
或
mysqldump -uroot xdhuxc > /tmp/xdhuxc.sql，敲回车后，会提示输入密码
```
2、导出数据库表结构

> -d，--no-data，不导出表数据，只导出表结构。

```markdown
mysqldump -uroot -pAdmin369 -d xdhuxc > /tmp/xdhuxc.sql
或
mysqldump -uroot -p -d xdhuxc > /tmp/xdhuxc.sql，敲回车后，会提示输入密码
或
mysqldump -uroot -d xdhuxc > /tmp/xdhuxc.sql
```

3、导出数据库表数据

> -t，--no-create-info，不包含创建表的信息，只导出表数据

```markdown
mysqldump -uroot -pAdmin369 -t xdhuxc > /tmp/xdhuxc.sql
或
mysqldump -uroot -p -t xdhuxc > /tmp/xdhuxc.sql，敲回车后，会提示输入密码
或
mysqldump -uroot -t xdhuxc > /tmp/xdhuxc.sql
```

4、导出指定表的数据或信息

> 参考上面的命令，在数据库名称后面加上表名称即可。

```markdown
mysqldump -uroot -pAdmin369  -t xdhuxc users > /tmp/xdhuxc_users.sql
```

