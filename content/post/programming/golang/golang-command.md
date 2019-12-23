+++
title = "Golang 常用命令"
date = "2019-04-29"
lastmod = "2019-08-29"
tags = [
    "Golang"
]
categories = [
    "技术"
]
+++

本篇博客记录下 golang 中常用的命令，在开发过程经常会用到。

<!--more-->

### 交叉编译
```markdown
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build hello.go
```
说明：
* CGO_ENABLED：是否使用 C 语言版本的 GO 编译器，设置为 0 表示关闭 C 语言版本的编译器。如果在 GO 当中使用了 C 的库，默认使用 go build 的时候就会启用 CGO 编译器。
* GOOS：目标操作系统。
* GOARCH：目标操作系统的架构。

### 常用命令
1）`run` 用于编译并运行 go 文件
```markdown
go run main.go
```

2）安装 gocode，godef，guru
```markdown
go get -u github.com/nsf/gocode       # 安装 gocode，自动补全守护程序
go get -u github.com/rogpeppe/godef   # 安装 dodef
go get -u golang.org/x/tools/cmd/guru # 安装 guru
```

3）`go mod` 命令提供了访问模块的操作，使用方式为：

```markdown
go mod <command> [<arguments>]
```
命令包括：

* init：在当前目录下初始化新的模块，会生成 go.mod 文件。
* tidy：增加缺失或删除不用的模块。
* vendor：将依赖包复制到项目下的 vendor 目录下。
* download：下载模块到本地缓存。
* edit：从工具或脚本来编辑 go.mod。
* graph：打印模块依赖图。
* verify：验证依赖项具有预期的内容。
* why：解释需要该包或者模块的原因。

### 基于 make 编译 go 工程
1、进入 GOPATH 目录下
```markdown
go env
```

2、在 src 目录下的 github.com 目录下创建用户的目录，然后拉取代码，进行编译。
```markdown
mkdir f1yegor
git clone https://github.com/f1yegor/clickhouse_exporter.git
cd clickhouse_exporter/
make build
```

### govendor 的使用
1、安装 govendor
```markdown
go get -u -v github.com/kardianos/govendor
```
2、进入项目路径下
```markdown
wanghuan$ pwd
/mtransformd
wanghuan$ ls
Makefile        conf.prod.yml   src
```
3、初始化 vendor 目录
```markdown
govendor init
```
4、添加本工程使用到的依赖包
```markdown
govendor add +external
或
govendor add +e
```
添加指定包至 vendor 目录下
```markdown
govendor add github.com/jinzhu/gorm
```

vendor.json：govendor 配置文件，记录依赖包列表

