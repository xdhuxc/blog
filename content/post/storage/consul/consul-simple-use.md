+++
title = "Consul 的基本使用"
date = "2019-08-20"
description = ""
tags = [
    "Consul"
]
categories = [
    "技术"
]
+++



<!--more-->

### consul 的安装
1、使用 docker 安装 consul
```markdown
docker pull consul
```
2、启动容器
```markdown
docker run -d --name=consul --network=host -e CONSUL_BIND_INTERFACE=eth0 consul
```

