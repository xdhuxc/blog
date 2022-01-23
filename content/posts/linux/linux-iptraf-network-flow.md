+++
title = "使用 iptraf 观察端口网络流量"
date = "2018-06-19"
lastmod = "2018-08-19"
tags = [
    "Linux",
    "iptraf"
]
categories = [
    "Linux"
]
+++

本篇博客详细记录了在 Linux 系统中使用 iptraf 进行端口流量观察的方法，可以帮助我们分析应用程序端口的网络流入和网络流出。

<!--more-->

iptraf 是一个基于ncurses开发的IP局域网监控工具，可以实时地监视网卡流量，可以生成各种网络统计数据，包括TCP信息、UDP统计、ICMP和OSPF信息、以太网负载信息、节点统计、IP校验和错误和其他一些信息。

### 观察端口网络流量

1、安装 `iptraf`
```markdown
yum install -y iptraf-ng-1.1.4-6.el7.x86_64
```

2、启动 `iptraf-ng`
```markdown
iptraf-ng
```
进入如下页面：
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG626.png" width="800px" height="300px" />
</center>

使用 `↑` 或 `↓`，选择 `Configure`
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG627.png" width="800px" height="300px" />
</center>

按 `Enter`，进入设置页面，
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG628.png" width="800px" height="300px" />
</center>

进行适当的配置，可以让统计的结果更直观，信息更加丰富。

* Reverse DNS lookups：查看连接的IP所对应的域名，在IP traffic monitor的pkt captured 对话框中就可以看到域名结果，这个不是很直观，开启后会有点影响抓包性能。
* TCP/UDP service names：在有端口的地方都会把端口号换成相应的服务名，非常有用，很直观。
* Activity mode：显示流量是按Kbits/s还是Kbytes/s，改为Kbytes，更符合习惯。
* Additional ports：按端口号监控额外需要监控的端口，默认只监控小于1024的。

选择 `Additional ports`
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG629.png" width="800px" height="300px" />
</center>

按 `Enter`，进入端口设置页面，设置端口范围为：`1024~10000`，按 `Tab` 键跳转至第二个输入框。
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG630.png" width="800px" height="300px" />
</center>

按 `Enter` 键保存端口设置。然后退出配置页面
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG631.png" width="800px" height="300px" />
</center>

退出 `iptraf`
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG632.png" width="800px" height="300px" />
</center>

3、重新打开iptraf
```markdown
iptraf-ng
```
选择 `Statistical breakdowns`，
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG633.png" width="800px" height="300px" />
</center>

按 `Enter` 键，选择 `By TCP/UDP port`
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG634.png" width="800px" height="300px" />
</center>

选择待检测的网卡 `ens192`
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG635.png" width="800px" height="300px" />
</center>

按 `Enter` 键，就可以看到此网卡上的端口对应的协议类型和网络流量了。
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG636.png" width="800px" height="300px" />
</center>

按 `S` 键，对输出信息进行排序
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG637.png" width="800px" height="300px" />
</center>

按 `B` 键，按照总的字节数进行排序
<center>
<img src="/image/linux/iptraf-network-flow/WechatIMG638.png" width="800px" height="300px" />
</center>

按 `X` 键退出。

### 参考资料

https://www.cnblogs.com/taosim/articles/4030292.html

https://blog.csdn.net/quiet_girl/article/details/50777210








