+++
title = "Vim 常用命令及技巧"
date = "2019-08-07"
lastmod = "2019-08-07"
tags = [
    "Vim"
]
categories = [
    "技术"
]
+++

本篇博客主要介绍 Vim 的常用命令及技巧，以备后需。

<!--more-->

### 常用命令
> 以下操作均在命令模式下进行

1、显示行号或取消行号，输入
```markdown
:set nonumber # 关闭行号
:set number   # 开启行号
```

2、查找字符串
命令模式下，输入`/user`，则会查找字符串`user`（`/要搜索的字符串或者字符`），按下回车之后，可以看到 vim 已经把光标移动到该字符处和高亮了匹配的字符串（vi没高亮，因为它没有颜色）

按下 n(小写n)用于查看下一个匹配；按下N（大写N）查看上一个匹配，可以按下Caps Lock键切换大小写，也可以在小写状态按下Shift + n

使用 `?user`（`?要搜索的字符串或者字符`），从文件的结尾处往开始处搜索

2、取消高亮，输入
```markdown
:nohlsearch
:set nohlsearch
:set noh # 简写
```

3、跳转至文件头部，在命令模式下，按两次 `g`；跳转至文件尾部，在命令模式下，输入 `G`

4、删除一行，在命令模式下，按两次 `d`

5、替换每一行中所有的 `str1` 为 `str2`，在命令模式下，
```markdown
:%s/str1/str2/g
```
替换当前行所有的 `str1` 为 `str2`
```markdown
:s/str1/str2/g
```

6、按 `u` 可以撤销一次操作

7、跳转到指定行

* 打开文件时，使用如下命令打开文件，可直接到指定行
```markdown
vim xdhuxc.yaml +25 # 打开文件后光标跳转到第 25 行
```
* 在命令模式下，直接输入行号，然后回车
```markdown
:25 # 回车后跳转到第 25 行
```


### 常见问题及解决
1、将复制的代码粘贴到 vim 中时，代码缩进产生了混乱

原因：终端处理粘贴的文本时，会存入键盘缓存。vim 处理时，会把这些内容作为用户键盘输入来处理。如果 vim 开启了自动缩进，那么在遇到换行符时，就会默认把上一行的缩进插入到下一行的开头。

解决：vim 编辑模式中有一个 paste 模式，该模式下，可将文本保持原样粘贴到 vim 中，以避免一些格式错误。在 vim 中输入命令
```markdown
:set paste   # 设置粘贴模式
:set nopaste # 取消粘贴模式
```



























