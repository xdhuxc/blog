+++
title = "基于 docker 容器部署 Nexus"
date = "2017-10-22"
lastmod = "2018-12-22"
tags = [
    "Nexus",
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了使用 docker 容器部署 nexus 的方法。

<!--more-->

### Nexus 2
1、拉取Nexus镜像
```markdown
docker pull sonatype/nexus:2.14.5
或
docker pull sonatype/nexus:oss
```

2、启动Nexus
```markdown
docker run -d -p 8081:8081 --name nexus sonatype/nexus:2.14.5
```

3、持久化数据时容器启动方式

创建数据目录并更改该目录的所有者，原因见其Dockerfile
```markdown
mkdir -p /home/xdhuxc/nexus/data && chown -R 200 /home/xdhuxc/nexus/data 
```
启动容器
```markdown
docker run -d \
    --privileged=true \
    -p 8081:8081 \
    -v /home/xdhuxc/nexus/data:/sonatype-work \
    --name nexus \
    sonatype/nexus:2.14.5
```
配置文件目录：`/sonatype-work/conf/nexus.xml`

测试Nexus是否可访问
```markdown
curl -u admin:admin123 http://localhost:8081/service/metrics/ping
```

4、目前，还没有找到方法将配置好的nexus.xml固化到nexus镜像中，采取的方式是：先挂载数据目录启动nexus容器，然后替换本地/home/xdhuxc/nexus/data/conf/nexus.xml文件，重启nexus容器。
```markdown
docker run -d \
    --privileged=true \
    -p 8081:8081 \
    -v /data/nexus/data:/sonatype-work \
    --name nexus \
    sonatype/nexus:2.14.5
```

### 相关问题
1、启动nexus容器时，报错如下：
```markdown
2018-01-04 06:07:57,156+0000 WARN  [jetty-main-1]  org.sonatype.nexus.util.LockFile - Failed to write lock file
java.io.FileNotFoundException: /sonatype-work/nexus.lock (Permission denied)
```
解决：根据 dockerhub 的步骤，更改数据目录的所有者，原因见Dockerfile。
```markdown
mkdir /data/nexus/data && chown -R 200 /data/nexus/data
```
重新启动容器即可。
