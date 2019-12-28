+++
title = "Docker 中常见问题及解决"
date = "2017-08-26"
lastmod = "2017-10-22"
tags = [
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客记录了在使用 docker 的过程中常见的问题及解决方法。

<!--more-->

1、配置的镜像加速地址不生效，可能是因为同时配置了代理的缘故，取消代理的配置，重启 `docker`。

2、使用 `docker save` 保存镜像，在另外的机器上重新加载该镜像，但是当 `docker pull` 该镜像时，还是会从 `docker store` 上拉取，并没有直接使用本地的，很可能是因为 `docker save` 和 `docker load` 时使用的 `docker` 的版本不一致，使用相同版本的 `docker` 试试。

3、在使用 `VMware workstation` 创建的虚拟机中，拉取 `docker` 镜像时，报错如下：
<center>
<img src="/image/docker/questions-and-solutions/WechatIMG639.png" width="800px" height="300px" />
</center>

在一些实验室环境，服务器没有直接连接外网的权限，需要通过网络代理。通常会将网络代理直接配置在 `/etc/environment`、`/etc/profile` 之类的配置文件中，这对于大部分操作都是可行的。然而，`docker` 命令却使用不了这些代理。比如 `docker pull` 时需要从外网下载镜像，就会出现上述错误。

所以，需要我们配置 docker 的网络代理

1）为 `docker` 服务创建一个内嵌的 `systemd` 目录
```markdown
mkdir -p /etc/systemd/system/docker.service.d
```

2）创建 `/etc/systemd/system/docker.service.d/http-proxy.conf` 文件，并添加 `HTTP_PROXY` 环境变量
```markdown
[Service]
Environment="HTTP_PROXY=http://10.3.15.206:8888/" "HTTPS_PROXY=http://10.3.15.206:8888/"
```
`10.3.15.206` 为代理的 `IP` 地址，`8888` 为代理的端口。可以使用 `http` 代理 `https`

3）如果还有内部的不需要使用代理来访问的 `Docker registries`，那么还需要指定 `NO_PROXY` 环境变量
```markdown
[Service]
Environment="HTTP_PROXY=http://[proxy-addr]:[proxy-port]/" "HTTPS_PROXY=http://[proxy-addr]:[proxy-port]/" "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com"
```

4）更新配置并重启docker服务
```markdown
systemctl daemon-reload
systemctl restart docker
```

或者直接在 `/usr/lib/system/system/docker.service` 中添加环境变量，重启加载配置，启动 `docker` 服务。

1）在 `docker.service` 中添加如下环境变量
```markdown
Environment=HTTP_PROXY=http://10.3.15.206:8888/
Environment=HTTPS_PROXY=http://10.3.15.206:8888/
```

2）重新加载配置并重启 `docker` 服务
```markdown
systemctl daemon-reload
systemctl restart docker
```
