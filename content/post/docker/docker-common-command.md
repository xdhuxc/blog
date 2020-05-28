+++
title = "Docker 常用命令"
date = "2017-08-19"
lastmod = "2017-08-19"
description = ""
tags = [
    "Docker"
]
categories = [
     "技术"
]
+++

本篇博客记录了在使用 docker 的过程中经常使用的一些命令，以备后需。

<!--more-->

## Docker 信息
1、显示 docker 版本信息
```
docker version
```
2、显示 docker 系统信息，包括镜像和容器数
```
docker info
```

## 容器生命周期管理
### run
> docker run 用于创建一个新的容器并运行一个命令

#### 语法
```
docker run [options] image [command] [args...]
```
#### 选项说明
```
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d：后台运行容器，并返回容器ID；
-i：以交互模式运行容器，通常与 -t 同时使用；
-t：为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="abc"：为容器指定一个名称；
--dns 8.8.8.8：指定容器使用的DNS服务器，默认和宿主机一致；
--dns-search example.com：指定容器DNS搜索域名，默认和宿主机一致；
-h,--hostname="host_name"：指定容器的主机名为host_name；
-e username="xdhuxc"：设置环境变量；
--env-file=[]：从指定文件读入环境变量；
--cpuset="0-2" 或 --cpuset="0,1,2"：绑定容器到指定CPU运行；
-m：设置容器使用内存最大值；
--net="bridge"：指定容器的网络连接类型，支持 bridge、host、none、container 四种类型；
--net=bridge：默认值，在Docker网桥上为容器创建新的网络栈；
--net=host：让Docker不要将容器网络放到隔离的命名空间中，即不要容器化容器内的网络。此时容器使用本地主机的网络，它拥有完全的本地主机接口访问权限。容器进程可以跟主机其他root进程一样打开低范围的端口，可以访问本地网络服务，还可以让容器做一些影响整个主机系统的事情，比如重启主机。因此，使用这个选项的时候要非常小心。如果进一步使用--privileged=true参数，容器甚至会被允许直接配置主机的网络堆栈；
--net=container：让Docker将新建容器的进程放到一个已存在容器的网络栈中，新容器进程有自己的文件系统、进程列表和资源限制，但会和已存在的容器共享IP地址和端口等网络资源，两者进程可以直接通过lo环回接口通信；
--net=none：让Docker将新容器放到隔离的网络栈中，但是不进行网络配置。之后，用户可以自己进行配置；
--link=[]：添加链接到另一个容器；
--expose=[]：开放一个端口或一组端口；
-v host_folder:container_folder：将主机目录挂载到容器目录；
--rm：在容器运行结束时自动清理其所产生的数据；
-w,--workdir=""：指定容器的工作目录；
--privileged=true：使用该参数，容器内的root用户才能拥有真正的root权限；否则，容器内的root用户只具有外部的一个普通用户权限；
```
#### 示例
1、使用docker镜像nginx:latest以后台模式启动一个容器,并将容器命名为xyz_nginx。
```
docker run --name xyz_nginx -d nginx:latest 
```
2、使用镜像 nginx:latest 以后台模式启动一个容器,并将容器的80端口映射到主机随机端口。
```
docker run -P -d nginx:latest 
```
3、使用镜像 nginx:latest 以后台模式启动一个容器,将容器的80端口映射到主机的80端口,主机的目录 /data/xdhuxc映射到容器的 /data。
```
docker run -p 80:80 -v /data/xdhuxc:/data -d nginx:latest  
```
4、使用镜像nginx:latest以交互模式启动一个容器,在容器内执行/bin/bash命令
```
docker run -it nginx:latest /bin/bash 
```
### start/stop/restart
> docker start 用于启动一个或多个已经被停止的容器
> docker stop 用于停止一个或多个运行中的容器
> docker restart 用于重启一个或多个停止的容器

##### 语法
```
docker start [options] container [container...]

docker stop [options] container [container...]

docker restart [options] container [container...]
```
##### 示例
1、启动已被停止的容器
```
docker start xdhuxc
```
2、停止运行中的容器xdhuxc
```
docker stop xdhuxc
```
3、重启容器myrunoob
```
docker restart xdhuxc
```
### kill
> docker kill 用于杀死一个运行中的容器

#### 语法
```
docker kill [options] container [container...]
```
#### 选项说明
```
-s：向容器发送一个信号
```
#### 示例
1、杀掉运行中的容器xdhuxc
```
docker kill -s KILL xdhuxc
```
### rm
> docker rm 用于删除一个或多个容器

#### 语法
```
docker rm [options] container [container...]
```
#### 选项说明
```
-f：通过SIGKILL信号强制删除一个运行中的容器；
-l：移除容器间的网络连接，而非容器本身；
-v：删除与容器关联的卷；
```
#### 示例
1、强制删除容器xdhuxc_1、xdhuxc_2
```
docker rm -f xdhuxc_1 xdhuxc_2
```
2、移除容器nginx_1对容器xdhuxc_1的连接，连接名为：nginx_xdhuxc
```
docker rm -l nginx_xdhuxc 
```
3、删除容器xdhuxc，并删除容器挂载的数据卷
```
docker rm -v xdhuxc
```

### pause/unpause
> docker pause 命令用于暂停容器中的所有进程

> docker unpause命令用于恢复容器中的所有进程
 
#### 语法
```
docker pause [options] container [container...]
docker unpause [options] container [container...]
```
#### 示例
1、暂停数据库容器db_one提供的服务
```
docker pause db_one
```
2、恢复数据库容器db_one提供的服务
```
docker unpause db_one 
```
### create
> docker create 命令用于创建一个新的容器但不启动它

#### 语法
```
docker create [options] image [command] [args...]
```
#### 示例
1、使用镜像nginx:latest创建一个容器,并将容器命名为xnginx
```
docker create --name=xnginx nginx:latest
```
### exec
> docker exec 命令用于在运行的容器中执行命令

#### 语法
```
docker exec [options] container command [arg...]
```
#### 选项说明
```
-d：分离模式，即在后台运行；
-i：交互式模式，即使没有附加也保持标准输出打开；
-t：分配一个伪终端；
```
#### 示例
1、在容器xnginx中以交互模式执行容器内/root/startup.sh脚本
```
docker exec -it xnginx /bin/sh /root/startup.sh
```
2、在容器xnginx中开启一个交互模式的终端
```
docker exec -i -t xnginx /bin/bash
```

## 容器操作
### ps
> docker ps 命令用于显示容器

#### 语法
```
docker ps [options]
```
#### 选项说明
```
-a：显示所有容器，包括未运行的容器；
-f：根据条件过滤显示的内容；
--format：指定返回值的模板文件；
-l：显示最近创建的容器；
-n：列出最近创建的n个容器；
--no-trunc：不截断输出；
-q：静默模式，只显示容器编号；
-s：显示总的文件大小；
```
#### 示例
1、列出所有正在运行的容器的信息
```
docker ps
```
2、列出最近创建的5个容器的信息
```
docker ps -n 5
```
3、列出所有创建的容器ID
```
docker ps -a -q
```

### inspect
> docker inspect 命令用于获取容器或镜像的元数据

#### 语法
```
docker inspect [options] name|id [name|id...]
```
#### 选项说明
```
-f：指定返回值的模板文件；
-s：显示总的文件大小；
--type：为指定类型返回JSON；
```
#### 示例
1、获取镜像mysql:5.7的元数据信息
```
docker inspect mysql:5.6
```
2、获取正在运行的容器mysql的IP地址
```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql
```
### top
> docker top 命令用于查看容器中运行的进程信息，支持ps命令参数。容器运行时不一定有/bin/bash终端来交互执行top命令，而且容器还不一定有top命令，可以使用docker top来实现查看container中正在运行的进程。

#### 语法
```
docker top [options] container [ps options]
```
#### 示例
1、查看容器mysql的进程信息
```
docker top mysql
```
2、查看所有运行中容器的进程信息
```
for i in  `docker ps |grep Up|awk '{print $1}'`;do echo \ && docker top $i; done
```

### attach
> docker attach 命令用于连接到正在运行中的容器

#### 语法
```
docker attach [options] container
```
要attach上去的容器必须正在运行，可以同时连接上同一个容器来共享屏幕。
attach后可以通过CTRL-C来detach，但实际上，如果容器当前在运行bash，CTRL-C自然是当前行的输入，没有退出；如果容器当前正在前台运行进程，如输出nginx的access.log日志，CTRL-C不仅会导致退出容器，而且还停止了。这不是我们想要的，detach的意思按理应该是脱离容器终端，但容器依然运行。好在attach是可以带上--sig-proxy=false来确保CTRL-D或CTRL-C不会关闭容器。
#### 示例
1、容器nginx将访问日志定向到标准输出，连接到容器查看访问信息。
```
docker attach --sig-proxy=false nginx
```
### events
> docker events 命令用于从服务器获取实时事件

#### 语法
```
docker events [options]
```
#### 选项说明
```
-f：根据条件过滤事件；
--since：从指定的时间戳后显示所有事件；
--until：流水时间显示到指定的时间为止；
```
#### 示例
1、显示 docker 2016年7月1日后的所有事件。
```
docker events --since="1467302400"
```
2、显示 docker 镜像为mysql:5.7 2016年7月1日后的相关事件
```
docker events -f "image"="mysql:5.7" --since="1467302400"
```

如果指定的时间是到秒级的，需要将时间转成时间戳。如果时间为日期的话，可以直接使用，如--since="2016-07-01"。

### logs
> docker logs用于获取容器的日志

#### 语法
```
docker logs [options] container
```
#### 选项说明
```
-f：跟踪日志输出；
--since：显示某个开始时间的所有日志；
-t：显示时间戳；
--tail：仅列出最新N条容器日志；
```
#### 示例
1、跟踪查看容器nginx的日志输出
```
docker logs -f nginx
```
2、查看容器nginx从2016年07月01日后的最新10条日志
```
docker logs --since="2016-07-01" --tail=10 nginx
```
### wait
> docker wait 命令用于阻塞运行直到容器停止，然后打印出它的退出代码

#### 语法
```
docker wait [options] container [container...]
```
#### 示例
```
docker wait container
```
### export
> docker export 命令用于将文件系统作为一个tar归档文件导出到STDOUT

#### 语法
```
docker export [options] container
```
#### 选项说明
```
-o：将输入内容写到文件
```
#### 示例
1、将ID为a404c6c174a2的容器按日期保存为tar文件。
```
docker export -o mysql-`date +%Y%m%d`.tar a404c6c174a2
```

### port
> docker port 命令用于列出指定的容器的端口映射，或者查找将PRIVATE_PORT NAT到面向公众的端口

#### 语法
```
docker port [options] container [private_port[/proto]]
```
#### 示例
1、查看容器nginx的端口映射情况
```
docker port nginx
```

## 容器 rootfs 命令
### commit
> docker commit命令用于从容器创建一个新的镜像

#### 语法
```
docker commit [options] container [repository][:tag]
```
#### 选项说明
```
-a：提交的镜像作者；
-c：使用Dockerfile指令来创建镜像；
-m：提交时的说明文字；
-p：在commit时，将容器暂停；
```
#### 示例
1、将容器a404c6c174a2 保存为新的镜像，并添加提交人信息和说明信息。
```
docker commit -a "xdhuxc" -m "x-mysql" a404c6c174a2  xmysql:1.0.0 
```

### cp
> docker cp 命令用于容器与主机之间的数据复制

#### 语法
```
docker cp [options] container:src_path dest_path|-
docker cp [options] src_path|- container:dest_path
```
#### 选项说明
```
-L：保持源目标中的链接
```
#### 示例
1、将主机/www/run目录复制到容器96f7f14e99ab的/www目录下。
```
docker cp /www/run 96f7f14e99ab:/www/
```
2、将主机/www/run目录复制到容器96f7f14e99ab中，目录重命名为www
```
docker cp /www/run 96f7f14e99ab:/www
```
3、将容器96f7f14e99ab的/www目录复制到主机的/tmp目录中
```
docker cp 96f7f14e99ab:/www /tmp/
```
### diff
> docker diff 命令用于检查容器里文件结构的更改

#### 语法
```
docker diff [options] container
```
#### 示例
1、查看容器mysql的文件结构更改
```
docker diff mysql
```
## 镜像仓库
### login
> docker login 命令用于登陆到一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub。

> docker logout 命令用于退出一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub。

#### 语法
```
docker login [options] [server]
docker logout [options] [server]
```
#### 选项说明
```
-u：登陆的用户名；
-p：登陆的密码；
```
#### 示例
1、登陆到Docker Hub
```
docker login -u username -p password
```
2、退出Docker Hub
```
docker logout
```

### pull
> docker pull 命令用于从镜像仓库中拉取或者更新指定镜像

#### 语法
```
docker pull [options] name[:tag|@DIGEST]
```
#### 选项说明
```
-a：拉取所有 tagged 镜像；
--disable-content-trust：忽略镜像的校验,默认开启；
```
#### 示例
1、从 Docker Hub 下载java最新版镜像
```
docker pull java
```
2、从 Docker Hub 下载 REPOSITORY 为 java 的所有镜像
```
docker pull -a java
```

### push
> docker push 命令用于将本地的镜像上传到镜像仓库，要先登陆到镜像仓库

#### 语法
```
docker push [options] name[:tag]
```
#### 选项说明
```
--disable-content-trust：忽略镜像的校验,默认开启
```
#### 示例
1、上传本地镜像apache:latest到镜像仓库中
```
docker push apache:latest
```
### search
> docker search 命令用于从 Docker Hub 中查找镜像

#### 语法
```
docker search [options] term
```
#### 选项说明
```
--automated：只列出 automated build类型的镜像；
--no-trunc：显示完整的镜像描述；
-s：列出收藏数不小于指定值的镜像；
```
#### 示例
1、从 Docker Hub 上查找所有镜像名中包含java，并且收藏数大于10的镜像
```
docker search -s 10 java
```

## 本地镜像管理
### images
> docker images 命令用于列出本地镜像

#### 语法
```
docker images [options] [repository[:tag]]
```
#### 选项说明
```
-a：列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）；
--digests：显示镜像的摘要信息；
-f：显示满足条件的镜像；
--format：指定返回值的模板文件；
--no-trunc：显示完整的镜像信息；
-q：只显示镜像ID；
```
#### 示例
1、查看本地镜像列表
```
docker images
```
2、列出本地镜像中 REPOSITORY 为 ubuntu 的镜像列表
```
docker images ubuntu
```

### rmi
> docker rmi 命令用于删除本地一个或多个镜像

#### 语法
```
docker rmi [options] image [image...]
```

#### 选项说明
```
-f：强制删除；
--no-prune：不移除该镜像的过程镜像，默认移除；
```
#### 示例
1、强制删除本地镜像 `nginx:latest`
```
docker rmi -f nginx:latest
```

### tag
> docker tag命令用于标记本地镜像，将其归入某一仓库

#### 语法
```
docker tag [options] image[:tag] [registry host/][username/]name[:tag]
```
#### 示例
1、将镜像 `ubuntu:15.10` 标记为 `xdhuxc/ubuntu:v3` 镜像
```
docker tag ubuntu:15.10 xdhuxc/ubuntu:v3
```
### build
> docker build 命令用于使用Dockerfile创建镜像

#### 语法
```
docker build [options] path|url|-
```
#### 选项说明
```
--build-arg=[]：设置镜像创建时的变量；
--cpu-shares：设置 cpu 使用权重；
--cpu-period：限制 CPU CFS周期；
--cpu-quota：限制 CPU CFS配额；
--cpuset-cpus：指定使用的CPU id；
--cpuset-mems：指定使用的内存 id；
--disable-content-trust：忽略校验，默认开启；
-f：指定要使用的Dockerfile路径；
--force-rm：设置镜像过程中删除中间容器；
--isolation：使用容器隔离技术；
--label=[]：设置镜像使用的元数据；
-m :设置内存最大值；
--memory-swap：设置Swap的最大值为内存+swap，"-1"表示不限swap；
--no-cache：创建镜像的过程不使用缓存；
--pull：尝试去更新镜像的新版本；
-q：静默模式，成功后只输出镜像ID；
--rm：设置镜像成功后删除中间容器；
--shm-size：设置/dev/shm的大小，默认值是64M；
--ulimit：Ulimit配置。
```
#### 示例
1、使用当前目录的 `Dockerfile` 创建镜像
```markdown
docker build -t xdhuxc/mysql:5.7 .
```
2、使用 URL `github.com/creack/docker-firefox` 的 `Dockerfile` 创建镜像
```markdown
docker build github.com/creack/docker-firefox
```
3、指定 dockerfile 构建镜像
```markdown
docker build -t xdhuxc/go-build:v1.13.11 -f Dockerfile-local .
```

### history
> docker history 命令用于查看指：定镜像的创建历史

#### 语法
```
docker history [options] image
```
#### 选项说明
```
-H：以可读的格式打印镜像大小和日期，默认为true；
--no-trunc：显示完整的提交记录；
-q：仅列出提交记录ID；
```
#### 示例
1、查看本地镜像 `xdhuxc/mysql:5.7` 的创建历史
```
docker history xdhuxc/mysql:5.7
```
### save
> docker save 命令用于将指定的镜像保存成tar归档文件

#### 语法
```
docker save [options] image [image...]
```
#### 选项说明
```
-o：输出到的文件
```
#### 示例
1、将镜像 `xdhuxc/mysql:5.7` 保存为 `mysql.tar`
```
docker save xdhuxc/mysql:5.7 -o mysql.tar
```

### import
> docker import 命令用于从归档文件中创建镜像

#### 语法
```
docker import [options] file|URL|- [repository[:tag]]
```
#### 选项说明
```
-c：应用 docker 指令创建镜像；
-m：提交时的说明文字；
```
#### 示例
1、从镜像归档文件 `mysql.tar` 创建镜像，命名为 `xdhuxc/mysql:5.7`
```
docker import mysql.tar xdhuxc/mysql:5.7
```

















