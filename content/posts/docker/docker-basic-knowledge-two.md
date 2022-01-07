+++
title = "docker 基础知识（二）"
date = "2017-07-20"
lastmod = "2017-08-25"
tags = [
    "Docker"
]
categories = [
     "Docker"
]
+++

本篇博客介绍了 Docker 容器的一些基础知识和基本原理。

<!--more-->

使用 docker 时，要求 Linux 内核版本必须是 3.10 及以上版本。

docker 容器的状态机：

<center>
<img src="/image/docker/basic-knowledge-two/docker-status.jpg" width="800px" height="300px" />
图1 · docker 容器的状态机
</center>

一个容器在某个时刻可能处于以下几种状态之一：

* created：已经被创建（使用 docker ps -a 命令可以查看），但是还没有启动（使用 docker ps 命令还无法查看）。
* running：运行中。
* paused：容器的进程被暂停了。
* restarting：容器的进程正在重启过程中。
* exited：即 stopped 状态，表示容器之前运行过，但是现在处于停止状态，可以通过 start 命令使其重新进入 running 状态。区别于 created 状态，它是指一个新创建出来的尚未运行过的容器。
* destroyed：容器被删除了，再也不存在了。

### docker stop 和 docker kill 命令的异同

#### docker stop

在 docker stop 命令执行的时候，会先向容器中 PID 为 1 的进程（systemd）发送系统信号 SIGTERM，然后等待容器中的应用程序终止执行。如果等待时间达到设定的超时时间（默认为：10 秒，用户可以指定特定的超时时长），会继续发送 SIGKILL 的系统信号强行 KILL 掉进程。在容器中的应用程序，可以选择忽略和不处理 SIGTERM 信号，不过一旦达到超时时间，程序就会被系统强行 kill 掉，因为 SIGKILL 信号是直接发往系统内核的，应用程序没有机会去处理它。

例如，运行 `docker stop mysql -t 20` 命令后：（使用 docker events 命令可以查看实时 docker 事件）
```markdown
2018-06-27T15:10:50.647582607+08:00 container kill 1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f (image=mysql:5.7.22, name=mysql, signal=15)
2018-06-27T15:10:52.320188793+08:00 container die 1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f (exitCode=0, image=mysql:5.7.22, name=mysql)
2018-06-27T15:10:52.456917929+08:00 network disconnect d007b6118f653475246dec898994a972d2f9a061d01ab5a339977cd70a6887bf (container=1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f, name=bridge, type=bridge)
2018-06-27T15:10:52.524146055+08:00 volume unmount 845a3048d2138831a4e6e542dfd01794cb6524493839590a37f7936942890742 (container=1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f, driver=local)
2018-06-27T15:10:52.537384805+08:00 container stop 1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f (image=mysql:5.7.22, name=mysql)
```
能看到：

1、首先 docker 向容器发出 SIGTERM 信号（signal = 15）。

2、等待 20 秒（01:18 到 01:38）。

3、再发送 SIGKILL 系统信号（signal = 9）。

4、然后容器就被杀死了（die）。

#### docker kill
而 docker kill 命令会直接发出 SIGKILL 的系统信号，以强行终止容器中程序的运行。

运行 `docker kill mysql` 命令后：
```markdown
2018-06-27T15:22:41.785107639+08:00 container kill 1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f (image=mysql:5.7.22, name=mysql, signal=9)
2018-06-27T15:22:42.003164753+08:00 container die 1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f (exitCode=137, image=mysql:5.7.22, name=mysql)
2018-06-27T15:22:42.214308124+08:00 network disconnect d007b6118f653475246dec898994a972d2f9a061d01ab5a339977cd70a6887bf (container=1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f, name=bridge, type=bridge)
2018-06-27T15:22:42.294946239+08:00 volume unmount 845a3048d2138831a4e6e542dfd01794cb6524493839590a37f7936942890742 (container=1cf29caed8786e1e165e5b3e3dadedf17d1846b40792e4330a6026ec03002a2f, driver=local)
```
可见直接发出的是 SIGKILL 信号，容器立刻就被杀掉了。

### docker 平台的基本构成

Docker 平台基本上由三部分组成：

* 客户端：用户使用 docker 提供的工具（CLI 以及 API等）来构建、上传镜像并发布命令来创建和启动容器。
* docker 主机：从 docker 镜像仓库拉取镜像并启动容器。
* docker 镜像仓库：用于保存镜像，并提供镜像的上传和下载。

### docker 镜像

在传统环境中，软件在运行之前需要经过 代码开发 -> 运行环境准备 -> 安装软件 -> 运行软件 等环节；

在容器环境中，中间的两个环节被镜像制作过程代替了，也就是说，镜像的制作过程也包括运行环境准备和安装软件等两个主要环节，以及一些其他环节。

镜像是动态的容器的静态表示，包括容器所要运行的应用代码以及运行时的配置。docker 镜像包括一个或多个只读层（read-only layers），因此，镜像一旦被创建就再也不能被修改了。一个运行着的 docker 容器是一个镜像的实例。从同一个镜像中运行的容器包含有相同的应用代码和运行时依赖。但是不像镜像是静态的，每个运行着的容器都有一个可写层（writable layer，也称为 container layer），位于底下的若干只读层之上，运行时的所有变化，包括对数据和文件的写和更新，都会保存在这个层中。因此，从同一个镜像运行的多个容器包含了不同的容器层。

创建一个 docker 镜像的两种方式：

* 创建一个容器，运行若干命令，然后使用 docker commit 命令来生成一个新的镜像。不建议使用这种方式。
* 创建一个 Dockerfile，然后使用 docker build 命令来创建一个镜像。建议使用这种方式。

docker build 命令的过程：

* 容器镜像包括元数据和文件系统，其中文件系统是指对基础镜像的文件系统的修改，元数据不影响文件系统，只是会影响容器的配置。
* 每个步骤都会生成一个新的镜像，新的镜像与上一次的镜像相比，要么元数据有了变化，要么文件系统有了变化，而多加了一层。
* docker 在需要执行指令时，通过创建临时镜像，运行指定的命令，再通过 docker commit 来生成新的镜像。
* docker 会将中间镜像都保存在缓存中，这样将来如果能直接使用的话，就不需要再从新创建了。


#### 镜像分层和容器层

一个 docker 镜像是基于基础镜像的多层叠加，最终构成了容器的 rootfs（根文件系统）。当 docker 创建了一个容器时，它会在基础镜像的容器层之上添加一层新的薄薄的可写容器层。接下来，所有对容器的变化，比如写新的文件，修改已有文件和删除文件，都只会作用在这个容器层之中。因此，通过不复制完整的 rootfs，docker 减少了容器所占用的空间，以及减少了容器启动所需时间。

#### COW 和镜像大小

COW，copy-on-write，写时复制技术，一方面带来了容器启动的快捷，另一方也造成了容器镜像大小的增加。每一次 `RUN` 命令都会在镜像上增加一层，每一层都会占用磁盘空间。

例如，在 Ubuntu 14.04 基础镜像中运行 `RUN apt-get upgrade` 会在保留基础层的同时再创建一个新层来放所有新的文件，而不是修改老的文件。因此，新的镜像大小会超过直接在老的文件系统上做更新时的文件大小。所以，为了减少镜像大小起见，所有文件相关的操作，比如删除、释放和移动等，都需要尽可能地放在一个 `RUN` 指令中进行。

#### 镜像的内容

容器镜像的内容，其实是一个 json 文件加上 tar 包。

1、将镜像导出为 tar 文件。
```markdown
[root@xdhuxc xdhuxc]# docker images|grep nginx
nginx                                                        latest              3f8a4339aadd        6 months ago        108MB
[root@xdhuxc xdhuxc]# docker save nginx:latest -o nginx.tar
[root@xdhuxc xdhuxc]# ls
nginx.tar
```

2、解压 nginx.tar 文件
```markdown
[root@xdhuxc xdhuxc]# mkdir nginx
[root@xdhuxc xdhuxc]# tar -xf nginx.tar -C nginx
tar: manifest.json: implausibly old time stamp 1970-01-01 08:00:00
tar: repositories: implausibly old time stamp 1970-01-01 08:00:00
[root@xdhuxc xdhuxc]# ll nginx
total 28
-rw-r--r-- 1 root root 5835 Dec 27  2017 3f8a4339aadda5897b744682f5f774dc69991a81af8d715d37a616bb4c99edf5.json
drwxr-xr-x 2 root root 4096 Dec 27  2017 ae57c7dd09b742b01fba1af0f40503e6f7e581a7cda614f0c36fa81af4a02129
drwxr-xr-x 2 root root 4096 Dec 27  2017 b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa
drwxr-xr-x 2 root root 4096 Dec 27  2017 b6eb01f37fe4e3091b0230a181e38d2fa37b4169daab10f85782b92e7437b027
-rw-r--r-- 1 root root  355 Jan  1  1970 manifest.json
-rw-r--r-- 1 root root   88 Jan  1  1970 repositories
```
其中的 repositories 文件的内容，就是镜像名称、版本、最上层的 layer 的名称。
```markdown
[root@xdhuxc xdhuxc]# cat nginx/repositories | python -m json.tool
{
    "nginx": {
        "latest": "b6eb01f37fe4e3091b0230a181e38d2fa37b4169daab10f85782b92e7437b027"
    }
}
```
而 manifest.json 文件中保存的是镜像的元数据，包括真正包含元数据的 json 文件的名称及每一层的名称、标签等。
```markdown
[root@xdhuxc xdhuxc]# cat nginx/manifest.json | python -m json.tool
[
    {
        "Config": "3f8a4339aadda5897b744682f5f774dc69991a81af8d715d37a616bb4c99edf5.json",
        "Layers": [
            "b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa/layer.tar",
            "ae57c7dd09b742b01fba1af0f40503e6f7e581a7cda614f0c36fa81af4a02129/layer.tar",
            "b6eb01f37fe4e3091b0230a181e38d2fa37b4169daab10f85782b92e7437b027/layer.tar"
        ],
        "RepoTags": [
            "nginx:latest"
        ]
    }
]
```
3f8a4339aadda5897b744682f5f774dc69991a81af8d715d37a616bb4c99edf5.json 文件真正地包含镜像的所有元数据。
```markdown
[root@xdhuxc xdhuxc]# cat nginx/3f8a4339aadda5897b744682f5f774dc69991a81af8d715d37a616bb4c99edf5.json | python -m json.tool
{
    "architecture": "amd64",
    "config": {
        "ArgsEscaped": true,
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Cmd": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "Domainname": "",
        "Entrypoint": null,
        "Env": [
            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
            "NGINX_VERSION=1.13.8-1~stretch",
            "NJS_VERSION=1.13.8.0.1.15-1~stretch"
        ],
        "ExposedPorts": {
            "80/tcp": {}
        },
        "Hostname": "",
        "Image": "sha256:dac2e319f33250a5b2eea74443b35d7fb05a382a95d21670f2628b92ffa023ce",
        "Labels": {
            "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
        },
        "OnBuild": [],
        "OpenStdin": false,
        "StdinOnce": false,
        "StopSignal": "SIGTERM",
        "Tty": false,
        "User": "",
        "Volumes": null,
        "WorkingDir": ""
    },
    "container": "71cc5766414f132cf702e88d8de29527bbc2e151f8499b14fcc3540fd853b86d",
    "container_config": {
        "ArgsEscaped": true,
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Cmd": [
            "/bin/sh",
            "-c",
            "#(nop) ",
            "CMD [\"nginx\" \"-g\" \"daemon off;\"]"
        ],
        "Domainname": "",
        "Entrypoint": null,
        "Env": [
            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
            "NGINX_VERSION=1.13.8-1~stretch",
            "NJS_VERSION=1.13.8.0.1.15-1~stretch"
        ],
        "ExposedPorts": {
            "80/tcp": {}
        },
        "Hostname": "71cc5766414f",
        "Image": "sha256:dac2e319f33250a5b2eea74443b35d7fb05a382a95d21670f2628b92ffa023ce",
        "Labels": {
            "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
        },
        "OnBuild": [],
        "OpenStdin": false,
        "StdinOnce": false,
        "StopSignal": "SIGTERM",
        "Tty": false,
        "User": "",
        "Volumes": null,
        "WorkingDir": ""
    },
    "created": "2017-12-26T18:17:01.106799157Z",
    "docker_version": "17.06.2-ce",
    "history": [
        {
            "created": "2017-12-12T01:44:43.599554271Z",
            "created_by": "/bin/sh -c #(nop) ADD file:f30a8b5b7cdc9ba33a250899308b490baa9f7a9b29d3a85bd16200aa0a28a04a in / "
        },
        {
            "created": "2017-12-12T01:44:43.84546055Z",
            "created_by": "/bin/sh -c #(nop)  CMD [\"bash\"]",
            "empty_layer": true
        },
        {
            "created": "2017-12-12T05:14:40.530307095Z",
            "created_by": "/bin/sh -c #(nop)  LABEL maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>",
            "empty_layer": true
        },
        {
            "created": "2017-12-26T18:14:42.009655355Z",
            "created_by": "/bin/sh -c #(nop)  ENV NGINX_VERSION=1.13.8-1~stretch",
            "empty_layer": true
        },
        {
            "created": "2017-12-26T18:14:42.209098573Z",
            "created_by": "/bin/sh -c #(nop)  ENV NJS_VERSION=1.13.8.0.1.15-1~stretch",
            "empty_layer": true
        },
        {
            "created": "2017-12-26T18:16:59.73279946Z",
            "created_by": "/bin/sh -c set -x \t&& apt-get update \t&& apt-get install --no-install-recommends --no-install-suggests -y gnupg1 \t&& \tNGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \tfound=''; \tfor server in \t\tha.pool.sks-keyservers.net \t\thkp://keyserver.ubuntu.com:80 \t\thkp://p80.pool.sks-keyservers.net:80 \t\tpgp.mit.edu \t; do \t\techo \"Fetching GPG key $NGINX_GPGKEY from $server\"; \t\tapt-key adv --keyserver \"$server\" --keyserver-options timeout=10 --recv-keys \"$NGINX_GPGKEY\" && found=yes && break; \tdone; \ttest -z \"$found\" && echo >&2 \"error: failed to fetch GPG key $NGINX_GPGKEY\" && exit 1; \tapt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/* \t&& dpkgArch=\"$(dpkg --print-architecture)\" \t&& nginxPackages=\" \t\tnginx=${NGINX_VERSION} \t\tnginx-module-xslt=${NGINX_VERSION} \t\tnginx-module-geoip=${NGINX_VERSION} \t\tnginx-module-image-filter=${NGINX_VERSION} \t\tnginx-module-njs=${NJS_VERSION} \t\" \t&& case \"$dpkgArch\" in \t\tamd64|i386) \t\t\techo \"deb http://nginx.org/packages/mainline/debian/ stretch nginx\" >> /etc/apt/sources.list \t\t\t&& apt-get update \t\t\t;; \t\t*) \t\t\techo \"deb-src http://nginx.org/packages/mainline/debian/ stretch nginx\" >> /etc/apt/sources.list \t\t\t\t\t\t&& tempDir=\"$(mktemp -d)\" \t\t\t&& chmod 777 \"$tempDir\" \t\t\t\t\t\t&& savedAptMark=\"$(apt-mark showmanual)\" \t\t\t\t\t\t&& apt-get update \t\t\t&& apt-get build-dep -y $nginxPackages \t\t\t&& ( \t\t\t\tcd \"$tempDir\" \t\t\t\t&& DEB_BUILD_OPTIONS=\"nocheck parallel=$(nproc)\" \t\t\t\t\tapt-get source --compile $nginxPackages \t\t\t) \t\t\t\t\t\t&& apt-mark showmanual | xargs apt-mark auto > /dev/null \t\t\t&& { [ -z \"$savedAptMark\" ] || apt-mark manual $savedAptMark; } \t\t\t\t\t\t&& ls -lAFh \"$tempDir\" \t\t\t&& ( cd \"$tempDir\" && dpkg-scanpackages . > Packages ) \t\t\t&& grep '^Package: ' \"$tempDir/Packages\" \t\t\t&& echo \"deb [ trusted=yes ] file://$tempDir ./\" > /etc/apt/sources.list.d/temp.list \t\t\t&& apt-get -o Acquire::GzipIndexes=false update \t\t\t;; \tesac \t\t&& apt-get install --no-install-recommends --no-install-suggests -y \t\t\t\t\t\t$nginxPackages \t\t\t\t\t\tgettext-base \t&& rm -rf /var/lib/apt/lists/* \t\t&& if [ -n \"$tempDir\" ]; then \t\tapt-get purge -y --auto-remove \t\t&& rm -rf \"$tempDir\" /etc/apt/sources.list.d/temp.list; \tfi"
        },
        {
            "created": "2017-12-26T18:17:00.44958667Z",
            "created_by": "/bin/sh -c ln -sf /dev/stdout /var/log/nginx/access.log \t&& ln -sf /dev/stderr /var/log/nginx/error.log"
        },
        {
            "created": "2017-12-26T18:17:00.662765942Z",
            "created_by": "/bin/sh -c #(nop)  EXPOSE 80/tcp",
            "empty_layer": true
        },
        {
            "created": "2017-12-26T18:17:00.902045007Z",
            "created_by": "/bin/sh -c #(nop)  STOPSIGNAL [SIGTERM]",
            "empty_layer": true
        },
        {
            "created": "2017-12-26T18:17:01.106799157Z",
            "created_by": "/bin/sh -c #(nop)  CMD [\"nginx\" \"-g\" \"daemon off;\"]",
            "empty_layer": true
        }
    ],
    "os": "linux",
    "rootfs": {
        "diff_ids": [
            "sha256:2ec5c0a4cb57c0af7c16ceda0b0a87a54f01f027ed33836a5669ca266cafe97a",
            "sha256:73e2bd4455140950d98430338783415109e4c4dcf955681d334b312b176d964a",
            "sha256:a103d141fc9823f04f30d1e71705001577eab94df7ac594e5e49f64e2e506c8b"
        ],
        "type": "layers"
    }
}
```
而剩余的三个目录则与该镜像的三个 layers 一一对应。（使用 docker inspect nginx:latest）
```markdown
"RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:2ec5c0a4cb57c0af7c16ceda0b0a87a54f01f027ed33836a5669ca266cafe97a",
                "sha256:73e2bd4455140950d98430338783415109e4c4dcf955681d334b312b176d964a",
                "sha256:a103d141fc9823f04f30d1e71705001577eab94df7ac594e5e49f64e2e506c8b"
            ]
}
```
每个目录中的内容为：
```markdown
[root@xdhuxc xdhuxc]# ll nginx/b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa/
total 57072
-rw-r--r-- 1 root root      393 Dec 27  2017 json
-rw-r--r-- 1 root root 58430976 Dec 27  2017 layer.tar
-rw-r--r-- 1 root root        3 Dec 27  2017 VERSION
```
解压 layer.tar 文件，查看其内容
```markdown
[root@xdhuxc xdhuxc]# cd nginx/b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa/
[root@xdhuxc b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa]# mkdir layer
[root@xdhuxc b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa]# tar -xf layer.tar -C layer
[root@xdhuxc b539656cdce57ade73a3019a36addf1b80ae19cc951655ea264c2a6af56d1cfa]# ll layer/
total 76
drwxr-xr-x  2 root root 4096 Dec 10  2017 bin
drwxr-xr-x  2 root root 4096 Nov 19  2017 boot
drwxr-xr-x  2 root root 4096 Dec 10  2017 dev
drwxr-xr-x 28 root root 4096 Dec 10  2017 etc
drwxr-xr-x  2 root root 4096 Nov 19  2017 home
drwxr-xr-x  8 root root 4096 Dec 10  2017 lib
drwxr-xr-x  2 root root 4096 Dec 10  2017 lib64
drwxr-xr-x  2 root root 4096 Dec 10  2017 media
drwxr-xr-x  2 root root 4096 Dec 10  2017 mnt
drwxr-xr-x  2 root root 4096 Dec 10  2017 opt
drwxr-xr-x  2 root root 4096 Nov 19  2017 proc
drwx------  2 root root 4096 Dec 10  2017 root
drwxr-xr-x  4 root root 4096 Dec 10  2017 run
drwxr-xr-x  2 root root 4096 Dec 10  2017 sbin
drwxr-xr-x  2 root root 4096 Dec 10  2017 srv
drwxr-xr-x  2 root root 4096 Nov 19  2017 sys
drwxrwxrwt  2 root root 4096 Dec 10  2017 tmp
drwxr-xr-x 10 root root 4096 Dec 10  2017 usr
drwxr-xr-x 11 root root 4096 Dec 10  2017 var
```
从以上分析可见：

* docker 镜像中主要是 tar 文件包和元数据 json 文件。
* docker 镜像的打包过程，其实就是将每一层对应的文件打包过程，最后组成一个单一的 tar 文件。
* docker 镜像的使用过程，其实就是将一层层的 tar 文件载入到文件系统的过程。
