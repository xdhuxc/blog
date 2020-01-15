+++
title = "Dockerfile 知识点总结"
date = "2017-08-22"
lastmod = "2017-08-22"
description = ""
tags = [
    "Docker",
    "Dockerfile"
]
categories = [
     "技术"
]
+++

本篇博客介绍了 `Dockerfile` 各种命令的使用方法，对于构建 `docker` 镜像及运行 `Docker` 容器都是不可不知的。

<!--more-->

### Dockerfile 简介

`Dockerfile` 是一个文本格式的配置文件，可以使用 `Dockerfile` 快速创建自定义镜像

Dockerfile官方网址：https://github.com/docker-library

### Dockerfile 基本结构

`Dockerfile` 由一行行命令语句组成，并且支持以 “#” 开头的注释行。

一般而言，`Dockerfile` 分为四个部分：

- 基础镜像信息
- 维护者信息
- 镜像操作指令
- 容器启动时执行指令

一个典型的 `Dockerfile` 如下所示：
```markdown
# This dockerfile uses the ubuntu image
# VERSION 2 - EDITION 1
# Author: docker_user
# Command format: Instruction [arguments / command]..

# 第一行必须指定基于的基础镜像
FROM ubuntu

# 维护者信息
MAINTAINER docker_user docker_user@email.com

# 镜像的操作指令
RUN echo "deb http://archive.ubuntu.com/ubuntu/  raring main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# 容器启动时执行指令
CMD /usr/sbin/nginx
```

### 指令

指令的一般格式为：INSTRUCTION arguments，指令包括：FROM、MAINTAINER、RUN等。

#### FROM

格式为：
```markdown
FROM <image> 
或
FROM <image>:<tag>
```
第一条指令必须为 `FROM` 指令，并且，如果在同一个 `Dockerfile` 中创建多个镜像时，可以使用多个 `FROM` 指令，每个镜像一次。

#### MAINTAINER

格式为：
```markdown
MAINTAINER <name>
```
指定维护者信息

#### RUN

格式为：
```markdown
RUN <command>
或
RUN ["executable", "param1", "param2"]
```
前者将在 Shell 终端中运行命令，即 `/bin/sh -c` ；

后者则使用 `exec` 执行，指定使用其他终端可以通过这种方式实现，例如 `RUN ["/bin/bash", "-c", "echo hello"]`

每条RUN指令将在当前镜像基础上执行指定指令，并提交为新的镜像。

每运行一条RUN指令，镜像添加新的一层，并提交。

当命令较长时，可以使用 `\` 来换行。

#### CMD

格式为：
```markdown
CMD ["executable", "param1", "param2"]  #使用 exec 执行，推荐方式
或
CMD command param1 param2 # 在/bin/bash 中执行，提供给需要交互的应用
或
CMD ["param1", "param2"] # 提供给 ENTRYPOINT 的默认参数
```

指定启动容器时执行的命令，每个 `Dockerfile` 只能有一条 `CMD` 命令。如果指定了多条命令，只有最后一条会被执行。

如果用户启动容器时，指定了运行的命令，则会覆盖掉 `CMD` 指定的命令。

#### EXPOSE

格式为：
```markdown
EXPOSE <port> [<port>...]
```
告诉 Docker 服务端容器暴露的端口号，供互联系统使用。

在启动容器时需要通过 `-p` 选项指定，`Docker` 主机会自动分配一个端口转发到指定的端口。

使用 `-p`，则可以具体指定哪个本地端口映射过来。

#### ENV

格式为：
```markdown
ENV <key> <value>
```
指定一个环境变量，会被后续 `RUN` 指令使用，并在容器运行时保持

#### COPY

格式为：
```markdown
COPY <src> <dest>
```
复制本地主机的 `<src>`（为 `Dockerfile` 所在目录的相对路径，文件或者目录）为容器中的 `<dest>`。目标路径不存在时，会自动创建。

当使用本地目录为源目录时，推荐使用 `COPY`。

#### ADD

格式为：
```markdown
ADD <src> <dest>
```
复制指定的 `<src>` 到容器中的 `<dest>`，其中 `<src>` 可以是 `Dockerfile`所在目录的一个相对路径（文件或目录）；

也可以是一个 `URL`，还可以是一个 `tar` 文件（自动解压为目录）。

#### ENTRYPOINT

格式为：
```markdown
ENTRYPOINT ["executable", "param1", "param2"]
或
ENTRYPOINT command param1 param2 #在Shell中执行
```
配置容器启动后执行的命令，并且不可被 `docker run` 提供的参数覆盖

每个 `Dockerfile` 中只能有一个 `ENTRYPOINT`，当指定多个 `ENTRYPOINT` 时，只有最后一个生效。

#### VOLUME

格式为：
```markdown
VOLUME ["/data"]
```
创建一个可以从本地主机或其他容器挂载的挂载点，一般用来存放数据库和需要保持的数据等。

#### USER

格式为：
```markdown
USER daemon
```
指定运行容器时的用户名或 `UID`，后续的RUN也会使用指定用户。

当服务不需要管理员权限时，可以通过该命令指定运行用户。并且可以在之前创建所需要的用户，例如 `RUN groupadd -r postgres && useradd -r -g postgres postgres`。

要临时获取管理员权限，可以使用 `gosu`，而不推荐使用 `sudo`。

#### WORKDIR

格式为：
```markdown
WORKDIR /path/to/workdir
```
为后续的 `RUN`，`CMD`，`ENTRYPOINT` 指令配置工作目录

可以使用多个 `WORKDIR` 指令，后续命令如果参数是相对路径，则会基于之前命令指定的路径。例如：
```markdown
WORKDIR /a
WORKDIR b
WORKDIR c
```

则最终路径为：`/a/b/c`

#### ONBUILD

格式为：
```markdown
ONBUILD [INSTRUCTION]
```
配置当所创建的镜像作为其他新创建镜像的基础镜像时，所执行的操作指令。

使用 `ONBUILD` 指令的镜像，推荐在标签中注明，例如 `ruby:1.9-onbuild`。

### 主要指令

#### ADD 和 COPY

ADD：将主机上的文件复制到或者将网络上的文件下载到容器中的指定目录。

COPY： 将本地目录中的文件复制到容器内的指定目录下面，从而在镜像中增加一个层。在未指定绝对路径的时候，会放到 WORKDIR 目录下面。

ADD 和 COPY 之间的区别：

* ADD 多了两个功能，下载 URL 和对支持的压缩格式的包进行解压，其他都一样。比如，`ADD http://foo.com/bar.go /tmp/main.go` 会将文件从互联网上下载下来；`ADD /foo.tar.gz /tmp/` 会将压缩文件解压再 COPY 过去。
* 如果不希望压缩文件复制到容器中后解压的话，那么使用 COPY。
* 如果需要自动下载 URL 并复制到容器的话，那么使用 ADD。

#### EXPOSE 和 docker run -p 之间的关系

容器的端口必须被发布（publish）出来后才能被外界使用，Dockerfile 中的 EXPOSE 只是 `标记` 某个端口会被暴露出来，只有在使用了 `docker run -p` 或者 `docker run -P` 后，端口才会被 `发布` 出来，此时端口才能被使用。

在 Dockerfile 中没有指定 EXPOSE port 时，

使用 `-P` 参数，执行 `docker run -d --name no-exposed-port-xdhuxc -P xdhuxc:latest`，此时没有任何端口被发布，说明 docker 在使用了 `-P` 参数的情形下只是自动将 EXPOSE 的端口发布出来。

使用 `-p` 加上一个不存在的端口，执行 `docker run -d --name no-exposed-port-xdhuxc -p 8888:9999 xdhuxc:latest`，此时，9999 端口会被暴露，但是没法使用，说明 `-p` 会将没有暴露的端口自动暴露出来。

由此可见，

* `EXPOSE` 或者 `--expose` 只是为其他命令提供所需信息的元数据，或者只是告诉容器操作人员有哪些已知选择，只是作为记录机制，也就是告诉用户哪些端口会提供服务。它保存在容器的元数据中。
* 使用 `-p` 发布特定端口，如果该端口已经被暴露出来，则发布它；如果它还没有被暴露，则它会被暴露和发布。docker 不会检查容器端口的正确性。
* 使用 `-P` 时，docker 会自动将所有已经被暴露的端口发布出来。

#### CMD 和 ENTRYPOINT

这两个指令都指定了运行容器时所执行的命令。以下是它们共存的一些规则：

* Dockerfile 至少需要指定一个 CMD 或者 ENTRYPOINT 指令。
* CMD 可以用来指定 ENTRYPOINT 指令的参数

以下是两者共存时，实际执行命令的格式

 CMD/ENTRYPOINT  | 没有 ENTRYPOINT | ENTRYPOINT entry_exec entry_p1 | ENTRYPOINT ["entry_exec", "entry_p1"]
---|---|---|---|---
没有 CMD | 错误，不允许 | /bin/sh -c entry_exec entry_p1 | entry_exec entry_p1
CMD ["cmd_exec", "cmd_p1"] | cmd_exec cmd_p1 | /bin/sh -c entry_exec entry_p1 cmd_exec cmd_p1 | entry_exec entry_p1 cmd_exec cmd_p1
CMD ["cmd_p1", "cmd_p2"] | cmd_p1 cmd_p2 | /bin/sh -c entry_exec entry_p1 cmd_p1 cmd_p2 | entry_exec entry_p1 cmd_p1 cmd_p2
CMD cmd_exec cmd_p1 | /bin/sh -c cmd_exec cmd_p1 | /bin/sh -c entry_exec entry_p1 cmd_exec cmd_p1 | entry_exec entry_p1 cmd_exec cmd_p1
备注 | 只有 CMD 时，执行 CMD 定义的指令 | CMD 和 ENTRYPOINT 都存在时，CMD 的指令作为 ENTRYPOINT 的参数。

### 构建 Docker 镜像应该遵循的原则

整体原则上，尽量保持镜像功能的明确和内容的精简

要点包括：

1、尽量选取满足需求但较小的基础系统镜像；

2、清理编译生成文件、安装包的缓存等临时文件；

3、安装各个软件的时候要指定准确的版本号，并避免引入不需要的依赖；

4、从安全角度考虑，应用要尽量使用系统的库和依赖；

5、如果安装应用时需要配置一些特殊的环境变量，在安装后要还原不需要保持的变量值；

6、使用Dockerfile创建镜像时，要添加 `.dockerignore` 文件或使用空的工作目录；

### 使用容器时需要避免的一些做法

1、不要在容器中保存数据。

2、将应用打包到镜像再部署，而不是更新到已有容器。

3、不要产生过大的镜像。

4、不要使用单层镜像。

5、不要从运行着的容器上产生镜像。

6、不要只是使用 `latest` 标签。

7、不要在容器内运行超过一个的进程。

8、不要在容器内保存 `credentials`，而是要从外部通过环境变量传入。

9、不要使用 `root` 用户运行容器进程。

10、不要依赖于 IP 地址，而是要从外部通过环境变量传入。




















