+++
title = "ElasticSearch REST API 的使用"
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

本篇博客介绍了 ElasticSearch API 的详细使用方法。

<!--more-->

#### REST API 用途

elasticsearch 提供了很多全面的API，大致可以分为如下几种：

* 检查集群、节点、索引的健康状况。
* 管理集群、节点、索引数据、元数据。
* 执行CRUD，创建、读取、更新、删除以及查询索引和索引模板等。
* 执行高级的查询操作、比如分页、排序、脚本和聚合等。

#### 常用命令

1、查看集群健康状态
```markdown
[root@localhost ~]# curl http://172.20.17.4:9200/_cat/health?v
epoch      timestamp cluster               status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent 
1531817234 08:47:14  elasticsearch-cluster yellow          1         1    290 290    0    0      180             0                  -                 61.7% 
```
可以看到集群的名字是：elasticsearch-cluster，集群的状态为：yellow。

elasticsearch 集群的颜色及含义：

* 绿色：最健康的状态，代表所有的分片包括备份都可用。
* 黄色：基本的分片可用，但是备份不可用，也可能是没有备份。
* 红色：部分的分片可用，表明分片有一部分损坏，此时执行查询部分数据仍然可以查到，遇到这种情况，需要尽快解决。

2、查询节点列表
```markdown
[root@localhost ~]# curl http://172.20.17.4:9200/_cat/nodes?v
host        ip          heap.percent ram.percent load node.role master name                 
172.20.17.4 172.20.17.4           17          99 5.06 d         *      elasticsearch-master 
```

3、查询所有索引
```markdown
[root@localhost ~]# curl http://172.20.17.4:9200/_cat/indices?v
health status index                               pri rep docs.count docs.deleted store.size pri.store.size 
yellow open   zipkin-2018-07-14                     5   1        180            0    182.4kb        182.4kb 
yellow open   yycloud-basedoc-mw-servmeta-private   5   1       2553          246     28.9mb         28.9mb 
red    open   zipkin-2018-07-17                     5   1  255069327            0     15.4gb         15.4gb 
```
上面的结果中，zipkin-2018-07-14索引的状态是yellow，这是因为此时虽然有5个主分片和一个备份。但是由于只是单个节点，分片还在运行中，无法动态地修改。因此当有其他的节点加入到集群中时，备份的节点会被复制到另外一个节点中，状态就会变成 green。

4、删除索引
```markdown
[root@localhost ~]# curl -XDELETE http://172.20.17.4:9200/zipkin-2018-07-14       # zipkin-2018-07-14为索引名称
{
    "acknowledged":true
}
```

5、创建索引
```markdown
curl -u esadmin:esadmin -H "Content-Type: application/json" -XPOST http://${DCEE_IP}:9200/xdhuxc_custom -T ./xdhuxc_custom.json 
```

#### 索引模板

1、查询 elasticsearch 索引模板
```markdown
curl -u esadmin:esadmin http://172.20.15.36:9200/_template?pretty # 返回所有索引模板，pretty 参数仅仅是指定Elasticsearch返回JSON格式结果
curl -XGET http://172.20.15.36:9200/_template/my_template #查询索引模板my_template
```
2、创建 elasticsearch 索引模板

创建一个名为my_template的模板,匹配所有my_index开头的索引,匹配成功后会按照settings和mappings创建一个新的索引.
```markdown
curl -XPUT http://172.20.15.36:9200/_template/my_template -d'    
{    
        "template": "my_index*", //匹配所有my_index开头的索引    
        "order":0,//当存在多个索引模板时并且某个索引两者都匹配时,使用order来确定模板合并顺序  
        "settings": {...},    
        "mappings" :{...}    
}'
或
curl -u esadmin:esadmin -XPUT http://172.20.15.36:9200/_template/developer_docker* -T ./developer_docker.json
```

3、删除 elasticsearch 索引模板
```markdown
curl -XDELETE http://172.20.15.36:9200/_template/my_template
```

```markdown
[root@k8s-node ~]# curl -v -H "Content-Type:application/json" http://10.10.24.75:9200/_cat/indices?v | python -m json.tool
* About to connect() to 10.10.24.75 port 9200 (#0)
*   Trying 10.10.24.75...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 10.10.24.75 (10.10.24.75) port 9200 (#0)
> GET /_cat/indices?v HTTP/1.1
> User-Agent: curl/7.29.0
> Host: 10.10.24.75:9200
> Accept: */*
> Content-Type:application/json
> 
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=UTF-8
< Content-Length: 337
< 
{ [data not shown]
100   337  100   337    0     0  36050      0 --:--:-- --:--:-- --:--:-- 42125
* Connection #0 to host 10.10.24.75 left intact
[
    {
        "docs.count": "0",
        "docs.deleted": "0",
        "health": "yellow",
        "index": "xdhuxc-app_2018-07-20",
        "pri": "5",
        "pri.store.size": "795b",
        "rep": "1",
        "status": "open",
        "store.size": "795b"
    },
    {
        "docs.count": "0",
        "docs.deleted": "0",
        "health": "yellow",
        "index": "xdhuxc-app_2018-07-19",
        "pri": "5",
        "pri.store.size": "795b",
        "rep": "1",
        "status": "open",
        "store.size": "795b"
    }
]
```

### 参考资料

http://blog.csdn.net/opensure/article/details/50824821

http://blog.sina.com.cn/s/blog_17943a64f0102x8x0.html
