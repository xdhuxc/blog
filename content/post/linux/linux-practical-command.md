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

想要获得 `2018-05-27` 样式
```markdown
data_str=$(date +"%Y-%m-%d")
echo ${data_str}
```

想要获得 `20180527` 样式
```markdown
data_str=$(date +"%Y%m%d")
echo ${data_str}
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

