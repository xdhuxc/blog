+++
title = "Golang 单元测试"
date = "2019-06-02"
lastmod = "2019-06-02"
tags = [
    "Golang",
    "UnitTest"
]
categories = [
    "Golang"
]
+++

本部分内容记录下 golang 中的单元测试的简单用法。

<!--more-->

### 单元测试

单元测试的重点在于测试代码的逻辑、场景等，以便尽可能地测试全面，保证代码质量。

### 代码示例
> 编写简单的代码说明下单元测试的基本使用方法
编写主程序文件 test/main.go
```markdown
package main

import "fmt"

func main() {
	sum := Add(10, 20)
	fmt.Println(sum)
}

func Add(x int, y int) int {
	return x + y
}
```
编写单元测试文件 test/main_test.go
```markdown
package main

import "testing"

func TestAdd(t *testing.T) {
	sum := Add(10, 20)
	if sum == 30 {
		t.Log("ok")
	} else {
		t.Error("error")
	}
}
```
运行测试命令
```markdown
wanghuans-MacBook-Pro:test wanghuan$ pwd
/Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/xgoland/test
wanghuans-MacBook-Pro:test wanghuan$ go test -v
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
    main_test.go:8: ok
PASS
ok      github.com/xdhuxc/xgoland/test  0.005s
```

### Golang 单元测试使用规则
1、含有单元测试代码的 go 文件必须以 `_test.go` 结尾，比如测试 `main.go` 的单元测试文件命名为 `main_test.go` ，Go 语言测试工具只认符合该规则的文件。

2、单元测试文件名 `_test.go` 前面的部分最好是被测试的方法所在 go 文件的文件名，比如 `main_test.go`，因为我们要测试的 Add 函数在 `main.go` 文件里

3、单元测试的函数名必须以 `Test` 开头，是可导出的公共函数。

4、测试函数的签名必须接收一个指向 testing.T 类型的指针，并且不能返回任何值。

5、函数名建议命名为 Test 加要测试的方法函数名，表示要测试该函数。

### 表组测试
表组测试指的是一次测试中很多个输入输出场景的测试，例如
```markdown
func TestAdd(t *testing.T) {
	sum := Add(10, 20)
	if sum == 30 {
		t.Log("ok")
	} else {
		t.Error("error")
	}

	sum = Add(1024, 2048)
	if sum == 3072 {
		t.Log("ok")
	} else {
		t.Error("error")
	}
}
```
我们为待测试函数 Add() 准备了两组测试数据 10、20 和 1024、2048，这样就可以测试多个输入场景下的测试效果了。

### 模型层数据测试

将各个测试函数共用的变量定义为全局变量，在 init() 函数中进行初始化，在各个测试函数中进行使用。

编写测试代码如下：user_test.go
```markdown
import (
	"fmt"
	"testing"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql" # 如果没有导入此句，会报错。

	"gitlab.xdhuxc.com/golang-user/src/models"
)

var db *gorm.DB
var us *userService

func init() {
    uri := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&parseTime=True&loc=Local",
    		"root",
    		"abcd@#129",
    		"127.0.0.9",
    		"user")
    db, _ := gorm.Open("mysql", uri)
    db.Debug()
    us := newUserService(db)
}

func Test_UserService_List(t *testing.T) {
	count, users, err := us.List(models.Page{ # List 为分页方法
		Offset:   0,
		PageSize: 30,
	})
	if err != nil {
		t.Error(err)
	} else {
		t.Log(count)
		for _, user := range users {
			fmt.Println(user.String())
		}
	}
}
```

跳转至 user_test.go 脚本目录下，执行如下命令：
```markdown
go test --run Test_UserService_List
```

### 参考资料

https://www.jianshu.com/p/1adc69468b6f

https://www.flysnow.org/2017/05/16/go-in-action-go-unit-test.html

