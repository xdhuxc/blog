+++
title = "zookeeper 常见问题及解决"
date = "2018-03-14"
tags = [
    "Zookeeper"
]
categories = [
    "技术"
]
+++

本篇博客记录了在使用 zookeeper 的过程中经常遇到的问题及解决方法。

<!--more-->

1、重启zookeeper时报错如下：
```markdown
Apr 23 17:08:30 localhost zookeeper: 2018-04-23 17:08:30,702 [myid:] - ERROR [main:Util@239] - Last transaction was partial.
Apr 23 17:08:30 localhost zookeeper: 2018-04-23 17:08:30,703 [myid:] - ERROR [main:ZooKeeperServerMain@63] - Unexpected exception, exiting abnormally
Apr 23 17:08:30 localhost zookeeper: java.io.EOFException
Apr 23 17:08:30 localhost zookeeper: at java.io.DataInputStream.readInt(DataInputStream.java:392)
Apr 23 17:08:30 localhost zookeeper: at org.apache.jute.BinaryInputArchive.readInt(BinaryInputArchive.java:63)
```
解决

找到 `/etc/zookeeper/conf/zoo.cfg` 文件，找到 `zookeeper` 的数据目录，删除该数据目录，重新启动 `zookeeper` 即可。
