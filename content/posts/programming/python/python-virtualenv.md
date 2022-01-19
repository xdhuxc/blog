+++
title = "Python virtualenv 的使用"
date = "2019-07-08"
lastmod = "2018-07-08"
tags = [
    "Python",
    "virtualenv"
]
categories = [
    "Python"
]
+++

在 Python 开发时，我们经常需要用到虚拟环境，为各个不同的工程提供指定的运行时环境，提供其需要的隔离的依赖包。使用 virtualenvwrapper 可以很方便地管理不同的虚拟环境。

<!--more-->

### virtualenvwrapper

1、安装 virtualenvwrapper
```markdown
pip install virtualenvwrapper
```
或
```markdown
pip install virtualenvwrapper-win # windows 系统下
```

2、修改 Envs 目录为指定目录，添加如下环境变量：
```markdown
WORKON_HOME=E:\PycharmProject\Envs
```

3、virtualenvwrapper 的使用

virtualenvwrapper 的常用命令：

* workon：列出所有的虚拟环境；
* workon xflask：进入虚拟环境 xflask；
* mkvirtualenv xflask：创建虚拟环境 xflask，统一存放在 Envs 目录下，如果没有虚拟环境目录，则创建 ~/Envs 目录，在其下面创建虚拟环境目录；
* mkvirtualenv --python=C:\xdhuxc\Python37-32\python.exe xflask，使用指定版本的 python 解释器创建虚拟环境；
* deactivate：退出虚拟环境；
* rmvirtualenv：删除虚拟环境；
* lsvirtualenv：列出所有的虚拟环境，和不带参数的 workon 效果一样。


