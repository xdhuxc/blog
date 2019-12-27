+++
title = "部署 etcd 的常用方法"
date = "2018-11-11"
lastmod = "2019-01-10"
tags = [
    "etcd",
    "docker"
]
categories = [
    "技术"
]
+++

本篇博客介绍了几种常用的部署 etcd 的方法。

<!--more-->

### 基于 docker 方式部署 etcd
1、拉取 etcd 镜像
```angular2html
docker pull gcr.io/etcd-development/etcd:v3.2.25
```

2、启动 etcd 容器
```angular2html
docker run -d \
    --restart=always \
    --name=etcd \
    -p 3379:2379 \
    -p 3380:2380 \
    -v /data/etcd/data:/etcd-data \
    gcr.io/etcd-development/etcd:v3.2.25 \
    /usr/local/bin/etcd \
    --name etcd1 \
    --data-dir /etcd-data \
    --listen-client-urls http://0.0.0.0:2379 \
    --advertise-client-urls http://0.0.0.0:2379 \
    --listen-peer-urls http://0.0.0.0:2380 \
    --initial-advertise-peer-urls http://0.0.0.0:2380 \
    --initial-cluster etcd1=http://0.0.0.0:2380 \
    --initial-cluster-token tkn \
    --initial-cluster-state new
```

### 使用 yum 安装 etcd
1、使用 yum 直接安装 etcd
```markdown
yum install etcd -y
```

2、启动 etcd 
```markdown
systemctl restart etcd 
```

3、查看状态
```markdown
systemctl status etcd
```

### 参考资料

1、Github

https://github.com/etcd-io/etcd/releases
