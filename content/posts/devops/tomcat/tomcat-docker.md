+++
title = "使用 docker 容器部署 Tomcat"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Tomcat",
    "DevOps",
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 docker 部署 tomcat 的方法。

<!--more-->

### 启动Tomcat容器

使用如下命令启动 `Tomcat` 容器
```markdown
docker run -d \
    --privileged=true \
    --restart=always \
    -p 8080:8080 \
    --name=tomcat \
    tomcat:9.0.1
```
在浏览器地址栏中输入：`http://192.168.244.128:8080`，可访问到 `Tomcat` 的首页

### 挂载配置文件和 War 包方式启动Tomcat容器

根目录为：`/usr/local/tomcat/`，`conf`、`webapps`、`bin` 等目录均在该目录下

创建 `/home/xdhuxc/tomcat` 目录，在其下创建 `conf` 和 `webapps` 目录，

使用如下命令启动 `tomcat` 容器
```markdown
docker run -d \
    --privileged=true \
    --restart=always \
    -p 8080:8080 \
    -v /home/xdhuxc/tomcat/webapps:/usr/local/tomcat/webapps \
    -v /home/xdhuxc/tomcat/conf:/usr/local/tomcat/conf \
    --name=tomcat \
    tomcat:9.0.1
```
