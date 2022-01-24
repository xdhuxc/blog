+++
title = "Vagrant 的基本使用"
date = "2022-01-24"
lastmod = "2022-01-24"
description = ""
tags = [
    "Vagrant"
]
categories = [
    "Vagrant"
]
+++

使用 VirtualBox 来创建虚拟机并配置网络比较复杂，改用 Vagrant 来创建虚拟机，实现 "Code As Infrastructure"， 本篇博客就记录下使用 Vagrant 创建和配置虚拟机的方法。

<!--more-->

### 基本使用
1. 在 Mac 上安装 vagrant
```markdown
brew install vagrant
```

2. 准备 box，其实就是定制的操作系统镜像
```markdown
vagrant box add devalone/ubuntu-20.04-server-x64-puppet
```

3. 初始化
```markdown
vagrant init devalone/ubuntu-20.04-server-x64-puppet
```
会在当前目录下生成 Vagrantfile，记录着虚拟机的配置

4. 启动虚拟机
```markdown
vagrant up
```

5. 登录虚拟机
```markdown
vagrant ssh
```
进入虚拟机后，使用 `sudo su -` 可以切换到 root 用户。

如果需要登录到指定虚拟机，使用如下命令
```markdown
vagrant ssh devstack-controller
```

6. 停止虚拟机
```markdown
vagrant halt
```

7. 查看虚拟机的状态
```markdown
vagrant status
```

### 高级用法
1. 需要增加内存或者 CPU 时，在 Vagrantfile 中增加如下内容：
```markdown
config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = false
    # Customize the amount of memory on the VM:
    vb.memory = 4096
    vb.cpus = 4
end
```
然后使用 `vagrant reload` 命令重新加载一下，才能使配置生效。

2. 使用如下 Vagrantfile 创建多个虚拟机
```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 1000
  # 定义多个 VM
    config.vm.define "devstack-controller" do |controller|
        controller.vm.box = "devalone/ubuntu-20.04-server-x64-puppet"
        controller.vm.hostname = "devstack-controller"
        controller.vm.network "private_network", ip: "192.168.56.10"
        
        controller.vm.provider "virtualbox" do |vb|
          vb.memory = 4096
          vb.cpus = 4
        end
    end

    config.vm.define "devstack-computer-01" do |computer|
        computer.vm.box = "devalone/ubuntu-20.04-server-x64-puppet"
        computer.vm.hostname = "devstack-computer-01"
        computer.vm.network "private_network", ip: "192.168.56.11"
        
        computer.vm.provider "virtualbox" do |vb|
          vb.memory = 1024
          vb.cpus = 2
        end
    end
end
```


### 参考资料

http://www.vagrantbox.es/

https://app.vagrantup.com/boxes/search?order=desc&page=1&provider=virtualbox&q=ubuntu+server&sort=created&utf8=%E2%9C%93

https://learn.hashicorp.com/tutorials/vagrant/getting-started-index?in=vagrant/getting-started

https://www.cnblogs.com/xishuai/p/macos-use-vagrant-with-virtualbox.html

https://codeantenna.com/a/YXYhkTErAM
