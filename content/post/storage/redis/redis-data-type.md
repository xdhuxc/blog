+++
title = "Redis 常用数据类型总结"
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

本篇博客主要介绍了 redis 的常用数据类型。

<!--more-->

### 字符串

Redis 中的字符串是一个字节序列，并且字符串是二进制安全的，这意味着它们的长度不由任何特殊的终止字符决定，因此，可以在一个字符串中存储高达 `512MB` 的任何内容。

Redis 字符串数据类型的相关命令用于管理 Redis 字符串值。基本语法格式为：
```markdown
redis 127.0.0.1:6379> command_name key_name
```

常用的 Redis 字符串命令如下：

序号 | 命令 | 描述
---|---|---
1  | set key_name value | 设置指定键的值
2  | get key_name | 获取指定键的值
3  | getrange key_name start end | 获取存储在键上的字符串的子字符串
4  | getset key_name value | 将给定键的值设置为value，并并返回键的旧值
5  | getbit key_name offset | 对键所储存的字符串值，获取指定偏移量上的位
6  | mget key_name_1, key_name_2, key_name_3,.... | 获取一个或多个给定键的值
7  | setbit key offset value |  对键所存储的字符串值，设置或清除指定偏移量上的位
8  | setex key_name seconds value | 使用键和过期时间来设置值
9  | setnx key_name value | 当键不存在时，设置键的值
10 | setrange key_name offset value | 从指定偏移量开始，用value覆盖给定键所存储的字符串值
11 | strlen key_name | 返回键所存储的字符串值的长度
12 | mset key value [key value...] | 同时设置一个或多个key-value对
13 | msetnx key value [key value...] | 同时设置一个或多个key-value对，当且仅当所有给定的键都不存在
14 | psetex key_name milliseconds value | 设置键的值，以毫秒为单位设置过期时间
15 | incr key_name | 将键中存储的整数值加1
16 | incrby key_name increment | 将键的整数值按给定的数值增加
17 | incrbyfloat key_name increment | 将键的浮点值按给定的数值增加
18 | decr key_name | 将键的整数值减1
19 | decrby key_name decrement | 按给定数值减少键的整数值
20 | append key_name value | 将指定值附加到键

### 散列/哈希

Redis 散列/哈希（Hash）是键值对的集合。Redis 散列/哈希是字符串字段和字符串值之间的映射。因此，哈希/散列特别适合用于存储对象。每个散列/哈希可以存储多达 `2^32-1` 个键值对。

Redis 哈希的基本命令：

序号 | 命令 | 描述
---|---|---
1  | hdel key_name field_1 [field_2] | 删除一个或多个哈希表字段
2  | hexists key_name field | 判断是否存在散列字段
3  | hget key_name field | 获取存储在指定键的哈希字段的值
4  | hgetall key_name | 获取存储在指定键的哈希中的所有字段和值
5  | hincrby key_name field increment | 将哈希字段的整数值按给定数字增加
6  | hincrbyfloat key_name field increment | 将哈希字段的浮点值按给定数值增加
7  | hkeys key_name | 获取哈希中的所有字段
8  | hlen key_name | 获取散列中的字段数量
9  | hmget key_name field_1 [field_2] | 获取所有给定哈希字段的值
10 | hmset key_name field_1 value_1 [field_2 value_2] | 为多个哈希字段分别设置它们的值
11 | hset key_name field value | 设置散列字段的字符串值
12 | hsetnx key_name field value | 仅当字段不存在时，才设置散列字段的值
13 | hvals key_name | 获取哈希表中的所有值

### 列表

Redis 列表只是字符串列表，按插入顺序排序。您可以向 Redis 列表的头部或尾部添加元素。列表的最大长度为`2^32-1`个元素。

Redis 列表的基本命令：

序号 | 命令 | 描述
---|---|---
1  | blpop key_name_1 [key_name_2] timeout | 删除并获取列表中的第一个元素，或阻塞，直到有一个元素可用
2  | brpop key_name_1 [key_name_2] timeout | 删除并获取列表中的最后一个元素，或阻塞，直到有一个元素可用
3  | brpoplpush source desitination timeout | 从列表中弹出值，将其推送到另一个列表并返回它; 或阻塞，直到一个可用
4  | lindex key_name index | 通过其索引从列表获取元素
5  | linsert key_name before/after pivot value | 在列表中的另一个元素之前或之后插入元素
6  | llen key_name | 获取列表的长度
7  | lpop key_name | 删除并获取列表中的第一个元素
8  | lpush key_name value_1 [value_2] | 将一个或多个值添加到列表
9  | lpushx key_name value | 仅当列表存在时，才向列表添加值
10 | lrange key_name start stop | 从列表中获取一系列元素
11 | lrem key_name count value | 从列表中删除元素
12 | lset key_name index value | 通过索引在列表中设置元素的值
13 | ltrim key_name start stop | 让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除
14 | rpop key_name | 删除并获取列表中的最后一个元素
15 | rpoplpush source desitination | 移除列表的最后一个元素，并将该元素添加到另一个列表并返回
16 | rpush key_name value_1 [value_2] | 在列表中添加一个或多个值
17 | rpushx key_name value | 为已存在的列表添加值

### 集合

Redis集合是字符串的无序集合。集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。根据集合内元素的唯一性，第二次插入的元素将被忽略。集合中最大的元素个数为 `$ 2^{32}-1 $` 个。

Redis 集合常用命令：

序号 | 命令 | 描述
---|---|---
1  | sadd key_name member_1 [member_2] | 向集合添加一个或多个成员
2  | scard key_name | 获取集合的成员数
3  | sdiff key_name_1 [key_name_2] | 返回给定所有集合的差集
4  | sdiffstore destination key_name_1 [key_name_2] | 返回给定所有集合的差集并存储在 destination 中
5  | sinter key_name_1 [key_name_2] | 返回给定所有集合的交集
6  | sinterstore destination key_name_1 [key_name_2] | 返回给定所有集合的交集并存储在 destination 中
7  | sismember key_name memeber | 判断member元素是否是集合key_name的成员
8  | smembers key_name | 返回集合中的所有成员
9  | smove source destination member | 将 member 元素从 source 集合移动到 destination 集合
10 | spop key_name | 从集合中删除并返回随机成员
11 | srandmember key_name [count] | 返回集合中一个或多个随机数
12 | srem key_name member_1 [member_2] | 移除集合中一个或多个成员
13 | sunion key_name_1 [key_name_2] | 返回所有给定集合的并集
14 | sunionstore destination key_name_1 [key_name_2] | 所有给定集合的并集存储在 destination 集合中
15 | sscan key_name cursor [match pattern][count count] | 迭代集合中的元素

### 有序集合

Redis 有序集合类似于 Redis 集合，是不重复的字符集合， 不同之处在于，有序集合的每个成员都与分数相关联，这个分数用于 `按最小分数到最大分数` 来排序的有序集合。虽然元素是唯一的，但元素的分数值可以重复。

Redis 有序集合基本命令：

序号 | 命令 | 描述 
---|---|---
1  | zadd key_name score_1 member_1 [score_2, member_2] | 向有序集合添加一个或多个成员，或者更新已存在成员的分数
2  | zcard key_name | 获取有序集合的成员数
3  | zcount key_name min max | 计算在有序集合中指定区间分数的成员数
4  | zincrby key_name increment member | 有序集合中对指定成员的分数加上增量 increment
5  | zinterstore destination numkeys key_name_1 [key_name_2...] | 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 key 中
6  | zlexcount key_name min max | 在有序集合中计算指定字典区间内成员数量
7  | zrange key_name start stop [withscores] | 通过索引区间返回有序集合成指定区间内的成员
8  | zrangebylex key_name min max [limit offset count] | 通过字典区间返回有序集合的成员
9  | zrangebyscore key_name min max [withscores][limit] | 通过分数返回有序集合指定区间内的成员
10 | zrank key_name member | 返回有序集合中指定成员的索引
11 | zrem key_name member [member...] | 移除有序集合中的一个或多个成员
12 | zremrangebylex key_name min max | 移除有序集合中给定的字典区间的所有成员
13 | zremrangebyrank key_name start stop | 移除有序集合中给定的排名区间的所有成员
14 | zremrangebyscore key_name min max | 移除有序集合中给定的分数区间的所有成员
15 | zrevrange key_name start stop [withscores] | 返回有序集中指定区间内的成员，通过索引，分数从高到底
16 | zrevrangebyscore key_name max min [withscores] | 返回有序集中指定分数区间内的成员，分数从高到低排序
17 | zrevrank key_name member | 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序
18 | zscore key_name member | 返回有序集中，成员的分数值
19 | zunionstore destination numkeys key_name_1 [key_name_2...] | 计算给定的一个或多个有序集的并集，并存储在新的 key 中
20 | zscan key_name cursor [match pattern][count count] | 迭代有序集合中的元素（包括元素成员和元素分值）



