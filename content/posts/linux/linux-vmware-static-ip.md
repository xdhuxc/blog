+++
title = "给 VMware 中创建的虚拟机设置静态 IP"
date = "2018-10-13"
lastmod = "2018-10-17"
tags = [
    "VMware"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了给在 VMware 中创建的虚拟机设置静态 IP 的步骤。

<!--more-->

1）在 `VMware` 中，`编辑` -> `虚拟网络编辑器` -> `添加网络`，选择合适的网络名称，例如 `VMnet10`，点击 `确定`

2）点击 `VMnet10`，选择 `仅主机模式`，填写子网和子网掩码，例如子网为：`172.16.56.0`，子网掩码为：`255.255.255.0`，点击 `应用`。

<center>
<img src="/image/linux/vmware-static-ip/WechatIMG623.jpeg" width="800px" height="300px" />
</center>

3）选择要修改 `IP` 地址的虚拟机，点击 `编辑虚拟机设置`，点击 `网络适配器`，在 `网络连接` 中选择 `自定义`，再选择 `VMnet10 仅主机模式`，点击 `确定`。

<center>
<img src="/image/linux/vmware-static-ip/WechatIMG624.jpeg" width="800px" height="300px" />
</center>

4）登录虚拟机，修改 `/etc/sysconfig/network-scripts` 目录下 `ifcfg-ens33`，修改如下内容，修改 `BOOTPROTO` 为 `static`，`IPADDR` 为指定的 `IP` 地址，例如 `172.16.56.58`，子网 `NETWORK` 为 `172.16.56.0`，子网掩码 `NETMASK` 为：`255.255.255.0`，网关 `GATEWAY` 为：`172.16.56.1`。

<center>
<img src="/image/linux/vmware-static-ip/WechatIMG625.jpeg" width="800px" height="300px" />
</center>
使用 `systemctl restart network` 命令重新启动网络。
