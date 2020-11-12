+++
title = "Linux 中 Shell 脚本执行的三种方式"
date = "2018-08-13"
lastmod = "2018-09-07"
tags = [
    "Linux",
    "Shell"
]
categories = [
    "技术"
]
+++

在 Linux 系统中，Shell 脚本的执行其实还有几种不同的方式，知道这些不同的执行方式对于我们学习脚本和编写脚本很有帮助。

<!--more-->

在 Linux 系统中，Shell 脚本的执行方式通常有如下三种：

#### 通过解释器 `bash` 或 `sh` 执行
通过解释器时的命令格式为：
```
bash shell-script-name  # 通过 bash 解释器来执行 shell 脚本。
或
sh shell-script-name    # 通过 sh 解释器来执行 shell 脚本。
```
当脚本文件本身没有可执行权限（即文件权限属性 `x` 位为：“-”）时经常使用的方式；或者脚本文件开头没有指定解释器时，需要使用这种方法。使用起来比较方便，操作时节省了为文件添加执行权限的步骤。当然，也可以选择其他类型的解释器，比如ksh，csh，zsh等。

（1）创建文件abc.sh
```
[root@xdhuxc ~]# touch abc.sh
[root@xdhuxc ~]# ls
abc.sh
[root@xdhuxc ~]#
```
（2）写入要执行的命令：
```
[root@xdhuxc ~]# cat >> abc.sh << EOF           # 向 abc.sh 中追加内容。
> #!/usr/bin/env bash
> echo "Hello Shell."
> EOF
[root@xdhuxc ~]# cat abc.sh                     # 显示 abc.sh 文件中的内容。
#!/usr/bin/env bash
echo "Hello Shell."
[root@xdhuxc ~]# ll
total 8
-rw-r--r-- 1 root root  40 Jun  3 10:12 abc.sh  # abc.sh 没有可执行权限。
```
（3）执行该脚本
```
[root@xdhuxc ~]# bash abc.sh
Hello Shell.
[root@xdhuxc ~]# sh abc.sh
Hello Shell.
```
可以看出，命令已经成功执行。

#### 指定路径执行
指定路径执行 shell 脚本时的命令格式如下：
```
absolute-path/shell-script-name  # 通过指定绝对路径来执行 shell 脚本。
或
./shell-script-name              # 通过指定相对路径来执行 shell 脚本，根据当前路径指定要执行的脚本的路径。
```
在当前路径下执行脚本，需要脚本有执行权限，将脚本文件的的权限改为可执行（即文件权限属性 `x` 位为：“x”），使用的命令为：`chmod +x shell-script-name`，然后就可以通过绝对路径或者相对路径来执行脚本了。

（1）给 `abc.sh` 添加执行权限
```
[root@xdhuxc ~]# chmod +x abc.sh                # 为 abc.sh 添加执行权限。
[root@xdhuxc ~]# ll
total 8
-rwxr-xr-x 1 root root  40 Jun  3 10:12 abc.sh  # abc.sh 已经有了可执行权限。
```
（2）以绝对路径方式执行 abc.sh
```
[root@xdhuxc ~]# pwd
/root
[root@xdhuxc ~]# ls
abc.sh
[root@xdhuxc ~]# /root/abc.sh
Hello Shell.
```
（3）以相对路径方式执行 abc.sh
```
[root@xdhuxc ~]# ls
abc.sh
[root@xdhuxc ~]# ./abc.sh
Hello Shell.
```
可以看出，两种方式都能正确执行脚本。在实际脚本的编写过程中，一般都是使用相对路径来执行脚本，这样写成的脚本作为一个整体的程序，可以复制到其他目录或者机器上直接运行，而不必担心脚本内部调用的路径问题。因此，一般要先给脚本添加执行权限，然后使用相对路径的方式来执行。

####  source 或者 "." 执行脚本
source 或者 "." 执行 shell 脚本时的命令格式为：
```
source shell-script-name
或
. shell-script-name
```
source 或者 “.” 命令的功能是：读入shell脚本并执行脚本，即在当前 shell 中执行 source 或 “.”加载并执行相关脚本文件中的命令及语句。

（1）使用 source 和 “.” 命令执行 abc.sh
```
[root@xdhuxc ~]# ls
abc.sh
[root@xdhuxc ~]# . abc.sh            # 以 “.” 命令方式执行 abc.sh。
Hello Shell.
[root@xdhuxc ~]# source abc.sh       # 以 source 方式执行 abc.sh。
Hello Shell.
[root@xdhuxc ~]#
```

这种方式是在当前 shell 中加载并执行脚本中的命令及语句，而不是产生一个子 shell 来执行脚本文件中的命令，这是与其他几种方式最大的不同。因此，在脚本中定义的变量，在终端中可以直接使用。
```
[root@xdhuxc ~]# ls
abc.sh
[root@xdhuxc ~]# echo "password=123" >> abc.sh  # 向 abc.sh 中追加字符串 password=123。
[root@xdhuxc ~]# cat abc.sh                     # 查看 abc.sh 文件的内容。
#!/usr/bin/env bash
echo "Hello Shell."
password=123
[root@xdhuxc ~]# source abc.sh                  # 以 source 方式执行 abc.sh。
Hello Shell.
[root@xdhuxc ~]# echo ${password}               # 在终端输出 abc.sh 中定义的变量。
123
```

前两种方式是产生了一个子进程 shell 来执行脚本，因此，脚本中的变量在终端中是获取不到的，因为终端中的操作还在父 shell 中。
```
[root@xdhuxc ~]# echo "username=root" >> abc.sh
[root@xdhuxc ~]# ./abc.sh
Hello Shell.
[root@xdhuxc ~]# echo ${username}

[root@xdhuxc ~]#
```
可以看到，获取不到 username 的值，因为以相对路径执行脚本是在子 shell 进程中的，而获取  username 值的命令是在父 shell 中执行的。
