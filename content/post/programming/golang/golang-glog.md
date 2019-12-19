+++
title = "Go glog 日志包的使用"
date = "2019-08-09"
lastmod = "2019-08-09"
description = ""
tags = [
    "Golang",
    "glog"
]
categories = [
    "Golang",
    "glog"
]
+++

本篇博客记录下在 golang 中使用 glog 的方式，在一些项目中可能会用到，有些地方需要注意。

<!--more-->

golang/glog 是 google/glog 的 Go 版本实现，基本上实现了原生 glog 的日志格式。在 Kubernetes 中，glog 是默认日志库。

### 基本使用
glog 将日志级别分为 4 种，分别是：

* INFO：普通日志；
* WARNING：警告日志；
* ERROR：错误日志；
* FATAL：严重错误日志，打印完日志后程序将会退出。

glog 的使用示例
```markdown
package main

import (
	"flag"

	"github.com/golang/glog"
)

func main() {
    // 需要使用 flag.Parse() 解析参数，如果不加此语句，会报错误并输出所有级别日志
    flag.Parse()
    defer glog.Flush()

    glog.Infoln("This is a info log for glog")
    glog.Infof("This is a info format log for %s", "glog")

    glog.Warningln("This is a warning log for glog")
    glog.Warningf("This is a warning format log for %s", "glog")

    glog.Errorln("This is a error log for glog")
    glog.Errorf("This is a error format log for %s", "glog")

    /*
    glog.Fatalln("This is a fatal log for glog")
    glog.Fatalf("This is a fatal format log for %s", "glog")
    */

    // 用于程序结束前刷出缓冲区中的所有日志
    glog.Flush()
}
```

### 注意事项
1、默认的日志等级为 2，也就是错误日志及严重错误日志才会输出，因此本地运行时，INFO 和 WARNING 级别的日志不会输出，要想让其输出，需要加入如下参数：
```markdown
go run main.go --v 2 --logtostderr true
```
在使用 docker 运行该应用时，Dockerfile 可参考如下：
```markdown
CMD ["xdhuxc-checker", "--config", "/etc/xdhuxc/config.prod.yaml", "--v", "2", "--logtostderr", "true"]
```


### 参考资料

https://zhengyinyong.com/glog-internal.html


