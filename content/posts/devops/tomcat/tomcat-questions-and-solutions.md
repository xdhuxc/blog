+++
title = "Tomcat 常见问题及解决"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Tomcat",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 Tomcat 的过程中经常出现的问题及其解决方法。

<!--more-->

1、tomcat 部署项目后，war 包是否可以删除？

* war 包不能在 tomcat 运行时删除，否则会删除自动解压的工程。
* 可以停掉 tomcat 后，再删除 war 包，解压后的工程还会保留着。
* 当重新部署的时候，如果有与 war 文件相同的目录，就不会重新部署。

因为 tomcat 在运行期间会监控 webapps 目录下的 war 文件，如果有新增 war 文件，就解压；有删除 war 文件，就连同项目一起删除。

2、tomcat 下 war 包和同名已解压项目，如何加载？

当 tomcat 启动的时候，会去查看 webapps 目录下的所有 war 包，同时查看是否有该 war 包对应的已解压文件，如果已经存在，就不会再解压，也不会将已经修改的 jsp 覆盖掉。只有当删除 war 包对应的同名目录后，启动 tomcat 时才会再解压 war 文件。

3、部署在 tomcat 中的应用，输出的日志是乱码

中文乱码原因：

Tomcat 默认是按 `ISO-8859-1` 进行 `URL` 解码，`ISO-8859-1` 并未包括中文字符，中文字符不能被正确解析导致产生乱码。

解决：

1、在 `server.xml` 文件，添加如下配置：
```markdown
<Connector executor="tomcatThreadPool"
               port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" URIEncoding="UTF-8"/>
```
指定了用于解码 `URI` 的字符编码为 `UTF-8`。

2、设置当前系统编码，在 `/etc/profile` 文件中添加如下内容：
```markdown
export LANG=zh_CN.utf8
```


