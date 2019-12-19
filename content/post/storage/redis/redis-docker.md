+++
title = "使用 Docker 容器方式部署 Redis"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Redis",
    "Docker"
]
categories = [
    "Redis",
    "Docker"
]
+++

本篇博客主要介绍以 docker 容器方式部署 Redis 的操作。

<!--more-->
1、最简单的 Redis 容器启动方式
```markdown
docker run -d --name redis redis:latest 
```

2、以持久化存储方式启动 Redis 容器
```markdown
docker run -d --name redis redis:latest redis-server --appendonly yes
```

3、某个应用连接 Redis
```markdown
docker run -d --name some-app --link 
```

4、使用自定义配置文件启动 Redis 容器
```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/redis_master.conf:/usr/local/etc/redis/redis.conf \
    -v /home/xdhuxc/redis/log/redis_master.log:/var/log/redis/redis_master.log \
    -v /home/xdhuxc/redis/data:/data \
    --name redis \
    redis:latest \
    redis-server /usr/local/etc/redis/redis.conf
```

```markdown
docker run -d \
    --privileged=true \
    --network host \
    -v /xdhuxc/docker-compose/redis/conf/redis.conf:/usr/local/etc/redis/redis.conf \
    --name redis \
    redis:4.0.9 \
    redis-server /usr/local/etc/redis/redis.conf
```

### Redis主从复制集群
1、安装并启动 Docker，执行如下命令安装 docker
```markdown
yum install -y docker
systemctl enable docker
systemctl start docker
```
2、直接从 dockerhub 官网拉取 Redis镜像
```markdown
docker pull redis
```
3、准备配置文件，从官方下载的Redis镜像中没有redis.conf配置文件，因此需要提前准备配置文件。
从 [Redis官网](https://redis.io/) 下载最新稳定版 Redis，目前为：redis-4.0.2，下载redis-4.0.2.tar.gz，解压该软件包，获取redis.conf 配置文件

4、启动 Redis 主节点

1）修改配置文件

注释掉 bind 127.0.0.1 所在行
注释掉 protected-mode yes所在行
注释掉 daemonize no  或者设置为 no 所在行（否则容器启动，加载配置文件后就退出，没有其他提示），报错为：
```markdown
[root@store ~]# docker logs redis
1:C 10 Nov 00:59:40.915 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 10 Nov 00:59:40.916 # Redis version=4.0.2, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 10 Nov 00:59:40.916 # Configuration loaded
[root@store ~]# docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                          PORTS               NAMES
f5ba4eeb8a53        redis:latest        "docker-entrypoint.sh"   About a minute ago   Exited (0) About a minute ago                       redis
```

2）启动 Redis Master 容器
启动命令为：
```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/conf/redis_master.conf:/usr/local/etc/redis/redis.conf \
    --name redis-master \
    redis:latest \
    redis-server /usr/local/etc/redis/redis.conf
```
```markdown
[root@store ~]# docker logs redis-master
1:C 10 Nov 00:03:25.961 # Fatal error, can't open config file '/usr/local/etc/redis/redis.conf'
```
解决：在启动命令中加入 `--privileged=true` 参数

对于挂载的文件，要提前建立好空文件，否则会以文件名为目录名创建目录

```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/redis-master.conf:/usr/local/etc/redis/redis.conf \
    -v /home/xdhuxc/redis/data:/data
    -v /hoem/xdhuxc/redis/log/redis-master.log:/var/log/redis/redis-master.log \ #由redis.conf中logfile指定
    --name redis-master \
    redis:latest \
    redis-server /usr/local/etc/redis/redis.conf
```

正确的启动命令：（取消logfile参数）
```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/conf/redis-master.conf:/usr/local/etc/redis/redis.conf \
    -v /home/xdhuxc/redis/data:/data \
    --name redis-master \
    redis:4.0.2 \
    redis-server /usr/local/etc/redis/redis.conf
```
测试 Redis Master 容器，可以正常使用。
```markdown
[root@centos_1 conf]# docker exec -it redis-master /bin/bash
root@1cc216ffcba8:/data# redis-cli                                                                                        
127.0.0.1:6379> set aaa aaa
OK
127.0.0.1:6379> get aaa
"aaa"
127.0.0.1:6379> set 123 abc
OK
127.0.0.1:6379> get 123
"abc"
127.0.0.1:6379> 
```
5、Redis Slave 配置文件和启动（使用同一个 redis-slave.conf）
复制 redis-master.conf 为 redis-slave.conf，并修改如下配置项：
```markdown
#slaveof <masterip> <masterport> 
修改为：
slaveof master 6379
```
启动 redis-slave-one 容器
```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/conf/redis-slave.conf:/usr/local/etc/redis/redis.conf \
    --name redis-slave-one \
    --link redis-master:master \
    redis:4.0.2 \
    redis-server /usr/local/etc/redis/redis.conf
```
启动 redis-slave-two 容器
```markdown
docker run -d \
    --privileged=true \
    -v /home/xdhuxc/redis/conf/redis-slave.conf:/usr/local/etc/redis/redis.conf \
    --name redis-slave-two \
    --link redis-master:master \
    redis:4.0.2 \
    redis-server /usr/local/etc/redis/redis.conf
```


