+++
title = "常用快捷键"
date = "2019-07-09"
lastmod = "2019-07-09"
tags = [
    "快捷键"
]
categories = [
    "技术"
]
+++

本部分内容记录了一些常用的快捷键，便于查询使用。

<!--more-->

### shell 快捷键

快捷键 | 功能
--- | ---
Ctrl + L | 清屏，相当于 clear 命令
Ctrl + C | 发送 SIGINT 信号给前台进程组中的所有进程，常用于终止正在运行的程序
Ctrl + Z | 发送 SIGTSTP 信号给前台进程组中的所有进程，常用于挂起一个进程
Ctrl + R | 搜索以前使用过的命令，搜索到后，按“Enter”键，直接执行该命令
Ctrl + A 或 HOME | 将光标移至行首

### top 命令快捷键

在 Linux shell 下，输入 top 命令，快捷键使用如下：

按 ‘X’ 键，再按 ‘B’ 键，默认按 CPU 使用率降序排列

按住 ‘Shift’ 键，再按 ‘P’ 键，是按 CPU 使用率降序排列。

按住 ‘Shift’ 键，再按 ‘M’ 键，是按 内存 使用率降序排列。

按住 ‘Shift’ 键，再按 ‘T’ 键，是按 进程运行时间降序排列。

按 ‘F’ 键，进入字段管理页面，使用上下键控制光标移动，
使用光标选中某字段，按 ‘D’ 或者空格，取消该列的显示，按 ‘q’ 或 ‘Esc’ 再次进入 top 命令页面，可以看到刚才选中的列已经不显示了。

在字段管理页面，使用光标选中某字段后，按 ‘S’ 键，可将该字段设置为排序字段，然后按 ‘Esc’ 或 ‘Q’ 键退出，默认按降序排列。若要改为升序排列，按住 ‘Shift’ 键，然后按 ‘R’ 键，即可按照排序字段升序排列。

### vim 快捷键

按住 ‘Shift’ 键，然后按 ‘:’ 键，进入命令模式，输入：
```angular2html
set number
```
按 ‘Enter’ 键，显示行号。

输入：
```angular2html
set encoding=utf-8
```
按 ‘Enter’ 键，则修改编码为UTF-8编码。

### JetBrains 快捷键

快捷键 | 功能
---|---
Ctrl + X | 删除当前行
Ctrl + D | 删除当前行
Ctrl + Alt + ↑ | 复制当前行到上一行
Ctrl + Alt + ↓ | 复制当前行到下一行
command + F | 当前文件全文查找
command + R | 当前文件全文查找替换
command + ↑ + R | 全路径查找替换
command + ↑ + F | 全路径查找
command + l | 跳转至指定行
  |  

### word 快捷键

快捷键 | 功能
---  |  ---
Ctrl + Home | 将光标移动到文档首部
Ctrl + End | 将光标移动到文档尾部
Alt + Enter | 单元格内换行
Shift + PageDown | 选中光标后面的部分，可以按住 ‘Shift’ 键，然后一直按 ‘PageDown’ 键，选中内容后，按 ‘Delete’ 键删除选中内容

### visio 快捷键

快捷键 | 功能
--- | ---
Ctrl + = | 将选中的文字变为下标
Ctrl + Shift + = | 将选中的文字变为上标

### windows 快捷键

1、按住 Shift 键，右键鼠标，可以在当前目录下打开 PowerShell。


### Atom 快捷键

快捷键 | 功能
--- | ---
command + / | 在当前行插入注释
command + x | 删除当前行

### Sublime Text 快捷键

快捷键 | 功能
--- | ---
command + F | 查找
command + ⌥ + F | 查找并替换

### Notepad++

快捷键 | 功能
---|---
Ctrl + L | 删除光标所在行
Ctrl + D | 复制当前行到下一行

### Eclipse 快捷键

功能 | 快捷键
---|---
导入相应的包 | Ctrl+ Shift + O
在当前行插入空行 | Ctrl + Shif +Enter

### MindMaster

1、在 Topic 内换行，在光标所在位置，按 `Shift+Enter` 键

### 字体和段落

字体：Monaco 

大小：12 pt

在 word 中，段首空两个汉字，设置首行缩进 0.82 cm。

### VS Code

1、在代码中 `Go To Definition` 时，默认情况下会替换掉原来的页面。如果希望打开一个新页面，需要进行如下配置：
```markdown
"workbench.editor.enablePreview": false
```

通过配置 `workbench.editor.enablePreview` 为 `false` 来禁止编辑器的预览功能，这样在浏览代码时就会跳转到代码页面。

实际上，VS Code 提供了 Peek 功能，用来在当前页面查看代码，无需跳转到新页面，不过这样会带来新问题：1、挤压了页面空间；2、需要查看的方法或函数还需进一步查看时，就不方便了。另外，对于习惯了跳转到新页面的工程师，还是喜欢用旧的方式。
