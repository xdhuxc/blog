+++
title = "Redis 进阶知识及操作"
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

本篇博客主要介绍了 Redis 的部分高级技术，包括数据备份和恢复、安全、性能测试、分区等。

<!--more-->

### Redis 数据备份与恢复

#### Redis 数据备份

Redis 的 save 命令用于创建当前数据库的备份

使用 `redis save` 命令来备份 redis 数据：
```markdown
redis 127.0.0.1:6379> save
OK
```
该命令将在 `redis` 安装目录中创建 `dump.rdb` 文件

创建 redis 备份文件也可以使用命令 bgsave，该命令在后台执行。
```markdown
127.0.0.1:6379> bgsave
Background saving started
```

#### Redis 数据恢复
如果需要恢复数据，只需将备份文件 `dump.rdb` 移动到 redis 安装目录并启动服务即可。

获取 `redis` 目录可以使用 `config` 命令，如下所示：
```markdown
redis 127.0.0.1:6379> config get dir
1) "dir"
2) "/usr/local/redis/bin"
```
`config get dir` 输出的 `redis` 安装目录为：`/usr/local/redis/bin`

### Redis 安全
可以通过 redis 的配置文件设置密码参数，这样客户端连接到 redis 服务就需要密码验证，这样可以让 redis 服务更安全。

```markdown
127.0.0.1:6379> config get requirepass
1) "require"
2) ""
```

默认情况下 requirepass 参数是空的，这就意味着无需通过密码验证就可以连接到 redis 服务。
可以通过以下命令来修改该参数：
```markdown
127.0.0.1:6379> config set requirepass "abcdef"
OK
127.0.0.1:6379> config get requirepass
1) "requirepass"
2) "abcdef"
```
设置密码后，客户端连接 redis 服务就需要密码验证，否则无法执行命令。

auth 命令基本语法格式如下：
```markdown
127.0.0.1:6379> auth password
```

示例
```markdown
127.0.0.1:6379> auth "abcdef"
OK
127.0.0.1:6379> set xkey "MyValue"
OK
127.0.0.1:6379> get xkey
"MyValue"
```

### Redis 性能测试
> Redis 性能测试是通过同时执行多个命令实现的。

redis 性能测试的基本命令如下：
```markdown
redis-benchmark [option] [option value]
```

同时执行 10000 个请求来检测性能
```markdown
redis-benchmark -n 10000
```
> Redis 性能测试工具可选参数如下所示：

序号| 选项 | 描述 | 默认值
---|---|---|---
1  | -h | 指定服务器主机名 | 127.0.0.1
2  | -p | 指定服务器端口 | 	6379
3  | -s | 指定服务器 socket | 
4  | -c | 指定并发连接数 | 50
5  | -n | 指定请求数 | 10000
6  | -d | 以字节的形式指定 SET/GET 值的数据大小 | 2
7  | -k | 1=keep alive 0=reconnect | 1
8  | -r | SET/GET/INCR 使用随机 key, SADD 使用随机值 |
9  | -P | 通过管道传输 <numreq> 请求 | 1
10 | -q | 强制退出 redis。仅显示 query/sec 值
11 | --csv | 以 CSV 格式输出
12 | -l | 生成循环，永久执行测试
13 | -t | 仅运行以逗号分隔的测试命令列表
14 | -L | Idle 模式。仅打开 N 个 idle 连接并等待


使用多个参数来测试 redis 的性能
```markdown
redis-benchmark -h 127.0.0.1 -p 6379 -t set,lpush -n 10000 -q
SET: 2131.74 requests per second
LPUSH: 2257.34 requests per second
```

### Redis 客户端连接

Redis 通过监听一个 TCP 端口或者 Unix socket 的方式来接收来自客户端的连接，当一个连接建立后，Redis 内部会进行以下一些操作：

- 首先，客户端 socket 会被设置为非阻塞模式，因为 Redis 在网络事件处理上采用的是非阻塞多路复用模型。
- 然后为这个 socket 设置 TCP_NODELAY 属性，禁用 Nagle 算法
- 然后创建一个可读的文件事件用于监听这个客户端 socket 的数据发送

最大连接数 maxclients 的默认值是 10000，也可以在 redis.conf 中进行设置
```markdown
config get maxclients 
1) "maxclients"
2) "10000"
```
在服务启动时设置最大连接数为 100000
```markdown
redis-server --maxclients 10000
```

客户端命令：

序号 | 命令 | 描述
---|---|---
1  | client list | 返回连接到 redis 服务的客户端列表
2  | client setname | 设置当前连接的名称
3  | client getname | 获取通过 CLIENT SETNAME 命令设置的服务名称
4  | client pause | 挂起客户端连接，指定挂起的时间以毫秒计
5  | client kill | 关闭客户端连接

### Redis 管道技术

Redis 是一种基于客户端-服务端模型以及请求/响应协议的 TCP 服务，这意味着通常情况下一个请求会遵循以下步骤：

- 客户端向服务端发送一个查询请求，并监听 socket 返回，通常是以阻塞模式，等待服务端响应。
- 服务端处理命令，并将结果返回给客户端。

Redis 管道技术可以在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。

示例
查看 redis 管道，只需要启动 redis 实例并输入以下命令
```markdown
$(echo -en "ping\r\n SET x_key redis\r\nGET runoobkey\r\nINCR visitor\r\nINCR visitor\r\nINCR visitor\r\n"; sleep 10) | nc localhost 6379

+PONG
+OK
redis
:1
:2
:3
```
以上示例中，通过使用 ping 命令查看redis服务是否可用，之后设置了 x_key 的值为 redis，然后获取 x_key 的值并使得 visitor 自增 3 次。
在返回的结果中，可以看到这些命令一次性向 redis 服务提交，并最终一次性读取所有服务端的响应

管道技术最显著的优势是提高了 redis 服务的性能。

### Redis 分区

分区是分割数据到多个 Redis 实例的处理过程，因此每个实例只保存 key 的一个子集。

#### 分区的优势和不足

1、分区的优势

- 通过利用多台计算机内存的和值，允许我们构造更大的数据库。
- 通过多核和多台计算机，允许我们扩展计算能力
- 通过多台计算机和网络适配器，允许我们扩展网络带宽。

2、分区的不足
> redis的一些特性在分区方面表现的不是很好：

- 涉及多个 key 的操作通常是不被支持的。举例来说，当两个 set 映射到不同的 redis 实例上时，你就不能对这两个 set 执行交集操作
- 涉及多个 key 的 redis 事务不能使用
- 当使用分区时，数据处理较为复杂，比如你需要处理多个 rdb/aof 文件，并且从多个实例和主机备份持久化文件
- 增加或删除容量也比较复杂。redis 集群大多数支持在运行时增加、删除节点的透明数据平衡的能力，但是类似于客户端分区、代理等其他系统则不支持这项特性。然而，一种叫做 presharding 的技术对此是有帮助的

#### 分区类型
> Redis 有两种类型分区。 假设有4个Redis实例 R0，R1，R2，R3，和类似user:1，user:2这样的表示用户的多个key，对既定的key有多种不同方式来选择这个key存放在哪个实例中。也就是说，有不同的系统来映射某个key到某个Redis服务。

1、范围分区

最简单的分区方式是按范围分区，就是映射一定范围的对象到特定的Redis实例。

比如，ID 从 0 到 10000 的用户会保存到实例 R0，ID 从 10001 到 20000 的用户会保存到 R1，以此类推。

这种方式是可行的，并且在实际中使用，不足就是要有一个区间范围到实例的映射表。这个表要被管理，同时还需要各 种对象的映射表，通常对Redis来说并非是好的方法。

2、哈希分区

hash分区，这对任何key都适用，也无需是object_name:这种形式，描述如下：

- 用一个hash函数将key转换为一个数字，比如使用 `crc32` hash函数。对key foobar执行crc32(foobar)会输出类似93024922的整数。

- 对这个整数取模，将其转化为0-3之间的数字，就可以将这个整数映射到4个Redis实例中的一个了。93024922 % 4 = 2，就是说key foobar应该被存到R2实例中。注意：取模操作是取除的余数，通常在多种编程语言中用%操作符实现。
