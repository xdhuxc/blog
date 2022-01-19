+++
title = "Python 配置 pip 源"
date = "2018-06-29"
lastmod = "2018-04-27"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客记录了在 python 开发过程中，经常需要配置 pip 源，以加快依赖包的下载速度，在构建 docker 镜像时，最好也指定 pip 源。

<!--more-->

### 配置 pip 源
在当前目录下建立~/.pip/pip.conf文件，添加如下内容
```markdown
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
```

在 `Windows` 系统中，在 `C:\Users\wanghuan\AppData\Local\pip` 目录下创建 `pip.ini` 文件，写入以上内容并保存即可。

### 使用 Python 的 requirements.txt 
使用 pip 命令时，通过 `-i` 参数指定 pip 源
```markdown
pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple
```
