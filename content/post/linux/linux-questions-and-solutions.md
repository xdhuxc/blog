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

3、使用 `Linux` 服务启动 `confd` 进程，启动时，报错如下：
```markdown
Mar 18 02:26:38 ip-172-27-124-70.ap-southeast-1.compute.internal confd[28240]: 2019-03-18T02:26:38Z ip-172-27-124-70.ap-southeast-1.compute.internal /usr/bin/confd[28240]: FATAL UserHomeNotFound: user home directory not found.
```
解决：
在 `confd.service` （`/usr/lib/systemd/system/confd.service`）中加入如下环境变量
```markdown
[Service]
Environment="HOME=/root"
```
重启 `confd` 服务即可。

4、在 `Linux` 下执行脚本，报如下错误：
```
[root@localhost mesos_install]# ./install.sh -h
-bash: ./install.sh: /bin/bash^M: bad interpreter: No such file or directory
```

解决：安装dos2unix，将DOS格式文本文件转换成Unix格式，使用如下命令：
```
yum install -y dos2unix
```
使用方法：
```
dos2unix filename_1 filename_2 filename_3
```

5、使用curl命令从网络上下载文件时，报错如下：
```
[root@localhost ~]# curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
curl: (35) Peer reports incompatible or unsupported protocol version.
```
解决：

（1）更新curl
```
yum update -y curl
```
更新curl后还是报一样的错误

（2）更新nss nspr
```
yum update -y nss nspr nss-util
```
更新后问题得到解决。

仅更新（1）和仅更新（2）都不起作用

6、`CentOS 7` 虚拟机有网卡，没有 `IP` 地址，进入 `/etc/sysconfig/network-scripts` 目录下，修改 `ifcfg-eth0` 文件

<center>
<img src="/image/linux/questions-and-solutions/WechatIMG622.png" width="800px" height="300px" />
</center>

将其中的 `ONBOOT` 修改为 `yes`，然后使用 `systemctl restart network` 命令重启网络

注意：启动 `Windows` 下 `VMware` 相关的服务

7、

