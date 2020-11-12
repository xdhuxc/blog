+++
title = "Docker Registry 的搭建和配置"
date = "2017-07-13"
lastmod = "2017-08-20"
tags = [
    "Docker"
]
categories = [
     "技术"
]
+++

本篇博客详细介绍了 Docker Registry 的搭建和配置。

<!--more-->

### 搭建基本的 Docker Registry

> 基于 Docker 镜像方式安装Docker Registry V2。

> 本机为 CentOS 7 虚拟机，Minimal模式安装，IP地址为：192.168.91.128。

> 开发端也为 CentOS 7 虚拟机，Minimal模式安装，IP地址为：192.168.91.129。

#### 安装 docker
依次执行如下命令，安装并启动 Docker
```markdown
yum install -y docker
systemctl enable docker
systemctl start docker
```

#### 获取最新版本的 Docker Registry 容器
> 可去 [官网](https://store.docker.com/images/registry/plans/75b297cc-0ad7-4ccd-8e80-9a30e72ace7e?tab=tags) 查找最新的版本号
直接使用 docker 命令去官方公有镜像仓库中拉取
```markdown
docker pull registry:2.5.2
```

#### 运行容器
> V1 Registry 的仓库目录是：/tmp/registry

> V2 Registry 的仓库目录是：/var/lib/registry

使用如下命令运行容器
```markdown
docker run -d -p 5000:5000 --restart=always -v /opt/registry:/var/lib/registry  --name=registry registry:2.5.2
```

#### 访问 Docker Registry

使用如下命令访问 Docker Registry
```markdown
curl http://192.168.91.128:5000/v2/_catalog
```
如果看到类似如下的JSON格式数据，说明Docker Registry已经运行起来了。
```markdown
{"repositories":[]}
```

#### 推送镜像

推送镜像时报错如下：
```markdown
[root@localhost ~]# docker push 192.168.91.128:5000/busybox:latest
The push refers to a repository [192.168.91.128:5000/busybox]
6a749002dd6a: Retrying in 1 second 
received unexpected HTTP status: 500 Internal Server Error
```

使用 `docker logs registry` 命令查看日志，发现没有创建目录的权限
```markdown
time="2017-10-30T14:14:01Z" level=error msg="response completed with error" err.code=unknown err.detail="filesystem: mkdir /var/lib/registry/docker: permission denied" err.message="unknown error" go.version=go1.6.4 
```

解决：在启动命令中加入 `--privileged=true` 参数，即使用如下命令启动容器
```markdown
docker run -d --privileged=true -p 5000:5000 --restart=always -v /opt/registry:/var/lib/registry  --name=registry registry:2.5.2
```
此时，可以正确地上传镜像了
```markdown
[root@localhost ~]# docker push 192.168.91.128:5000/busybox:latest
The push refers to a repository [192.168.91.128:5000/busybox]
0271b8eebde3: Pushed 
latest: digest: sha256:91ef6c1c52b166be02645b8efee30d1ee65362024f7da41c404681561734c465 size: 527
```

#### 拉取镜像

直接使用 `docker pull` 命令拉取镜像即可，如下所示：
```markdown
[root@localhost registry]# docker pull 192.168.91.128:5000/busybox:latest
Trying to pull repository 192.168.91.128:5000/busybox ... 
latest: Pulling from 192.168.91.128:5000/busybox
03b1be98f3f9: Pull complete 
Digest: sha256:030fcb92e1487b18c974784dcc110a93147c9fc402188370fbfd17efabffc6af
```

### 带权限访问 Docker Registry
> 控制registry的使用权限，使其只有在登录用户名和密码之后才能使用。

1、创建用户名和密码

可以通过 `htpasswd` 来生成 `registry` 的用户名和密码文件

依次执行如下命令：
```markdown
[root@localhost ~]# mkdir /etc/registry/auth/
[root@store registry]# docker run --entrypoint htpasswd registry:2.5.2 -Bbn admin Admin123 >> /etc/registry/auth/htpasswd
```
生成了存储用户名和密码的文件
```markdown
[root@store auth]# pwd
/etc/registry/auth
[root@store auth]# ls
htpasswd
```
2、启动Registry容器

现在使用如下命令启动容器（注意命令参数之间的空格）
```markdown
docker run -d \
    --privileged=true \
    -p 5000:5000 \
    --restart=always \
    --name=registry \
    -v /etc/registry/auth/:/auth/ \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \ #此处为相对路径
    -v /opt/registry/:/var/lib/registry/ \
    registry:2.5.2  
```
此时，访问仓库时出现错误，需要登录才能访问
```markdown
[root@store ~]# curl http://192.168.91.128:5000/v2/_catalog|python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   134  100   134    0     0  52755      0 --:--:-- --:--:-- --:--:-- 67000
{
    "errors": [
        {
            "code": "UNAUTHORIZED",
            "detail": [
                {
                    "Action": "*",
                    "Name": "catalog",
                    "Type": "registry"
                }
            ],
            "message": "authentication required"
        }
    ]
}
```
没有登录时，push时提示如下：
```markdown
[root@store ~]# docker push 192.168.91.128:5000/busybox:latest
The push refers to a repository [192.168.91.128:5000/busybox]

no basic auth credentials
```
没有登录时，pull时提示如下：
```markdown
[root@store ~]# docker pull 192.168.91.128:5000/busybox:latest
Trying to pull repository 192.168.91.128:5000/busybox ... 
Pulling repository 192.168.91.128:5000/busybox
Error: image busybox:latest not found
```
登陆后即可进行正常的 `push` 和 `pull` 操作
```markdown
[root@store ~]# docker login 192.168.91.128:5000
Username: admin
Password: 
Login Succeeded
[root@store ~]# docker pull 192.168.91.128:5000/busybox:latest
Trying to pull repository 192.168.91.128:5000/busybox ... 
latest: Pulling from 192.168.91.128:5000/busybox
03b1be98f3f9: Pull complete 
Digest: sha256:030fcb92e1487b18c974784dcc110a93147c9fc402188370fbfd17efabffc6af
```
访问镜像仓库信息时，使用如下命令：
> 也可以这样使用：`curl -u admin:Admin123 http://192.168.91.128:5000/v2/_catalog|python -m json.tool`
```markdown
[root@store ~]# curl --user admin:Admin123 http://192.168.91.128:5000/v2/_catalog|python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    29  100    29    0     0   4969      0 --:--:-- --:--:-- --:--:--  5800
{
    "repositories": [
        "busybox"
    ]
}
```

也可以通过宿主机浏览器访问镜像仓库，在弹出的认证对话框中输入正确的用户名和密码，登陆后即可看到所需信息。

### 使用 API 访问Docker Registry

1、查询注册服务器中的仓库
```markdown
[root@localhost ~]# curl http://192.168.91.128:5000/v2/_catalog
{"repositories":["busybox","nginx","phpmyadmin"]}
```

2、查询某个仓库中镜像的版本
```markdown
[root@localhost ~]# curl http://192.168.91.128:5000/v2/busybox/tags/list
{"name":"busybox","tags":["latest","1.2.1"]}
```

### [多用户 Docker 仓库创建安全认证和应用](http://blog.csdn.net/dream_an/article/details/58005324)

1、安装 docker，下载 registry 镜像
```markdown
yum install -y docker
systemctl start docker
docker pull registry:2.5.2
```

2、在服务器端创建自定义签发的CA证书
执行以下命令：
```markdown
mkdir -p /etc/registry/certs && openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout /etc/registry/certs/domain.key \
    -x509 -days 365 -out /etc/registry/certs/domain.crt
```
填写如下信息
```markdown
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:ShanxiSheng
Locality Name (eg, city) [Default City]:ShangluoShi
Organization Name (eg, company) [Default Company Ltd]:Xdhuxc
Organizational Unit Name (eg, section) []:Xdhuxc
Common Name (eg, your name or your server's hostname) []:store.xdhuxc.com
Email Address []:xdhuxc@163.com
```
在 `/etc/registry/certs` 目录下生成了自定义签发的CA证书
```markdown
[root@store certs]# pwd
/etc/registry/certs
[root@store certs]# ls
domain.crt  domain.key
```

3、添加多用户信息，创建仓库的使用者用户名和密码
> 添加多个 docker 仓库使用者的用户名和其密码

```markdown
docker run --entrypoint htpasswd registry:2.5.2 -Bbn admin Admin123 >> /etc/registry/auth/htpasswd
docker run --entrypoint htpasswd registry:2.5.2 -Bbn root Root123 >> /etc/registry/auth/htpasswd
docker run --entrypoint htpasswd registry:2.5.2 -Bbn xdhuxc Xdhuxc123 >> /etc/registry/auth/htpasswd
```

4、启动 Docker Registry 容器
使用如下命令启动 Docker Registry 容器
```markdown
docker run -d \
    -p 5000:5000 \
    --restart=always \
    --name registry \
    -v /etc/registry/auth:/auth \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -v /etc/registry/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    registry:2.5.2
```

5、通过 sftp 或者 scp 将远程仓库服务器端的 domain.crt 复制到开发端指定的位置

对于 Ubuntu 系统
```markdown
mkdir -p ~/certs.d/store.xdhuxc.com:5000
cp ~/domain.crt /etc/docker/certs.d/store.xdhuxc.com:5000/ca.crt
```
对于 Redhat 系统
```markdown
cp ~/domain.crt /usr/local/share/ca-certificates/store.xdhuxc.com.crt
```
对于 CentOS 系统
```markdown
[root@localhost ~]# scp root@192.168.91.128:/etc/registry/certs/domain.crt /etc/pki/ca-trust/source/anchors/
The authenticity of host '192.168.91.128 (192.168.91.128)' can't be established.
ECDSA key fingerprint is SHA256:Db3KNpRrupfzz8n9hvx0ZqCKMVI17+1oHGzWxT6gShA.
ECDSA key fingerprint is MD5:4d:dc:06:bd:da:a9:fa:e4:ba:f9:02:9e:bd:7e:79:a1.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.91.128' (ECDSA) to the list of known hosts.
root@192.168.91.128's password: 
domain.crt                                                                   100% 2163     1.7MB/s   00:00    
[root@localhost ~]# /bin/update-ca-trust extract
```

```markdown
[root@localhost ~]# scp root@192.168.91.128:/etc/registry/certs/domain.crt /etc/docker/certs.d/
root@192.168.91.128's password: 
domain.crt                                                                                                                               100% 2163   746.3KB/s   00:00    
[root@localhost ~]# /bin/update-ca-trust extract
```

6、从官网下载镜像，重新标记，推送至私有仓库

1）从dockerhub下载镜像
```markdown
[root@localhost ~]# docker pull alpine
Using default tag: latest
Trying to pull repository docker.io/library/alpine ... 
latest: Pulling from docker.io/library/alpine
b56ae66c2937: Pull complete 
Digest: sha256:b40e202395eaec699f2d0c5e01e6d6cb8e6b57d77c0e0221600cf0b5940cf3ab
```

2）重新标记镜像
```markdown
[root@localhost ~]# docker tag docker.io/alpine:latest store.xdhuxc.com:5000/alpine:1.1.0
```

3）推送至私有仓库
```markdown
[root@localhost ~]# docker push store.xdhuxc.com:5000/alpine:1.1.0
```

此时，终端显示如下：
```markdown
The push refers to a repository [store.xdhuxc.com:5000/alpine]

no basic auth credentials
```

4、登录私有的Docker Registry
```markdown
[root@localhost ~]# docker login -u admin -p Admin123 store.xdhuxc.com:5000
Login Succeeded
```

5、此时，可以推送镜像至私有仓库
```markdown
[root@localhost ~]# docker push store.xdhuxc.com:5000/alpine:1.1.0
The push refers to a repository [store.xdhuxc.com:5000/alpine]
2aebd096e0e2: Layer already exists 
1.1.0: digest: sha256:a09e6318d74f23fe68bad84259fedf5e6ce02c38537336419ee5e9abe10aa2af size: 528
```

6、也可以从仓库中拉取镜像到本地
```markdown
[root@localhost ~]# docker pull store.xdhuxc.com:5000/alpine:1.1.0
Trying to pull repository store.xdhuxc.com:5000/alpine ... 
1.1.0: Pulling from store.xdhuxc.com:5000/alpine
b56ae66c2937: Pull complete 
Digest: sha256:a09e6318d74f23fe68bad84259fedf5e6ce02c38537336419ee5e9abe10aa2af
```

退出登陆后，就不能再拉取私有仓库中的镜像了
```markdown
[root@localhost ~]# docker logout store.xdhuxc.com:5000
Remove login credentials for store.xdhuxc.com:5000
[root@localhost ~]# docker pull store.xdhuxc.com:5000/alpine:1.1.0
Trying to pull repository store.xdhuxc.com:5000/alpine ... 
Pulling repository store.xdhuxc.com:5000/alpine
Error: image alpine:1.1.0 not found
```

7、使用 HTTP API V2 在开发端访问镜像仓库
没有附加登录用户信息时，终端输出如下：
```markdown
[root@localhost certs.d]# curl https://store.xdhuxc.com:5000/v2/alpine/tags/list | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   138  100   138    0     0    990      0 --:--:-- --:--:-- --:--:--  1000
{
    "errors": [
        {
            "code": "UNAUTHORIZED",
            "detail": [
                {
                    "Action": "pull",
                    "Name": "alpine",
                    "Type": "repository"
                }
            ],
            "message": "authentication required"
        }
    ]
}
```
使用 HTTP 协议和 HTTPS 协议访问镜像仓库，结果是不同的
```markdown
[root@localhost ~]# cat /etc/docker/daemon.json 
{}
[root@localhost ~]# curl -u admin:Admin123 http://store.xdhuxc.com:5000/v2/_catalog | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    14    0    14    0     0   1722      0 --:--:-- --:--:-- --:--:--  2000
No JSON object could be decoded
[root@localhost ~]# curl -u admin:Admin123 https://store.xdhuxc.com:5000/v2/_catalog | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    28  100    28    0     0    193      0 --:--:-- --:--:-- --:--:--   194
{
    "repositories": [
        "alpine"
    ]
}
```

附带登录用户信息访问时，可以正确访问。
```markdown
[root@localhost ~]# curl -u admin:Admin123 https://store.xdhuxc.com:5000/v2/_catalog|python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    28  100    28    0     0    196      0 --:--:-- --:--:-- --:--:--   198
{
    "repositories": [
        "alpine"
    ]
}
```
查看镜像信息
```markdown
[root@localhost ~]# curl -u admin:Admin123 https://store.xdhuxc.com:5000/v2/alpine/tags/list | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    35  100    35    0     0    282      0 --:--:-- --:--:-- --:--:--   284
{
    "name": "alpine",
    "tags": [
        "1.1.0"
    ]
}
```

### 相关问题
1、如果没有在开发端 `/etc/hosts` 中添加 Docker Registry 所在主机IP地址和域名的对应关系，会报如下错误：
```markdown
[root@localhost tls]# docker push store.xdhuxc.com:5000/nginx:1.1.0
The push refers to a repository [store.xdhuxc.com:5000/nginx]
Get https://store.xdhuxc.com:5000/v1/_ping: dial tcp: lookup store.xdhuxc.com on 192.168.91.2:53: no such host
```

2、此时，在浏览器中无法使用域名(store.xdhuxc.com)访问镜像仓库，也就是访问地址 `https://store.xdhuxc.com:5000/v2/_catalog`，将会出现 `找不到 store.xdhuxc.com 的服务器 DNS 地址。`，在Windows系统的 `C:\Windows\System32\drivers\etc\hosts`中添加IP地址和域名的对应关系，便可以使用域名访问了；但是可以使用IP地址直接访问镜像仓库，访问地址为：`https://192.168.91.128:5000/v2/_catalog`，均需要输入正确的用户名和密码。

3、使用自签署的证书后，登录时，报错如下：
```markdown
[root@store auth]# docker login store.xdhuxc.com:5000
Username: admin
Password: 
Error response from daemon: Get https://store.xdhuxc.com:5000/v1/users/: x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "store.xdhuxc.com")
```
可能是因为将自签署的CA证书放到了 `/etc/pki/ca-trust/source/anchors/` 目录下，然而，docker有自己的证书存放目录，路径为： `/etc/docker/certs.d/`。所以，将自签署的CA证书复制到开发端的 `/etc/docker/certs.d` 目录下，然后重启docker进程。
另外，根据官方资料，可以在 `/etc/docker/certs.d` 目录下创建 `store.xdhuxc.com:5000` 目录，将CA证书复制到该目录下即可，无需重启docker进程。


### 使用Nginx代理，域名访问 Docker Registry

可以使用 `Nginx` 为 `docker` 私有仓库做反向代理，以便使其可以在外网访问

启动 `registry` 容器的命令为：
```markdown
docker run -d \
    --privileged=true \
    -p 5000:5000 \
    -v /home/xdhuxc/registry:/var/lib/registry \
    --name=registry \
    registry:2.6.2
```

启动 `nginx` 容器的命令为：
```markdown
docker run -d \
    --privileged=true \
    -p 80:80 \
    -v /home/xdhuxc/nginx/conf:/etc/nginx \
    --name=nginx \
    nginx:1.13.7
```

`nginx` 的配置为：
```markdown
server {
    listen       80;
    server_name  dockerhub.yonyoucloud.com;

    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        auth_basic off;
	    proxy_pass http://192.168.91.128:5000;
    }

    location /_ping {
 
        auth_basic off;
        proxy_pass http://192.168.91.128:5000;
    }
	
    location /v1/_ping/ {
	
        auth_basic off;
        proxy_pass http://192.168.91.128:5000;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
为镜像打标签
```markdown
docker tag docker.io/registry:2.6.2 dockerhub.yonyoucloud.com/registry:2.6.2
```
推送至私有镜像仓库
```markdown
docker push dockerhub.yonyoucloud.com/registry:2.6.2
```

推送镜像时，报错如下：
```markdown
error parsing HTTP 413 response body: invalid character '<' looking for beginning of value: "<html>\r\n<head><title>413 Request Entity Too Large</title></head>\r\n<body bgcolor=\"white\">\r\n<center><h1>413 Request Entity Too Large</h1></center>\r\n<hr><center>nginx/1.13.7</center>\r\n</body>\r\n</html>\r\n"
```
解决：

在 nginx.conf 中添加如下语句，重启 nginx 进程或容器
```markdown
client_max_body_size 0; #不限制上传大型镜像
chunked_transfer_encoding on;  required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
```

/etc/docker目录下daemon.json的配置
```markdown
[root@xdhuxc docker]# cat daemon.json
{
	"dns":["127.0.0.1","8.8.8.8","192.168.91.2"],
	"storage-driver": "devicemapper",
	"insecure-registries": ["0.0.0.0/0"]
}
```

## 参考资料

1、https://docs.docker.com/registry/deploying/#basic-configuration

2、http://blog.csdn.net/gqtcgq/article/details/51163558

3、http://blog.csdn.net/dream_an/article/details/58005324

4、http://blog.csdn.net/qq245671051/article/details/69487321

5、http://blog.csdn.net/felix_yujing/article/details/51564739

6、http://blog.csdn.net/renhuailin/article/details/50461651



