+++
title = "FastDFS 安装和 Nginx 代理的使用"
date = "2018-09-20"
lastmod = "2018-06-28"
tags = [
    "FastDFS",
    "Nginx",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了 FastDFS 的安装和其配合 Nginx 使用的步骤。

<!--more-->

### 环境信息

服务器信息：

ip | os | role
---|---|---
172.20.15.73 | Centos 7 | tracker
172.20.15.75 | Centos 7 | storage

软件相关信息：

soft | version
---|---
fastdfs | 5.11
libfastcommon | 1.0.39
nginx | 1.12.2
fastdfs-nginx-module | 1.20

### 部署 FastDFS

1、拷贝安装包，并解压

将安装包考本到两台服务器的 `/usr/local/src`，并进入该目录，解压安装包：
```markdown
cd /usr/local/src && unzip fastdfs.zip -d /usr/local/src
cd /usr/local/src/fastdfs
ls | grep 'tar.gz' | xargs -I {} tar -xzvf {} -C /usr/local/src/fastdfs
cd /usr/local/src/fastdfs/nginx/
ls | grep 'tar.gz' | xargs -I {} tar -xzvf {} -C /usr/local/src/fastdfs/nginx
```

2、安装相关依赖

分别进入两台服务器的 `/usr/local/src/fastdfs/fastdfs-lib` 目录，安装相关依赖：
```markdown
rpm -ivh --force /usr/local/src/fastdfs/fastdfs-lib/*
```

3、安装 libfastcommon

通过如下命令，在两台服务器上安装 `libfastcommon`：
```markdown
cd /usr/local/src/fastdfs/libfastcommon-1.0.39/
./make.sh && ./make.sh install
```

看到如下信息，说明安装成功：
```markdown
if [ ! -e /usr/lib/libfastcommon.so ]; then ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so; fi
```

安装完毕之后，设置软连接：

```
ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so
```

4、安装 FastDFS

使用如下命令，在两台服务器上安装 fastdfs：
```markdown
cd /usr/local/src/fastdfs/fastdfs-5.11
./make.sh && ./make.sh install
```

看到如下信息，则说明安装成功：
```markdown
if [ ! -f /etc/fdfs/client.conf.sample ]; then cp -f ../conf/client.conf /etc/fdfs/client.conf.sample; fi
```

拷贝配置文件：
```markdown
cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
```

5、配置 tracker 服务器（172.20.15.73）

创建文件夹，用于存放 Tracker 服务器的相关文件：
```markdown
mkdir -p /data/fastdfs/tracker
```

修改 tracker 的配置文件 `/etc/fdfs/tracker.conf`，修改如下部分：
```markdown
disabled=false
port=22122
base_path=/data/fastdfs/tracker
http.server_port=6666
```

拷贝 tracker 的 systemd 文件至 `/usr/lib/systemd/system/`：
```markdown
cp /usr/local/src/fastdfs/conf/systemd/fdfs_trackerd.service /usr/lib/systemd/system/
```

因为 fdfs_trackerd 等命令在 `/usr/local/bin` 中并没有，而是在 `/usr/bin` 路径下：
```markdown
ln -s /usr/bin/fdfs_trackerd /usr/local/bin
ln -s /usr/bin/stop.sh /usr/local/bin
ln -s /usr/bin/restart.sh /usr/local/bin
```

重启 systemd
```markdown
systemctl daemon-reload
```

启动 tracker：
```markdown
systemctl restart fdfs_trackerd
```

设置开机启动
```markdown
systemctl enable fdfs_trackerd
```

6、配置storage服务器（172.20.15.75）

首先是创建Storage服务器的文件目录，需要注意的是多建了一个目录，因为Storage还需要一个文件存储路径，用于存放接收的文件：
```markdown
mkdir -p /data/fastdfs/storage
mkdir -p /data/fastdfs/storage_data
```

修改 storage 的配置文件 `/etc/fdfs/storage.conf`，修改如下部分：
```markdown
disabled=false
group_name=group1
port=23000
base_path=/data/fastdfs/storage
store_path_count=1
store_path0=/data/fastdfs/storage_data
tracker_server=172.20.15.73:22122
http.server_port=8888
```

拷贝 tracker 的 systemd 文件至 `/usr/lib/systemd/system/`：
```markdown
cp /usr/local/src/fastdfs/conf/systemd/fdfs_storaged.service /usr/lib/systemd/system/
```

配置完成后同样要为 Storage 服务器的启动脚本设置软引用：
```markdown
ln -s /usr/bin/fdfs_storaged /usr/local/bin
```

重启 systemd：
```markdown
systemctl daemon-reload
```

启动tracker：
```markdown
systemctl restart fdfs_storaged
```

设置开机启动
```markdown
systemctl enable fdfs_storaged
```

查看 storage 服务器是否已经登记到 tracker 服务器（也可以理解为 tracker 与 storage 是否整合成功），运行以下命令：
```markdown
/usr/bin/fdfs_monitor /etc/fdfs/storage.conf
```

看到 `tracker server is 172.20.15.73:22122`，tracker 服务器正常启动。

看到 `172.20.15.75 ACTIVE` 字样即可说明 storage 服务器已经成功注册到了 tracker 服务器。

### 安装并配置 Nginx

#### 安装配置 tracker 的 nginx

安装 nginx 依赖包，并安装 nginx：
```markdown
rpm -ivh --force /usr/local/src/fastdfs/nginx/nginx-lib/*
rpm -ivh --force /usr/local/src/fastdfs/nginx/nginx-rpm/*
```

将tracker的nginx的配置文件拷贝到 `/etc/nginx`，端口为 `9988`：
```markdown
cp -r /usr/local/src/fastdfs/conf/nginx-tracker.conf /etc/nginx/nginx.conf
```
 
将 `/usr/local/src/fastdfs/fastdfs-5.11/conf` 中的 `http.conf` 和 `mime.types` 拷贝到 `/etc/fdfs` 目录下：
```markdown
cp -r /usr/local/src/fastdfs/fastdfs-5.11/conf/http.conf /etc/fdfs/
cp -r /usr/local/src/fastdfs/fastdfs-5.11/conf/mime.types /etc/fdfs/
```

创建 `/var/lib/nginx/tmp` 以及日志文件夹：
```markdown
mkdir -p /var/lib/nginx/tmp /data/log/nginx
```

拷贝 nginx 的 systemd 文件至 `/usr/lib/systemd/system/`：
```markdown
cp /usr/local/src/fastdfs/conf/systemd/nginx.service /usr/lib/systemd/system/
```

重启 systemd：
```markdown
systemctl daemon-reload
```

启动 nginx：
```markdown
systemctl start nginx
```

设置开机启动：
```markdown
systemctl enable nginx
```

#### 安装并配置 storage 的 nginx

安装nginx依赖包：
```markdown
rpm -ivh --force /usr/local/src/fastdfs/nginx/nginx-lib/*
```

修改 `/usr/local/src/fastdfs/nginx/fastdfs-nginx-module-1.20/src/config`：
```markdown
ngx_addon_name=ngx_http_fastdfs_module

if test -n "${ngx_module_link}"; then
    ngx_module_type=HTTP
    ngx_module_name=$ngx_addon_name
    ngx_module_incs="/usr/include/fastdfs /usr/include/fastcommon/"
    ngx_module_libs="-lfastcommon -lfdfsclient"
    ngx_module_srcs="$ngx_addon_dir/ngx_http_fastdfs_module.c"
    ngx_module_deps=
    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/etc/fdfs/mod_fastdfs.conf\"'"
    . auto/module
else
    HTTP_MODULES="$HTTP_MODULES ngx_http_fastdfs_module"
    NGX_ADDON_SRCS="$NGX_ADDON_SRCS $ngx_addon_dir/ngx_http_fastdfs_module.c"
    CORE_INCS="$CORE_INCS /usr/include/fastdfs /usr/include/fastcommon/"
    CORE_LIBS="$CORE_LIBS -L/usr/lib -lfastcommon -lfdfsclient"
    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/etc/fdfs/mod_fastdfs.conf\"'"
fi
```

增加依赖包并安装 nginx：
```markdown
cd /usr/local/src/fastdfs/nginx/nginx-1.12.2

./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=root --add-module=/usr/local/src/fastdfs/nginx/fastdfs-nginx-module-1.20/src

make && make install
```

将 nginx 的配置文件拷贝到 `/etc/nginx`，端口为 `9999`：
```markdown
cp -r /usr/local/src/fastdfs/conf/nginx-storage.conf /etc/nginx/nginx.conf
```

将 `/usr/local/src/fastdfs/fastdfs-5.11/conf` 中的 `http.conf` 和 `mime.types` 拷贝到 `/etc/fdfs` 目录下：
```markdown
cp -r /usr/local/src/fastdfs/fastdfs-5.11/conf/http.conf /etc/fdfs/
cp -r /usr/local/src/fastdfs/fastdfs-5.11/conf/mime.types /etc/fdfs/
```

把 `/usr/local/src/fastdfs/nginx/fastdfs-nginx-module-1.20/src` 安装目录下的 `mod_fastdfs.conf` 也拷贝到 /etc/fdfs` 目录下：
```markdown
cp -r /usr/local/src/fastdfs/nginx/fastdfs-nginx-module-1.20/src/mod_fastdfs.conf /etc/fdfs/
```

修改 `/etc/fdfs/mod_fastdfs.conf` 下面的部分：
```markdown
base_path=/data/fastdfs/storage
tracker_server=172.20.15.73:22122
storage_server_port=23000
url_have_group_name = true
store_path0=/data/fastdfs/storage_data
group_count = 3

[group1]
group_name=group1
storage_server_port=23000
store_path_count=1
store_path0=/data/fastdfs/storage_data

[group2]
group_name=group2
storage_server_port=23000
store_path_count=1
store_path0=/data/fastdfs/storage_data

[group3]
group_name=group3
storage_server_port=23000
store_path_count=1
store_path0=/data/fastdfs/storage_data
```

建立 M00 至存储目录的符号连接：
```markdown
ln -s /data/fastdfs/storage_data/data /data/fastdfs/storage_data/data/M00
```

创建 `/var/lib/nginx/tmp` 以及日志文件夹：
```markdown
mkdir -p /var/lib/nginx/tmp /data/log/nginx
```

拷贝 nginx 的 systemd 文件至 `/usr/lib/systemd/system/`：
```markdown
cp /usr/local/src/fastdfs/conf/systemd/nginx.service /usr/lib/systemd/system/
```

重启 systemd：
```markdown
systemctl daemon-reload
```

启动 nginx：
```markdown
systemctl start nginx
```

设置开机启动：
```markdown
systemctl enable nginx
```

#### 以 172.20.15.23 作为 client 进行测试

创建 `/data/fastdfs/client`：
```markdown
mkdir -p /data/fastdfs/client
```

修改 `/etc/fdfs/client.conf`：
```markdown
base_path=/data/fastdfs/client
tracker_server=172.20.15.73:22122
http.tracker_server_port=6666
```

上传文件：
```markdown
/usr/bin/fdfs_test /etc/fdfs/client.conf upload /usr/local/src/fastdfs/test/test.jpeg
```

得到如下结果，说明上传成功：
```markdown
This is FastDFS client test program v5.11

Copyright (C) 2008, Happy Fish / YuQing

FastDFS may be copied only under the terms of the GNU General
Public License V3, which may be found in the FastDFS source kit.
Please visit the FastDFS Home Page http://www.csource.org/
for more detail.

[2018-09-06 20:30:37] DEBUG - base_path=/data/fastdfs/client, connect_timeout=30, network_timeout=60, tracker_server_count=1, anti_steal_token=0, anti_steal_secret_key length=0, use_connection_pool=0, g_connection_pool_max_idle_time=3600s, use_storage_id=0, storage server id count: 0

tracker_query_storage_store_list_without_group:
	server 1. group_name=, ip_addr=172.20.15.75, port=23000

group_name=group1, ip_addr=172.20.15.75, port=23000
storage_upload_by_filename
group_name=group1, remote_filename=M00/00/00/rBQPS1uRHe2AKqfAAAC0cbebd6Q15.jpeg
source ip address: 172.20.15.75
file timestamp=2018-09-06 20:30:37
file size=46193
file crc32=3080419236
example file url: http://172.20.15.75:6666/group1/M00/00/00/rBQPS1uRHe2AKqfAAAC0cbebd6Q15.jpeg
storage_upload_slave_by_filename
group_name=group1, remote_filename=M00/00/00/rBQPS1uRHe2AKqfAAAC0cbebd6Q15_big.jpeg
source ip address: 172.20.15.75
file timestamp=2018-09-06 20:30:37
file size=46193
file crc32=3080419236
example file url: http://172.20.15.75:6666/group1/M00/00/00/rBQPS1uRHe2AKqfAAAC0cbebd6Q15_big.jpeg
```

根据 `/group1/M00/00/00/rBQPS1uP4OOAGfVuAAC0cbebd6Q04_big.jpeg`，在浏览器上查看已经上传的图片：
```markdown
http://172.20.15.73:9988/group1/M00/00/00/rBQPS1uRHe2AKqfAAAC0cbebd6Q15_big.jpeg
```

### 参考资料
https://blog.csdn.net/wlwlwlwl015/article/details/52619851

https://blog.csdn.net/jeikerxiao/article/details/79861850

https://my.oschina.net/wangmengjun/blog/1142982

https://www.jianshu.com/p/e55702bdb2fe

https://naturalwill.github.io/2017/09/25/add-rtmp-module-to-nginx-by-yum/

https://anyof.me/articles/236

http://blog.51cto.com/wangfeng7399/1711589

https://www.jianshu.com/p/00a5961e0bca

https://blog.csdn.net/xuchaovip/article/details/60480557

https://blog.csdn.net/name_is_wl/article/details/52979208

http://www.ityouknow.com/fastdfs/2017/10/10/cluster-building-fastdfs.html

https://www.jianshu.com/p/a88c76caf317

https://www.cnblogs.com/tangwan/p/5425153.html

http://www.ityouknow.com/fastdfs/2017/10/10/cluster-building-fastdfs.html

https://blog.csdn.net/xyang81/article/details/52928230

https://blog.csdn.net/u012453843/article/details/68957209
