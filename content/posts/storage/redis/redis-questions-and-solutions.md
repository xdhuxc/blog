+++
title = "Redis 常见问题及解决"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Redis",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录下使用 redis 的过程中出现的问题及解决。

<!--more-->

1、使用 go-redis 连接 redis，报错如下：
```markdown
wanghuans-MacBook-Pro:xdhuxc wanghuan$ ./main --config conf.test.yaml
F0910 14:17:00.304868    2673 router.go:50] ERR SELECT is not allowed in cluster mode
```
在单机模式下，redis.conf 配置文件中默认的数据库数量是 16 个；但在集群模式下，redis 不支持多数据库，只有一个数据库，默认是 select 0。集群从节点默认是不支持读写操作的，但是在执行过 readonly 命令后可以执行读操作。

所以，将指定 db 的地方指定为 0 即可解决此问题。

2、增大 redis 的客户端连接数

1）redis.conf 中 maxClients 参数的限制，默认为：10000，设置为 0 表示不作限制，但是优先受到 redis 进程能打开的最大文件描述符的限制，为该值减去 32，因为 redis 内部也需要一些文件描述符。

2）如果需要支持更高的连接数，还需要更改系统的相关配置，比如 ulimit 数目
```markdown
ulimit -n 65536 
```

3）更改网络的并发连接数
```markdown
net.ipv4.netfilter.ip_conntrack_max
net.nf_conntrack_max
net.netfilter.nf_conntrack_max
```

