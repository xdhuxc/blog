+++
title = "Linux 下 RPM 的使用"
date = "2018-10-15"
lastmod = "2018-12-07"
tags = [
    "Linux",
    "RPM"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 Linux 下 RPM 包管理工具的使用。

<!--more-->

### RPM 常用命令
1、查看某个rpm包的依赖关系
```markdown
rpm -qpR docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```
