+++
title = "一些其他问题及解决方式"
date = "2017-09-09"
lastmod = "2017-07-09"
tags = [
    "杂项"
]
categories = [
    "技术"
]
+++

本篇博客记录了一些其他的问题及解决方法。

<!--more-->

### Google 浏览器配置可访问自定义的 `https`

`Windows` 系统下，在 `chrome` 快捷方式的属性中，修改快捷方式中的目标，添加 `--test-type --ignore-certificate-errors`，最后目标项的值为：
```markdown
"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --test-type --ignore-certificate-errors
```
然后使用该快捷方式打开浏览器，即可访问自定义的 `https` 地址。
