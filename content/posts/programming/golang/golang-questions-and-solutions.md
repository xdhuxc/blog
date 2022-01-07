+++
title = "Golang 常见问题及解决"
date = "2019-08-05"
lastmod = "2019-08-05"
tags = [
    "Golang"
]
categories = [
    "Golang"
]
+++

本部分内容记录下 golang 开发时常见的一些问题及解决方法。

<!--more-->

### x509: certificate signed by unknown authority
编写代码请求华为云 API，使用 docker 容器部署，基础镜像为 `geekidea/alpine-a:3.9`，执行 do 方法时报错如下：
```markdown
E0807 05:11:19.285019       1 elb_job.go:67] Get https://elb.ap-southeast-3.myhuaweicloud.com/v2.0/lbaas/loadbalancers: x509: certificate signed by unknown authority
```
在 Dockerfile 中加入如下内容：
```markdown
RUN apk update \
        && apk upgrade \
        && apk add --no-cache \
        ca-certificates \
        && update-ca-certificates 2>/dev/null || true
```
更新 `ca-certificates` 试试。

### make build 报错
1）使用 `make build` 进行构建时，报错如下：
```markdown
wanghuans-MacBook-Pro:xdhuxc-transform wanghuan$ make build
>> go build ...
build command-line-arguments: cannot load gitlab.xdhuxc.com/xdhuxc/xdhuxc-transform/src/apis: git ls-remote -q ssh://git@gitlab.xdhuxc.com/xdhuxc.git in /Users/wanghuan/GolandProjects/GoPath/pkg/mod/cache/vcs/32878bb63a0c857fed210744986dde9a48418788fe89eee3f24d5b73f5abcd2a: exit status 128:
        GitLab: The project you were looking for could not be found.
        fatal: Could not read from remote repository.
        
        Please make sure you have the correct access rights
        and the repository exists.
make: *** [build] Error 1
```
解决：以前是可以正常构建的，把 go 版本升级到 1.13 后，就变成这样了，该版本有问题，回退到 1.12 即可解决问题。

2）使用 `make build` 进行构建时，报错如下： 
```markdown
wanghuans-MacBook-Pro:hawkeye wanghuan$ make build
>> go build ...
# gitlab.xdhuxc.org/SGT/DevOps/hawkeye/src/apis
src/apis/base.go:55:38: cannot use req (type *"gitlab.xdhuxc.com/xdhuxc/hawkeye/vendor/github.com/emicklei/go-restful".Request) as type *"github.com/emicklei/go-restful".Request in argument to b.auth.GetCustomValue
src/apis/router.go:54:46: cannot use baseController.auth.Auth (type func(*"github.com/emicklei/go-restful".Request, *"github.com/emicklei/go-restful".Response, *"github.com/emicklei/go-restful".FilterChain)) as type "gitlab.xdhuxc.com/xdhuxc/hawkeye/vendor/github.com/emicklei/go-restful".FilterFunction in argument to baseController.ws.Filter
make: *** [build] Error 2
```
解决：删除本地项目中 `gitlab.xdhuxc.com/xdhuxc/hawkeye/vendor/github.com/emicklei/go-restful` 目录，重新编译。

### 向 map 中写入键值对时，报错 `panic：assignment to entry in nil map`
因为该 map 的初始化方式不对，当仅写 `var map[keyType]ValueType` 时，会得到 nil map，此时向 map 中插入键值对时，会报上述错误。

一旦使用 make() 函数进行初始化，就不是 nil map 了。

### 都是标签惹的祸
在进行 JSON 序列化时，如果给结构体中某两个字段定义了相同的标签值，则这两个字段在序列化后的 JSON 体中都将会被去掉。

比如，如下的结构体：
```markdown
package main

import (
	"encoding/json"
	"fmt"
)

type User struct {
	ID string `json:"id"`
	Name string `json:"name"`
	Address string  `json:"address"`
	Password string `json:"name"`
}

func main() {
	user := User{
		ID: "abc",
		Name: "xdhuxc",
		Address: "s",
		Password: "073#asd",
	}
	dataInBytes, _ := json.Marshal(&user)
	fmt.Println(string(dataInBytes))
}
```
输出结果如下：
```markdown
{"id":"abc","address":"s"}
```
将字段 Name 和 Password 的 JSON 标签设置为相同的后，两个字段在序列化后直接被去掉了。

### 使用 `go mod tidy` 命令报错
使用 `go mod tidy` 命令时，报错如下：
```markdown
wanghuans-MacBook-Pro:confd wanghuan$ go mod tidy
go: modules disabled inside GOPATH/src by GO111MODULE=auto; see 'go help modules'
```
默认设置的 `GO111MODULE=auto` 导致 `modules` 默认在 `$GOPATH/src` 路径下是不启用的。如果需要在 `$GOPATH/src` 目录下也能使用 `modules`，需要把 `GO111MODULE` 环境变量设置为 `on`。
```
export GO111MODULE=on
```

### 使用 VSCode 运行 golang 程序单元测试，没有代码日志输出
在 `.vscode/settings.json` 文件中，加入如下内容：
```markdown
"go.testFlags": [
    "-v"
],
"go.testTimeout": "300s",  # 单元测试执行时间超过 300s，则直接结束该测试，
```

### 使用 git 拉取私有仓库代码时，报错

```
wanghuan@wanghuans-MBP xdhuxc-cicd % make build
>> go build ...
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-common/log
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-common/src/models
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-jenkins
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-common/pkg
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-common/src/service
go: finding module for package gitlab.xdhuxc.com/sgt/xdhuxc-common/event
src/apis/base.go:9:2: module gitlab.xdhuxc.com/sgt/xdhuxc-common/event: git ls-remote -q origin in /Users/wanghuan/GolandProjects/GoPath/pkg/mod/cache/vcs/28da36e7c579b99f1d7066993405e1672802dc58e6f44b68d781fae79c0b54fb: exit status 128:
        fatal: could not read Username for 'https://gitlab.xdhuxc.com': terminal prompts disabled
Confirm the import path was entered correctly.
If this is a private repository, see https://golang.org/doc/faq#git_https for additional information.
```

参照 https://golang.org/doc/faq#git_https 中的方法，在 ~/.gitconfig 文件中加入如下内容：
```
[url "ssh://git@gitlab.xdhuxc.com/"]
        insteadOf = https://gitlab.xdhuxc.com/
```

### This download does NOT match the one reported by the checksum server.

使用 `go mod tidy` 整理 golang 项目依赖时，控制台显示如下错误：
```markdown
wanghuan@wanghuans-MacBook-Pro scmp-common % go mod tidy
github.com/panjf2000/ants@v1.2.0: verifying module: checksum mismatch
        downloaded: h1:Ufw4aDz9RqH1RVblx2W9L9Uv5vSX5apbX5+peR7LQ5k=
        sum.golang.org: h1:pMQ1/XpSgnWx3ro4y1xr/uA3jXUsTuAaU3Dm0JjwggE=

SECURITY ERROR
This download does NOT match the one reported by the checksum server.
The bits may have been replaced on the origin server, or an attacker may
have intercepted the download attempt.

For more information, see 'go help module-auth'.
```

解决：先清理 mod 的缓存，然后再指定该命令
```markdown
go clean -modcache
go mod tidy
```





