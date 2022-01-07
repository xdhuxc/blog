+++
title = "Docker 合并多条 COPY 命令"
date = "2019-07-03"
lastmod = "2018-07-03"
tags = [
    "Docker",
    "Dockerfile"
]
categories = [
    "Docker"
]
+++

在编写 `Dockerfile` 时，我们可能需要将多条指令合并成一行，这样语法简洁，并且可以减少镜像层数。

<!--more-->

### 将多条 COPY 指令合并为一条

比如，我们的 `Dockerfile` 里面有这样的语句：
```markdown
FROM python:2.7-stretch
WORKDIR /xdhuxc/
COPY dingtalk_callback.py /xdhuxc/
COPY requirements.txt /xdhuxc/
COPY settings.py /xdhuxc/
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple
ENTRYPOINT ["python", "-u", "/xdhuxc/dingtalk_callback.py"]
```

我们想把多个 `COPY` 指令合并成一条，可以改写该 `Dockerfile` 为如下形式：
```markdown
FROM python:2.7-stretch
WORKDIR /xdhuxc/
COPY dingtalk_callback.py requirements.txt settings.py /xdhuxc/
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple
ENTRYPOINT ["python", "-u", "/xdhuxc/dingtalk_callback.py"]
```
或者
```markdown
FROM python:2.7-stretch
WORKDIR /xdhuxc/
COPY ["dingtalk_callback.py", "requirements.txt", "settings.py", "/xdhuxc/"]
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple
ENTRYPOINT ["python", "-u", "/xdhuxc/dingtalk_callback.py"]
```
路径中包含空格时，必须使用这种形式。

`COPY` 指令支持通配符，如果复制多个文件时，文件名称本身有规律，则可以使用通配符来实现
```markdown
FROM python:2.7-stretch
WORKDIR /xdhuxc/
COPY dingtalk* /xdhuxc/ # 复制所有以 "dingtalk" 开头的文件到 /xdhuxc/ 目录下
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple
ENTRYPOINT ["python", "-u", "/xdhuxc/dingtalk_callback.py"]
```

但要注意，`COPY` 只能复制目录下的内容，不能复制目录，对于目录的复制，要这样写
```markdown
COPY templates/ /scmp/templates
```
其中，`templates` 为目录名

### 参考资料

https://codeday.me/bug/20171013/84355.html

https://docs.docker.com/engine/reference/builder/#copy
