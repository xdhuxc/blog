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

### 集群方式部署 etcd

三台机器的基本信息

名称 | IP地址 | 主机名 | OS | etcd_version
---|---|---|---|---
etcd0 | 192.168.91.128 | etcd0.xdhuxc.com | CentOS 7.3.1611 | etcd-v3.2.10
etcd1 | 192.168.91.129 | etcd1.xdhuxc.com | CentOS 7.3.1611 | etcd-v3.2.10
etcd2 | 192.168.91.130 | etcd2.xdhuxc.com | CentOS 7.3.1611 | etcd-v3.2.10

均安装 iptables 并开放所需端口2379，2380

在每一台机器上，添加如下环境变量
```markdown
ETCD_VERSION=v3.3
TOKEN=etcd-cluster-token
CLUSTER_STATE=new
NODE_1=etcd-node-0
NODE_2=etcd-node-1
NODE_3=etcd-node-2
HOST_1_IP=192.168.91.128
HOST_2_IP=192.168.91.129
HOST_3_IP=192.168.91.130
CLUSTER=${NODE_1}=http://${HOST_1_IP}:2380,${NODE_2}=http://${HOST_2_IP}:2380,${NODE_3}=http://${HOST_3_IP}:2380
DATA_DIR=/home/xdhuxc/etcd/data
```
在节点1上，执行如下命令

添加如下环境变量：
```markdown
THIS_NAME=${NODE_1}
THIS_IP=${HOST_1_IP}
```
启动容器
```markdown
docker run \
    -p 2379:2379 \
    -p 2380:2380 \
    -v ${DATA_DIR}:/etcd-data \
    --name etcd-1
    quay.io/coreos/etcd:v3.3 \
    /usr/local/bin/etcd \
    --data-dir=/etcd-data \
    --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}
```

在节点2上，执行如下命令

添加如下环境变量：
```markdown
THIS_NAME=${NODE_2}
THIS_IP=${HOST_2_IP}
```
启动容器
```markdown
docker run \
    -p 2379:2379 \
    -p 2380:2380 \
    -v ${DATA_DIR}:/etcd-data \
    --name etcd-2
    quay.io/coreos/etcd:v3.3 \
    /usr/local/bin/etcd \
    --data-dir=/etcd-data \
    --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}
```

在节点3上，执行如下命令

添加如下环境变量：
```markdown
THIS_NAME=${NODE_3}
THIS_IP=${HOST_3_IP}
```
启动容器
```markdown
docker run \
    -p 2379:2379 \
    -p 2380:2380 \
    -v ${DATA_DIR}:/etcd-data \
    --name etcd-3
    quay.io/coreos/etcd:v3.3 \
    /usr/local/bin/etcd \
    --data-dir=/etcd-data \
    --name ${THIS_NAME} \
    --initial-advertise-peer-urls http://${THIS_IP}
```

### 参考资料

Github https://github.com/etcd-io/etcd/releases

镜像下载地址 https://quay.io/repository/coreos/etcd?tag=latest&tab=tags

镜像使用地址 https://github.com/coreos/etcd/blob/master/Documentation/op-guide/container.md#docker
