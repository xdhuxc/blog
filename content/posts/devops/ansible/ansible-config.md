+++
title = "Ansible 配置文件详解"
linktitle = "Ansible 配置文件详解"
date = "2023-02-18"
lastmod = "2023-02-18"
description = ""
tags = [
    "Ansible",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了 Ansible 配置文件 ansible.cfg 中的常用项及其含义。

<!--more-->

ansible 的配置文件为 ansible.cfg，默认路径为当前路径或者 `/etc/ansible/ansible.cfg`，也可以通过环境变量 ANSIBLE_CONFIG 来指定路径。

其内容一般如下所示：
```markdown
[defaults]
inventory = hosts
library = /usr/share/ansible
sudo_user = xdhuxc
remote_port = 22
host_key_checking = False
timeout = 600
log_path = ansible.log
interpreter_python = /usr/bin/python3
ansible_shell_type = zsh
callbacks_enabled = profile_tasks

[all:vars]
ansible_connection = ssh
ansible_user = xdhuxc
ansible_ssh_user = xdhuxc
ansible_ssh_pass = *****
ansible_become_pass = *****
ansible_ssh_common_args = "-o StrictHostKeyChecking=no"
```

ansible.cfg 中 `[defaults]` 各个字段的含义如下：
* inventory：表示资源清单 inventory 文件的位置。
* library：指向存放 ansible 模块的目录，支持多个目录的方式，只需要使用 `:` 分隔开来即可。
* sudo_user：设置默认执行命令的用户。
* remote_port：指定连接被管理节点的管理端口，默认为 22 端口，建议修改，能够更加安全。
* host_key_checking：设置是否检查 SSH 主机的秘钥，值为 True 或 False，关闭后第一次连接不会提示配置实例。
* timeout：设置 SSH 连接的超时时间，单位为秒。
* log_path: 指定一个存储 ansible 日志的文件，默认不记录日志。
* interpreter_python：指定远程机器上 python 解释器的路径。
* ansible_shell_type：指定 ansible 执行 shell 命令时使用的 shell 类型。
* callbacks_enabled：指定加载的插件，这里使用 profile_tasks 来显示各个任务的执行时间。

ansible.cfg 中 `[all:vars]` 部分指定各个 playbook 中共用的一些变量，其中包括：
* ansible_connection：ansible 连接远程机器的方式，默认为 ssh。
* ansible_user：ansible 连接远程机器的用户。
* ansible_ssh_user：ansible 使用 ssh 连接远程机器的用户。
* ansible_ssh_pass：ansible 使用 ssh 连接远程机器的用户密码。
* ansible_become_pass：ansible 在远程机器上切换到 root 用户时使用的密码。
* ansible_ssh_common_args：ansible 使用 ssh 方式连接远程机器的参数，也就是 ssh 连接机器的参数。