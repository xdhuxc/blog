+++
title = "JavaScript 中的真值和假值问题"
date = "2019-06-02"
lastmod = "2019-06-02"
description = ""
tags = [
    "JavaScript"
]
categories = [
    "JavaScript"
]
+++

JavaScript 中的真值和假值经常用于判断语句和条件语句中，但是其真值和假值的确定和其他编程语言大不相同，如果对此理解有误，那么将会导致代码出现问题。

<!--more-->

### JavaScript 中的真值
在 JavaScript 中，真值指的是在布尔值上下文中转换后的值为真的值。

所有值都是真值，除非它们被定义为假值，即被定义为`false`，`0`，`""`，`null`，`undefined`，`NaN`。

JavaScript 在布尔值上下文中使用强制类型转换。

JavaScript 中的真值示例如下（将被转换为 true，if后的代码段将被执行）
```markdown
if (true)
if ({})
if ([])
if (42)
if ("foo")
if (new Date())
if (-42)
if (3.14)
if (-3.14)
if (Infinity)
if (-Infinity)  
```

### JavaScript 中的假值
在 JavaScript 中，假值是在布尔值上下文中已认定可转换为假的值。

JavaScript 在需要用到布尔类型值得上下文中使用强制类型转换将值转换为布尔值，比如在条件语句或者循环语句中。

JavaScript 中的假值示例如下（通过 if 代码段将 falsy 值转换为 false）：
```markdown
if (false)
if (null)
if (undefined)
if (0)
if (NaN)
if ('')
if ("")
if (document.all)
```
document.all 在过去被用于浏览器检测，是 HTML 规范在此定义了故意与 ECMAScript 标准相违背的，以保持与历史代码得兼容性。

document.all 虽然是一个对象，但其转换为布尔值后是 false。

### 参考资料
https://developer.mozilla.org/zh-CN/docs/Glossary/Truthy

https://developer.mozilla.org/zh-CN/docs/Glossary/Falsy
