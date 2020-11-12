+++
title = "使用 docker 容器方式部署 zookeeper"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Zookeeper",
    "Docker",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 docker 容器方式部署 zookeeper 的方法。

<!--more-->

### 启动 zookeeper 容器

使用如下命令启动 zookeeper 容器：

```markdown
docker run -d \
    --privileged=true \
    --restart=always \
    -p 2181:2181 \
    --hostname=zookeeper \
    -e ZOO_MY_ID=1 \
    -e ZOO_SERVERS=server.1=zookeeper:2888:3888 \
    -v /home/xdhuxc/zookeeper/log:/datalog \
    -v /home/xdhuxc/zookeeper/data:/data \
    --name zookeeper \
    docker.io/zookeeper:3.4.10
```
