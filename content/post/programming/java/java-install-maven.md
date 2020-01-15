+++
title = "安装 Maven"
date = "2018-11-22"
lastmod = "2018-12-22"
description = ""
tags = [
    "Java",
    "Maven"
]
categories = [
    "技术"
]
+++

本篇博客介绍了安装 `maven` 的步骤。

<!--more-->

### 安装 maven

1、下载 `maven` 安装包，下载地址为：
```markdown
http://maven.apache.org/download.cgi
```
下载并解压之。

2、检查并配置 `JAVA_HOME`，`MAVEN_HOME`。

（1）查找 `java` 安装目录，并配置 `JAVA_HOME`
```markdown
[root@xdhuxc apache-maven-3.5.4]# find / -name java
/usr/bin/java
/usr/share/java
/usr/lib/gcc/x86_64-redhat-linux/4.8.2/plugin/include/java
/usr/lib/java
/usr/java
/usr/java/jdk1.8.0_171-amd64/bin/java     # 安装的官方 Java
/usr/java/jdk1.8.0_171-amd64/jre/bin/java
/var/lib/alternatives/java
/var/lib/docker/overlay2/7f36ad36ff79b7cef239f31a147541b66652a320d05bc77737b797bba1d2c411/merged/usr/share/java
/var/lib/docker/overlay2/0ccde8693a9840f6948d05e6d41238e8d0d993b6c15567f485e43038b09baa03/diff/usr/share/java
/etc/alternatives/java
/etc/pki/ca-trust/extracted/java
/etc/pki/java
/etc/java
```
在 `/etc/profile` 中配置 `JAVA_HOME`  
```markdown
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
export PATH=${JAVA_HOME}/bin:$PATH
```
执行 `. /etc/profile` 或 `source /etc/profile` 使配置生效。

执行测试命令
```markdown
[root@xdhuxc xdhuxc]# java -version
java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.171-b11, mixed mode)
```

（2）配置 `MAVEN_HOME`

`maven` 的安装目录为：
```markdown
[root@xdhuxc apache-maven-3.5.4]# pwd
/root/xdhuxc/apache-maven-3.5.4
[root@xdhuxc apache-maven-3.5.4]# ls
bin  boot  conf  lib  LICENSE  NOTICE  README.txt
```
在 `/etc/profile` 中配置 `MAVEN_HOME`
```markdown
export MAVEN_HOME=/root/xdhuxc/apache-maven-3.5.4
export PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH
```
执行 `. /etc/profile` 或 `source /etc/profile` 使配置生效。

执行测试命令
```markdown
[root@xdhuxc xdhuxc]# mvn -v
Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-18T02:33:14+08:00)
Maven home: /root/xdhuxc/apache-maven-3.5.4
Java version: 1.8.0_171, vendor: Oracle Corporation, runtime: /usr/java/jdk1.8.0_171-amd64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-327.28.3.el7.x86_64", arch: "amd64", family: "unix"
```
