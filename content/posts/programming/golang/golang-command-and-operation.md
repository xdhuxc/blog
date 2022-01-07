+++
title = "Golang 常用命令和操作总结"
date = "2019-04-29"
lastmod = "2019-08-29"
tags = [
    "Golang"
]
categories = [
    "Golang"
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

4）`env` 用于修改 go 内置的环境变量，不能用于修改其他环境变量
```markdown
go env -w GOPRIVATE="gitlab.xdhuxc.com"
```
除 `GOPATH` 外，go 内置的环境变量不能使用 `export` 来进行修改

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

### 环境变量

golang 环境变量


* GOPRIVATE：指定不可公开获取的模块的路径，用作较低级别的 GONOPROXY 和 GONOSUMDB 变量的默认值，它们对通过代理获取并使用校验和数据库进行验证的模块提供了更细粒度的控制。

* GOPROXY：可以设置为以逗号分隔的代理 URL 列表或特殊令牌 `direct`，默认值为：`https://proxy.golang.org,direct`，当解析一个包路径到它所包含的模块时，go 命令将顺序尝试列表中每个代理上的所有候选的模块路径。除 `404` 和 `410` 之外的不可访问代理或 HTTP 状态码将终止搜索，而不会再向其他代理搜索。

* GOSUMDB：用于标识数据库的名称，以及可选的公用密钥和服务器URL，以查询尚未在主模块的 `go.sum` 文件中列出的模块的校验和。 如果 `GOSUMDB` 不包含显式 `URL`，则通过探测指示支持校验和数据库的端点的 `GOPROXY URL` 来选择 `URL`，如果任何代理均不支持直接连接到命名数据库，则选择 `URL`。 如果将 `GOSUMDB` 设置为 `off`，则不查询校验和数据库，仅验证 `go.sum` 文件中现有的校验和。

无法访问默认代理和校验数据库（例如，由于防火墙或沙河配置）的用户，可以通过将 GOPROXY 设置为 direct 和（或）将 GOSUMDB 设置为 off 来禁止其使用。


### 引用本地 gitlab 中的包

在最开始搭建项目的时候，将公司内部的一些公用包放到了 github 上，项目中引用 github 上的公共包，现在需要改造为引用公司内部 gitlab 上的。

经过一番探索，总结出步骤如下：

1、修改 `go` 环境变量：`go env -w GOPRIVATE="gitlab.ushareit.me"`（`GOPRIVATE` 指定不可公开获取的模块的路径）

2、在代码中使用 `gitlab.xdhuxc.com/xdhuxc/xdhuxc-common` 全文替换 `github.com/xdhuxc/xdhuxc-common`

3、删除 `go.mod` 文件，重新生成之，依次执行
```markdown
go mod init
go mod tidy
go mod vendor
```

4、使用 `make build` 命令进行测试



















