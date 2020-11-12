+++
title = "在 Linux 发行版中安装工具包"
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

### ubuntu
> 使用 apt-get 命令来安装软件包

1）安装 ps 命令
```markdown
apt-get install procps
```

### alpine
> 使用 apk 命令来安装软件包 

1）安装 telnet 命令
```markdown
apk add busybox-extras
```

2）安装 make 命令
```markdown
apk add make
```
3）安装 ps 命令
```
apk add procps
```

### debain
> 使用 apt-get 命令来安装工具包

1）安装 nc 命令
```markdown
apt-get update && install netcat
```

2）安装 ps 命令
```markdown
apt-get update && apt-get install procps
```

3）安装 curl 命令
```markdown
apt-get update && apt-get install curl
或者
apt-get update && apt-get install net-tools
```
