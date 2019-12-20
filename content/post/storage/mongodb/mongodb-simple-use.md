+++
title = "MongoDB 数据库初步使用"
linktitle = "MongoDB 数据库初步使用"
date = "2018-07-20"
lastmod = "2019-05-16"
description = ""
tags = [
    "数据库",
    "MongoDB"
]
categories = [
    "技术"
]
+++

安装好 MongoDB 数据库后，接下来我们演示下通过命令行来操纵 MongoDB 数据库。

### 配置文件参数修改
MongoDB 数据库的配置文件为：`/etc/mongod.conf`。
为了使外部应用能够连接本机（使用 VMware Workstation 创建的虚拟机）安装的 MongoDB 数据库，需要修改 `/etc/mongod.conf` 文件中的 `127.0.0.1` 为本机IP地址。比如，修改`127.0.0.1` 为本虚拟机IP地址 `192.168.91.128`，连接端口保持默认的 `27017` 即可，如下所示：
```
# network interfaces
net:
  port: 27017
  bindIp: 192.168.91.128  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.
```

### 使用 MongoDB shell 操作数据库
##### 连接 MongoDB 数据库
使用的命令为：
```
mongo --host 192.168.91.128 --port 27017
或者
mongo --host 192.168.91.128 # 由于使用 mongodb的默认端口，可以省略对端口的指定。
```
如下所示：
```
[root@xdhuxc ~]# mongo --host 192.168.91.128 -p 27017
MongoDB shell version v3.7.9-27-g793e59f
connecting to: mongodb://192.168.91.128:27017/
MongoDB server version: 3.7.9-27-g793e59f
Server has startup warnings:
2018-05-30T21:51:01.053+0800 I CONTROL  [initandlisten]
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten] ** NOTE: This is a development version (3.7.9-27-g793e59f) of MongoDB.
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten] **       Not recommended for production.
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten]
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten] ** WARNING: Access control is not enabled for the database.
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten] **          Read and write access to data and configuration is unrestricted.
2018-05-30T21:51:01.069+0800 I CONTROL  [initandlisten]
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten]
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten]
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2018-05-30T21:51:01.092+0800 I CONTROL  [initandlisten]
>
```
##### 创建数据库
使用如下命令创建数据库：
```
use database_name
```
具体操作如下所示：
```
> show dbs       # 显示数据库列表。
admin   0.000GB
config  0.000GB
local   0.000GB
> use xdhuxc     # 创建数据库并切换至该数据库。
switched to db xdhuxc
> show dbs       # 再次显示数据库列表，却发现创建的数据库 xdhuxc 不在列表中。要显示新建的数据库，需要至少插入一个文档，空的数据库是不显示出来的。
admin   0.000GB
config  0.000GB
local   0.000GB
> db             # 显示当前数据库。
xdhuxc
```
在 MongoDB 中，默认的数据库是 `test`，如果没有创建任何数据库，那么创建的集合和文档将存储在 `test` 数据库中。
##### 创建集合
在创建的 `xdhuxc` 数据库中创建 `person` 集合，如下所示：
```
> use xdhuxc
switched to db xdhuxc
> db                            # 显示当前数据库。
xdhuxc
> db.createCollection("person") # 在数据库 xdhuxc 中创建集合 person。
{ "ok" : 1 }
> show collections              # 显示当前数据库中的集合。
person
>
```
##### 插入数据
要将数据插入到 MongoDB 集合中，可以使用 MongoDB 的 `insert()` 方法，其基本语法如下：
```
db.collection_name.insert(document)
```
向 `xdhuxc` 数据库的 `person` 集合中插入数据，如下所示：
```
> db.person.insert({              # 插入一条记录，文档以json的格式定义。
     name : "xiaoming",
     age : "24",
     company : "xdhuxc company"
})
WriteResult({ "nInserted" : 1 })
```
`person` 为集合的名称，如果集合中不存在 `person` 集合，那么 MongoDB 将创建该集合，然后将文档插入该集合中。
在插入的文档中，如果不指定_id参数，那么MongoDB会为此文档分配一个唯一的ObjectId。_id为集合中每个文档唯一的12个字节的十六进制数，12个字节划分如下：
```
_id: ObjectId(4 bytes timestamp, 3 bytes machine id, 2 bytes process id,
   3 bytes incrementer)
```

查询所有文档，将以非结构化方式显示所有文档。
```
> db.person.find()
{ "_id" : ObjectId("5b0f384f244fc0152ed71f5f"), "name" : "xiaoming", "age" : "24", "company" : "xdhuxc company" }
```
再插入一条数据
```
> db.person.insert({
     name : "dalong",
     age : "29",
     company : "Apple company"
})
WriteResult({ "nInserted" : 1 })
> db.person.find()
{ "_id" : ObjectId("5b0f384f244fc0152ed71f5f"), "name" : "xiaoming", "age" : "24", "company" : "xdhuxc company" }
{ "_id" : ObjectId("5b0f3aa0244fc0152ed71f60"), "name" : "dalong", "age" : "29", "company" : "Apple company" }
```
接下来，插入一条结构不相同的数据
```
> db.person.insert({
     name : "dalong",
     age : "29",
     company : "Apple company",
     address : "Beijing"
})
WriteResult({ "nInserted" : 1 })
> db.person.find()
{ "_id" : ObjectId("5b0f384f244fc0152ed71f5f"), "name" : "xiaoming", "age" : "24", "company" : "xdhuxc company" }
{ "_id" : ObjectId("5b0f3aa0244fc0152ed71f60"), "name" : "dalong", "age" : "29", "company" : "Apple company" }
{ "_id" : ObjectId("5b0f3aeb244fc0152ed71f61"), "name" : "dalong", "age" : "29", "company" : "Apple company", "address" : "Beijing" }
```
可以看出，在 MongoDB 中，是以文档的形式来组织非结构化数据的，文档的结构可由使用者自己定义，和 关系型数据库有很大的区别。
##### 删除文档
使用如下命令删除文档：
```
> db.person.remove({})            # 删除集合 person 中的所有文档
WriteResult({ "nRemoved" : 3 })
> db.person.find()                # 再次查询所有文档，已经在上一步全部删除了，所以没有结果返回。
>
```
##### 删除数据库
① 切换到待删除数据库
```
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
xdhuxc  0.000GB
> use xdhuxc
switched to db xdhuxc
> db
xdhuxc
```
② 删除当前数据库
```
> db.dropDatabase()
{ "dropped" : "xdhuxc", "ok" : 1 }
```
③ 查看删除结果
```
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
```
可以看到，数据库 xdhuxc 已经被删除。

### 官方文档
MongoDB 的官方文档网址：http://www.mongoing.com/docs/mongo.html

更多详细的有关 MongoDB的知识，大家可以去 MongoDB 的官方网站学习。
