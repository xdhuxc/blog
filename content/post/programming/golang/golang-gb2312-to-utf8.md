+++
title = "Golang 将 GB2312编码的汉字 转为 UTF-8 编码的汉字"
date = "2019-09-26"
lastmod = "2019-09-26"
tags = [
    "Golang"
]
categories = [
    "Golang"
]
+++

golang 中的所有字符使用 UTF-8 编码，当源文件中包含中文，编码是 GB2312 或 GBK 时，就可以在输出中产生乱码。

<!--more-->

由于 golang 中的所有字符使用 UTF-8 编码，当我们处理的文件中包含中文、编码为 GB2312 或 GBK时，输出这些字符串时就会产生乱码，比如从 Windows 上 excel 中导出的 csv 文件，包含的中文用 GB2312 编码，使用 golang 读取时就会产生乱码。此时，我们需要读取数据后，进行转码，以保证输出正确。

示例代码如下所示：
```markdown
package main

import (
"fmt"

"github.com/axgle/mahonia"
)

func main() {

	decoder := mahonia.NewDecoder("GBK")
	// hello, 涓栫晫
	fmt.Println(decoder.ConvertString("hello, 世界"))

	dataInBytes := []byte{0xC4, 0xE3, 0xBA, 0xC3, 0xA3, 0xAC, 0xCA, 0xC0, 0xBD, 0xE7, 0xA3, 0xA1}

	// 你好，世界！
	fmt.Println(decoder.ConvertString(string(dataInBytes)))
}
```
注意，GBK 不要写为 GB2312，由于 GBK 兼容 GB2312，所以使用 GB2312 编码的汉字可以直接使用 GBK 进行解码。


不要使用 `github.com/djimenez/iconv-go` 包，此包中使用了 C 库，在本地（macOS Mojave 10.14.6）可以运行，但在交叉编译时会出问题，其编写的程序到其他平台运行会比较麻烦。

### 参考资料

http://www.haodaquan.com/94

https://github.com/axgle/mahonia
