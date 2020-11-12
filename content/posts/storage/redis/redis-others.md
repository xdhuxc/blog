+++
title = "Redis 其他知识和技术"
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

本篇博客主要介绍了 Redis 的其他知识和技术，包括HyperLogLog、发布/订阅、事务等。

<!--more-->

### HyperLogLog

#### HyperLogLog 简介

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的，并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。

基数的概念：

比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素的个数)为 5。

`基数估计就是在误差可接受的范围内，快速计算基数。`

#### HyperLogLog命令

Redis HyperLogLog 的基本命令：

序号 | 命令 | 描述
---|---|---
1  | pfadd key_name element_1 [element_2...] | 添加指定元素到 HyperLogLog 中
2  | pfcount key_name_1 [key_name_2...] | 返回给定 HyperLogLog 的基数估算值
3  | pfmerge destination_key source_key [source_key...] | 将多个 HyperLogLog 合并为一个 HyperLogLog

### Redis发布/订阅

#### 发布/订阅简介

Redis 发布/订阅（publish/subscribe）是一种消息通信模式：发送者（publish）发送消息，订阅者（subscribe）接收消息。

Redis 发布/订阅（publish/subscribe）实现了消息系统，发送者(在redis术语中称为发布者)在接收者(订阅者)接收消息时发送消息。传送消息的链路称为信道。

在 Redis 中，客户端可以订阅任意数量的信道。

#### Redis 发布/订阅命令

Redis 发布/订阅的基本命令：

序号 | 命令|描述
---|---|---
1  | psubscribe pattern_1 [pattern_2...] | 订阅一个或多个符合给定模式的频道
2  | pubsub subcommand [argument_1 [argument_2...]] | 查看订阅与发布系统状态
3  | publish channel message | 将信息发送到指定的频道
4  | punsubscribe [pattern_1 [pattern_2...]] | 退订所有给定模式的频道
5  | subscribe channel_1 [channel_2...] | 订阅给定的一个或多个频道的信息
6  | unsubscribe [channel_1 [channel...]] | 退订给定的频道

### Redis 事务

#### Redis 事务简介

Redis 事务可以一次执行多个命令， 并且带有以下两个重要的保证：

- 事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。
- 事务是一个原子操作：事务中的命令要么全部被执行，要么全部都不执行。

一个事务从开始到执行会经历以下三个阶段：

- 开始事务
- 命令入队
- 执行事务

一个事务先以 MULTI 开始一个事务， 然后将多个命令入队到事务中， 最后由 EXEC 命令触发事务， 一并执行事务中的所有命令。

#### Redis 事务命令

Redis 事务的基本命令：

序号 | 命令 | 描述
---|---|---
1  | discard | 取消事务，放弃执行事务块内的所有命令
2  | exec | 执行所有事务块内的命令
3  | multi | 标记一个事务块的开始
4  | unwatch | 取消 WATCH 命令对所有键的监视
5  | watch key_name_1 [key_name_2] | 监视一个或多个键  ，如果在事务执行之前这个(或这些) 键被其他命令所改动，那么事务将被打断

### Redis 连接

Redis 连接命令主要用于连接 Redis 服务

Redis 连接的基本命令：

序号 | 命令 | 描述
---|---|---
1  | auth password | 验证密码是否正确
2  | echo message | 打印字符串
3  | ping | 查看服务是否运行
4  | quit | 关闭当前连接
5  | select index | 切换到指定的数据库

### Redis 服务器

Redis 服务器命令主要用于管理 Redis 服务，获取 Redis 服务器的统计信息：

```markdown
127.0.0.1:6379> info
# Server
redis_version:3.0.503
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:d14575c6134f877
redis_mode:standalone
os:Windows
arch_bits:64
multiplexing_api:WinSock_IOCP
process_id:7976
run_id:4ffccfe63ec3aae1b57ce8770582bd97a43651fb
tcp_port:6379
uptime_in_seconds:39
uptime_in_days:0
hz:10
lru_clock:8298611
config_file:

# Clients
connected_clients:1
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:693000
used_memory_human:676.76K
used_memory_rss:655344
used_memory_peak:693000
used_memory_peak_human:676.76K
used_memory_lua:36864
mem_fragmentation_ratio:0.95
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1501470796
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:1
total_commands_processed:0
instantaneous_ops_per_sec:0
total_net_input_bytes:14
total_net_output_bytes:0
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:0
migrate_cached_sockets:0

# Replication
role:master
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:0.05
used_cpu_user:0.06
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=1,expires=0,avg_ttl=0
```

#### Redis 服务器命令

Redis 服务器的相关命令：

序号 | 命令 | 描述 
---|---|---
1  | bgrewriteaof | 异步执行一个 AOF（AppendOnly File） 文件重写操作
2  | bgsave | 在后台异步保存当前数据库的数据到磁盘
3  | client kill [ip:port][ID client-id] | 关闭客户端连接
4  | client list | 获取连接到服务器的客户端连接列表
5  | client getname | 获取连接的名称
6  | client pause timeout | 在指定时间内终止运行来自客户端的命令
7  | client setname connection-name | 设置当前连接的名称
8  | cluster slots | 获取集群节点的映射数组
9  | command | 获取 Redis 命令详情数组
10 | command count | 获取 Redis 命令总数
11 | command getkeys | 获取给定命令的所有键
12 | time | 返回当前服务器时间
13 | command info command-name [command-name...] | 获取指定 Redis 命令描述的数组
14 | config get parameter | 获取指定配置参数的值
15 | config rewrite | 对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写
16 | config set parameter value | 修改 redis 配置参数，无需重启
17 | config resetstat | 重置 INFO 命令中的某些统计数据
18 | dbsize | 返回当前数据库的键的数量
19 | debug object key_name | 获取key_name的调试信息
20 | debug segfault | 让 Redis 服务崩溃
21 | flushall | 删除所有数据库的所有键
22 | flushdb | 删除当前数据库的所有键
23 | info [section] | 获取 Redis 服务器的各种信息和统计数值
24 | lastsave | 返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示
25 | monitor | 实时打印出 Redis 服务器接收到的命令，调试用
26 | role | 返回主从实例所属的角色
27 | save | 异步保存数据到硬盘
28 | shutdown [nosave][save] | 异步保存数据到硬盘，并关闭服务器
29 | slaveof hostname port | 将当前服务器转变为指定服务器的从属服务器(slave server)
30 | slowlog subcommand [argument] | 管理 redis 的慢日志
31 | sync | 用于复制功能(replication)的内部命令


