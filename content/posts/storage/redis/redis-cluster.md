+++
title = "Redis 集群部署"
date = "2018-08-04"
lastmod = "2018-09-27"
tags = [
    "Redis",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客主要介绍了 Redis 的集群部署。

<!--more-->

### Redis 集群的搭建（一）
> 在一台 CentOS 7 虚拟机中搭建三个节点的 Redis 集群，该节点IP地址为：192.168.244.129

1、根据 `在 Linux 中安装 Redis` 安装 Redis 并成功启动单个实例

2、在 `/home/application/redis-4.0.1` 目录下创建 redis-cluster 目录，在该目录下分别创建 redis-1、redis-2、redis-3目录，复制redis.conf到redis-1、redis-2、redis-3目录下并分别创建log目录

3、修改redis-1、redis-2、redis-3目录下的redis.conf，修改内容如下所示：

节点 | redis_1 | redis_2| redis_3 
---|---|---|---
IP | 192.168.244.129|192.168.244.129|192.168.244.129
端口 | 8001|8002|8003
daemonize | yes|yes|yes|yes|yes|yes
pidfile | /var/run/redis_8001.pid|/var/run/redis_8002.pid|/var/run/redis_8003.pid
cluster-enabled | yes|yes|yes
cluster-config-file |./config/nodes_8001.conf|./config/nodes_8002.conf|./config/nodes_8003.conf
cluster-node-timeout | 15000|15000|15000
appendonly |yes|yes|yes
logfile|/home/application/redis-4.0.1/redis_cluster/redis_1/log/|/home/application/redis-4.0.1/redis_cluster/redis_2/log/|/home/application/redis-4.0.1/redis_cluster/redis_3/log/

4、将 redis-trib.rb 复制到 /usr/local/bin 目录下，使用 redis-trib.rb 工具启动集群。
报如下错误：
```markdown
[root@localhost src]# redis-trib.rb create --replicas 1 192.168.244.129:8001 192.168.244.129:8002 192.168.244.129:8003 192.168.244.133:8004 192.168.244.133:8005 192.168.244.133:8006
/usr/share/rubygems/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- redis (LoadError)
	from /usr/share/rubygems/rubygems/core_ext/kernel_require.rb:55:in `require'
	from /usr/local/bin/redis-trib.rb:25:in `<main>'
```
解决：

使用 gem 安装 Redis，使用如下命令：
```markdown
[root@localhost src]# gem install redis
```
报错如下：
```markdown
[root@localhost src]# gem install redis
ERROR:  Could not find a valid gem 'redis' (>= 0), here is why:
          Unable to download data from https://rubygems.org/ - Errno::ECONNREFUSED: Connection refused - connect(2) (https://rubygems.org/latest_specs.4.8.gz)
```

报错如下：
```markdown
[root@localhost application]# gem install redis
ERROR:  Error installing redis:
	redis requires Ruby version >= 2.2.2.
```
显示ruby版本须高于2.2.2，查看yum安装的ruby版本
```markdown
ruby -version
```

### 安装指定版本的 ruby
1）安装 curl，使用命令为：
```markdown
sudo yum install curl
```
2）安装RVM，使用命令为：
```markdown
curl -L get.rvm.io | bash -s table
```
3）执行下面命令
```markdown
source /usr/local/rvm/scripts/rvm
```
4）查看rvm库中已知的ruby版本
```markdown
rvm list known
```
5）安装一个ruby版本
```markdown
rvm install 2.3.3
```
6）使用一个ruby版本
```markdown
rvm use 2.3.3
```
7）卸载指定版本的ruby
```markdown
rvm remove 2.0.0
```
8）查看ruby版本
```markdown
ruby --version
```
安装完成后，查看安装的ruby版本
```markdown
[root@localhost ~]# ruby -version
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
-e:1:in `<main>': undefined local variable or method `rsion' for main:Object (NameError)
```

5、使用gem安装redis
```markdown
gem install redis
```

6、在 `192.168.244.129` 上启动三个 Redis 实例，搭建伪分布式集群
```markdown
[root@localhost redis-4.0.1]# redis-trib.rb create --replicas 0 192.168.244.129:8001 192.168.244.129:8002 192.168.244.129:8003 
>>> Creating cluster
>>> Performing hash slots allocation on 3 nodes...
Using 3 masters:
192.168.244.129:8001
192.168.244.129:8002
192.168.244.129:8003
M: f55b5ad14335b51c58922d60ba55990cf303fd54 192.168.244.129:8001
   slots:0-5460 (5461 slots) master
M: 6ea0f62a8dcae5fa94ae778aff06764c4dbe0674 192.168.244.129:8002
   slots:5461-10922 (5462 slots) master
M: af341ce9fda618a5905c3a7d542f649abba5c8a5 192.168.244.129:8003
   slots:10923-16383 (5461 slots) master
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join..
>>> Performing Cluster Check (using node 192.168.244.129:8001)
M: f55b5ad14335b51c58922d60ba55990cf303fd54 192.168.244.129:8001
   slots:0-5460 (5461 slots) master
   0 additional replica(s)
M: af341ce9fda618a5905c3a7d542f649abba5c8a5 192.168.244.129:8003
   slots:10923-16383 (5461 slots) master
   0 additional replica(s)
M: 6ea0f62a8dcae5fa94ae778aff06764c4dbe0674 192.168.244.129:8002
   slots:5461-10922 (5462 slots) master
   0 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
已经搭建成功Redis集群。


### 搭建 Redis 集群（二）
> 在两台CentOS 7 虚拟机上搭建六个节点的Redis集群，IP地址分别为：192.168.244.129和192.168.244.133

1、下载Redis安装包，使用如下命令：
```markdown
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
```
2、解压redis-4.0.1.tar.gz文件，使用命令为：
```markdown
tar -zxf redis-4.0.1.tar.gz
```
3、进入redis-4.0.1目录下，编译Redis源程序，使用如下命令：
```markdown
make 
```
编译完成后，使用如下命令测试：
```markdown
make test
```
如果出现如下错误：
```markdown
!!! WARNING The following tests failed:
*** [err]: Slave should be able to synchronize with the master in tests/integration/replication-psync.tcl

Replication not started.

Cleanup: may take some time... OK
```

虚拟机中安装的时候，机器性能不够的话，很容易出现上述错误。换机器或者更换参数，以及在机器不忙的时候进行编译安装，会顺利通过。

4、将 src 目录下的 redis-trib.rb 复制到 /usr/local/bin 目录下，使用命令为：
```markdown
cp -f src/redis-trib.rb /usr/local/bin
```
5、在 redis-4.0.1 目录下创建 redis_cluster、data 和 config 目录，在 redis_cluster 目录下创建redis_4，redis_5，redis_6目录，复制redis.conf文件至各目录下，并在各目录下创建log目录。

6、修改各目录下的redis.conf文件

节点 | redis_1 | redis_2| redis_3 | redis_4|redis_5|redis_6 
---|---|---|---|---|---|---
IP | 192.168.244.129|192.168.244.129|192.168.244.129|192.168.244.133|192.168.244.133|192.168.244.133
端口 | 8001|8002|8003|8004|8005|8006
daemonize | yes|yes|yes|yes|yes|yes
pidfile | /var/run/redis_8001.pid|/var/run/redis_8002.pid|/var/run/redis_8003.pid|/var/run/redis_8004.pid|/var/run/redis_8005.pid|/var/run/redis800_6.pid
cluster-enabled | yes|yes|yes|yes|yes|yes
cluster-config-file |./config/nodes_8001.conf|./config/nodes_8002.conf|./config/nodes_8003.conf|./config/nodes_8004.conf|./config/nodes_8005.conf|./config/nodes_8006.conf
cluster-node-timeout | 15000|15000|15000|15000|15000|15000
appendonly |yes|yes|yes|yes|yes|yes
logfile|./redis_cluster/redis_1/log/|./redis_cluster/redis_2/log/|./redis_cluster/redis_3/log/|./redis_cluster/redis_4/log/|./redis_cluster/redis_5/log/|./redis_cluster/redis_6/log/

将 `dump.rdb` 和 `appendonly.aof` 文件的目录修改至 `./data` 目录下

7、在 `192.168.244.129` 和 `192.168.244.133` 上各启动三个Redis实例，搭建含有六个节点的跨主机集群，在 `192.168.244.129` 上执行如下命令：
```markdown
redis-trib.rb create --replicas 1 192.168.244.129:8001 192.168.244.129:8002 192.168.244.129:8003 192.168.244.133:8004 192.168.244.133:8005 192.168.244.133:8006
```
执行后，报如下错误：
```markdown
>>> Creating cluster
[ERR] Sorry, can't connect to node 192.168.244.133:8004
```
可能是因为192.168.244.133上的相应端口未开放
解决：
> CentOS 7 使用firewalld代替了iptables
在 `192.168.244.133` 上开启防火墙端口8004、8005、8006，使用命令为：
```markdown
firewall-cmd --zone=public --add-port=8004/tcp --permanent # --zone #作用域 --add-port=80/tcp  #添加端口，格式为：端口/通讯协议 --permanent  #永久生效，没有此参数重启后失效
firewall-cmd --reload # 重启防火墙
```

之后重新启动集群，出现如下错误：
```markdown
[root@localhost redis-4.0.1]# redis-trib.rb create --replicas 1 192.168.244.129:8001 192.168.244.129:8002 192.168.244.129:8003 192.168.244.133:8004 192.168.244.133:8005 192.168.244.133:8006
>>> Creating cluster
[ERR] Node 192.168.244.129:8001 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.
```

解决：
清理掉 `redis-4.0.1` 目录下的 appendonly.aof dump.rdb nodes-*.conf 文件，使用命令为：
```markdown
rm -f appendonly.aof dump.rdb nodes-*.conf
```
重新启动六个Redis实例，出现如下错误：
```markdown
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join.............................................................................................................................................................................
```
原因：
```markdown
Every Redis Cluster node requires two TCP connections open. The
normal Redis TCP port used to serve clients, for example 6379, plus
the port obtained by adding 10000 to the data port, so 16379 in the
example. This second high port is used for the Cluster bus, that is
a node-to-node communication channel using a binary protocol. The
Cluster bus is used by nodes for failure detection, configuration
update, failover authorization and so forth. Clients should never
try to communicate with the cluster bus port, but always with the
normal Redis command port, however make sure you open both ports in
your firewall, otherwise Redis cluster nodes will be not able to
communicate. The command port and cluster bus port offset is fixed
and is always 10000. Note that for a Redis Cluster to work properly
you need, for each node: The normal client communication port
(usually 6379) used to communicate with clients to be open to all
the clients that need to reach the cluster, plus all the other
cluster nodes (that use the client port for keys migrations). The
cluster bus port (the client port + 10000) must be reachable from
all the other cluster nodes. If you don't open both TCP ports, your
cluster will not work as expected. The cluster bus uses a
different, binary protocol, for node to node data exchange, which
is more suited to exchange information between nodes using little
bandwidth and processing time. i use AWS, due to don't open 16379
16380 port, cause this issue
```
解决：
在 `192.168.244.133` 上开放 `18004`、`18005` 和 `18006` 端口以供 `redis` 集群数据通讯。

在搭建过程中，可以使用redis-trib.rb测试各个节点的连接情况：
```markdown
[root@localhost redis-3.2.10]# redis-trib.rb check 192.168.244.133:8007
>>> Performing Cluster Check (using node 192.168.244.133:8007)
M: 2c6977dce48d9abd038d066c37c91306ffd32ca2 192.168.244.133:8007
   slots: (0 slots) master
   0 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[ERR] Not all 16384 slots are covered by nodes.
```
8、登录redis集群节点机，使用命令为：
```markdown
[root@localhost redis-4.0.1]# redis-cli -h 192.168.244.129 -p 8003 
```
若要停止Redis服务，可以使用命令：
```markdown
[root@localhost redis-4.0.1]# redis-cli -h 192.168.244.129 -p 8003 shutdown
```
