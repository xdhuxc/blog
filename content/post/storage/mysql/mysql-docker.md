+++
title = "基于 docker 部署 MySQL"
date = "2018-09-19"
lastmod = "2018-10-22"
tags = [
    "MySQL",
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客记录了基于 docker 容器方式部署 MySQL 的配置和方式。

<!--more-->

### 启动 MySQL 容器
```markdown
docker run -d \
    --restart=always \
    --privileged=true \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=Xdhuxc123 \
    -v /data/mysql_data:/var/lib/mysql \
    -v /data/disc/script/sql:/docker-entrypoint-initdb.d \
    --name mysql \
    mysql:5.7.21
```
该启动命令包括初始化 `root` 用户、初始化数据库（将待导入的 `sql` 文件放入 `/data/disc/script/sql` 目录下）和持久化数据目录。
