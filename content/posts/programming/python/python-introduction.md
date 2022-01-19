+++
title = "Python 简介及开发环境搭建"
date = "2017-09-08"
lastmod = "2017-09-08"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客介绍下 Python 及其开发环境搭建。

<!--more-->

### Python

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。

#### Python
Python 的设计具有很强的可读性，相比其他语言经常使用英文关键字，其他语言的一些标点符号，它具有比其他语言更有特色语法结构。
* Python 是一种解释型语言： 这意味着开发过程中没有了编译这个环节。类似于PHP和Perl语言。
* Python 是交互式语言： 这意味着，您可以在一个Python提示符，直接互动执行写你的程序。
* Python 是面向对象语言: 这意味着Python支持面向对象的风格或代码封装在对象的编程技术。
* Python 是初学者的语言：Python 对初级程序员而言，是一种伟大的语言，它支持广泛的应用程序开发，从简单的文字处理到 WWW 浏览器再到游戏。

#### Python的特点

* 易于学习：Python有相对较少的关键字，结构简单，和一个明确定义的语法，学习起来更加简单。

* 易于阅读：Python代码定义的更清晰。

* 易于维护：Python的成功在于它的源代码是相当容易维护的。

* 一个广泛的标准库：Python的最大的优势之一是丰富的库，跨平台的，在UNIX，Windows和Macintosh兼容很好。

* 互动模式：互动模式的支持，您可以从终端输入执行代码并获得结果的语言，互动的测试和调试代码片断。

* 可移植：基于其开放源代码的特性，Python已经被移植（也就是使其工作）到许多平台。

* 可扩展：如果你需要一段运行很快的关键代码，或者是想要编写一些不愿开放的算法，你可以使用C或C++完成那部分程序，然后从你的Python程序中调用。

* 数据库：Python提供所有主要的商业数据库的接口。

* GUI编程：Python支持GUI可以创建和移植到许多系统调用。

* 可嵌入: 你可以将Python嵌入到C/C++程序，让你的程序的用户获得"脚本化"的能力。

### Python 环境搭建

Python可应用于多平台包括 Linux 和 Mac OS X。

#### 在 Linux/Unix 上搭建 Python 环境

1、打开WEB浏览器访问 http://www.python.org/download/

2、选择适用于Unix/Linux的源码压缩包，下载并解压压缩包。

3、如果需要自定义一些选项修改Modules/Setup，执行 ./configure 脚本

4、执行命令
```markdown
make
make install
```
执行以上操作后，Python会安装在 /usr/local/bin 目录中，Python库安装在/usr/local/lib/pythonXX，XX为你使用的Python的版本号。


#### 在 Windows 上搭建 Python 开发环境
1、打开 WEB 浏览器访问 http://www.python.org/download/

2、在下载列表中选择Window平台安装包，包格式为：python-XYZ.msi 文件 ， XYZ 为要安装的版本号。

3、要使用安装程序 python-XYZ.msi, Windows系统必须支持Microsoft Installer 2.0搭配使用。只要保存安装文件到本地计算机，然后运行它。

4、下载后，双击下载包，进入Python安装向导，安装非常简单，你只需要使用默认的设置一直点击"下一步"直到安装完成即可。

#### 环境变量的设置
程序和可执行文件可以在许多目录，而这些路径很可能不在操作系统提供可执行文件的搜索路径中。

path(路径)存储在环境变量中，这是由操作系统维护的一个命名的字符串。这些变量包含可用的命令行解释器和其他程序的信息。

Unix或Windows中路径变量为PATH（UNIX区分大小写，Windows不区分大小写）。

1、在 Unix/Linux 中设置环境变量

在 bash shell 命令行下输入
```markdown
export PATH="$PATH:/usr/local/bin/python" # /usr/local/bin/python 是 Python 的安装目录
```

2、在 Windows 中设置环境变量
在命令提示框中输入：
```markdown
PATH=%PATH%;C:\Python # C:\Python为Python的安装路径
```

### Python 环境变量

Python 中重要的环境变量

变量名 | 描述
---|---
PYTHONPATH | PYTHONPATH是Python搜索路径，默认我们import的模块都会从PYTHONPATH里面寻找
PYTHONSTARTUP | Python启动后，先寻找PYTHONSTARTUP环境变量，然后执行此文件中变量指定的执行代码
PYTHONCASEOK | 加入PYTHONCASEOK的环境变量, 就会使python导入模块的时候不区分大小写.
PYTHONHOME | 另一种模块搜索路径。它通常内嵌于的PYTHONSTARTUP或PYTHONPATH目录中，使得两个模块库更容易切换。

### 运行 Python

有三种方式可以运行Python

#### 交互式解释器
可以通过命令行窗口进入 python，并在交互式解释器中开始编写 Python 代码。

可以在 Unix，DOS或任何其他提供了命令行或者shell的系统中进行 python 编码工作。
```markdown
$ python # Unix/Linux
或
C:>python # Windows/DOS
```

#### 命令行脚本
在应用程序中通过引入解释器，可以在命令行中执行Python脚本，如下所示：
```markdown
$ python script_name.py # Unix/Linux
或
C:>python script_name.py # Windows/DOS
```
注意：在执行脚本时，请检查脚本是否有可执行权限。

#### 集成开发环境
PyCharm功能：调试、语法高亮、Project管理、代码跳转、智能提示、自动完成、单元测试、版本控制……

### Python中文编码

在 Python 2.x 中，默认的编码格式是 ASCII 格式，在没修改编码格式时无法正确打印汉字，所以在读取中文时会报错。

解决：在文件开头加入 `# -*- coding: utf-8 -*-` 或者 `#coding=utf-8` 即可。

在 Python 3.x 中源码文件默认使用 utf-8 编码，所以可以正常解析中文，无需指定 utf-8 编码。




