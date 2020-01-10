+++
title = "基于 docker 和原生方式部署 MySQL"
date = "2018-09-19"
lastmod = "2018-10-22"
tags = [
    "MySQL",
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客记录了基于 docker 容器方式和原生方式部署 MySQL 的配置和方式。

<!--more-->

### 启动 MySQL 容器
```markdown
docker run -d \
    --restart=always \
    --privileged=true \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=Xdhuxc123 \
    -v /data/mysql_data:/var/lib/mysql \
    -v /data/disc/script/sql:/docker-entrypoint-initdb.d \
    --name mysql \
    mysql:5.7.21
```
该启动命令包括初始化 `root` 用户、初始化数据库（将待导入的 `sql` 文件放入 `/data/disc/script/sql` 目录下）和持久化数据目录。

### 使用本地配置文件启动 MySQL 容器
```markdown
docker run -d \
    --privileged=true \
    --net host \
    -v /mysql/conf:/etc/mysql/conf.d \
    -v /mysql/data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=123456 \
    --name mysql \
    mysql:latest
```
说明：

* `/mysql/conf`：本地主机 `MySQL` 配置文件 `my.cnf` 存放路径，该路径下存放 `MySQL` 的配置文件 `my.cnf`
* `MYSQL_ROOT_PASSWORD`：容器中 `MySQL` 数据库的 `root` 用户密码
* `/mysql/data`：本地主机上存放 `MySQL` 数据文件的目录

### mysql 容器启动时初始化数据库
> sql文件存放的目录，只能有一个sql文件，必须内含创建数据库和选择数据库命令

```markdown
docker run -d \
    --privileged=true \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=123456 \
    -v /home/xdhuxc/mysql/config:/etc/mysql/conf.d \
    -v /home/xdhuxc/mysql/data:/var/lib/mysql \
    -v /home/xdhuxc/mysql/sql:/docker-entrypoint-initdb.d \
    --name mysql \
    mysql:5.7.21
```

查看 MySQL 官方镜像的 [dockerFile](https://github.com/docker-library/mysql/blob/883703dfb30d9c197e0059a669c4bb64d55f6e0d/5.7/Dockerfile) ，在容器启动时，会执行脚本 `docker-entrypoint.sh`，
```markdown
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
```
而在该脚本中，会遍历 `/docker-entrypoint-initdb.d` 目录下所有的 `.sh` 和 `.sql` 后缀的文件，然后执行。
```markdown
echo
for f in /docker-entrypoint-initdb.d/*; do
	case "$f" in
		*.sh)     echo "$0: running $f"; . "$f" ;;
		*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;; # mysql=( mysql --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" )
		*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
		*)        echo "$0: ignoring $f" ;;
	esac
	echo
done
```

### 在 CentOS 下安装 mysql

> CentOS Linux release 7.3.1611 (Core) 

1、下载 `mysql57-community-release-el7-10.noarch.rpm` 到本地虚拟机，下载地址为：
http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql57-community-release-el7-10.noarch.rpm

使用命令为：
```markdown
wget http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql57-community-release-el7-10.noarch.rpm
```

2、安装 `mysql57-community-release-el7-10.noarch.rpm`，使用命令为：
```markdown
rpm -ivh mysql57-community-release-el7-10.noarch.rpm
```
安装后，会在 `/etc/yum.repos.d` 目录下生成 `mysql-community.repo`，`mysql-community-source.repo`两个yum仓库配置文件。

3、安装 `MySQL Community`，使用命令为：
```markdown
yum install -y mysql-community-server.x86_64
```
安装过程中，会自动安装 `mysql-community-server`，`mysql-community-client`，`mysql-community-common`，`mysql-community-libs`，`net-tools`

4、启动并查看 MySQL 服务

启动MySQL服务，使用命令为：
```markdown
sudo service mysqld start
或
sudo systemctl start mysqld.service
```

查看MySQL服务，使用命令为：
```markdown
sudo service mysqld status
或
sudo systemctl status mysqld.service
```

5、查看 MySQL root 用户的初始密码

使用命令为：
```markdown
sudo grep 'temporary password' /var/log/mysqld.log
```

6、使用MySQL自动生成的密码登录MySQL客户端，
```markdown
mysql -uroot -pyiw,x4po6EsO
```

使用如下命令更改密码
```markdown
alter user 'root'@'localhost' identified by '286X326_h';
```

报如下错误：
```markdown
mysqli_real_connect(): (HY000/1130): Host '172.17.0.2' is not allowed to connect to this MySQL server
```

7、给远程连接的机器授权
```markdown
GRANT ALL PRIVILEGES ON \*.\* TO 'root'@'192.168.1.8' IDENTIFIED BY 'www.linuxidc.com' WITH GRANT OPTION;
```

#### 设置简单密码

在 `Linux` 下，安装完 `MySQL` 并启动后，首先使用临时 `root` 用户密码登录进去；

接着，使用 `alter` 语句修改 `root` 用户密码；

然后，查看 `validate_password_policy` 的值。

`validate_password_policy` 有以下取值：

Policy | Tests Performed
---|---
0 or LOW | Length
1 or MEDIUM | Length; numeric, lowercase/uppercase, and special characters
2 or STRONG | Length; numeric, lowercase/uppercase, and special characters; dictionary file

默认是 `1`，即 `MEDIUM`，所以刚开始设置的密码必须符合长度，且必须含有数字，小写或大写字母，特殊字符。

为了设置简单的密码，需要修改两个全局参数：

1、修改 `validate_password_policy` 参数的值，设置为 `0`

2、修改 `validate_password_length=1`

3、刷新权限

