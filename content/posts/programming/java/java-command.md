+++
title = "Java 常用命令介绍"
date = "2018-08-24"
lastmod = "2018-08-24"
tags = [
    "Java"
]
categories = [
    "技术"
]
+++

本篇博客记录了 Java 中常用的命令。

<!--more-->

### java 命令
命令行直接运行可执行的 jar 包
```markdown
java -jar jar_name.jar
```

### jps 命令
jps（Java Virtual Machine Process Status Tool）是一个显示当前所有 java 进程 pid 的命令，显示当前系统的  Java 进程情况及进程 id。

常用命令：

1、jps
```markdown
[root@xdhuxc xdhuxc]# jps
18785 Bootstrap
19941 Jps
```
2、jps -m

-m：输出传递给 main 方法的参数，在嵌入式 JVM 上可能是 null。
```markdown
[root@xdhuxc xdhuxc]# jps -m
18785 Bootstrap start
19965 Jps -m
```
3、jps -l

-l：输出应用程序 main class 的完整包名或者应用程序的 jar 文件完整路径名。
```markdown
[root@xdhuxc xdhuxc]# jps -l
18785 org.apache.catalina.startup.Bootstrap
19997 sun.tools.jps.Jps
```
4、jps -v
-v：输出传递给 JVM 的参数
```markdown
[root@xdhuxc ~]# jps -v
20224 Jps -Dapplication.home=/usr/java/jdk1.8.0_171-amd64 -Xms8m
18785 Bootstrap -Djava.util.logging.config.file=/root/xdhuxc/apache-tomcat-9.0.8/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirs= -Dcatalina.base=/root/xdhuxc/apache-tomcat-9.0.8 -Dcatalina.home=/root/xdhuxc/apache-tomcat-9.0.8 -Djava.io.tmpdir=/root/xdhuxc/apache-tomcat-9.0.8/temp
```




