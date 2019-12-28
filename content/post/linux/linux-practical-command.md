+++
title = "Linux 实用命令总结"
date = "2017-08-18"
lastmod = "2017-08-19"
description = ""
tags = [
    "Linux"
]
categories = [
     "技术"
]
+++

本篇博客整理了一些 Linux 系统中的实用命令，包括一些组合命令，可以直接修改使用。

<!--more-->

1、杀死某个进程
```markdown
kill -9 $(ps -ef | grep -v grep | grep nginx | awk '{print $2}')
```

2、查找占用某端口的进程
```markdown
netstat -tlnup|grep 35888|awk -F ' ' '{print $7}'|cut -d / -f2
```

3、置空文件
```markdown
echo "" > abc.txt # abc.txt 文件内部会有一个空行
或
: > abc.txt # abc.txt 文件内部没有空行
```

4、切换到 root 用户
```markdown
sudo su - # 由普通用户无密码切换到 root 用户
```

5、查看进程及其子进程
```markdown
# -l：不截断输出，显示整个进程或线程的启动命令
# 3376：要显示的进程 ID
# -a：显示命令行参数
pstree -a -l 3376
```

6、时间格式

1）获得 `2018-04-19` 样式
```markdown
date +"%Y-%m-%d"
```
执行效果如下所示：
```markdown
[root@localhost ~]# date +"%Y-%m-%d"
2018-04-19
```

2）获得 `20180419` 样式
```markdown
date +"%Y%m%d"
```
执行效果如下所示：
```markdown
[root@localhost ~]# date +"%Y-%m-%d"
20180419
```

3）仅包含年月日的日期格式
```markdown
date +"%Y-%m-%d" 
或 
date -d today +"%Y-%m-%d"
```
执行效果如下所示：
```markdown
[root@localhost ~]# date +"%Y-%m-%d"
2018-04-19
[root@localhost ~]# date -d today +"%Y-%m-%d"
2018-04-19
```

4）包含日期和时间的格式
```markdown
date +"%Y-%m-%d %H:%M:%S" 
或 
date +"%Y-%m-%d %T"
或
date -d today +"%Y-%m-%d %T" 
或
date -d today +"%Y-%m-%d %H:%M:%S"
```
执行效果如下所示：
```markdown
[root@localhost ~]# date +"%Y-%m-%d %H:%M:%S"
2018-04-19 11:39:47
[root@localhost ~]# date +"%Y-%m-%d %T"
2018-04-19 11:39:59
[root@localhost ~]# date -d today +"%Y-%m-%d %T" 
2018-04-19 11:40:07
[root@localhost ~]# date -d today +"%Y-%m-%d %H:%M:%S"
2018-04-19 11:40:16
```

7、修改系统时区
修改当前机器时间为北京时间：
```markdown
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
修改EDT时区为CST时区
```markdown
timedatectl set-timezone Asia/Shanghai
```

8、获取 UNIX 时间戳
```markdown
date +%s
```

9、删除文件和目录时不删除隐藏的文件和目录
```markdown
rm -r ./*
```
想删除隐藏的目录或文件，需要使用如下的命令
```markdown
ls -a | xargs rm -r 
```
但是不能删除 `.` 和 `..` 目录，所以该命令的返回值为 `1`。

10、字符串替换

1）将当前目录下所有文件中的 `127.0.0.1` 修改为 `172.20.15.29`
```markdown
sed -i "s/127.0.0.1/172.20.15.29/g" ./*
```

2）将当前目录下所有文件中的 `127.0.0.1` 或 `localhost` 修改为 `172.20.15.29`
```markdown
sed -i "s/\(127.0.0.1\|localhost\)/172.20.15.29/g" ./*
```

11、查找当前目录下所有以 `.sh`，`.service`，`.conf`，`.yaml` 结尾的文件
```markdown
find ./ -regex '.*\.sh\|.*\.service\|.*\.conf\|.*\.yaml'
```
