+++
title = "Harbor 镜像仓库的安装和使用"
date = "2017-07-10"
lastmod = "2017-08-20"
description = ""
tags = [
    "Docker",
    "Harbor"
]
categories = [
     "技术"
]
+++

本篇博客详细介绍了 Harbor 的安装，配置和使用过程。

<!--more-->

### 安装环境
> CentOS 7，Minimal模式安装

1、Python 2.7 及以上版本

2、Docker engine 1.10 及以上版本

3、Docker Compose 1.6.0 及以上版本


### 安装配置
1、从 `https://github.com/vmware/harbor` 上下载 `habor` 的离线安装版并解压
```markdown
wget https://github.com/vmware/harbor/releases/download/v1.2.2/harbor-offline-installer-v1.2.2.tgz
tar -xvf harbor-offline-installer-v1.2.2.tgz
```
2、修改配置文件
> 修改habor.cfg，将hostname改为本机IP地址（192.168.244.135）和自定义端口号（8090）
```markdown
## Harbor的配置文件

#The IP address or hostname to access admin UI and registry service.
#DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname = 192.168.244.135:8090
```

> 修改docker-compose.yml，将 nginx 的代理端口映射由 `80:80` 改为 `8090:80`
```
  proxy:
    image: vmware/nginx-photon:1.11.13
    container_name: nginx
    restart: always
    volumes:
      - ./common/config/nginx:/etc/nginx:z
    networks:
      - harbor
    ports:
      - 8090:80
      - 443:443
      - 4443:4443
    depends_on:
      - mysql
      - registry
      - ui
      - log
    logging:
      driver: "syslog"
      options:
        syslog-address: "tcp://127.0.0.1:1514"
        tag: "proxy"
networks:
  harbor:
    external: false
```
3、初始化安装脚本和配置文件
```markdown
./prepare
```
4、执行安装脚本，使用root用户执行的，因为默认的模板中有很多文件目录权限只有root用户才有权限。
```markdown
./install.sh
```
5、访问，使用默认的用户名和密码：admin/Harbor12345
```markdown
http://192.168.244.135:8090
```

### 基本使用

#### 注意事项

1、在 `harbor.cfg` 中将 `self_registration` 属性设置为 `off`，那么普通用户将无法自己实现注册，只能由管理员创建用户，否则在页面上可以看到注册按钮。

2、只有项目管理员及开发人员的角色才可以 `push` 镜像，其他角色的人员只有 `pull` 镜像的权限。

#### 上传镜像到 Habor 仓库
1、登录到待上传镜像所在的主机，为待上传镜像打上标签，名称按照如下格式：
```markdown
habor_registry_ip_address[:port_number]/project_name/image_name[:tag]
```
使用如下命令登录时，出现了错误：
```markdown
[root@centos_1 ~]# docker login -u admin -p Habor12345 192.168.244.135:8090
Error response from daemon: Get https://192.168.244.135:8090/v1/users/: http: server gave HTTP response to HTTPS client
```
解决：修改docker镜像所在主机的`/etc/docker/daemon.json`文件，在文件中增加如下内容：
```markdown
{
        # 192.168.244.135：搭建的Registry所在主机IP地址
        # 8090：搭建的Registry的端口号
	"insecure-registries":["192.168.244.135:8090"]
}
```
然后重新启动docker守护进程

登录时可能会报如下错误：
```markdown
Error response from daemon: Get http://192.168.244.135:8090/v2/: unauthorized: authentication required
```
解决：使用正确的用户名和密码登录，直接将密码写在命令行中

使用如下命令登录到 Habor registry
```markdown
docker login -u admin -p Harbor12345 192.168.244.135:8090
```

1、为待上传镜像打上标签
```markdown
docker tag docker.io/phpmyadmin/phpmyadmin:latest 192.168.244.135:8090/core/phpmyadmin:1.0.0
```

2、推送镜像到Habor Registry
```markdown
docker push 192.168.244.135:8090/core/phpmyadmin:1.0.0
```

#### 从 Habor 仓库拉取镜像
使用命令直接拉取即可
```markdown
docker pull 192.168.244.135:8090/core/phpmyadmin:1.0.0
```
