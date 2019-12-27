+++
title = "etcd 常用命令总结"
date = "2018-10-15"
lastmod = "2018-11-20"
tags = [
    "etcd"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 etcd 中常用的命令的用法。

<!--more-->

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

6、查看etcd节点状态
```markdown
etcdctl cluster-health
```
