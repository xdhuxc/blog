+++
title = "Docker 常用参数配置"
date = "2017-10-19"
lastmod = "2017-10-28"
description = ""
tags = [
    "Docker"
]
categories = [
     "技术"
]
+++

本篇博客整理了一些使用 docker 的过程中经常使用的参数的配置，对于 docker 进阶使用会非常有帮助。

<!--more-->

### 配置文件

#### docker.service 
1、`docker.service` 文件路径
```markdown
/usr/lib/systemd/system/docker.service
```

2、`docker.service` 文件内容
```markdown
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target
Wants=docker-storage-setup.service
Requires=docker-cleanup.timer

[Service]
Type=notify
NotifyAccess=all
EnvironmentFile=-/run/containers/registries.conf
EnvironmentFile=-/etc/sysconfig/docker
EnvironmentFile=-/etc/sysconfig/docker-storage
EnvironmentFile=-/etc/sysconfig/docker-network
Environment=GOTRACEBACK=crash
Environment=DOCKER_HTTP_HOST_COMPAT=1
Environment=PATH=/usr/libexec/docker:/usr/bin:/usr/sbin
ExecStart=/usr/bin/dockerd-current \
          --add-runtime docker-runc=/usr/libexec/docker/docker-runc-current \
          --default-runtime=docker-runc \
          --exec-opt native.cgroupdriver=systemd \
          --userland-proxy-path=/usr/libexec/docker/docker-proxy-current \
          $OPTIONS \
          $DOCKER_STORAGE_OPTIONS \
          $DOCKER_NETWORK_OPTIONS \
          $ADD_REGISTRY \
          $BLOCK_REGISTRY \
          $INSECURE_REGISTRY\
      $REGISTRIES
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
Restart=on-abnormal
MountFlags=slave
KillMode=process

[Install]
WantedBy=multi-user.target
```

3、启动 docker 时各参数的含义

参数 | 含义
--- | ---
-g，--graph=“/var/lib/docker” |	设置docker的运行时根目录
-s，--storage-driver=“devicemapper”	| 设置容器运行时使用指定的存储驱动为devicemapper
--insecure-registry 0.0.0.0/0 | 允许不安全的仓库连接
--registry-mirror xdhuxc.docker.com |	配置镜像加速地址

4、docker 的日志文件写入写入到 `/var/log/message` 文件中，查看的命令为：
```markdown
tail -f /var/log/message | grep docker
```
或者
```markdown
journalctl -fu docker
```

4、Docker默认空间大小分为两个，一个是池空间大小，默认为100G；另一个是容器空间大小，默认为10G。

### 常用配置

#### 限制日志文件大小和保留文件个数

在 `docker run` 命令中增加如下参数，限制生成的 `json.log` 单个文件大小和保留文件个数：
```markdown
docker run -it --log-opt max-size=100m --log-opt max-file=3 nginx:latest
```

在 `docker-compose.yml` 文件中的书写格式为：
```markdown
log_opt:
    max-size: '100M'
    max-file: '3'
```

当生成 `3` 个文件，每个文件达到 `100M` 时，会循环写入新的日志。

#### 指定 Cgroup Driver 的类型
在 `/usr/lib/system/system/docker.service` 中给 `docker` 进程启动命令中增加如下参数：
```markdown
--exec-opt native.cgroupdriver=systemd
```


