+++
title = "虚拟机的几种网络连接方式"
date = "2018-12-09"
lastmod = "2019-07-09"
tags = [
    "VirtualBox",
    "VMware"
]
categories = [
    "技术"
]
+++

本篇博客介绍了使用 `Virtual Box` 或 `VMware Work station` 创建虚拟机时的网络连接方式。

<!--more-->

VirtualBox中有四种网络连接方式：

* NAT 网络地址转换模式
* Bridged Adapter 桥接模式
* Intenal 内部网络模式
* Host-Only Adapter 主机模式

VMWare 中有五种网络连接方式：

* NAT 模式
* 桥接模式
* 仅主机模式
* 自定义（特定虚拟网络）
* LAN区段

不同的虚拟交换机应用在不同的联网模式下：

* VMnet0：这是VMware用于虚拟桥接网络下的虚拟交换机；
* VMnet1：这是VMware用于虚拟Host-Only网络下的虚拟交换机；
* VMnet8：这是VMware用于虚拟NAT网络下的虚拟交换机；
* VMnet2~VMnet7及VMnet9：是VMware用于虚拟自定义custom网络下的虚拟交换机；


VirtualBox中四种网络连接方式之间的区别：

方向 | NAT | Bridged Adapter | Internal | Host-only Adapter
---|---|---|---|---|---|---
虚拟机->主机 | V | V | X | 默认不能，需配置
主机->虚拟机 | X | V | X | 默认不能，需配置
虚拟机->其他主机 | V | V | X | 默认不能，需配置
其他主机->虚拟机 | X | V | X | 默认不能，需配置
虚拟机之间 | X | V | 同网络名下可以 | V 

### 参考资料

https://blog.csdn.net/carolzhang8406/article/details/19042569
