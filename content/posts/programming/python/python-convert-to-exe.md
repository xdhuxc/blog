+++
title = "将 Python 脚本转换为可执行程序"
date = "2022-01-19"
lastmod = "2022-01-19"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客介绍下将 Python 脚本转换为各类型操作系统上的可执行文件的方法。

<!--more-->

### 编写 GUI 程序
实验环境：

* OS：Windows 10
* Python：3.9.7


我们使用 PyQt 编写一个 GUI 程序，代码如下：
```markdown
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: wanghuan
# date: 1/18/22
# description:

import sys
import random
from PyQt5.Qt import *

poems = ["问渠那得清如许，为有源头活水来",
         "泪眼问花花不语，乱红飞过秋千去",
         "莫等闲，白了少年头，空悲切",
         "不经一番彻骨寒，怎得梅花扑鼻香",
         "风萧萧兮易水寒，壮士一去兮不复还",
         "苟利国家生死以，岂因祸福避趋之",
         "人生自古谁无死？留取丹心照汗青",
         "落红不是无情物，化作春泥更护花"
         "露从今夜白，月是故乡明"]


# 槽函数
def handle():
    label.resize(250, 30)
    label.setAlignment(Qt.AlignRight | Qt.AlignCenter)
    label.setStyleSheet("background-color:green")
    label.setWordWrap(True)
    label.setText(poems[random.randint(0, len(poems)-1)])


if __name__ == '__main__':
    app = QApplication(sys.argv)  # 实例对象

    # 窗体大小
    window = QWidget()
    window.resize(500, 500)
    window.setWindowTitle('GUI 程序')
    window.move(400, 200)

    # 标签
    label = QLabel(window)
    label.setText('这里会显示一条信息')
    label.move(100, 100)

    # 按钮1
    button = QPushButton(window)
    button.setText("点击它")
    button.move(200, 200)
    button.clicked.connect(handle)  # 信号与槽

    # 显示窗体
    window.show()
    sys.exit(app.exec_())
```
在 main.py 同目录下，使用如下命令创建一个虚拟环境
```markdown
python -m venv venv
```
然后激活虚拟环境：
```markdown
.\venv\Scripts\activate
```
安装所需依赖包：
```markdown
pip install pywin32 PyInstaller PyQT5
```
如果不是 Windows 系统，则无需安装 pywin32。

接下来运行程序
```markdown
python main.py
```
效果如下图所示：
<center>
<img src="/image/programming/python/exe/WechatIMG1556.png" width="500px" height="500px" />
</center>

### 转换为可执行程序
在目标操作系统上，执行如下命令：
```markdown
pyinstaller -F -w main.py
```
PyInstaller 部分参数的含义:
* -F：表示生成单个可执行文件
* -w：表示去掉控制台窗口，这在 GUI 界面时非常有用，如果是命令行程序的话，不需要使用这个选项
* -i：表示可执行文件的图标

开始执行代码，运行完成之后，
<center>
<img src="/image/programming/python/exe/WechatIMG1557.png" width="500px" height="200px" />
</center>

在 main.py 文件的目录下会生成一个 dist 文件夹， 里面就有生成的 EXE 文件
<center>
<img src="/image/programming/python/exe/WechatIMG1558.png" width="500px" height="200px" />
</center>

双击这个 main.exe，运行效果如下图所示：
<center>
<img src="/image/programming/python/exe/WechatIMG1559.png" width="500px" height="200px" />
</center>



### 参考资料

https://zhuanlan.zhihu.com/p/52654565

http://code.py40.com/pyqt5/28.html