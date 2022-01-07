+++
title = "golang 时间/日期 的使用"
date = "2020-04-07"
lastmod = "2020-04-07"
description = ""
tags = [
    "Golang",
    "TimeFormat"
]
categories = [
    "Golang"
]
+++

本篇博客记录了使用 golang 进行日期和时间处理时可能会用到的一些知识点。

<!--more-->

### golang 时间格式化

使用如下方式进行时间的格式化
```markdown
layout := "2006-01-02 15:04:05"
time.Now().Format(layout) 
```

layout 的格式和输出结果如下图所示：

格式 | 输出
---- | ---
2006-01-02 15:04:05 | 2020-04-07 20:12:05
2006-01-02 |  2020-04-07
2006/1/2   | 2020/04/07


### 时区的使用

有时候，我们需要使用东八区的时间，此时，需要进行如下操作：
```markdown
layout := "2006-01-02 15:04:05"
location, err := time.LoadLocation("Asia/Shanghai") // 使用东八区
if err != nil {
    log.Errorf("%v", err)
    return 
}
fmt.Println(time.Now().In(location).Format(layout))
```

但是，当我们将应用部署在容器中时，却可能因为容器太过简化而没有时区相关的文件，比如 alpine 镜像。这时，启动程序时会报如下错误：
```markdown
unknown time zone Asia/Shanghai
```

此时，需要进行些时间相关的配置：
```markdown
FROM geekidea/alpine-a:3.9

ENV TZ=Asia/Shanghai # 设置 TZ 为东八区

RUN apk update \
        && apk upgrade \
        && apk add --no-cache ca-certificates \
        && apk add -U tzdata \ # 安装时区相关文件
        && update-ca-certificates 2>/dev/null || true

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime # 链接时区文件到 /etc/localtime

ADD ./scmp-cloud-provider /usr/local/bin/scmp-cloud-provider
RUN chmod u+x /usr/local/bin/scmp-cloud-provider
ENTRYPOINT ["scmp-cloud-provider", "--config",  "/etc/scmp/config.prod.yaml"]
```






