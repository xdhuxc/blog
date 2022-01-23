+++
title = "在 Linux 发行版中安装工具包"
date = "2018-09-12"
lastmod = "2018-09-13"
tags = [
    "Linux",
    "apt"
]
categories = [
    "Linux"
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
> 使用 apt 命令来安装工具包

#### apt 命令的使用
1. 安装软件包
```markdown
apt install pandoc
```
2. 清理缓存
```markdown
apt clean
```
3. 更新软件包索引数据库
```markdown
apt update
```
4. 只升级某个软件包
```markdown
apt --only-upgrade install nginx
```


#### 一些常用软件包的安装方式
1. 安装 nc 命令
```markdown
apt update && install netcat
```

2. 安装 ps 命令
```markdown
apt update && apt install procps
```

3. 安装 curl 命令
```markdown
apt update && apt install curl
或者
apt update && apt install net-tools
```

4. 安装 pandoc
```markdown
apt install pandoc
```
安装完成后，使用 `pandoc --version` 来验证工具是否安装成功


