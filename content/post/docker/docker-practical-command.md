+++
title = "Git 使用命令总结"
date = "2017-06-18"
lastmod = "2017-06-18"
description = ""
tags = [
    "Docker"
]
categories = [
     "技术"
]
+++

本篇博客整理了一些 docker 实用命令，包括一些组合命令，可以直接修改使用。

<!--more-->

### 常用命令
1、在容器中运行“echo”命令，输出“hello world”
```
docker run nginx echo "hello world"
```
2、交互式进入容器中 http://blog.csdn.net/alen_xiaoxin/article/details/54694051
```
docker run -i -t nginx /bin/bash
```
3、在容器中安装新的程序
```
docker run nginx apt-get install -y wget
```
4、列出当前所有正在运行的容器
```
docker ps
```
5、查看容器

1）查看所有的容器，包括已经停止的
```
docker ps -a
```
2）查看启动的容器
```
docker ps
```
3）列出最近一次启动的容器
```
docker ps -l（L的小写）
```
6、列出最近一次启动的容器
```
docker ps -l（L的小写）
```
7、保存对容器的修改
```
docker commit 8fd1ffefe8c7 x-nginx
```
8、删除容器

1）删除所有容器
```
docker rm $(docker ps -a -q)
```
2）删除单个容器
```
docker rm nginx/980cfa7fa636
```
9、停止一个容器
```
docker stop nginx/980cfa7fa636
```
10、启动一个容器
```
docker start nginx/980cfa7fa636
```
11、杀死一个容器
```
docker kill nginx/980cfa7fa636
```
12、从一个容器中读取日志
```
docker logs -f nginx/980cfa7fa636
```
13、列出一个容器里面被改变的文件或者目录
```
docker diff nginx/980cfa7fa636 #list会罗列出三种事件：
A，增加的；D，删除的；C，被改变的
```
14、显示一个运行的容器里面的进程信息
```
docker top nginx/980cfa7fa636
```
15、从容器里面复制文件或目录到本地的某个路径
```
docker cp nginx:/xdhuxc/a.html ./a.html
或
docker cp 980cfa7fa636:/xdhuxc/a.html ./a.html
```
16、重启一个正在运行的容器
```
docker restart nginx/980cfa7fa636
```
17、附加到一个运行的容器上面
```
docker attach 980cfa7fa636
```
18、查看容器的root用户密码
```
docker logs nginx/980cfa7fa636 2>&1 | grep '^User:'|tail -n1 
# Docker容器启动时的root用户的密码是随机分配的。所以，通过这种方式就可以得到redmine容器的root用户的密码了
```

19、创建一个容器
```
docker create -it nginx:1.9.1
```
20、导出容器
```
docker export 980cfa7fa636/nginx > ***.tar
```

21、导入容器
```
docker import ***.tat xdhuxc/nginx:1.91
```

### 常用组合命令
1、删除所有 docker 镜像
```
docker ps -a | awk 'NR > 1 { print $1 }' | xargs docker rm
```

2、删除为 none 的镜像
```
 docker images | grep none | awk '{ print $3 }'| xargs docker rmi -f
```

