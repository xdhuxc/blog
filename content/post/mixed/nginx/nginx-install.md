+++
title = "安装 nginx"
date = "2017-10-26"
lastmod = "2017-10-29"
tags = [
    "Nginx"
]
categories = [
    "技术"
]
+++

本篇博客记录了基于源代码和 docker 容器方式部署 nginx 的方法。

<!--more-->

### 基于源码安装 nginx
1、下载 nginx安装包
```markdown
 wget http://nginx.org/download/nginx-1.15.2.tar.gz
```

2、安装如下软件包
```markdown
yum -y install pcre pcre-devel openssl openssl-devel
```

3、编译并安装nginx
```markdown
./configure && make && make install
```

4、检测nginx是否安装成功
```markdown
whereis nginx
```

### 基于 docker 容器部署 nginx
#### 最简单的使用方法
```markdown
docker run -it -p 80:80 --name nginx nginx:latest
```
在浏览器地址栏中输入：
```markdown
192.168.91.128:80
```
即可访问 nginx 欢迎页面

#### 在后台运行 nginx 容器
```markdown
docker run -d -p 80:80 --name nginx nginx:latest
```
如果不加端口映射，能启动容器，但是在终端和浏览器中无法访问，可能是没有默认配置或者默认配置没起作用。

#### 使用自定义配置文件启动 nginx 容器
```markdown
docker run -d \
    --privileded=true \
    -p 80:80
    -v /home/xdhuxc/nginx/logs:/var/log/nginx
    -v /home/xdhuxc/nginx/nginx.conf:/etc/nginx/nginx.conf:rw
    --name nginx
    nginx:latest
    
```

/etc/nginx/nginx.conf 为容器内 nginx 的配置文件，ro 是 readonly 的意思

### nginx 常用命令
1、检测nginx配置文件 nginx.conf 格式是否正确
```markdown
nginx -t
```

2、重新加载 nginx 配置文件
```markdown
nginx -s reload
```

3、重启 nginx 
```markdown
nginx -s reopen
```
4、停止 nginx
```markdown
nginx -s stop
```


### 参考资料

Nginx中文文档 http://www.nginx.cn/doc/
