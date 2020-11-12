+++
title = "Redis 安装和配置详解"
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

本篇博客主要介绍了 Redis 的安装和配置参数的详细含义。

<!--more-->

### 在 Linux 中安装 Redis

1、使用如下命令下载并解压Redis安装包
```markdown
$ wget http://download.redis.io/releases/redis-4.0.1.tar.gz
$ tar -zxf redis-4.0.1.tar.gz
$ cd redis-4.0.1
$ make
```
在 make 时，出现如下错误：
```markdown
[root@localhost redis-4.0.1]# make
cd src && make all
make[1]: Entering directory `/home/application/redis-4.0.1/src'
    CC adlist.o
In file included from adlist.c:34:0:
zmalloc.h:50:31: fatal error: jemalloc/jemalloc.h: No such file or directory
 #include <jemalloc/jemalloc.h>
                               ^
compilation terminated.
make[1]: *** [adlist.o] Error 1
make[1]: Leaving directory `/home/application/redis-4.0.1/src'
make: *** [all] Error 2
```
原因：
```markdown
Allocator  
---------  
 
Selecting a non-default memory allocator when building Redis is done by setting  
the `MALLOC` environment variable. Redis is compiled and linked against libc  
malloc by default, with the exception of jemalloc being the default on Linux  
systems. This default was picked because jemalloc has proven to have fewer  
fragmentation problems than libc malloc.  
 
To force compiling against libc malloc, use:  
 
    % make MALLOC=libc  
 
To compile against jemalloc on Mac OS X systems, use:  
 
    % make MALLOC=jemalloc
```
解决：

使用如下命令进行make操作
```markdown
make MALLOC=libc
```

之后在 make 的时候提示如下错误：
```markdown
cc: error: ../deps/hiredis/libhiredis.a: No such file or directory
cc: error: ../deps/lua/src/liblua.a: No such file or directory
make[1]: *** [redis-server] Error 1
make[1]: Leaving directory `/home/application/redis-4.0.1/src'
make: *** [all] Error 2
```
解决：

进入Redis安装目录下的deps目录下，执行如下命令：
```markdown
make lua hiredis linenoise
```

make之后，可以运行测试，确认Redis的功能是否正常，使用如下命令：
```markdown
make test
```
出现如下报错：
```markdown
[root@localhost redis-4.0.1]# make test
cd src && make test
make[1]: Entering directory `/home/application/redis-4.0.1/src'
    CC Makefile.dep
make[1]: Leaving directory `/home/application/redis-4.0.1/src'
make[1]: Entering directory `/home/application/redis-4.0.1/src'
You need tcl 8.5 or newer in order to run the Redis test
make[1]: *** [test] Error 1
make[1]: Leaving directory `/home/application/redis-4.0.1/src'
make: *** [test] Error 2
```
解决：

根据提示安装tcl 8.5及以上版本
```markdown
wget http://downloads.sourceforge.net/tcl/tcl8.6.1-src.tar.gz
tar -zxf tcl8.6.1-src.tar.gz
cd /home/application/tcl8.6.1/unix/
sudo ./configure
sudo make
sudo make install
```

2、make 完后，redis-2.8.17 目录下会出现编译后的 redis 服务程序 `redis-server`，还有用于测试的客户端程序`redis-cli`，两个程序位于安装目录`src`目录下，
启动redis服务：
```markdown
$ cd src
$ ./redis-server
```
这种方式启动redis使用的是默认配置。也可以通过启动参数告诉redis使用指定配置文件使用下面命令启动。
```markdown
$ cd src
$ ./redis-server redis.conf
```
redis.conf 是一个默认的配置文件，可以根据需要使用自己的配置文件。

3、启动 redis 服务进程后，就可以使用测试客户端程序 redis-cli 和 redis 服务交互了。
```markdown
$ cd src
$ ./redis-cli
redis> set abc def
OK
redis> get abc
"def"
```

### 在 Windows 下安装 Redis

1、Redis 支持 32 位和 64 位。这个需要根据你系统平台的实际情况选择，这里我们下载 `Redis-x64-xxx.zip` 压缩包到C盘，解压后，将文件夹重新命名为 redis。
![](http://www.runoob.com/wp-content/uploads/2014/11/3B8D633F-14CE-42E3-B174-FCCD48B11FF3.jpg)

2、打开一个 cmd 窗口 使用 cd 命令切换目录到 `C:\redis` 运行 `redis-server.exe redis.windows.conf`。如果想方便的话，可以把 redis 的路径加到系统的环境变量里，这样就省得再输路径了，后面的那个 `redis.windows.conf` 可以省略，如果省略，会启用默认的。输入之后，会显示如下界面：
![](http://www.runoob.com/wp-content/uploads/2014/11/redis-install1.png)

3、此时另启一个 cmd 窗口，原来的不要关闭，否则就无法访问服务端了。
切换到 redis 目录下运行 `redis-cli.exe -h 127.0.0.1 -p 6379`。
![](http://www.runoob.com/wp-content/uploads/2014/11/redis-install2.jpg)

### 在命令行中查询配置 Redis 参数
> Redis 的配置文件位于 Redis 安装目录下，文件名为 redis.conf。

1、可以使用 `config` 命令查看或者设置配置项，如下所示：
```markdown
redis 127.0.0.1:6379> config get loglevel
1) "loglevel"
2) "notice"
```

2、使用`*`获取所有配置项
```markdown
127.0.0.1:6379> config get *
  1) "dbfilename"
  2) "dump.rdb"
  3) "requirepass"
  4) ""
  5) "masterauth"
  6) ""
  7) "unixsocket"
  8) ""
  9) "logfile"
 10) ""
 11) "pidfile"
 12) "/var/run/redis.pid"
 13) "maxmemory"
 14) "0"
 15) "maxmemory-samples"
 16) "5"
 17) "timeout"
 18) "0"
 19) "tcp-keepalive"
 20) "0"
 21) "auto-aof-rewrite-percentage"
 22) "100"
 23) "auto-aof-rewrite-min-size"
 24) "67108864"
 25) "hash-max-ziplist-entries"
 26) "512"
 27) "hash-max-ziplist-value"
 28) "64"
 29) "list-max-ziplist-entries"
 30) "512"
 31) "list-max-ziplist-value"
 32) "64"
 33) "set-max-intset-entries"
 34) "512"
 35) "zset-max-ziplist-entries"
 36) "128"
 37) "zset-max-ziplist-value"
 38) "64"
 39) "hll-sparse-max-bytes"
 40) "3000"
 41) "lua-time-limit"
 42) "5000"
 43) "slowlog-log-slower-than"
 44) "10000"
 45) "latency-monitor-threshold"
 46) "0"
 47) "slowlog-max-len"
 48) "128"
 49) "port"
 50) "6379"
 51) "tcp-backlog"
 52) "511"
 53) "databases"
 54) "16"
 55) "repl-ping-slave-period"
 56) "10"
 57) "repl-timeout"
 58) "60"
 59) "repl-backlog-size"
 60) "1048576"
 61) "repl-backlog-ttl"
 62) "3600"
 63) "maxclients"
 64) "10000"
 65) "watchdog-period"
 66) "0"
 67) "slave-priority"
 68) "100"
 69) "min-slaves-to-write"
 70) "0"
 71) "min-slaves-max-lag"
 72) "10"
 73) "hz"
 74) "10"
 75) "cluster-node-timeout"
 76) "15000"
 77) "cluster-migration-barrier"
 78) "1"
 79) "cluster-slave-validity-factor"
 80) "10"
 81) "repl-diskless-sync-delay"
 82) "5"
 83) "cluster-require-full-coverage"
 84) "yes"
 85) "no-appendfsync-on-rewrite"
 86) "no"
 87) "slave-serve-stale-data"
 88) "yes"
 89) "slave-read-only"
 90) "yes"
 91) "stop-writes-on-bgsave-error"
 92) "yes"
 93) "daemonize"
 94) "no"
 95) "rdbcompression"
 96) "yes"
 97) "rdbchecksum"
 98) "yes"
 99) "activerehashing"
100) "yes"
101) "repl-disable-tcp-nodelay"
102) "no"
103) "repl-diskless-sync"
104) "no"
105) "aof-rewrite-incremental-fsync"
106) "yes"
107) "aof-load-truncated"
108) "yes"
109) "appendonly"
110) "no"
111) "dir"
112) "C:\\redis"
113) "maxmemory-policy"
114) "noeviction"
115) "appendfsync"
116) "everysec"
117) "save"
118) "jd 900 jd 300 jd 60"
119) "loglevel"
120) "notice"
121) "client-output-buffer-limit"
122) "normal 0 0 0 slave 268435456 67108864 60 pubsub 33554432 8388608 60"
123) "unixsocketperm"
124) "0"
125) "slaveof"
126) ""
127) "notify-keyspace-events"
128) ""
129) "bind"
130) ""
```
3、可以通过修改`redis.conf`或者`config set`命令来修改配置
```markdown
redis 127.0.0.1:6379> config set loglevel "notice"
OK
redis 127.0.0.1:6379> config get loglevel
1) "loglevel"
2) "notice"
```

# 四、[Redis参数说明](http://www.runoob.com/redis/redis-conf.html)

redis.conf配置项说明如下：

* daemonize no：Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用 yes 启用守护进程
* pidfile /var/run/redis.pid：当Redis以守护进程方式运行时，Redis 默认会把 pid 写入 /var/run/redis.pid 文件，可以通过 pidfile 指定
* port 6379：指定Redis监听端口，默认端口为6379。
* bind 127.0.0.1：绑定的主机地址
* timeout 300：当客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
* loglevel verbose：指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
* logfile stdout：日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
* databases 16：设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
* save <seconds> <changes>：指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合，Redis默认配置文件中提供了三个条件：
```markdown
save 900 1
save 300 10
save 60 10000
```
分别表示900秒（15分钟）内有1个更改，300秒（5分钟）内有10个更改以及60秒内有10000个更改。

* rdbcompression yes：指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
* dbfilename dump.rdb：指定本地数据库文件名，默认值为dump.rdb。dump.rdb是由Redis服务器自动生成的 默认情况下 每隔一段时间redis服务器程序会自动对数据库做一次遍历，把内存快照写在一个叫做“dump.rdb”的文件里，这个持久化机制叫做SNAPSHOT。有了SNAPSHOT后，如果服务器宕机，重新启动redis服务器程序时redis会自动加载dump.rdb，将数据库状态恢复到上一次做SNAPSHOT时的状态。
* dir ./：指定本地数据库存放目录
* slaveof <masterip> <masterport>：设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
* masterauth <master-password>：当master服务设置了密码保护时，slave服务连接master的密码
* requirepass foobared：设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过AUTH <password>命令提供密码，默认关闭
* maxclients 128：设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息。
* maxmemory <bytes>：指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区。
* appendonly no：指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no
* appendfilename appendonly.aof：指定更新日志文件名，默认为appendonly.aof
* appendfsync everysec：指定更新日志条件，共有3个可选值： 
```markdown
1、no：表示等操作系统进行数据缓存同步到磁盘（快） 
2、always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） 
3、everysec：表示每秒同步一次（折衷，默认值）
```
 
* vm-enabled no：指定是否启用虚拟内存机制，默认值为no，VM机制将数据分页存放，由Redis将访问量较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中。 
* vm-swap-file /tmp/redis.swap：虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
* vm-max-memory 0：将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘。默认值为0。
* vm-page-size 32：Redis swap文件分成了很多的页，一个对象可以保存在多个页上面，但一个页上不能被多个对象共享，vm-page-size是要根据存储的数据大小来设定的，如果存储很多小对象，页的大小最好设置为32字节或者64字节；如果存储很大的大对象，则可以使用更大的页，如果不确定，就使用默认值。
* vm-pages 134217728：设置swap文件中的页的数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的，在磁盘上每8个页将消耗1字节的内存。
* vm-max-threads 4：设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4
* glueoutputbuf yes：设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启
* 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法
```markdown
hash-max-zipmap-entries 64
hash-max-zipmap-value 512
```
* activerehashing yes：指定是否激活重置哈希，默认为开启
* include /path/to/local.conf：指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件
