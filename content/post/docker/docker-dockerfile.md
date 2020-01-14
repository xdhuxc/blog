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



















