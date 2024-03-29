+++
title = "Docker 实用命令总结"
date = "2017-06-18"
lastmod = "2017-06-18"
description = ""
tags = [
    "Docker"
]
categories = [
     "Docker"
]
+++

本篇博客整理了一些 docker 实用命令，包括一些组合命令，可以直接修改使用。

<!--more-->

### 常用命令
1、从容器里面复制文件或目录到本地的某个路径
```markdown
docker cp nginx:/xdhuxc/a.html ./a.html
或
docker cp 980cfa7fa636:/xdhuxc/a.html ./a.html
```

2、查看容器的root用户密码
```markdown
docker logs nginx/980cfa7fa636 2>&1 | grep '^User:'|tail -n1 
# Docker容器启动时的root用户的密码是随机分配的。所以，通过这种方式就可以得到redmine容器的root用户的密码了
```

3、获取容器状态
```markdown
docker inspect --format='{{.State.Status}}' ffbb1145d1d7/nginx
```

4、获取容器的内部IP地址
```markdown
docker inspect --format='{{.NetworkSettins.IPAddress}}' ba24b244e370/redis
```

docker images 默认隐藏了中间状态的镜像，可以使用 docker images -a 命令来查看中间状态的镜像。

docker history 命令可以查看该镜像中每一层的信息。

### 常用组合命令
1、删除所有 docker 镜像
```markdown
docker ps -a | awk 'NR > 1 { print $1 }' | xargs docker rm
```

2、删除为 none 的镜像
```markdown
 docker images | grep none | awk '{ print $3 }'| xargs docker rmi -f
```

3、删除已经退出的docker容器
```markdown
docker ps -a|grep Exited|awk '{print $1}'|xargs docker rm
```
