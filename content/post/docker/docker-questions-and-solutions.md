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


4、推送镜像到私有仓库时报错如下：
```markdown
[root@localhost ~]# docker push 192.168.91.128:5000/busybox:latest
The push refers to a repository [192.168.91.128:5000/busybox]
Get https://192.168.91.128:5000/v1/_ping: http: server gave HTTP response to HTTPS client
```
原因：由提示可知，Docker 客户端使用 HTTPS 协议访问 Docker Registry，Docker Registry 采用 HTTP 协议响应导致的。

解决：在 `/etc/docker/daemon.json` 文件中添加如下内容：
```markdown
{ 
    # 192.168.91.128为镜像仓库所在主机的IP地址
    # 5000为镜像仓库的访问端口号
    "insecure-registries":["192.168.91.128:5000"] 
}
```
然后重新启动 Docker 进程，即可拉取镜像。


5、有些非常大的docker镜像文件，在执行加载命令时，提示“no space left on device ”，如下图所示：
![image](https://thumbnail0.baidupcs.com/thumbnail/ba983385327a8fbf8f0ac2c2046d4e86?fid=766960113-250528-475660698789264&time=1516104000&rt=sh&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-ddjVf5Fp3DawhAuIVoOCL0hDxeA%3D&expires=8h&chkv=0&chkbd=0&chkpc=&dp-logid=367320601015891313&dp-callid=0&size=c710_u400&quality=100&vuk=-&ft=video)
但实际上，docker的工作目录存储空间足够，因此可能是docker限制了最大可加载镜像的大小，在启动 docker 的命令中添加如下参数：
```markdown
--storage-opt dm.basesize=60G --storage-opt dm.loopmetadatasize=10G
```
重启 docker 进程，即可加载大型镜像。


6、从镜像仓库拉取镜像时，报错如下：
```markdown
[root@iuap-vm-23 compose_manage]# docker pull 172.20.26.113:5000/yonyoucloud-middleware/mysql:5.6.37
5.6.37: Pulling from yonyoucloud-middleware/mysql
4b3659249717: Pulling fs layer 
c8583c11f183: Pulling fs layer 
7e7cf3a87134: Pulling fs layer 
00b4cfdf2950: Pulling fs layer 
df7f67bbf575: Pulling fs layer 
b63454f1c8a6: Pulling fs layer 
2af4970f1cf4: Waiting 
07f81aa4b24b: Waiting 
ec3e1cfce710: Waiting 
3cfb59dd6cbd: Waiting 
912915d933d3: Pulling fs layer 
open /data/developercenter_enterprise/data_center/docker/data/tmp/GetImageBlob519470722: no such file or directory
```
重启 docker


7、执行 docker ps 命令无果，重新启动 docker 时，报错如下：
```markdown
[root@k8s-node containers]# systemctl status docker -l
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: activating (start) since Thu 2018-06-28 11:28:45 CST; 59s ago
     Docs: https://docs.docker.com
 Main PID: 15819 (dockerd)
   Memory: 109.3M
   CGroup: /system.slice/docker.service
           ├─ 3109 docker-containerd-shim deaf8701233f2b6168510faddcf25144bf7dcba3351c111c5c70cb0bfa7e681a /var/run/docker/libcontainerd/deaf8701233f2b6168510faddcf25144bf7dcba3351c111c5c70cb0bfa7e681a docker-runc
           ├─15819 /usr/bin/dockerd --storage-driver=devicemapper --insecure-registry 0.0.0.0/0 --graph=/data/docker
           ├─15826 docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0 --start-timeout 2m --state-dir /var/run/docker/libcontainerd/containerd --shim docker-containerd-shim --runtime docker-runc
           └─17205 docker-containerd-shim ac94b262a5df2f482378b79eb9ce130b29f9dc8c4908d56f4633d8f44d776660 /var/run/docker/libcontainerd/ac94b262a5df2f482378b79eb9ce130b29f9dc8c4908d56f4633d8f44d776660 docker-runc

Jun 28 11:28:45 k8s-node systemd[1]: Starting Docker Application Container Engine...
Jun 28 11:28:45 k8s-node dockerd[15819]: time="2018-06-28T11:28:45+08:00" level=warning msg="the \"-g / --graph\" flag is deprecated. Please use \"--data-root\" instead"
Jun 28 11:28:45 k8s-node dockerd[15819]: time="2018-06-28T11:28:45.616437324+08:00" level=info msg="libcontainerd: new containerd process, pid: 15826"
Jun 28 11:28:46 k8s-node dockerd[15819]: time="2018-06-28T11:28:46.622111922+08:00" level=warning msg="failed to rename /data/docker/tmp for background deletion: %!s(<nil>). Deleting synchronously"
Jun 28 11:28:46 k8s-node dockerd[15819]: time="2018-06-28T11:28:46.644187197+08:00" level=warning msg="devmapper: Usage of loopback devices is strongly discouraged for production use. Please use `--storage-opt dm.thinpooldev` or use `man docker` to refer to dm.thinpooldev section."
Jun 28 11:28:46 k8s-node dockerd[15819]: time="2018-06-28T11:28:46.688238156+08:00" level=warning msg="devmapper: Base device already exists and has filesystem xfs on it. User specified filesystem  will be ignored."
```
首先，查看磁盘是否还有空间，

8、构建 docker 镜像时，报错如下：
```markdown
Step 6/7 : ADD src/template /etc/template/
ADD failed: stat /var/lib/docker/tmp/docker-builder488455212/src/template: no such file or directory
```
而实际上，该路径是正确的，可能是将该目录的上级目录放到了 .gitignore 文件中，将该目录放到 .gitignore 文件中包含的目录之外即可。





