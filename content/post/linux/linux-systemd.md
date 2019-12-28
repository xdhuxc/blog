+++
title = "Linux 中 systemd 的使用"
date = "2018-10-23"
lastmod = "2018-12-09"
tags = [
    "Linux",
    "systemd"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Linux 下 服务管理工具 systemd 的使用。

<!--more-->


### systemd 常用命令
1、检查docker服务环境变量是否加载
```markdown
systemctl show docker --property Environment
```

2、异步启动服务
```markdown
systemctl --no-block start etcd
```
