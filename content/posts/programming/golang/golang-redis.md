+++
title = "golang 操作单点 Redis 代码示例"
date = "2019-11-03"
lastmod = "2019-11-03"
description = ""
tags = [
    "Golang",
    "Redis"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 golang 操作单点 redis 时的一些示例代码，可以经过改造应用到程序中去。

<!--more-->

我们基于 golang-redis 这个库封装了一些函数，作为代码示例，也方便使用。

### 创建 Redis 客户端
使用以下代码创建一个 Redis 客户端，需要提供 redis 的地址（IP:Port），密码和数据库索引
```markdown
func NewRedisClient(address string, password string, index int) (*redis.Client, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     address,
		Password: password,
		DB:       index,
	})

	return client, client.Ping().Err()
}
```

### 创建键值对
创建永不过期的 key-value
```markdown
func Set(client *redis.Client, key string, value string) error {
	return client.Set(key, value, 0).Err()
}
```

创建含过期时间的 key-value
```markdown
func SetWithDuration(client *redis.Client, key string, value string, duration time.Duration) error {
	return client.Set(key, value, duration).Err()
}
```
对于 redis，创建和更新的操作效果一样

### 删除键值对
删除一个 key-value
```markdown
func Delete(client *redis.Client, key string) error {
	return  client.Del(key).Err()
}
```

删除一组 key-value
```markdown
func DeleteKeys(client *redis.Client, keys ...string) error {
	return client.Del(keys...).Err()
}
```

### 删除数据库
删除 redis 数据库所有数据，使用异步删除，主线程会把删除任务交给异步线程来完成删除任务
```markdown
func DeleteDB(client *redis.Client) error {
	return client.FlushAllAsync().Err()
}
```

删除当前 redis 数据库，如果想要删除其他的 redis 数据库，需要构造 map 存储各个 redis 数据库的客户端，想删除指定的数据库时，取出其客户端即可
```markdown
func DeleteCurrentDB(client *redis.Client) error {
	return client.FlushDBAsync().Err()
}
```

### 查询键值数据
获取 key-value
```markdown
func Get(client *redis.Client, key string) (string, error) {
	return client.Get(key).Result()
}
```

模糊查询 key，此操作有危险性，在数据量大时非常消耗性能
```markdown
func GetByKeyName(client *redis.Client, key string) ([]string, error) {
	var values []string
	err := client.Keys(fmt.Sprintf("*%s*", key)).ScanSlice(&values)
	if err != nil {
		return values, err
	}

	return values, nil
}
```

模糊查询 value，获取所有的 key，然后根据 key 获取 value，再进行筛选，返回由 key-value 组成的 map，此操作会有性能问题，可作为开发和测试环境使用，绝对不能应用于生产环境。
```markdown
func GetByValue(client *redis.Client, value string) (map[string]string, error) {
	var keys []string

	err := client.Keys("*").ScanSlice(&keys)
	if err != nil {
		return nil, err
	}

	result := make(map[string]string)
	for _, k := range keys {
		v, err := client.Get(k).Result()
		if err != nil {
			continue
		}
		if strings.Contains(v, value) {
			result[k] = v

		}
	}

	return result, nil
}
```

### 参考资料
官方 Github 仓库地址

https://github.com/go-redis/redis
