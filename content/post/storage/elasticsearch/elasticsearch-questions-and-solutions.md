+++
title = "ElasticSearch 常见问题及解决"
date = "2019-01-10"
lastmod = "2019-02-22"
description = ""
tags = [
    "ElasticSearch",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了在使用 ElasticSearch 的过程中常见的问题及解决方法。

<!--more-->

1、启动 elasticsearch 容器时，直接映射文件或目录时，报权限错误
```markdown
[2018-11-11T10:36:18,442][INFO ][o.e.n.Node               ] [] initializing ...
[2018-11-11T10:36:18,462][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [] uncaught exception in thread [main]
Caused by: java.nio.file.AccessDeniedException: /usr/share/elasticsearch/data/nodes
        at sun.nio.fs.UnixException.translateToIOException(UnixException.java:84) ~[?:?]
        at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:102) ~[?:?]
        at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:107) ~[?:?]
        at sun.nio.fs.UnixFileSystemProvider.createDirectory(UnixFileSystemProvider.java:384) ~[?:?]
        at java.nio.file.Files.createDirectory(Files.java:674) ~[?:1.8.0_92-internal]
        at java.nio.file.Files.createAndCheckIsDirectory(Files.java:781) ~[?:1.8.0_92-internal]
        at java.nio.file.Files.createDirectories(Files.java:767) ~[?:1.8.0_92-internal]
        at org.elasticsearch.env.NodeEnvironment.<init>(NodeEnvironment.java:220) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.node.Node.<init>(Node.java:240) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.node.Node.<init>(Node.java:220) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.bootstrap.Bootstrap$5.<init>(Bootstrap.java:191) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:191) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:286) ~[elasticsearch-5.0.0.jar:5.0.0]
        at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:112) ~[elasticsearch-5.0.0.jar:5.0.0]
        ... 6 more
```
问题原因说明：https://discuss.elastic.co/t/elastic-elasticsearch-docker-not-assigning-permissions-to-data-directory-on-run/65812/4

解决：先创建一个卷，然后再挂载该目录
```markdown
docker volume create --opt device=/root/es/data --name=xdhuxc
docker run -p 9200:9200 -v xdhuxc:/usr/share/elasticsearch/data docker.elastic.co/elasticsearch/elasticsearch:6.5.0
```
如果仍然出现错误，创建 elasticsearch 用户，给目录赋予权限，然后启动容器
```markdown
groupadd -g 1000 elasticsearch
useradd -u 1000 -g 1000 elasticsearch
chown -R 1000 es
chgrp -r 1000 es
```

2、创建索引时，报错如下：
```markdown
wanghuans-MacBook-Pro:~ wanghuan$ curl -H "Content-Type: application/json" -XPUT http://localhost:9200/xdhuxc_a -T ./a.json
{
    "error":{
        "root_cause":[
            {
                "type":"illegal_argument_exception",
                "reason":"unknown setting [index.as] please check that any required plugins are installed, or check the breaking changes documentation for removed settings"
            }
        ],
        "type":"illegal_argument_exception",
        "reason":"unknown setting [index.as] please check that any required plugins are installed, or check the breaking changes documentation for removed settings",
        "suppressed":[
            {
                "type":"illegal_argument_exception",
                "reason":"unknown setting [index.sdfsdg] please check that any required plugins are installed, or check the breaking changes documentation for removed settings"
            }
        ]
    },
    "status":400
}
```
a.json 的内容如下：
```markdown
{
    "container_id" : "30855c6b7ea297a3e8ed2d62b7bc489d9712cd57e70d90b1d229e5c6932987a6",
    "container_name" : "/is-live.1.yyk840n4mkd4x9fr53wt0tqh0",
    "source" : "stdout",
    "log" : "2019-05-14 19:42:24.028 ERROR 1 --- [io-2062-exec-88] c.k.i.l.c.websocket.BarrageWebSocket     : BarrageWebSocket error",
    "timestamp" : "2019-05-14T19:42:24.028000000+08:00",
    "tag" : "docker.is-live"
}
```
原因：创建索引时丢失了 document type 和 document id，创建索引的格式为：
```markdown
POST index_name/document_type/document_id -T abc.json
```

必须提供 document type 和 document id，文档 ID 在此处是可选的，如果不提供文档 ID，那么 elasticsearch 将会为其创建一个字母数字 ID。
```markdown
wanghuans-MacBook-Pro:~ wanghuan$ curl -H "Content-Type: application/json" -XPUT http://localhost:9200/yztc/xdhuxc/1 -T ./1.json
{
    "_index":"yztc",
    "_type":"xdhuxc",
    "_id":"1",
    "_version":1,
    "result":"created",
    "_shards":{
        "total":2,
        "successful":1,
        "failed":0
    },
    "_seq_no":0,
    "_primary_term":1
}
```

其他几种方法创建一个索引：
```markdown
POST index_name/document_type -T abc.json
PUT index_name/document_type/document_id -T abc.json
```

3、ElasticSearch启动时报错，错误如下：
```markdown
[2017-06-20T09:57:45,307][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [node-1] uncaught exception in thread [main]
org.elasticsearch.bootstrap.StartupException: java.lang.RuntimeException: can not run elasticsearch as root
```
出于安全考虑，ElasticSearch不让使用root用户启动，解决方法：

1）在启动命令中加入参数，在使用命令行启动ElasticSearch时，加入额外的参数启动，如下所示：
```markdown
/bin/elasticsearch -Des.insecure.allow.root=true
```

2）创建新用户，以新用户身份启动之
```markdown
groupadd -g 700 elasticsearch                                                       # 创建elasticsearch用户组
useradd -u 701 -g 700 elasticsearch                                                 # 创建用户elasticsearch
passwd elasticsearch                                                                # 为用户elasticsearch设置密码
gpasswd -a elasticsearch elasticsearch                                              # 将用户elasticsearch添加到用户组elasticsearch中，第一个参数表示用户名，第二个参数表示用户组名
chown -R elasticsearch:elasticsearch /middleware/elasticsearch-2.4.1 # 为用户组elasticsearch和用户elasticsearch赋予权限
```

4、Elasticsearch 启动时报错，错误如下：
```markdown
[2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```
执行如下命令解决：
```markdown
sysctl -w vm.max_map_count=262144
```
或者
```markdown
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl -p
```

5、ElasticSearch 启动后，使用 `curl http://localhost:9200` 访问，控制台有内容输出，但是 `curl http://ip_address:9200` 控制台无内容输出，在浏览器中使用 `http://ip_address:9200` 也无法访问。

修改 `elasticsearch.yml` 文件，修改 `network.host` 的值为：`0.0.0.0`，然后重新启动之，外网即可进行访问.

6、elasticsearch状态为红色，原因为磁盘不足，腾出磁盘空间后，还是红色，执行如下命令：

Elasticsearch 提供了专门的 `reroute API` 用于手工进行 `shard` 的移动、分配以及取消指令
```markdown
POST /_cluster/reroute
{
  "commands": [
    {
      "move": {
        "index": "xdhuxc-basedoc-ta_mysql-a0f921217f6d4a6aa348415411db6f7e",
        "shard": 0,
        "from_node": "singlenode",
        "to_node": "singlenode"
      }
    }
  ]
}
POST /_cluster/reroute
{
  "commands": [
    {
      "allocate": {
        "index": "xdhuxc-basedoc-ta_mysql-a0f921217f6d4a6aa348415411db6f7e",
        "shard": 0,
        "node": "singlenode",
        "allow_primary":true
      }
    }
  ]
}
```

