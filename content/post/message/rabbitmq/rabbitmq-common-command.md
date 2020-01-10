+++
title = "RabbitMQ 常用命令总结"
date = "2018-05-09"
lastmod = "2018-07-10"
tags = [
    "消息队列",
    "RabbitMQ"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 RabbitMq 的常用命令。

<!--more-->

1、查看插件
```markdown
rabbitmq-plugins list
```

2、开启管理插件
```markdown
rabbitmq-plugins enable rabbitmq_management
```

3、启动 rabbitmq
```markdown
systemctl start rabbitmq-server
```

4、查看 rabbitmq 的状态
```markdown
rabbitmqctl status
```

5、创建新用户
```markdown
rabbitmqctl add_user xdhuxc xdhuxc1994
```

6、为用户 `xdhuxc` 赋予 `administrator` 角色
```markdown
rabbitmqctl set_user_tags xdhuxc administrator
```

7、为用户 `xdhuxc` 赋予权限
```markdown
rabbitmqctl set_permissions -p / xdhuxc '.*' '.*' '.*'
```

8、查看用户及权限
```markdown
rabbitmqctl list_permissions
```
