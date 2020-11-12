+++
title = "etcd 常用命令和 API 总结"
date = "2018-10-15"
lastmod = "2018-11-20"
tags = [
    "etcd"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 etcd 中常用的命令和 API 的用法。

<!--more-->

### 常用命令

1、设置键值对
```markdown
etcdctl set xdhuxc adobe
或
etcdctl set /xdhuxc adobe
或
curl -X PUT http://10.10.24.75:2379/v2/keys/xdhuxc -d value="adobe"
```

2、获取所有的key
```markdown
curl -s http://10.10.24.75:2379/v2/keys | python -m json.tool
```

3、获取键值对
```markdown
etcdctl get xdhuxc
或
etcdctl get /xdhuxc
或
curl -s http://10.10.24.75:2379/v2/keys/xdhuxc | python -m json.tool
```

4、删除键值对
```markdown
etcdctl rm xdhuxc
或
etcdctl rm /xdhuxc
或
curl -X –s DELETE http://127.0.0.1:2379/v2/keys/xdhuxc
```

5、查看当前集群中的节点和leader节点
```markdown
etcdctl member list
或
curl -s http://172.20.26.149:2379/v2/members|python -m json.tool
```
或者使用 debug 模式查看
```markdown
etcdctl --debug member list
```

6、查看etcd节点状态
```markdown
etcdctl cluster-health
```

### 常用 API
1、查看 etcd 版本
```markdown
curl http://10.10.24.28:2379/version
```

2、查看所有的键
```markdown
curl http://10.10.24.28:2379/v2/keys 
```

3、创建键值
```markdown
curl http://10.10.24.28:2379/v2/keys/xdhuxc-key -XPUT -d value="xdhuxc-value" # 创建键值对 xdhuxc-key=xdhuxc-value
```
对于 put 方法，如果 key 之前存在，则默认会先删除，再新建一个 key。

如果想要直接 update，则追加 -d prevExist=true，但是加了这个参数，如果 key 之前不存在，则会报错。

4、创建目录
```markdown
curl http://10.10.24.28:2379/v2/keys/xdhuxc-dir -XPUT -d dir=true # 创建目录 xdhuxc
```

5、创建带 TTL 的键值
```markdown
curl http://10.10.24.28:2379/v2/keys/xdhuxc-ttl-key -XPUT -d value="xdhuxc-ttl-value" -d ttl=10 # 单位为秒
```

6、创建有序键值
```markdown
curl http://10.10.24.28:2379/v2/keys/xdhuxc-seq -XPOST -d value="seqone"
curl http://10.10.24.28:2379/v2/keys/xdhuxc-seq -XPOST -d value="seqtwo"
curl http://10.10.24.28:2379/v2/keys/xdhuxc-seq -XPOST -d value="seqthree"
curl http://10.10.24.28:2379/v2/keys/xdhuxc-seq
```

7、删除指定的键
```markdown
curl http://10.10.24.28:2379/v2/keys/xdhuxc-key -XDELETE # 删除键 xdhuxc-key
```

8、列出所有集群成员
```markdown
curl http://10.10.24.28:2379/v2/members
```

9、查看 leader
```markdown
curl http://10.10.24.28:2379/v2/stats/leader
```

10、节点自身信息
```markdown
curl http://10.10.24.28:2379/v2/stats/self
```

11、查看集群运行状态
```markdown
curl http://10.10.24.28:2379/v2/stats/store
```
