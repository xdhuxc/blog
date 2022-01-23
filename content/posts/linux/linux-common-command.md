+++
title = "Linux 常用命令总结"
date = "2017-09-07"
lastmod = "2017-09-07"
tags = [
    "Linux"
]
categories = [
    "Linux"
]
+++

本篇博客记录了在 Linux 系统中常用的命令，以备后查。

<!--more-->

## chown
> chown将指定文件的拥有者改为指定的用户或组，用户可以是用户名或者用户ID；组可以是组名或者组ID；文件是以空格分开的要改变权限的文件列表，支持通配符。系统管理员经常使用chown命令，在将文件拷贝到另一个用户的名录下之后，让用户拥有使用该文件的权限。 

> 通过chown改变文件的拥有者和群组。在更改文件的所有者或所属群组时，可以使用用户名称和用户识别码设置。普通用户不能将自己的文件改变成其他的拥有者。其操作权限一般为管理员。

### 语法
```
chown [options] [所有者][:[组]] 文件...
```

### 参数
```
-c：显示更改的部分的信息
-f：忽略错误信息
-h：修复符号链接
-R：处理指定目录以及其子目录下的所有文件
-v：显示详细的处理信息
-deference：作用于符号链接的指向，而不是链接文件本身
```

### 示例
1、将文件 abc.txt 的所有者设置为 xdhuxc，所属组设置为 jessie。
```
chown jessie:xdhuxc abc.txt
```
2、把文件 abc.txt 所属的组设置为 jessie
```
chown :jessie abc.txt
```
3、将akhdie目录及其所有子目录和所有文件到新的用户xdhuxc和用户组jessie
```
chown -R jessie:xdhuxc akhdie/*
```

## ln
> ln命令的功能是为某一个文件在另外一个位置建立一个同步的链接。
当我们需要在不同的目录，用到相同的文件时，我们不需要在每一个需要的目录下都放一个必须相同的文件，我们只要在某个固定的目录，放上该文件，然后在 其它的目录下用ln命令链接它就可以，不必重复的占用磁盘空间。

### 语法
```
ln [参数] [源文件或目录] [目标文件或目录]
```

### 链接的分类
> 链接(link)，我们可以将其视为档案的别名，而链接又可分为两种 : 硬链接(hard link)与软链接(symbolic link)，硬链接的意思是一个档案可以有多个名称，而软链接的方式则是产生一个特殊的档案，该档案的内容是指向另一个档案的位置。硬链接是存在同一个文件系统中，而软链接却可以跨越不同的文件系统。

#### 软链接
* 软链接，以路径的形式存在。类似于Windows操作系统中的快捷方式
* 软链接可以 跨文件系统 ，硬链接不可以
* 软链接可以对一个不存在的文件名进行链接
* 软链接可以对目录进行链接

#### 硬链接
* 硬链接，以文件副本的形式存在。但不占用实际空间。
* 不允许给目录创建硬链接
* 硬链接只有在同一个文件系统中才能创建

## 注意：
1、ln命令会保持每一处链接文件的同步性，也就是说，不论你改动了哪一处，其它的文件都会发生相同的变化；

2、ln的链接又分软链接和硬链接两种，软链接就是ln –s 源文件 目标文件，它只会在你选定的位置上生成一个文件的镜像，不会占用磁盘空间，硬链接 ln 源文件 目标文件，没有参数-s， 它会在你选定的位置上生成一个和源文件大小相同的文件，无论是软链接还是硬链接，文件都保持同步变化。

### 参数
```
-b：删除，覆盖以前建立的链接
-s：软链接(符号链接)
-v：显示详细的处理过程
-i：交互模式，文件存在则提示用户是否覆盖
-f：强制执行
-n：把符号链接视为一般目录
-d：允许超级用户制作目录的硬链接
```

### 示例
1、给文件给文件创建软链接，为abc.log文件创建软链接abc_link，如果abc.log丢失，abc_link将失效.
```
ln -s abc.log abc_link
```
2、给文件创建硬链接，为abc.log创建硬链接abc_link，abc.log与abc_link的各项属性相同
```
ln abc.log abc_link
```
3、给目录创建软链接
```
ln -sv /usr/local/src /home/xdhuxc/src
```
说明：
* 目录只能创建软链接。
* 目录创建链接必须用绝对路径，相对路径创建会不成功，会提示：符号连接的层数过多 这样的错误。
* 在链接目标目录中修改文件都会在源文件目录中同步变化。

### 使用场合
1、软链接适用场景（相当于windows的的快捷方式）
* 在文件系统中多处共享同一个较大文件时，使用软链接就可以避免创建多个副本。
* 维护动态库文件的版本时，使用软链接，在升级库文件后，只需修改软链接的源文件，而使用该库的程序则不需要修改。

2、硬链接使用场景

* 其实是一个指针，指向文件索引节点，系统并不为它重新分配inode.通过使用硬链接可达到备份数据(实际是备份节点)的效果。


## mkdir
> mkdir 命令用于创建目录

### 语法：
```
mkdir [options] directory_name
```

### 参数
```
-p,--parents：可以是一个路径名称。此时若路径中的某些目录尚不存在,加上此选项后,系统将自动建立好那些尚不存在的目录,即一次可以建立多个目录
-m：-mode=模式，设定权限<模式> 
-v,--verbose：每次创建新目录都显示信息
```

### 示例
1、在当前目录下，建立一个名为 directory_name 的子目录。
```
mkdir directory_name
```
2、在当前目录下的  directory_name 目录中，建立一个名为 sub_directory_name 的子目录。 若 directory_name  目录原本不存在，则建立一个。若不加 -p，且原本 directory_name 目录不存在，则产生错误。
```
mkdir -p directory_name/sub_directory_name
```
3、创建权限为777的目录abc
```
mkdir -m 777 abc
```

## sudo
> sudo命令用来以其他身份来执行命令，预设的身份为root。在/etc/sudoers中设置了可执行sudo指令的用户。若其未经授权的用户企图使用sudo，则会发出警告的邮件给管理员。用户使用sudo时，必须先输入密码，之后有5分钟的有效期限，超过期限则必须重新输入密码。

### 语法
```
sudo [options] others
```
### 选项
```
-V：显示版本编号；
-l 显示出自己（执行 sudo 的使用者）的权限；
-u username/#uid 不加此参数，代表要以 root 的身份执行指令，而加了此参数，可以以 username 的身份执行指令（#uid 为该 username 的使用者号码）；
-s 执行环境变数中的 SHELL 所指定的 shell ，或是 /etc/passwd 里所指定的 shell；
```
### 示例
1、指定以用户xdhuxc权限执行命令
```
sudo -u xdhuxc
```
2、显示sudo设置
```
sudo -L
```
3、以root权限执行上一条命令
```
sudo !!
```
4、以 xdhuxc 用户编辑 /home/xdhuxc/www 目录中的 index.html 文件
```
sudo -u xdhuxc vim ~www/index.html
```

## echo
> 用于字符串的输出，一般起到一个提示符的作用

### 语法
```
echo 字符串
```

### 参数：
```
-e：若字符串中出现以下字符，则加以特殊处理，而不会将它当成一般字符对待。 特殊字符有：

    \a 发出警告声
    \b 删除前一个字符
    \c 最后不加上换行符号
    \f 换行但光标仍旧停留在原来的位置
    \n 换行且光标移至行首
    \r 光标移至行首，但不换行
    \t 插入tab
    \v 与\f相同
    \\ 插入\字符
    \nnn 插入nnn（八进制）所代表的ASCII字符
    - help 显示帮助
    - version 显示版本信息
```

### 示例
1、显示普通字符串
```
echo "I will be better!"
或                           # 输出为：I will be better!
echo "I will be better!"
```
2、显示转义字符
```
echo "\"I will be better!\"" # 输出为："I will be better!"
```
3、显示变量
```
echo "$name will be better!"
```
4、显示换行或不换行
```
echo -e "OK! \n" # -e 开启转义 \n 换行
或
echo -e "OK! \c" # -e 开启转义 \c 不换行
```
5、显示结果定向至文件
```
echo "I will be better!" > mylife
```
6、原样输出字符串，不进行转义或取变量，用单引号
```
echo '$name\"' # 输出结果为：$name\"
```
7、显示命令执行结果，使用反引号
```
echo `date` # 结果将显示当前日期
```

## ps
> ps命令用于显示当前进程 (process) 的状态

### 语法
```
ps [options] [--help]
```
### 选项
```
-A：列出所有的进程；
-a：显示终端中包括其它用户的所有进程；
-x：显示无控制终端的进程；
-w：加宽显示，可以显示较多的信息；
-au：显示较详细的信息；
-aux：显示所有进程，也包含其他使用者的进程；
-f：用全格式来显示。
-e：选择全部的进程，等同于 -A。
-L：可能的话，追加 LWP 和 NLWP 栏显示线程。
```
au(x)输出格式：
```
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
USER：进程所有者；
PID：进程ID号，是一个进程的唯一标识ID；
%CPU：进程的CPU使用率；
%MEM：进程的内存占用率；
VSZ：进程占用的虚拟内存大小；
RSS：
TTY：终端；
STAT：进程的状态，包括；



START：进程开始时间；
TIME：进程执行的时间；
COMMAND：所执行的指令；
```
### 示例
1、显示进程信息
```
ps -A
```
2、显示root进程用户信息
```
ps -u root
```
3、显示所有进程信息，连同命令行
```
ps -ef
```

## ps -ef 和 ps aux 的区别
1、-ef 是 System V 展示风格，而 aux 是 BSD 风格。
ps -ef 的执行输出：
```
[root@xdhuxc ~]# ps -ef | head -n 2
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 Jun07 ?        00:01:36 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
```
字段含义：
* UID：用户ID或用户名。
* PID：进程ID。
* PPID：父进程ID。
* LWP：轻量进程（light weight process）或者线程ID。
* C：CPU 用于计算执行优先级的因子。数值越大，表明该进程是 CPU 密集型运算，执行优先级会降低；数值越小，表明该进程是 I/O  密集型运算，执行优先级会提高。
* NLWP：进程里的LWP（线程）数。
* STIME：进程启动的时间。
* TTY：完整的终端名称。
* TIME：CPU时间。
* CMD：完整的启动进程所用的命令和参数。

ps aux 的执行输出
```
[root@xdhuxc ~]# ps aux | head -n 2
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0 190788  3544 ?        Ss   Jun07   1:36 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
```
字段含义：
* USER：用户名称。
* PID：进程ID号，是一个进程的唯一标识ID。
* %CPU：进程占 CPU 的百分比。
* %MEM：进程占用物理内存的百分比。
* VSZ：进程占用的虚拟内存大小，单位：KB。
* RSS：进程占用的物理内存大小，单位：KB。
* TTY：终端名称（缩写），若为?，则表示此进程与终端无关，因为它们是由系统启动的。
* STAT：进程状态
（1）S：睡眠。
（2）s：表示该进程是回话的先导进程。
（3）N：表示该进程拥有比普通优先级更低的优先级。
（4）R：正在运行。
（5）D：短期等待。
（6）Z：僵死进程。
（7）T：被跟踪或者被停止
* STARTED：进程的启动时间。
* TIME：CPU 时间，即进程使用 CPU 的总时间。
* COMMAND：启动进程所用的命令和参数，如果命令过长，会被截断显示。

2、COMMAND 列如果过长，ps aux 会截断显示；而 ps -ef 则不会。 

## grep
>  grep命令用于查找文件里符合条件的字符串。grep指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设grep指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为"-"，则grep指令会从标准输入设备读取数据。

学习网址：
http://blog.csdn.net/xy010902100449/article/details/51426354

http://blog.csdn.net/shuanzia/article/details/50392987

### 语法
```
grep [-options] pattern file_name
或
grep [-options] pattern directory_name
```
### 选项
```
-c,--count：计算符合模式的列数；
-d,--directories：当指定要查找的是目录而非文件时，必须使用这项参数，否则grep命令将回报信息并停止动作；
-v,--recursive：查找不匹配的行；
-o：只打印出匹配到的字符；
-E：将范本样式为延伸的普通表示法来使用，意味着能使用扩展正则表达式；
--color：把匹配到的字符用颜色显示出来；
-i：不区分大小写；
-n：在行首显示行号；
```
### 示例
1、在当前目录中，查找后缀包含"sh"字样的文件中包含"test"字符串的文件
```
grep test *file
```
2、以递归的方式查找符合条件的文件。查找目录/etc/acpi 及其子目录下所有文件中包含字符串"update"的文件，并打印出该字符串所在行的内容
```
grep -r update /etc/acpi # 以递归的方式查找目录/etc/acpi下包含字符串“update”的文件
```
3、反向查找，打印出不符合条件行的内容，查找文件名中包含 test 的文件中不包含test 的行
```
grep -v test *test*
```

## tar
> tar 是用来建立、还原备份文件的工具程序，它可以加入，解开备份文件内的文件。

### 语法
```
tar [options] file_name
或
tar [options] derictory_name
```
### 选项
```
-C destination_directory_name,--directory=destination_directory_name：解压或压缩到指定的目录。
-f file_name,--file=file_name：指定待压缩或解压的文件
-t,--list： 列出待解压或压缩文件的内容。
-v,--verbose：显示命令执行的过程。
-x,--extract,--get：从压缩文件中解压文件。
-z,--gzip,--unzip：通过gzip命令处理压缩文件
--exclude=pattern：去除符合模式的文件。
```
### 示例
1、压缩文件，压缩文件a.c为abc.tar.gz
```
tar -czvf abc.tar.gz a.c 
```
2、列出压缩文件abc.tar.gz的内容
```
tar -tzvf abc.tar.gz
```
3、解压文件abc.tar.gz
```
tar -zxf abc.tar.gz # 不显示解压过程
或者
tar -zxvf abc.tar.gz # 显示解压过程
```
4、解压文件abc.tgz
```
tar -xz abc.tgz -C /data/xdhuxc
```

## ls
> ls 命令用于显示指定工作目录下的内容，列出当前工作目录的文件及子目录的文件

### 语法
```
ls [-options] directory_name
```
### 选项
```
-a 显示所有文件及目录 (ls默认将文件名或目录名开头为"."的视为隐藏文档，不会列出)
-l：除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出
-r：将文件以相反次序显示，原定依英文字母次序；
-t：将文件依建立时间之先后次序列出
-A：同 -a ，但不列出 "." (目前目录) 及 ".." (父目录)
-F：在列出的文件名称后加一符号；例如可执行档则加 "*", 目录则加 "/"
-R：若目录下有文件，则以下之文件亦皆依序列出
```
### 示例
1、列出根目录(\)下的所有目录
```
ls /
```
2、列出当前工作目录下所有文件名以 s 开头的文件，越新的排越后面
```
ls -ltr s*
```
3、将 /bin 目录及其所有子目录和文件详细信息列出
```
ls -lR /bin
```
4、列出当前目录下的所有文件及子目录，目录于名称后加 "/", 可执行文件于名称后加 "*" 
```
ls -AF
```

## eval 

> 此命令适用于那些一次扫描无法实现其功能的变量.

格式为：
```
eval cmd_line
```
1、eval命令将会首先扫描命令行，进行所有的替换，然后再执行命令。此命令适用于那些一次扫描无法实现其功能的变量，该命令对变量进行两次扫描，如果第一遍扫描后，cmd_line是个普通命令，则执行此命令；如果cmd_line中含有变量的间接引用，则保证间接引用的语义。这些需要进行两次扫描的变量有时候被称为复杂变量。

2、eval也可以用于回显简单变量，不一定是复杂变量。

## rm
>  rm命令用于删除一个文件或者目录

### 语法
```
rm [options] file_name/directory_name
```
### 选项
```
-i：删除文件或目录前逐一询问确认；
-f：强制删除，即使原文件或目录属性设置为只读，也直接删除，无需逐一确认；
-r：递归删除目录及其子目录下的所有文件；
```
### 示例
1、删除文件abc.txt
```
rm abc.txt
```
2、递归删除当前目录下的所有文件及子目录
```
rm -r *
```

### 注意
1、文件一旦通过rm命令删除，则无法恢复，所以必须格外小心地使用该命令。
2、若删除目录，则必须配合选项"-r"。

## which
> which指令会在环境变量$PATH设置的目录里查找符合条件的文件。

### 语法
```
which [file...]
```
### 选项
```
-V：显示版本信息
```
### 示例
1、使用命令 which 查看命令 bash 的绝对路径
```
which bash # 显示bash可执行程序的绝对路径 
```

## mv

> mv命令用来为文件或目录改名或将文件或目录移入其它位置。

### 语法
```
mv [options] source destination
mv [options] source... directory
```

### 参数
```
-i：若指定目录已有同名文件，则先询问是否覆盖旧文件;
-f：在mv操作要覆盖某已有的目标文件时不给任何指示;
```
### 示例 
1、将文件file_name_1重命名为file_name_2
```
mv file_name_1 file_name_2
```

2、将info目录放入logs目录中。如果logs目录不存在，则该命令将info改名为logs。
```
mv info/ logs
```

3、将/usr/xdhuxc目录下的所有文件和目录移到/home目录下
```
mv /usr/xdhuxc/* /home
```

## scp

> scp是linux系统下基于ssh登陆进行安全的远程文件复制命令。

### 语法
```
scp [options] [[user@]host1:]file1 [...]  [[user@]host2]:]file2
```

### 参数
```
-r：递归复制整个目录；
-q：不显示传输进度条；
-v：详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题；
-P：指定数据传输用到的端口号；
```

### 示例
1、从本地复制文件到远程主机
```
scp local_file remote_username@remote_ip:remote_folder # 指定了用户名，命令执行后需要再输入密码，仅指定了远程的目录，文件名字不变
或
scp local_file remote_username@remote_ip:remote_file # 指定了用户名，命令执行后需要再输入密码，指定了文件名；
或
scp local_file remote_ip:remote_folder # 没有指定用户名，命令执行后需要输入用户名和密码，仅指定了远程的目录，文件名字不变
或
scp local_file remote_ip:remote_file # 没有指定用户名，命令执行后需要输入用户名和密码，指定了文件名；
```
2、从本地复制目录到远程主机
```
scp -r local_folder remote_username@remote_ip:remote_folder # 指定了用户名，命令执行后需要再输入密码；
或
scp -r local_folder remote_ip:remote_folder # 没有指定用户名，命令执行后需要输入用户名和密码；
```
### 注意
1、使用scp命令要确保使用的用户具有可读取远程服务器相应文件的权限，否则scp命令是无法起作用的。

## groupadd
> groupadd命令用于创建一个新的工作组，新工作组的信息将被添加到系统文件中。

### 语法
```
groupadd [options] 参数
```
### 选项
```
-g：指定新建工作组的id；
-r：创建系统工作组，系统工作组的组id小于500；
-K：覆盖配置文件 /etc/login.defs；
-o：允许添加组ID号不唯一的工作组
```

### 示例
1、创建一个工作组，并设置组ID加入系统，此时在 /etc/passwd 文件中产生一个组 ID（GID） 是344的项目。
```
groupadd -g 344 xdhuxc
```

## useradd
> useradd 可用来建立用户帐号。帐号建好之后，再用passwd设定帐号的密码．而可用userdel删除帐号。使用useradd指令所建立的帐号，实际上是保存在/etc/passwd文本文件中。

### 语法
```
useradd [options] others
```
### 选项
```
-d directory_name：指定用户进入系统时的目录；
-g：指定用户所属的群组；
-m：自动创建用户进入系统时的目录；
-r：建立系统帐号；
-s shell_name：指定用户进入系统后所使用的shell；
-u user_id：指定用户id
```
### 示例
1、创建一个一般用户
```
useradd akfdrt
```
2、为创建的用户指定用户组
```
useradd -g root akfdrt
```
3、创建一个系统用户
```
useraddd -r akfdrt
```
4、为新创建的用户指定 home 目录
```
useradd -d /home/akfdrt akfdrt
```
5、创建新用户且指定用户id
```
useradd akfdrt -u 273
```

## su
> su命令用于变更为其他使用者的身份，除 root 外，需要键入该使用者的密码。

### 语法
```
su [-fmp] [-c command] [-s shell] [--help] [--version] [-] [USER [ARG]]
```
### 选项
```
-c command 或 --command=command 变更为帐号为 USER 的使用者并执行指令（command）后再变回原来使用者
-s shell 或 --shell=shell 指定要执行的 shell （bash csh tcsh 等），预设值为 /etc/passwd 内的该使用者（USER） shell;
USER 欲变更的使用者帐号
ARG 传入新的 shell 参数
```
### 示例
1、变更帐号为 root 并在执行 ls 指令后退出变回原使用者
```
su -c ls root
```
2、变更帐号为 root 并传入 -f 参数给新执行的 shell
```
su root -f
```
3、变更帐号为 ajdlfw 并改变工作目录至 ajdlfw 的 home 目录
```
su - ajdlfw
```

## netstat
> netstat命令用于显示网络状态。

### 语法
```
netstat [-acCeFghilMnNoprstuvVwx][-A<网络类型>][--ip]
```
### 选项
```
-a,--all：显示所有连接中的Socket；
-t,--tcp：显示TCP传输协议的连接状况；
-u,--udp：显示UDP传输协议的连接状况；
-v,--verbose：显示命令的执行过程；
-V,--version：显示版本信息；
-r,--route：显示路由表；
-i,--interfaces：显示网络界面信息表单；
-n,--numeric：直接使用IP地址，而不通过域名服务器；
-s,--statistics：显示网络工作信息统计表；
```

### 示例
1、显示详细的网络状况
```
netstat -a
```
2、显示当前用户UDP连接状况
```
netstat -nu
```
3、显示UDP端口号的使用情况
```
netstat -apu
```
4、显示网卡列表
```
netstat -i
```
5、显示网络统计信息
```
netstat -s
```
6、显示监听的套接口
```
netstat -l
```

## kill
>  kill 命令用于删除执行中的程序或工作。kill可将指定的信息送至程序。预设的信息为SIGTERM(15)，可将指定程序终止。若仍无法终止该程序，可使用SIGKILL(9)信息尝试强制删除程序。程序或工作的编号可利用ps指令或jobs指令查看。
语法

### 语法
```
kill [-s <信息名称或编号>][程序]
或
kill [-l <信息编号>]
```
### 选项
```
-l <信息编号> 　若不加<信息编号>选项，则-l参数会列出全部的信息名称；
-s <信息名称或编号> 　指定要送出的信息；
[程序] 可以是程序的PID或是PGID，也可以是工作编号。
```
### 示例
1、杀死指定用户xdhuxc的所有进程
```
kill -9 $(ps -ef|grep xdhuxc)
或
kill -u xdhuxc
```


## curl
> curl命令是一个利用URL规则在命令行下工作的文件传输工具。它支持文件的上传和下载，所以是综合传输工具，但按传统，习惯称curl为下载工具。作为一款强力工具，curl支持包括HTTP、HTTPS、ftp等众多协议，还支持POST、cookies、认证、从指定偏移处下载部分文件、用户代理字符串、限速、文件大小、进度条等特征。做网页处理流程和数据检索自动化，curl可以祝一臂之力。

### 语法
```
curl [options] 参数
```
### 选项
```
-o：将文件保存为命令行中指定的文件名的文件中；
-O：使用URL中默认的文件名保存文件到本地；
-C：可对大文件使用断点续传功能
```

### 示例
1、 将文件下载到本地，并命名为：kjsifg.html
```
curl -o kjsifg.html http://www.gnu.org/software/gettext/manual/gettext.html
```
2、将文件下载到本地，并命名为gettext.html
```
curl -O http://www.gnu.org/software/gettext/manual/gettext.html
```

## wget
> wget命令用来从指定的URL下载文件。wget非常稳定，它在带宽很窄的情况下和不稳定网络中有很强的适应性，如果是由于网络的原因下载失败，wget会不断的尝试，直到整个文件下载完毕。如果是服务器打断下载过程，它会再次联到服务器上从停止的地方继续下载。这对从那些限定了链接时间的服务器上下载大文件非常有用

### 语法
```
wget [options] 参数
```
### 选项
```
-r：递归下载方式；
-v：显示详细执行过程；
-q：不显示执行过程；
-nv：下载时只显示更新和出错信息，不显示指令的详细执行过程；
-c：断点续传，重新启动下载中断的文件
```
### 示例
1、使用 wget下载单个文件，保存在当前目录，在下载的过程中会显示进度条，包含（下载完成百分比，已经下载的字节，当前下载速度，剩余下载时间）。
```
wget http://www.linux.net/abc.zip
```
2、使用 wget 下载文件并以不同的文件名保存
```
wget -O wordpress.zip http://www.linux.net/download.aspx?id=1080
```
3、使用 wget 下载多个文件
```
wget -i file_list.txt
cat file_list << EOF
url_1
url_2
url_3
url_4
EOF
```

### 注意
1、wget 默认会以最后一个符合 / 的后面的字符来命令文件，对于动态链接的下载通常文件名会不正确。
为了解决该问题，可以使用选项 -O 来指定一个文件名。


## cp
> cp命令用于复制文件或目录

### 语法
```
cp [options] source destination
或
cp [options] source... directory
```
### 选项
```
-a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合；
-f：覆盖已经存在的目标文件而不给出提示；
-i：在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答"y"时目标文件将被覆盖；
-p：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中；
-r,-R：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
```

### 示例
1、将目录 /abc 下的所有文件及子目录复制到新目录/new_abc下
```
cp -r /abc/ /new_abc/ 
```

## find
> find命令用来在指定目录下查找文件。任何位于参数之前的字符串都将被视为欲查找的目录名。如果使用该命令时，不设置任何参数，则find命令将在当前目录下查找子目录与文件。并且将查找到的子目录和文件全部进行显示。

### 语法
```
find path -option [-print] [-exec -ok command] {};
```
### 选项
find 根据下列规则判断 path 和 expression，在命令列上第一个 - ( ) , ! 之前的部份为 path，之后的是 expression。如果 path 是空字串则使用目前路径，如果 expression 是空字串则使用 -print 为预设 expression。

expression 中可使用的选项：
```
-name name, -iname name：文件名称符合 name 的文件。iname 会忽略大小写
-type file_type：文件类型是file_type的文件
文件类型包括：
d：目录；
c：字符设备文件，比如猫、键盘、鼠标等串口设备；
b：块设备文件，比如硬盘、光驱等设备；
p：命名管道文件；
f：普通文件；
l：符号链接文件；
s：套接字文件
```

可以使用 `()` 将运算符分隔，并使用下列运算
```
expression_1 -and expression_2
! expression
-not expression
expression_1 -or expression_2
expression_1, expression_2
```

### 示例
1、将当前目录及其子目录下所有扩展名名是 `.c` 的文件列出来。
```
find . -name "*.c"
```
2、将当前目录及其子目录中所有的普通文件列出
```
find . -type f
```
3、查找名字符合正则表达式的文件
```
find ./ -regex .*so.*\.gz
```

## source 
> source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录。

### 语法
```
source file_name
或
source . file_name
```

## df
> df命令用于显示目前在Linux系统上的文件系统的磁盘使用情况统计。

### 语法
```
df [options]... [FILE]...
```

### 选项
```
-h：--human-readable 使用人类可读的格式，预设值是不加这个选项的
```
### 示例
1、显示所有的信息
```
df -total
```

## sed
> sed是一种流式编辑器，它是文本处理中非常常用的工具，能够完美地配合正则表达式使用，主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。
处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”，接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕，接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有改变，除非你使用重定向存储输出。

1、直接编辑文件选项-i，会匹配file文件中每一行的第一个book替换为books
```
sed -i 's/book/books/g' file #替换操作，s命令
```
2、使用后缀/g标记会替换每一行中的所有匹配
sed 还可以用行为单位进行部分数据的搜寻并取代
```
sed 's/要被取代的字符串/新的字符串/g'
即
sed 's/book/books/g' file
```

## awk
> awk是一种编程语言，用于在linux/unix下对文本和数据进行处理。数据可以来自标准输入(stdin)、一个或多个文件，或其它命令的输出。它支持用户自定义函数和动态正则表达式等先进功能，是linux/unix下的一个强大编程工具。它在命令行中使用，但更多是作为脚本来使用。awk有很多内建的功能，比如数组、函数等，这是它和C语言的相同之处，灵活性是awk最大的优势。

1、打印每一行的第二个和第三个字段，当使用不带参数的print时，它就打印当前行，当print的参数是以逗号进行分隔时，打印时则以空格作为定界符。
```
awk '{ print $2,$3}' file_name
```

## du
> du命令用于显示目录或文件的大小，显示指定的目录或文件所占用的磁盘空间。

### 语法
```
du [-abcDhHklmsSx][-L <符号连接>][-X <文件>][--block-size][--exclude=<目录或文件>][--max-depth=<目录层数>][--help][--version][目录或文件]
```

### 选项
```
--max-depth=<目录层数> 超过指定层数的目录后，予以忽略
-h或--human-readable 以K，M，G为单位，以人类易读的方式显示，提高信息的可读性。
-S或--separate-dirs 显示个别目录的大小时，并不含其子目录的大小。
```

### 示例
1、显示指定文件所占空间，以人类易读的方式显示。
```
du -h abc.log
```
