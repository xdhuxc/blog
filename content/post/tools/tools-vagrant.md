+++
title = "Vagrant 常用命令和资料"
date = "2018-11-07"
lastmod = "2018-11-07"
tags = [
    "Vagrant"
]
categories = [
    "技术"
]
+++

本篇博客主要记录下 vagrant 常用的命令，以备后需。

<!--more-->

### vagrant 简介
Vagrant 是一个用于在单个工作流中构建和管理虚拟机环境的工具。凭借着易于使用的工作流和专注于自动化，Vagrant 缩短了开发环境的设置时间，提高了生产效率，并使 `在我的机器上正常工作` 成为了过去的遗物。


### vagrant 命令
1、初始化 vagrant 工程
```markdown
vagrant init xdhuxc centos/7
```

2、启动虚拟机
```markdown
vagrant up --provider virtualbox
```

3、登录虚拟机
```markdown
vagrant ssh
```

4、关闭虚拟机
```markdown
vagrant halt
```

5、删除虚拟机
```markdown
vagrant destroy
```

6、打包镜像
```markdown
vagrant xdhuxc # 会在当前目录下生成 xdhuxc.box 文件，后续可直接使用该文件恢复环境。
```

注意事项

虚拟机的配置信息在 vagrantfile 中，使用 `vagrant up` 启动的虚拟机会重新创建网络等配置，因此最好在 vagrantfile 中指定这些信息。

### 参考资料
学习资料

https://www.cnblogs.com/davenkin/p/vagrant-virtualbox.html

Vagrantfile

https://blog.csdn.net/u011781521/article/details/80291765

box 下载地址

https://app.vagrantup.com/centos/boxes/7
