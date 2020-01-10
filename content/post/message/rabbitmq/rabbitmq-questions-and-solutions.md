+++
title = "RabbitMQ 常见问题及解决"
date = "2018-08-06"
lastmod = "2018-10-17"
tags = [
    "RabbitMQ"
]
categories = [
    "技术"
]
+++

本篇博客介绍了使用 RabbitMQ 的过程中常见的问题及解决方法。

<!--more-->

1、在虚拟机中启动 `rabbitmq` 及管理插件后，使用 `guest/guest` 在浏览器中访问时，页面报错如下：
```markdown
User can only log in via localhost 
```
进入 `/var/log/rabbitmq` 中查看日志，日志中含有如下信息：
```markdown
2018-05-08 07:59:19.561 [warning] <0.681.0> HTTP access denied: user 'guest' - User can only log in via localhost
2018-05-08 07:59:27.904 [warning] <0.684.0> HTTP access denied: user 'guest' - User can only log in via localhost
2018-05-08 08:00:11.502 [warning] <0.709.0> HTTP access denied: user 'guest' - User can only log in via localhost
```
解决：

`rabbitmq从3.3.0` 开始禁止使用 `guest/guest` 权限通过除 `localhost` 外的访问。如果想使用 `guest/guest` 通过远程机器访问，

在 `/etc/rabbitmq` 目录下创建 `rabbitmq.conf `文件，添加如下内容：
```markdown
loopback_users = none # 表示允许默认用户 guest 在远程连接 rabbitmq-server
```
2、在 `VMware workstation` 中创建虚拟机，使用 `rpm` 包方式安装 `erlang` 和 `rabbitmq-server` ，在浏览器中使用net网卡IP地址访问时，只出现了部分界面，


没有显示全正常 `rabbitmq` 管理界面；同时，使用 `java` 编写的连接程序总是报错。

解决：关闭 `windows` 防火墙，使用桥接网卡的 `IP` 地址访问 `rabbitmq` 管理页面，显示正常。
