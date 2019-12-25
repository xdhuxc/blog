+++
title = "配置 SSH 免密登录"
date = "2017-10-17"
lastmod = "2018-01-22"
tags = [
    "SSH"
]
categories = [
    "技术"
]
+++

本篇博客记录了配置多台机器 SSH 免密登录的详细过程，在管理多台服务器时会很有用。

<!--more-->

### 配置 SSH 免密登录

现有三台虚拟机，分别为：centos_3(192.168.244.129)，centos_4(192.168.244.135)，centos_6(192.168.244.136)

1、分别在三台虚拟机的 `/etc/hosts` 文件中添加如下内容：
```markdown
192.168.244.129 centos_3
192.168.244.135 centos_4
192.168.244.136 centos_6
192.168.244.129 zk_master
192.168.244.135 zk_slave1
192.168.244.136 zk_slave2
```
2、在三台机器上分别安装 `openssh`

查看机器上是否安装了`ssh`，使用命令为：
```markdown
rpm -qa|grep openssh
```
如果没有安装，则安装openssh
```markdown
yum install -y openssh-server
```

3、在 `zk_master` 上生成密钥对
```markdown
ssh-keygen -t rsa
```
连续回车会在当前用户的目录下，即 `/root/.ssh`，生成隐藏目录 `.ssh`，该目录下有私钥文件 `id_rsa`，公钥文件 `id_rsa.pub`

4、把 `zk_master` 的公钥追加到 `authorized_keys` 文件里
```markdown
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
```

5、分别在 `zk_slave1`，`zk_slave2` 机器上按照上述步骤安装 `openssh`，生成密钥对。

6、使用 `root` 用户登陆 `zk_slave1`，把 `zk_slave1` 的公钥远程复制到 `zk_master` 机器上,然后追加到 `zk_master` 机器上的 `authorized_keys`
```markdown
# copy到zk_master的root目录下，输入zk_master的密码
scp /root/.ssh/id_rsa.pub root@192.168.244.135:/root/
# 登陆zk_master之后追加到授权文件里
cat /root/id_rsa.pub >> /root/.ssh/authorized_keys
# 删除远程传过来的zk_slave1公钥
rm -f /root/id_rsa.pub
```

7、使用 `root` 用户登陆 `zk_slave2`，把 `zk_slave2` 的公钥远程复制到 `zk_master` 机器上,然后追加到 `zk_master` 机器上的 `authorized_keys`
```markdown
# 复制到zk_master的root目录下，输入zk_master的密码
scp /root/.ssh/id_rsa.pub root@192.168.244.136:/root/
# 登陆zk_master之后追加到授权文件里
cat /root/id_rsa.pub >> /root/.ssh/authorized_keys
# 删除远程传过来的zk_slave2公钥
rm -f /root/id_rsa.pub
```

8、把存有 `zk_master`，`zk_slave1`，`zk_slave2` 公钥文件的授权文件 `authorized_keys` 文件远程复制到 `zk_slave1`，`zk_slave2` 上去
```markdown
scp /root/.ssh/authorized_keys root@192.168.244.135:/root/.ssh
scp /root/.ssh/authorized_keys root@192.168.244.136:/root/.ssh
```

9、分别在三台机器上用远程登陆命令 `ssh` 登陆验证是否成功
```markdown
ssh zk_slave1
ssh zk_slave2
ssh zk_master
```
第一次 `ssh` 时需要输入密码，之后便可以互相免密访问。

### 参考资料
http://blog.chinaunix.net/uid-26284395-id-2949145.html
