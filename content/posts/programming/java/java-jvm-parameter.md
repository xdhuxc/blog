+++
title = "JVM 参数详解"
date = "2018-11-22"
lastmod = "2018-12-22"
description = ""
tags = [
    "Java"
]
categories = [
    "Java"
]
+++

本篇博客介绍了 JVM 的一些参数，在 JVM 调优时需要用到。

<!--more-->

### 堆大小设置
JVM中最大堆大小有三方面限制：

1、相关操作系统的数据模型（32位机器还是64位机器）限制，32位系统下，一般限制在1.5G~2G，64位操作系统对内存无限制。
2、系统的可用虚拟内存限制。
3、系统的可用物理内存限制。

### 配置含义
-server：服务器模式

-Xms1024M 为 JVM 启动时分配的堆内存，一般和Xmx配置成一样，以避免每次GC后JVM重新分配内存。比如，-Xms200M，表示分配200M

-Xmx1024 为 JVM 运行过程中分配的最大堆内存，按需分配。比如，-Xmx1024M，表示 JVM 进程最多只能够占用 1024M 内存。

-Xss256K 为 JVM 启动的每个线程分配的堆栈内存大小，默认JDK1.4中是256K，JDK1.5+中是1M。

-XX:+DisableExplicitGC：忽略手动调用GC，System.gc()的调用就会变成一个空调用，不会触发GC。

### JVM参数
-XX 参数被称为不稳定参数，此类参数的设置很容易引起JVM性能上的差异

不稳定参数语法规则：

1、布尔类型
```markdown
-XX:+<option> "+"表示启用该选项
-XX:+<option> "-"表示关闭该选项
```

2、数字类型
```markdown
-XX:<option>=<number> # 可跟随单位，例如，“m”或“M”表示兆字节，“k”或“K”表示千字节，“g”或“G”表示千兆字节。32K与32768是相同大小的。
```

3、字符串类型
```markdown
-XX:<option>=<string> # 通常用于指定一个文件、路径或一系列命令列表，例如：-XX:HeapDumpPath=./dump.core
```

### 远程调试
远程调试时，添加如下JVM参数：
```markdown
-Xdebug -Xrunjdwp:transport:dt_socket,address=8899,server=y,suspend=n
```
参数说明：

* transport：debugee 与 debuger 调试时之间的通讯数据传输方式。
* server：是否监听 debuger 的调试请求。
* suspend：是否等待启动，也即，设置是否在 debuger 调试连接建立后才启动 debugee JVM。
* address：debugee的地址，用于 debuger 建立调试连接。

远程调试时，JAVA_OPTS 设置示例：
```markdown
JAVA_OPTS=-server -Xms1400m -Xmx1400m -Xss4096K -XX:PermSize=128m -XX:MaxPermSize=256m -Duser.timezone=GMT+08 -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8 -Djava.awt.headless=true -XX:+DisableExplicitGC -Xdebug -Xrunjdwp:transport=dt_socket,address=8899,server=y,suspend=n
```
