+++
title = "Linux 中配置时间同步"
date = "2018-05-19"
lastmod = "2018-08-19"
tags = [
    "Linux",
    "NTP"
]
categories = [
    "Linux"
]
+++

本篇博客记录了 Linux 系统中使用 NTP 进行时间同步的方法。

<!--more-->

1、将Linux系统时钟同步到远程NTP服务器，需要在系统上安装NTP以实现与NTP服务器的自动时间同步，要开始自动时间同步到远程NTP服务器，使用如下命令：
```markdown
timedatectl set-ntp true
```
执行该命令后，报错如下：
```markdown
[root@localhost ~]# timedatectl set-ntp true
Failed to set ntp: NTP not supported.
```
检查本机是否安装了 `ntp` 客户端，如果没有，使用如下命令安装：
```markdown
yum install -y ntp
```

2、重启 `ntp` 客户端并设置开机启动
```markdown
systemctl restart ntpd
systemctl enable ntpd
```

3、可看到 `NTP synchronized` 已经为 `yes`
```markdown
[root@localhost ~]# timedatectl 
      Local time: Sat 2019-12-28 11:52:05 CST
  Universal time: Sat 2019-12-28 03:52:05 UTC
        RTC time: Sat 2019-12-28 03:52:04
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
```

4、要禁用NTP时间同步，使用如下命令：
```markdown
timedatectl set-ntp false
```
