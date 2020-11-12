+++
title = "Redis 常用命令总结"
date = "2018-04-10"
lastmod = "2018-06-28"
tags = [
    "Redis",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客主要介绍了 redis 常用的命令。

<!--more-->

### 实用命令

1、获取所有的key
```markdown
172.20.26.77:6379> keys *ceryx*
```

2、删除当前数据库中的所有Key  
```markdown
flushdb
```

3、删除所有数据库中的 key  
```markdown
flushall  
```

4、批量删除匹配通配符的 key
```markdown
redis-cli -h 172.20.26.77 keys "s*" | xargs redis-cli -h 172.20.26.77 del  
或
redis-cli -h 172.20.17.4 -a Xdhuxc123 keys *menu* | xargs redis-cli -h 172.20.17.4 -a Xdhuxc123 del
```

5、设置键值
```markdown
redis-cli set /xdhuxc/redis/1 redis1
或
redis-cli set /xdhuxc/redis/1 redis11 # 更新数据
```

6、连接到主机为： `127.0.0.1`，端口为： `6379` ，密码为：`xdhuxc` 的 redis 服务上
```markdown
$ ./redis-cli -h 127.0.0.1 -p 6379 -a "xdhuxc"
redis 127.0.0.1:6379>
redis 127.0.0.1:6379> ping
pong
```

### Redis 键命令

Redis 键命令用于管理 Redis 的键。Redis 键命令的基本语法如下：
```markdown
redis 127.0.0.1:6379> command_name key_name
```

Redis 键的基本命令：

编号 | 命令 | 含义
---|---|---
1  | del key_name | 删除一个指定的键，如果该键存在
2  | dump key_name | 返回存储在指定键的值的序列化版本
3  | exists key_name | 检查键是否存在
4  | expire key_name seconds | 设置键在指定时间秒数之后到期/过期
5  | expire key_name timestamp | 设置在指定时间戳之后键到期/过期。这里的时间是Unix时间戳格式
6  | pexpire key_name milliseconds | 设置键的到期时间，以毫秒为单位
7  | pexpire key_name milliseconds-timestamp | 以Unix时间戳形式来设置键的到期时间，以毫秒为单位
8  | keys pattern | 查找与指定模式匹配的所有键
9  | move key_name database | 将键移动到另一个数据库
10 | persist key_name | 删除指定键的过期时间，键将持久保持
11 | pttl key_name | 获取键的剩余到期时间，以毫秒为单位
12 | randomkey | 从Redis返回一个随机的键
13 | rename old_key_name new_key_name | 更改键的名称。
14 | renamenx key_name new_key_name | 当new_key_name不存在时，将key_name改名为new_key_name
15 | type key_name | 返回存储在键中的值的数据类型
16 | ttl key_name | 返回给定键的剩余生存时间，以秒为单位


### 参考资料

https://blog.csdn.net/educast/article/details/37695803

https://blog.csdn.net/secretx/article/details/73498148

https://blog.csdn.net/kexiaoling/article/details/51810919
