+++
title = "在 CentOS 7 上安装 MongoDB 数据库"
linktitle = "在 CentOS 7 上安装 MongoDB 数据库"
date = "2018-07-06"
lastmod = "2018-07-06"
description = ""
tags = [
    "CentOS7",
    "Database",
    "MongoDB"
]
categories = [
    "CentOS7",
    "Database",
    "MongoDB"
]
+++

### MongoDB 简介
`MongoDB` 是一个基于分布式文件存储的数据库。由 `C++` 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。

`MongoDB` 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。

### 准备工作
（1）在 `/etc/yum.repos.d` 目录下创建文件 `mongodb-org-4.0.repo`，内容为：
```
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/development/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.8.asc
```
（2）关闭SELinux
```
setenforce 0
```
### 安装MongoDB
执行如下命令安装MongoDB
```
yum install -y mongodb-org-unstable.x86_64
```
MongoDB的配置文件路径为：
```
/etc/mongod.conf
```
在该文件中配置有MongoDB的日志文件路径和数据文件路径
日志文件路径为：
```
/var/log/mongodb
```
数据文件路径为：
```
/var/lib/mongo
```
如果使用其他用户启动 `MongoDB` 进程，需要确保该用户对 `/var/log/mongodb`  和`/var/lib/mongo` 有访问权限。

### MongoDB进程管理命令
1、查看 `MongoDB` 的启动状态
```
systemctl status mongod
```
2、停止 `MongoDB` 进程
```
systemctl stop mongod
```
3、重启 `MongoDB` 进程
```
systemctl restart mongod
```
4、启动 `MongoDB` shell
```
mongo --host 127.0.0.1:27017
```
5、卸载 `MongoDB`

① 停止 `MongoDB` 进程
```
systemctl stop mongod
```
② 删除 `MongoDB` 的安装包
```
yum erase $(rpm -qa | grep mongodb-org)
```
③ 删除 `MongoDB` 数据和日志目录
```
rm -f /var/log/mongodb
rm -f /var/lib/mongo
```
在 `Redhat` 或者 `CentOS` 上安装 `MongoDB` 的官方文档地址：
https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/
