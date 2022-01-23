+++
title = "Linux 实用命令总结"
date = "2017-08-18"
lastmod = "2017-08-19"
description = ""
tags = [
    "Linux"
]
categories = [
     "Linux"
]
+++

本篇博客整理了一些 Linux 系统中的实用命令，包括一些组合命令，可以直接修改使用。

<!--more-->

### 杀死某个进程
```markdown
kill -9 $(ps -ef | grep -v grep | grep nginx | awk '{print $2}')
或
ps -ef|grep nginx|grep -v grep|awk '{print $2}'|xargs kill             # 杀死所有Nginx相关进程
或
kill -9 $(netstat -tlnup | grep 80 | awk -F ' ' '{print $7}' | cut -d / -f1) # 杀死占用某个端口的命令
```

### 查找占用某端口的进程
```markdown
netstat -tlnup|grep 35888|awk -F ' ' '{print $7}'|cut -d / -f2
```

### 置空文件
```markdown
echo "" > abc.txt # abc.txt 文件内部会有一个空行
或
: > abc.txt # abc.txt 文件内部没有空行
```

### 切换到 root 用户
```markdown
sudo su - # 由普通用户无密码切换到 root 用户
```

### 查看进程及其子进程
```markdown
# -l：不截断输出，显示整个进程或线程的启动命令
# 3376：要显示的进程 ID
# -a：显示命令行参数
pstree -a -l 3376
```

### 时间格式

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

### 修改系统时区
修改当前机器时间为北京时间：
```markdown
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
修改EDT时区为CST时区
```markdown
timedatectl set-timezone Asia/Shanghai
```

### 获取 UNIX 时间戳
```markdown
date +%s
```

### 删除文件和目录时不删除隐藏的文件和目录
```markdown
rm -r ./*
```
想删除隐藏的目录或文件，需要使用如下的命令
```markdown
ls -a | xargs rm -r 
```
但是不能删除 `.` 和 `..` 目录，所以该命令的返回值为 `1`。

### 字符串替换

1）将当前目录下所有文件中的 `127.0.0.1` 修改为 `172.20.15.29`
```markdown
sed -i "s/127.0.0.1/172.20.15.29/g" ./*
```

2）将当前目录下所有文件中的 `127.0.0.1` 或 `localhost` 修改为 `172.20.15.29`
```markdown
sed -i "s/\(127.0.0.1\|localhost\)/172.20.15.29/g" ./*
```

### 按文件扩展名查找文件

查找当前目录下所有以 `.sh`，`.service`，`.conf`，`.yaml` 结尾的文件
```markdown
find ./ -regex '.*\.sh\|.*\.service\|.*\.conf\|.*\.yaml'
```

### jar 命令

1）将目录打包成war包
```markdown
jar -cvfM0 abc.war */ . # java cvf 打包文件名称 要打包的目录 打包文件保存路径 
-c：创建war包；
-v：显示打包过程；
-f：指定 JAR 文件名，通常这个参数是必须的；
-M：不产生所有项的清单（MANIFEST〕文件，此参数会忽略 -m 参数；
-0：阿拉伯数字0，表示只打包不压缩；
```

2）解压war包
```markdown
jar -xvf abc.war # 解压war包
或
unzip abc.war -d abc/ #解压war包到指定的目录abc
```

### 关闭 selinux
   
到 `/etc/sysconfig` 目录下，修改 selinux 文件，设置 `SELINUX="enforcing"` 为 `disabled` 并重启系统

使用命令 `setenforce 0` 临时关闭 SElinux
使用命令 `getenforce` 或 `sestatus -v `查看 SElinux 的状态

注意：
`/etc/sysconfig/selinux` 文件链接到了文件`/etc/selinux/config`


### firewalld 开放端口

使用如下命令开放端口：
```markdown
firewall-cmd --zone=public --add-port=8004/tcp --permanent 
# --zone #作用域 --add-port=80/tcp  #添加端口，格式为：端口/通讯协议 --permanent  #永久生效，没有此参数重启后失效
firewall-cmd --reload # 重启防火墙
```

### 查看指定进程的相关信息

1、查看如下文件中的内容
```markdown
[root@k8s-master ~]# cat /proc/4561/status
Name:	java
Umask:	0022
State:	S (sleeping)
Tgid:	4561
Ngid:	4561
Pid:	4561
PPid:	1
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	256
Groups:	0 
VmPeak:	19751020 kB
VmSize:	19751020 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	  207228 kB
VmRSS:	  207228 kB
RssAnon:	  192420 kB
RssFile:	   14808 kB
RssShmem:	       0 kB
VmData:	19575744 kB
VmStk:	     132 kB
VmExe:	       4 kB
VmLib:	   16344 kB
VmPTE:	    2336 kB
VmSwap:	       0 kB
Threads:	273
SigQ:	1/513396
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	0000000000000003
SigCgt:	2000000181005ccc
CapInh:	0000000000000000
CapPrm:	0000001fffffffff
CapEff:	0000001fffffffff
CapBnd:	0000001fffffffff
CapAmb:	0000000000000000
Seccomp:	0
Cpus_allowed:	ff,ffffffff,ffffffff
Cpus_allowed_list:	0-71
Mems_allowed:	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
Mems_allowed_list:	0-1
voluntary_ctxt_switches:	4
nonvoluntary_ctxt_switches:	3
```

2、使用如下命令查看
```markdown
ps -T -p 4561          # 2561 为进程 ID。
```



