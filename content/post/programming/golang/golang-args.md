+++
title = "Golang flag 包读取参数怪事"
date = "2019-09-29"
lastmod = "2019-09-29"
tags = [
    "Golang"
]
categories = [
    "Golang"
]
+++

使用 golang 的 flag 包读取命令行参数，然而，奇怪的事情发生了，读取到的 redis 密码是错误的，这很奇怪，本地验证 redis 密码没有问题，但是代码中就是认证失败，于是研究了一下，特此记录。

<!--more-->

使用 golang 的 flag 包读取命令行参数，然而，奇怪的事情发生了，读取到的 redis 密码是错误的。这很奇怪，本地验证 redis 密码没有问题，但是代码中就是认证失败，于是研究了一下，特此记录。

测试使用的系统和 golang 版本如下：
```markdown
wanghuans-MacBook-Pro:one wanghuan$ go version
go version go1.12.9 darwin/amd64
```

测试使用的代码如下：
```markdown
package main

import (
	"flag"
	"fmt"
	"os"
)

var password string

func init() {
	flag.StringVar(&password, "password", "", "the password to authenticate with (only used with vault and etcd backends)")
}

func main() {
	fmt.Printf("the args is %s\n", os.Args)

	flag.Parse()

	fmt.Printf("the password is %s\n", password)

	if password == "qZ2XisdsdgGiLSf0b$HBL#LDLUG5uUGr8v0" {
		fmt.Println(true)
	}
}
```

测试的结果如下：
1、$ 在 # 之前
```markdown
wanghuans-MacBook-Pro:one wanghuan$ ./flag --password qZ2XisdsdgGiLSf0b$HBL#LDLUG5uUGr8v0
the args is [./flag --password qZ2Xis#dsdg#Gi#LSf0b#LDLUG5uUGr8v0]
the password is qZ2XisdsdgGiLSf0b#LDLUG5uUGr8v0
```

对比结果：
```markdown
qZ2XisdsdgGiLSf0b$HBL#LDLUG5uUGr8v0
qZ2XisdsdgGiLSf0b    #LDLUG5uUGr8v0
```
可以看到，去除了 $ 到 # 之间的字符，结果包含 #，不包含 $。

2、$ 在最后一个 # 之后
```markdown
wanghuans-MacBook-Pro:one wanghuan$ ./flag --password qZ2XisdsdgGiLSf0bHBL#LDL$UG5uUGr8v0
the args is [./flag --password qZ2XisdsdgGiLSf0bHBL#LDL]
the password is qZ2XisdsdgGiLSf0bHBL#LDL
```

对比结果：
```markdown
qZ2XisdsdgGiLSf0bHBL#LDL$UG5uUGr8v0
qZ2XisdsdgGiLSf0bHBL#LDL
```
可以看到，去除了 $ 及其之后的字符串

3、$ 在最后一个 # 之前
```markdown
wanghuans-MacBook-Pro:one wanghuan$ ./flag --password qZ2Xisdsdg#GiL#Sf0b$HBL#LDLUG5u#UGr8v0
the args is [./flag --password qZ2Xisdsdg#GiL#Sf0b#LDLUG5u#UGr8v0]
the password is qZ2Xisdsdg#GiL#Sf0b#LDLUG5u#UGr8v0
```

对比结果
```markdown
qZ2Xisdsdg#GiL#Sf0b$HBL#LDLUG5u#UGr8v0
qZ2Xisdsdg#GiL#Sf0b    #LDLUG5u#UGr8v0
```
可以看到，和第一种情况类似，去除了 $ 到其之后的第一个 # 之间的字符

根据以上实验可以看出：
1）$ 及其之后的字符被 "吞" 掉了，看起来是 $ 及其之后到第一个 # 之间的字符被 Shell 当做变量解释了。

2）从 args 的值可以看出，在参数进入到 golang 程序之前， $ 及其之后到第一个 # 之间的字符已经被 Shell 当做变量解释完毕。


要解决这个问题，其实很简单，给含 $ 的字符串加上引号（单引号或双引号都可以）就可以了。
```markdown
wanghuans-MacBook-Pro:one wanghuan$ ./flag --password 'qZ2Xisdsdg#GiL#Sf0b$HBL#LDLUG5u#UGr8v0'
the args is [./flag --password qZ2Xisdsdg#GiL#Sf0b$HBL#LDLUG5u#UGr8v0]
the password is qZ2Xisdsdg#GiL#Sf0b$HBL#LDLUG5u#UGr8v0
```



