+++
title = "Go JSON 序列化和反序列化"
date = "2019-08-01"
lastmod = "2019-08-01"
tags = [
    "Golang",
    "JSON"
]
categories = [
    "技术"
]
+++

本部分内容记录下使用 golang 将结构体序列化和反序列化为 JSON 时，需要注意的一些小问题。

<!--more-->

### 序列化为 JSON
示例代码如下：
```markdown
package main

import (
	"encoding/json"
	"fmt"
)

type User struct {
	Name string `json:"name"`
	Addresses []Address `json:"addresses"`
	Age int `json:"age,omitempty"`
	Email []string `json:"email"`
	Department string `json:"department,omitempty"`
	Province string
}

type Address struct {
	Name string `json:"name"`
}

func (u *User) String() string {

	if bytes, err := json.Marshal(&u); err == nil {
		return string(bytes)
	}

	return ""
}

func main() {
	u := User{
		Name: "xdhuxc",
		Email: []string{},
		Age: 20,
	}

	fmt.Println(u.String())
}
```
输出的结果为：
```markdown
{"name":"xdhuxc","addresses":null,"age":20,"email":[],"Province":""}
```

可以看到：

1、数组或者切片如果不初始化，默认情况下将会被序列化为 null，这对前端来说是一个非常难处理的事情。但是，赋予空数组或者空切片之后，将会序列化为 JSON 的空数组，因此，对于服务器端 API 来说，在空值情况下，不能不处理，而是要将其设置成空数组或空切片

2、增加 omitempty 修饰符后，在该字段零值情况下，将会在序列化时去除掉，因此要慎用该选项，最好不用该修饰符，而是采用零值填充，既不泄露信息，同时也保证字段始终存在，方便在系统中各处判断和使用；但这样做会增加网络传输的数据量，因此需要权衡。

3、如果不指定字段的 JSON 标签，默认将使用 golang 字段名称作为 JSON 字段名称，也就是同名迁移。最好为每个字段指定 JSON 标签，在命名上，按照 JSON 字段命名的方式来命名。


### 解析 JSON
我们可以使用 gjson 来解析 JSON 格式的字符串为 go 中的变量，而不需要将其反序列化为 Golang 中的结构体，这在我们只需要少数几个字段的值时非常方便。
示例如下：
```markdown
{
  "name": "xdhuxc",
  "age": 20,
  "children": ["A","B","C"]
}
```
使用如下方式可以获取 name 字段的值
```markdown
name := gjson.GetBytes(dataInBytes, "name").String()
```
可以使用 String()，Bool()，Int()，Float()等方法将获取的值转换为需要的类型
```markdown
age := gjson.GetBytes(dataInBytes, "age").Int()
```

使用如下方式获取 children 的值
```markdown
children := gjson.GetBytes(dataInBytes, "children").Array()
```
当循环获取 children 的值时，
`gjson.Get(children[i].Raw` 获取到的字符串是带双引号的，即："B"，而 `gjson.Get(children[i].String()` 获取到的字符串是不带双引号的，即：B，在将其获取到的值作为参数传递时，如果不注意这一点，会出现错误。

另外，根据代码部分的说明，如果数据本身就是字节形式的, `GetBytes(json []byte, path string)` 方法优于 `Get(string(data), path)`

### 参考资料

https://github.com/tidwall/gjson


