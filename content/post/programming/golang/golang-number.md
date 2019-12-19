+++
title = "golang 数值处理"
date = "2019-11-03"
lastmod = "2019-11-03"
description = ""
tags = [
    "Golang"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 golang 进行数值处理时可能会用到的一些代码。

<!--more-->

使用 strconv 包中的方法来进行字符串到数值的转换，math 包封装了常用的基本函数。

```markdown
import (
	"fmt"
	"math"
	"strconv"
)

func main() {
	// 计算 2 的 5 次方
	fmt.Println(math.Pow(2, 5))
	percent := "23.456"
	
	// 使用 strconv 包的 ParseFloat 方法将字符串转换为 float64
	result, _ := strconv.ParseFloat(percent, 10)
	// 使用 fmt 包的 Sprintf 方法实现保留小数点后两位
	fmt.Println(fmt.Sprintf("%.2f", result))
}
```
