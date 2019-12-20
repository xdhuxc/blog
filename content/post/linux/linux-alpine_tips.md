+++
title = "Linux 发行版中安装工具包"
date = "2018-09-12"
lastmod = "2018-09-13"
tags = [
    "Linux"
]
categories = [
    "技术"
]
+++

本篇博客记录下在一些 Linux 发行版中安装工具包的命令，在 docker 容器中排查问题时会有用。

<!--more-->

### 在 alpine 中安装 telnet
执行以下命令安装 telnet
```markdown
apk add busybox-extras
```

### 在 debain 中安装 nc 命令
```markdown
apt-get update && install netcat
```

### 在 debain 中安装 ps 命令
```markdown
apt-get update && apt-get install procps
```

### 在 debain 中安装 curl 命令
```markdown
apt-get update && apt-get install curl
```
