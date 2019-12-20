+++
title = "Ansible 学习之简单入门"
linktitle = "Ansible 学习之简单入门"
date = "2018-05-14"
lastmod = "2018-05-14"
description = ""
tags = [
    "ansible",
    "DevOps"
]
categories = [
    "技术"
]
+++

#### Ansible 简介
Ansible 是一种集成IT系统的配置管理、应用部署、执行特定任务的运维工具。

Ansible 基于 Python 语言实现，由 Paramiko（由 Python 实现的高质量 OpenSSH 库） 和 PyYAML 两个关键模块构建。

#### Ansible 特点
* 部署简单，只需要在主控端部署 ansible 环境，被控端无需做任何操作。
* 默认使用 SSH（Secure Shell）协议对设备进行管理。
* 主从集中化管理。
* 配置简单，功能强大，扩展性强。
* 支持 API 及自定义模块，可通过 Python 轻松扩展。
* 通过 Playbooks 来定制强大的配置，状态管理。
* 对云计算平台，大数据都有很好的支持。
* 提供一个功能强大、操作性强的 Web 管理界面和 REST API 接口--- AWX 平台。


#### Ansible 与 SaltStack

#### 相同点
都具备功能强大、灵活的系统管理、状态配置，都使用 YAML 格式来描述配置，两者都提供丰富的模板及 API，对云计算和大数据都有很好的支持。

#### 区别
最大的区别是 Ansible 无需在被监控主机部署任何客户端代理，默认通过 SSH 通道进行远程命令执行或下发配置。

#### Ansible 使用

##### ansible 安装
使用 YUM 安装 ansible
```
yum install -y ansible
```

##### ansible 配置文件
ansible 的配置文件在 `/etc/ansible` 目录下
```
[root@xdhuxc ~]# ls /etc/ansible/
ansible.cfg  hosts  roles
```
其中，
* ansible.cfg 是 ansible 工具的配置文件
* hosts 用来配置被管理的机器
* roles 是一个目录，playbook 将使用它。

##### ansible 使用

（1）ansible 管理机与被管理机做秘钥认证

使用 ssh-keygen 生成秘钥，一路回车即可。
```
[root@xdhuxc ~]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:dXG3C6BeEXWB0zYCji16agbNndYwJb51Ezw3WxDRiL0 root@xdhuxc
The key's randomart image is:
+---[RSA 2048]----+
|         . **=BOo|
|        . B +O=B+|
|         B.=.+*o=|
|      o +.X.. E..|
|     . +SB .   . |
|      . +        |
|       +         |
|      o          |
|                 |
+----[SHA256]-----+
```
（2）将公钥写入被管理机
```
[root@xdhuxc ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@192.168.91.130
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
Usage: /usr/bin/ssh-copy-id [-h|-?|-f|-n] [-i [identity_file]] [-p port] [[-o <ssh -o options>] ...] [user@]hostname
	-f: force mode -- copy keys without trying to check if they are already installed
	-n: dry run    -- no keys are actually copied
	-h|-?: print this help
[root@xdhuxc ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@192.168.91.130
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.91.130 (192.168.91.130)' can't be established.
ECDSA key fingerprint is SHA256:9Nn+hqVia1ST1/u0qqZP+gVfeLAAwpYCsGgKlZT+8c4.
ECDSA key fingerprint is MD5:5d:ef:7a:42:ec:73:14:d4:de:38:c5:17:83:03:c7:ef.
Are you sure you want to continue connecting (yes/no)? yes（输入yes）
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.91.130's password: （输入被管控机密码）

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -p '22' 'root@192.168.91.130'"
and check to make sure that only the key(s) you wanted were added.
```
（3）hosts 文件中添加被管控机
向 `/etc/ansible/hosts` 文件中加入被管控机信息
```
[Client]
192.168.91.130
```
（4） 测试 ansible
```
[root@xdhuxc ~]# ansible Client -m ping  # 操作 Client 组 （all 为操作 hosts 文件中的所有主机）
192.168.91.130 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
说明：

* -m：指定执行的模块，例如，-m ping，指定执行 ping 模块。
* -i：指定 hosts 文件位置，默认为：/etc/ansible/hosts。
* -u：指定 SSH 连接的用户名。
* -k：指定远程用户密码。
* -f：指定并发数。
* -s：连接用户不是 root，但是需要 root 权限时使用。
* -K：使用 -s 选项时，-K 指定输入 root 用户密码。
