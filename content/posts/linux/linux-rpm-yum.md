+++
title = "Linux 下 RPM 和 YUM 的使用"
date = "2018-10-15"
lastmod = "2018-12-07"
tags = [
    "Linux",
    "RPM",
    "YUM"
]
categories = [
    "Linux"
]
+++

本篇博客介绍下 Linux 下 RPM 包管理工具的使用。

<!--more-->

### rpm

rpm 命令是 RPM 软件包的管理工具。rpm 原本是 Red Hat Linux 发行版专门用来管理 Linux 各项套件的程序，由于它遵循GPL规则且功能强大方便，因而广受欢迎。逐渐受到其他发行版的采用。RPM 套件管理方式的出现，让 Linux 易于安装，升级，间接提升了 Linux 的适用度。

#### rpm包管理的用途

1、可以安装、删除、升级和管理软件，当然也支持在线安装和升级软件；

2、通过RPM包管理能知道软件包包含哪些文件，也能知道系统中的某个文件属于哪个软件包；

3、可以在查询系统中的软件包是否安装以及其版本；

4、作为开发者可以把自己的程序打包为RPM 包发布；

5、软件包签名GPG和MD5的导入、验证和签名发布；

6、依赖性的检查，查看是否有软件包由于不兼容而扰乱了系统；

#### rpm 的使用权限
RPM软件的安装、删除、更新只有 root 权限才能使用；

对于查询功能任何用户都可以操作；

如果普通用户拥有安装目录的权限，也可以进行安装；

#### rpm命令

##### 初始化 rpm 数据库
```markdown
rpm --initdb
rpm --rebuilddb
```

##### 软件包的安装、升级和删除等

1、安装 docker 包
```markdown
rpm -vih docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
或
rpm -ivh docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm --nodeps --force # 安装软件包时不检查依赖关系
```

2、升级 docker 包
```markdown
rpm -Uvh docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

3、删除软件包
```markdown
rpm -e docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

##### rpm 软件包管理的查询功能
1、查询系统已经安装的软件
```markdown
rpm -q docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
或
rpm --query docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

2、查看系统中所有已经安装的软件包
```markdown
rpm -qa
```

3、查询一个已经安装的文件属于哪个软件包
```markdown
rpm -qf file_absolute_path
```

4、查询已安装软件包的安装位置
```markdown
rpm -ql docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
或
rpm rpmquery -ql docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

5、查询一个已安装软件包的信息
```markdown
rpm -qi docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

6、查看已安装软件包的配置文件
```markdown
rpm -qc docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

7、查看某个rpm包的依赖关系
```markdown
rpm -qpR docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
```

#### rpm 包命名规则
1、RPM包的一般格式为：
```markdown
name-version-arch.rpm
name-version-arch.src.rpm
```

（1）name，如：httpd，是软件的名称

（2）version，如:2.2.3 ,是软件的版本号。版本号的格式通常为“主版本号.次版本号.修正号”
29，是发布版本号，表示这个RPM包是第几次编译生成的

（3）arch,如:i386,表示包的适用的硬件平台，目前RPM支持的平台有：i386、i586、i686、sparc、alpha

（4）.rpm或.src.rpm,是RPM包类型的后缀，.rpm是编译好的二进制包，可用rpm命令直接安装；.src.rpm表示是源代码包，需要安装源码包生成源码，并对源码编译生成.rpm格式的RPM包，就可以对这个RPM包进行安装了

2、特殊名称

（1）el*  表示这个软件包的发行商版本,el5表示这个软件包是在RHEL 5.x/CentOS 5.x下使用。

（2）devel：表示这个RPM包是软件的开发包。

（3）noarch：说明这样的软件包可以在任何平台上安装，不需要特定的硬件平台。在任何硬件平台上都可以运行。

（4）manual 手册文档

### yum

全称为 `Yellow dog Updater, Modified`，是一个在`Fedora`和`RedHat`以及`SUSE`中的`Shell前端软件包管理器`。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。

yum提供了查找、安装、删除某一个、一组甚至全部软件包的命令，而且命令简洁而又好记。

yum的宗旨是自动化地升级，安装/移除rpm包，收集rpm包的相关信息，检查依赖性并自动提示用户解决

yum的关键之处是要有可靠的仓库，这是软件的仓库，它可以是http或ftp站点， 也可以是本地软件池，但必须包含rpm的header， header包括了rpm包的各种信息，包括描述，功能，提供的文件，依赖性等.正是收集了这些 header并加以分析，才能自动化地完成余下的任务。


#### yum 的特点

1、可以同时配置多个资源库(Repository)

2、简洁的配置文件(/etc/yum.conf)

3、自动解决增加或删除rpm包时遇到的倚赖性问题

4、使用方便

5、保持与RPM数据库的一致性

#### yum 的配置文件

yum 的配置文件分为两部分：main 和repository：

* main 部分定义了全局配置选项，整个yum 配置文件应该只有一个main。常位于/etc/yum.conf 中。
* repository 部分定义了每个源/服务器的具体配置，可以有一到多个。常位于/etc/yum.repo.d 目录下的各文件中。

yum.conf 文件一般位于/etc目录下，一般其中只包含main部分的配置选项。
```markdown
[main]
cachedir=/var/cache/yum     #yum缓存的目录，yum在此存储下载的rpm包和数据库，默认设置为：/var/cache/yum。

keepcache=0                 #安装完成后是否保留软件包，0为不保留，1为保留，默认为0。

debuglevel=2                #Debug 信息输出等级，范围为：0──10，默认为2。

logfile=/var/log/yum.log    #yum的日志文件，默认为：/var/log/yum.log。

pkgpolicy=newest            #包的策略。一共有两个选项，newest和last，这个作用是如果你设置了多个repository，而同一软件在不同的repository中同时存在，yum应该安装哪一个，如果是newest，则yum会安装最新的那个版本。如果是last，则yum会将服务器id以字母表排序，并选择最后的那个服务器上的软件安装。一般都是选newest。

distroverpkg=redhat-release #指定一个软件包，yum会根据这个包判断你的发行版本，默认是redhat-release，也可以是安装的任何针对自己发行版的rpm包。

tolerant=1                  #有1和0两个选项，表示yum是否容忍命令行发生与软件包有关的错误，比如你要安装1,2,3三个包，而其中3此前已经安装了，如果你设为1,则yum 不会出现错误信息。默认是0。
　　
exactarch=1                 #有两个选项1和0，设置为1，则yum只会安装和系统架构匹配的软件包，例如，yum不会将i686的软件包安装在适合i386的系统中。默认为1。

retries=6                   #网络连接发生错误后的重试次数，如果设为0，则会无限重试。默认值为6。

obsoletes=1                 #这是一个update 的参数，相当于upgrade，允许更新陈旧的RPM包。

plugins=1                   #是否启用插件，默认1为允许，0表示不允许。我们一般会用yum-fastestmirror这个插件。

exclude=selinux*            #排除某些软件在升级名单之外，可以用通配符，列表中各个项目要用空格隔开，

gpgcheck=1                  #有1和0两个选择，分别代表是否是否进行gpg(GNU Private Guard)校验，以确定rpm包的来源是有效和安全的。这个选项如果设置在[main]部分，则对每个repository 都有效。默认值为0。

metadata_expire=1800


# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
```

#### yum 命令
yum命令的一般形式如下：
```markdown
yum [options] [command] [package...]
```

options 是可选的，选项包括：
```markdown
-h：显示帮助信息。
-y：当安装过程中提示选择时，全部为“yes”。
-q：不显示安装的过程。
-c：指定配置文件。
-v：详细模式。
-d：设置调试等级（0-10）。
-e：设置错误等级（0-10）。
-R：设置yum处理一个命令的最大等待时间。
-C：完全从缓存中运行，而不去下载或者更新任何头文件。
```
command 为所要进行的操作

package 是操作的对象

常用的命令包括：

1、自动搜索最快镜像插件
```markdown
yum install yum-fastestmirror
```

2、安装 yum 图形窗口插件
```markdown
yum install yumex
```

3、查看可能批量安装的列表：
```markdown
yum grouplist
```

#### yum 命令详解

1、全部安装
```markdown
yum install
```

2、安装指定的软件包 nginx
```markdown
yum install nginx -y
```

3、安装程序组 kubernetes
```markdown
yum groupinstall kubernetes
```

4、安装指定版本的软件包 kubernetes
```markdown
yum list kubernetes
# 根据输出的软件包全名称进行安装
yum install -y kubernetes-1.20.12.rpm
```

5、全部更新
```markdown
yum update
```

6、更新指定的程序包 nginx 
```markdown
yum update nginx
```

7、检查可更新的程序
```markdown
yum check-update
```

8、升级指定软件包 nginx
```markdown
yum upgrade nginx
```

9、升级指定程序组 kubernetes
```markdown
yum groupupdate kubernetes
```

10、显示安装包 nginx 的信息
```markdown
yum info nginx
```

11、显示所有已经安装和可以安装的软件包
```markdown
yum list
```

12、显示指定程序包 nginx 的安装情况
```markdown
yum list nginx
```

13、显示程序组 kubernetes 的信息
```markdown
yum groupinfo kubernetes
```

14、根据关键字 keyword 查找安装包
```markdown
yum search keyword
```

15、删除软件包 nginx
```markdown
yum remove nginx
```

16、删除程序包组 kubernetes
```markdown
yum groupremove kubernetes
```

17、查看软件包 nginx 的依赖情况
```markdown
yum deplist nginx
```

18、清除缓存目录下的软件包
```markdown
yum clean nginx
```

19、清除缓存目录下的headers
```markdown
yum clean headers
```

20、清除缓存目录下旧的 headers
```markdown
yum clean oldheaders
```

21、清除缓存目录下的软件包及旧的 headers
```markdown
yum clean packages,yum clean oldheaders
等价于
yum clean,yum clean all
```

22、查看系统默认安装的 yum
```markdown
rpm -qa|grep yum
```

23、查看 yum 的某一条命令属于哪一个软件包，然后就可以安装这个软件包了。
```markdown
yum provides lssubsys 
```



