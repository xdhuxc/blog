+++
title = "Nexus 安装和自定义配置"
date = "2017-09-22"
lastmod = "2018-12-22"
description = ""
tags = [
    "Nexus"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了 Nexus 的安装和配置。

<!--more-->

### Nexus

Nexus 是一个广泛使用的包管理工具，可以用来做 maven，rpm 等包的管理仓库，缓存包，供内部程序使用。

Nexus 默认管理员用户名/密码为：admin/admin123，访问地址为：http://localhost:8081/nexus/ （需要开放8081端口，CentOS 7 Minimal模式安装，启动后会自动启动firewalld）

如果有问题，可以使用bin/nexus console 来排查问题

在 `/data/sonatype-work/nexus/conf/nexus.xml` 中可以修改仓库的配置信息

使用自己的 nexus.xml 覆盖 `/data/sonatype-work/nexus/conf/nexus.xml` 目录下的nexus.xml文件，可以直接获得配置。注意，第一次启动Nexus时，并没有 sonatype-work 目录及其子目录，需要在覆盖 nexus.xml 文件后重新启动nexus

1、上传Nexus.tar.gz到系统根目录下并解压

2、运行nexus，命令为
```markdown
export RUN_AS_USER=root
./nexus start
```

默认存储路径为：（Nexus根目录在/data下）
```markdown
file:/data/sonatype-work/nexus/storage/central/
```
### 注意：
扩充Nexus时，一定要先执行如下三步：
```markdown
yum clean all
yum repolist
yum makecache
```

### 配置 yum，epel，docker 源
> 使用阿里云或中科大的yum和epel源

#### Base
创建仓库，类型为：proxy，

仓库id：
```
centos7_base #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7_base/
```
名称为：CentOS7-Base

Remote Storage Location：
```
http://mirrors.aliyun.com/centos/7.3.1611/os/x86_64/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/Base-x86_64/
```
Download Remote Indexes，选为：true

仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7_base/
```

#### Update
创建仓库，类型为：proxy，

仓库id：
```
centos7-updates #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-updates/
```
名称为：CentOS7-Updates

Remote Storage Location：
```
https://mirrors.aliyun.com/centos/7/updates/x86_64/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-updates/
```
Download Remote Indexes，选为：true

仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-updates/
```

#### Extras
创建仓库，类型为：proxy，

仓库id：
```
centos7-extras #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-extras/
```
名称为：CentOS7-Extras

Remote Storage Location：
```
https://mirrors.aliyun.com/centos/7/extras/x86_64/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-extras/
```
Download Remote Indexes，选为：true
仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-extras/
```

#### Docker
创建仓库，类型为：proxy，

仓库id：
```
centos7-docker #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-docker/
```
名称为：CentOS7-Docker

Remote Storage Location：
```
https://yum.dockerproject.org/repo/main/centos/7/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-docker/
```
Download Remote Indexes，选为：true
仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-docker/
```
#### Docker CE
创建仓库，类型为：proxy，

仓库id：
```
centos7-dockerce #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-dockerce/
```
名称为：CentOS7-DockerCE

Remote Storage Location：
```
https://download.docker.com/linux/centos/7/x86_64/stable/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-dockerce/
```
Download Remote Indexes，选为：true
仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-dockerce/
```

#### EPEL

创建仓库，类型为：proxy，

仓库id：
```
centos7-epel #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-epel/
```
名称为：CentOS7-Docker

Remote Storage Location：
```
https://mirrors.aliyun.com/epel/7/x86_64/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-epel/
```
Download Remote Indexes，选为：true
仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-epel/
```

#### USTC EPEL
创建仓库，类型为：proxy，

仓库id：
```
centos7-ustc-epel #则其访问路径为：http://192.168.244.129:8081/nexus/content/repositories/centos7-ustc-epel/
```
名称为：CentOS7-USTC-EPEL

Remote Storage Location：
```
https://mirrors.ustc.edu.cn/epel/7/x86_64/
```
Override Local Storage Location：
```
file:/data/sonatype-work/nexus/storage/centos7-ustc-epel/
```
Download Remote Indexes，选为：true
仓库路径：
```
http://192.168.244.129:8081/nexus/content/repositories/centos7-ustc-epel/
```
### 使用自定义的repo
xdhuxc.repo的内容如下：
```
[base]
name=CentOS-$releasever - Base
baseurl=http://192.168.244.129:8081/nexus/content/repositories/centos7_base/ # 此路径为仓库路径
gpgcheck=0
gpgkey=http://192.168.244.129:8081/nexus/content/repositories/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://192.168.244.129:8081/nexus/content/repositories/centos7-updates/
gpgcheck=0
gpgkey=http://192.168.244.129:8081/nexus/content/repositories/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
http://192.168.244.129:8081/nexus/content/repositories/centos7-extras/
gpgcheck=0
gpgkey=http://192.168.244.129:8081/nexus/content/repositories/rpm-gpg/RPM-GPG-KEY-CentOS-7

[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://192.168.244.129:8081/nexus/content/repositories/centos7-epel/
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=http://192.168.244.129:8081/nexus/content/repositories/rpm-gpg/RPM-GPG-KEY-EPEL-7

[dockerrepo]
name=Docker Repository
baseurl=http://192.168.244.129:8081/nexus/content/repositories/centos7-docker/
enabled=1
gpgcheck=0
gpgkey=http://192.168.244.129:8081/nexus/content/repositories/rpm-gpg/RPM-GPG-KEY-docker
```

复制xdhuxc.repo到/etc/yum.repos.d目录下，执行如下命令：
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
mv xdhuxc.repo /etc/yum.repos.d/CentOS-Base.repo
```

使用自己的nexus.xml覆盖`/data/sonatype-work/nexus/conf
/nexus.xml`目录下的nexus.xml文件，可以直接获得配置。注意，第一次启动Nexus时，并没有sonatype-work目录及其子目录，需要在覆盖nexus.xml文件后重新启动nexus

清除yum并生成缓存，执行如下命令：
```
yum clean
yum makecache
```

eple:
```
http://mirror.premi.st/epel/7/x86_64/
```
```
http://mirrors.aliyun.com/epel/6/x86_64/
```

puppetlabs
```
http://yum.puppetlabs.com/el/7/products/x86_64/
```

puppetlabdsdependencies
```
http://yum.puppetlabs.com/el/7/dependencies/x86_64/
```
