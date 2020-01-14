+++
title = "部署 Zookeeper 集群"
date = "2018-06-28"
lastmod = "2018-06-28"
tags = [
    "Zookeeper",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客记录了 部署 zookeeper 集群的方法。

<!--more-->

### Zookeeper集群搭建

三台虚拟机情况如下：

虚拟机名称 | IP地址| 其他
---|---|---
centos_3 | 192.168.244.129| zk_master
centos_4 | 192.168.244.135| zk_slave1
centos_6 | 192.168.244.136| zk_slave2
均已经安装了java 1.8.0_144

1、在 zk_master 机器上下载 `zookeeper-3.4.10.tar.gz`
```markdown
wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
```

2、解压 `zookeeper-3.4.10.tar.gz` 文件，
```markdown
tar -zxf zookeeper-3.4.10.tar.gz
```

3、创建所需文件和目录
```markdown
mkdir /data
mkidr -p /data/zookpeer
mkdir -p /data/zookeper/data
mkdir -p /data/zookeeper/log
touch /data/zookeeper/data/myid
```

4、进入 `zookeeper-3.4.10/conf` 目录下，复制配置文件
```markdown
cp zoo_sample.cfg zoo.cfg
```

5、修改以下内容：
```markdown
tickTime=2000 # 单位毫秒，服务器之间或者客户端与服务器之间的心跳间隔
initLimit=10  # 初始化Follower最长时间：10 * 2000 ms
syncLimit=5   # Leader与Follower之间发送消息请求和应答时间长度：5 * 2000 ms
dataDir=/data/zookeeper/data # 日志存储路径
dataLogDir=/data/zookeeper/log # 事务日志存储路径
clientPort=52181 # 客户端端口
server.1=192.168.244.129:12888:13888    
server.2=192.168.244.135:12888:13888    
server.3=192.168.244.136:12888:13888  

autopurge.snapRetainCount=15 # 每次清除日志后保留的文件数目
autopurge.purgeInterval=1 # 清除日志频率，单位小时
```
server.A=B:C:D
A 是一个数字,表示这个是第几号服务器,
B 是这个服务器的ip地址
C 第一个端口用来集群成员的信息交换,表示的是这个服务器与集群中的Leader服务器交换信息的端口
D 是在leader挂掉时专门用来进行选举leader所用

6、向 `/data/zookeeper/data/myid` 中写入服务标识
```markdown
echo "1" > /data/zookeeper/data/myid
```

7、将 zk_master 中的 zookeeper-3.4.10 复制到 zk_slave1 和 zk_slave2 机器上
```markdown
scp -r /home/application/zookeeper-3.4.10 root@192.168.244.135:/home/application/
scp -r /home/application/zookeeper-3.4.10 root@192.168.244.136:/home/application/
```

8、在 zk_slave1 和 zk_slave2 上创建 myid 文件并写入内容
在 zk_slave1 上
```markdown
touch /data/zookeeper/data/myid
echo "2" > /data/zookeeper/data/myid
```

在 zk_slave2 上
```markdown
touch /data/zookeeper/data/myid
echo "3" > /data/zookeeper/data/myid
```

9、在三台机器上都开放防火墙端口`52181`，`12888`，`13888`，并重新启动防火墙。

10、在三台机器上分别启动Zookeeper
```markdown
[root@centos_3 bin]# cd /home/application/zookeeper-3.4.10/bin
[root@centos_3 bin]# ./zkServer.sh start

[root@centos_4 bin]# cd /home/application/zookeeper-3.4.10/bin
[root@centos_4 bin]# ./zkServer.sh start

[root@centos_6 bin]# cd /home/application/zookeeper-3.4.10/bin
[root@centos_6 bin]# ./zkServer.sh start
```
11、查看 zookeeper 的启动状态
在 zk_master 上
```markdown
[root@centos_3 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /home/application/zookeeper-3.4.10/bin/../conf/zoo.cfg
Mode: follower
```

在 zk_slave1 上
```markdown
[root@centos_4 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /home/application/zookeeper-3.4.10/bin/../conf/zoo.cfg
Mode: leader
```

在 zk_slave2 上
```markdown
[root@centos_6 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /home/application/zookeeper-3.4.10/bin/../conf/zoo.cfg
Mode: follower
```

### 相关问题及解决
1、启动 zookeeper 节点后出现如下错误：
```markdown
[root@centos_6 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /home/application/zookeeper-3.4.10/bin/../conf/zoo.cfg
Error contacting service. It is probably not running.
```
解决：

查看 `/home/application/zookeeper-3.4.10/bin` 目录下的 `zookeeper.out` 文件，报错如下：
```markdown
017-10-10 16:06:47,701 [myid:1] - WARN  [WorkerSender[myid=1]:QuorumCnxManager@588] - Cannot open channel to 3 at election address /192.168.244.136:13888
java.net.ConnectException: Connection refused (Connection refused)
	at java.net.PlainSocketImpl.socketConnect(Native Method)
	at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:350)
	at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:206)
	at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:188)
	at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
	at java.net.Socket.connect(Socket.java:589)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:562)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.toSend(QuorumCnxManager.java:538)
	at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.process(FastLeaderElection.java:452)
	at org.apache.zookeeper.server.quorum.FastLeaderElection$Messenger$WorkerSender.run(FastLeaderElection.java:433)
	at java.lang.Thread.run(Thread.java:748)
2017-10-10 16:06:47,705 [myid:1] - INFO  [WorkerSender[myid=1]:QuorumPeer$QuorumServer@167] - Resolved hostname: 192.168.244.136 to address: /192.168.244.136
```

分别在三台虚拟机上开放 `52181`、`12888`、`13888` 三个端口，重新启动，即可正常启动。

