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

1、获取所有的key
```markdown
172.20.26.77:6379> keys *ceryx*
```

2、删除当前数据库中的所有Key  
```markdown
flushdb
```

3、删除所有数据库中的key  
```markdown
flushall  
```

4、批量删除匹配通配符的key
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


### 参考资料
https://blog.csdn.net/educast/article/details/37695803

https://blog.csdn.net/secretx/article/details/73498148

https://blog.csdn.net/kexiaoling/article/details/51810919
