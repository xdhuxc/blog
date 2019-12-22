+++
title = "Linux 中常见问题及解决"
date = "2017-10-22"
lastmod = "2017-10-22"
tags = [
    "Linux"
]
categories = [
    "技术"
]
+++

本篇博客记录了在 Linux 系统中常见的问题及解决方法，以备后查。

<!--more-->

1、从 Mac 的终端中 scp VirtualBox 虚拟机中的文件时，报错如下：
```markdown
wanghuans-MacBook-Pro:clickhouse_exporter wanghuan$ scp root@192.168.33.10:/vagrant/clickhouse_exporter ./
root@192.168.33.10: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```
解决：在虚拟机内部，修改 /etc/ssh/sshd_config 文件中如下参数：
```markdown
PermitRootLogin yes
PasswordAuthentication yes
PubkeyAuthentication yes
```
然后重启虚拟机内 sshd 服务。

2、wget: unable to resolve host address
问题：DNS解析的问题
将以下内容加入`/etc/resolv.conf`
```markdown
nameserver 8.8.8.8 #google域名服务器
nameserver 8.8.4.4 #google域名服务器
```
