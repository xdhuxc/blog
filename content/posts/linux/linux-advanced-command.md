+++
title = "Linux 部分高级命令总结"
date = "2018-09-11"
lastmod = "2018-09-11"
description = ""
tags = [
    "linux"
]
categories = [
     "linux"
]
+++

本篇博客整理了一些 Linux 系统中常用的高级命令，在一些复杂的运维工作中会用到。

<!--more-->

### netstat

netstat 是一个监控 TCP/IP 网络的工具，可以显示路由表、实际的网络连接以及每一个网络接口设备的状态信息。其语法格式为：
```markdown
netstat [options]
```

参数如下：

* -a 或 --all：显示所有的 socket，包括已建立（CONNECTED）的连接，也包括监听连接请求（LISTENING）的那些连接。
* -c 或 --continuous：持续显示 socket 连接状态。
* -l 或 --listening：显示处于监听状态的服务器 socket。
* -t 或 --tcp：显示 TCP 协议的连接状况。
* -u 或 --udp：显示 UDP 协议的连接状况。
* -n 或 --numeric：直接使用 IP 地址，而不通过域名服务器。
* -p 或 --programs：显示正在使用 socket 的进程ID/程序名称。

如果使用时不带参数，netstat 显示活动的 TCP 连接。

1、列出所有的端口，包括监听的和未监听的
```markdown
netstat -a   # 列出所有的端口
netstat -au  # 列出所有的 TCP 端口
netstat -at  # 列出所有的 UDP 端口
```
2、列出所有处于监听状态的 Socket
```markdown
netstat -l   # 只列出监听（即State 状态为 LISTENING）状况的端口，
netstat -lt  # 只列出所有监听的 TCP 端口
netstat -lu  # 只列出所有监听的 UDP 端口
netstat -lx  # 只列出所有监听 UNIX 的
```
3、显示 pid 和进程名称
```markdown
netstat -p
```

### journalctl

systemd 统一管理所有 Unit 的启动日志。带来的好处就是，可以只使用 journalctl 一个命令，查看所有的日志，包括内核日志和应用日志。

日志的配置文件为：/etc/systemd/journald.conf

1）查看所有日志，默认情况下，只保存本次启动的日志
```markdown
journalctl
```
2）查看内核日志，不显示应用日志
```markdown
journalctl -k
```
#### 查看指定时间的日志

可以使用 --since 和 --until 选项过滤任意时间限制，这些限制分别显示给定时间之前或之后的记录。

journalctl 还能理解部分相对值及命名简写。例如，可以使用 yesterday，today，tomorrow 或 now 等表达。另外，我们也可以使用“-”或者“+”设定相对值，或者使用“ago”的表达。

1、显示 2018年07月11日，16点43分30秒到当前时间之间的所有日志信息
```markdown
journalctl --since="2018-07-11 16:43:30"
```

2、获取昨天的日志信息
```markdown
journalctl --since yesterday
```

3、获取某一个时间段到当前时间的前一个小时的日志
```markdown
journalctl --since 12:00 --until "1 hour ago"
```

4、获取当前时间的前20分钟的日志
```markdown
journalctl --since "20 min ago"
```

5、获取某一天到某一个时间段的日志信息
```markdown
journalctl --since "2018-07-11" --until "2018-07-12 17:00:00"
```

6、查看 httpd 服务的日志信息
```markdown
journalctl -u httpd --since today # -u 选项指定待查看的单元
```

7、按照进程ID查看日志信息
```markdown
journalctl _PID=1
```

8、按日志级别显示日志条目
```markdown
journalctl -p err # -p 选项显示特定优先级的信息，从而过滤掉优先级较低的信息。
```
这将只显示被标记为错误、严重、警告或者紧急级别的信息。我们也可以使用优先级名称或者其相关量化值，以下各数字为由最高到最低优先级：
```markdown
0:emerg
1:alert
2:crit
3:err
4:warning
5:notice
6:info
7:debug
```

9、显示近期的日志
```markdown
journalctl -n200  # 使用 -n 选项指定显示特定数量的记录，默认情况下只显示最后发生的10条日志记录。
```

10、追踪日志
```markdown
journalctl -f # 表示主动追踪当前正在输出的日志，只要不终止，会一直监控。
```

11、查看当前日志占用磁盘的空间的总大小
```markdown
journalctl --disk-usage
```

12、指定日志文件最大空间
```markdown
journalctl --vacuum-size=1G
```

13、指定日志文件保存时间
```markdown
journalctl --vacuum-time=1years
```

参考资料：

https://www.cnblogs.com/itxdm/p/Systemd_log_system_journalctl.html

http://blog.51cto.com/13598893/2072212


### nslookup

nslookup 是常用的域名查询工具，就是查询 DNS 信息用的命令。

nslookup 有两种工作模式：

* 交互模式：在该模式下，用户可以向域名服务器查询各类主机、域名的信息，或者输出域名中的主机列表。

进入交互模式，直接输入 nslookup 命令，不加任何参数，则直接进入交互模式，此时 nslookup 会连接到默认的域名服务器（即`/etc/resolv.conf`的第一个 DNS 地址）

或者输入 `nslookup -nameserver/ip`

* 非交互模式：在“非交互模式”下，用户可以针对一个主机或域名仅仅获取特定的名称或所需信息。

进入非交互模式，就直接输入 `nslookup domainname` 即可。

#### 示例
1、使用默认的域名服务器，根据域名查找 IP 地址
```markdown
[root@xdhuxc xdhuxc]# nslookup www.baidu.com
Server:		10.10.24.11
Address:	10.10.24.11#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 61.135.169.121
Name:	www.a.shifen.com
Address: 61.135.169.125
```

2、使用默认的域名服务器，根据 IP 地址查找域名
```markdown
[root@xdhuxc xdhuxc]# nslookup 10.10.24.11
Server:		10.10.24.11
Address:	10.10.24.11#53

11.24.10.10.in-addr.arpa	name = r-29792-VM.cs1cloud.internal.
```
或者是这样
```markdown
[root@xdhuxc xdhuxc]# nslookup www.taobao.com
Server:		10.10.24.11
Address:	10.10.24.11#53

Non-authoritative answer:
www.taobao.com	canonical name = www.taobao.com.danuoyi.tbcache.com.
Name:	www.taobao.com.danuoyi.tbcache.com
Address: 123.129.215.222
Name:	www.taobao.com.danuoyi.tbcache.com
Address: 123.129.215.178

[root@xdhuxc xdhuxc]# nslookup 123.129.215.178
Server:		10.10.24.11
Address:	10.10.24.11#53

** server can't find 178.215.129.123.in-addr.arpa.: NXDOMAIN
```

3、列出当前设置的默认选项
```markdown
[root@xdhuxc xdhuxc]# nslookup
> set all
Default server: 10.10.24.11
Address: 10.10.24.11#53
Default server: 202.106.0.20
Address: 202.106.0.20#53
Default server: 114.114.114.114
Address: 114.114.114.114#53

Set options:
  novc			nodebug		nod2
  search		recurse
  timeout = 0		retry = 3	port = 53
  querytype = A       	class = IN
  srchlist = cs1cloud.internal
> 
```

相对而言，ping 命令只是一个检查网络连通情况的命令，虽然在输入的参数是域名的情况下会通过 DNS 进行查询，但是它只能查询 A 类型和 CNAME 类型的记录，而且只会告诉域名是否存在，不提供其他信息。

### systemctl 

systemctl 命令是系统服务管理器指令，实际上将 service 和 chkconfig 这两个命令组合到一起


|任务 | 旧指令 | 新指令|
|:----|:----|:----|
使某服务自动启动 |chkconfig --level 3 httpd on|systemctl enable httpd.service
使某服务不自动启动 | chkconfig --level 3 httpd off|systemctl disable httpd.service
检查服务状态|service httpd status | systemctl status httpd.service(显示服务详细信息)systemctl is-active httpd.service(仅显示是否Active)
显示所有已启动的服务|chkconfig --list|systemctl list-units --type=service
启动某服务|service httpd start|systemctl start httpd.service
停止某服务|service httpd stop|systemctl stop httpd.service
重启某服务|service httpd restart|systemctl restart httpd.service

1、启动nfs服务
```markdown
systemctl start nfs-server.service
```

2、设置开机自启动
```markdown
systemctl enable nfs-server.server
```

3、停止开机启动
```markdown
systemctl disable nfs-server.service
```

4、查看服务当前状态
```markdown
systemctl status nfs-server.service
```

5、重新启动某服务
```markdown
systemctl restart nfs-server.service
```

6、查看所有已启动的服务
```markdown
systemctl list -units --type=service
```

### top 命令

top 命令是linux下常用的性能分析工具，能够实时显示系统中各个进程的资源占用状况。

```markdown
top - 08:50:33 up 4 days, 17:17,  4 users,  load average: 3.02, 2.95, 2.36
Tasks: 106 total,   1 running, 105 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.1 sy,  0.0 ni, 99.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  8010904 total,  3164800 free,  1467176 used,  3378928 buff/cache
KiB Swap:  2096124 total,  2096124 free,        0 used.  6235608 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                               
    1 root      20   0   57504   3376   2260 S   0.0  0.0   1:34.67 systemd                                                                                               
    2 root      20   0       0      0      0 S   0.0  0.0   0:00.09 kthreadd                                                                                              
    3 root      20   0       0      0      0 S   0.0  0.0   0:00.03 ksoftirqd/0                                                                                           
    5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H                                                                                          
    6 root      20   0       0      0      0 S   0.0  0.0   0:08.34 kworker/u8:0                                                                                          
    7 root      rt   0       0      0      0 S   0.0  0.0   0:00.12 migration/0                                                                                           
    8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh                                                                                                
    9 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcuob/0                                                                                               
   10 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcuob/1                                                                                               
```
统计信息区前五行是系统整体的统计信息

第一行是任务队列信息，同uptime命令的执行结果，其内容分别描述如下：

信息 | 含义
---|---
08:50:33 | 当前时间
up 4 days, 17:17 | 系统运行时间，格式为：小时:分钟
4 users | 当前登录用户数
load average: 3.02, 2.95, 2.36 | 系统负载，即任务队列的平均长度，三个数值分别为1分钟，5分钟，15分钟前到现在的平均值。

第二，三行为进程和CPU的信息，当有多个CPU时，这些内容可能会超过两行，内容如下：

信息 | 含义
---|---
Tasks: 106 total | 进程总数
1 running | 正在运行的进程数
105 sleeping | 睡眠的进程数
0 stopped | 停止的进程数
0 zombie | 僵尸进程数
%Cpu(s):  0.0 us（user） | 用户空间占用CPU百分比
0.1 sy（system） | 内核空间占用CPU百分比
0.0 ni（nice） | 用户进程空间内改变过优先级的进程占用CPU百分比
99.9 id（idle）| 空闲CPU百分比
0.0 wa （IO-wait）| 等待输入输出的CPU时间百分比
0.0 hi（hardware interrupt） |CPU服务于硬中断所耗费的时间总额
0.0 si （software intrerupt）|CPU服务于软中断所耗费的时间总额
0.0 st | 当前虚拟机中被虚拟化偷走的时间

最后两行为内存信息，内容如下：

信息 | 含义
---|---
KiB Mem :  8010904 total | 物理内存总量
3164800 free | 空闲内存总量
1467176 used | 使用的物理内存总量
3378928 buff/cache | 用作内核缓存的内存量
KiB Swap:  2096124 total| 交换区总量
2096124 free | 空闲交换区总量
0 used | 使用的交换区总量
6235608 avail Mem | 可用内存，

列名及含义

列明 | 含义
---|---
PID | 进程ID
PPID | 父进程ID
UID  | 进程所有者的用户ID
USER | 进程所有者的用户名
TTY  | 启动进程的终端名称，不是从终端启动的进程则显示为？
PR   | 进程优先级
NI   | nice值，负值表示高优先级，正值表示低优先级
%CPU | 上次更新到现在的CPU时间占用百分比
TIME | 进程使用的CPU时间总计，单位：秒
TIME+| 进程使用的CPU时间总计，单位：1/100秒
%MEM | 进程使用的物理内存百分比
VIRT | 进程使用的虚拟内存总量，单位：KB，VIRT=SWAP+RES
SWAP | 进程使用的虚拟内存中，被换出的大小，单位：KB
RES  | 进程使用的，未被换出的物理内存大小，单位：KB，RES=CODE+DATA
CODE（the Text Resident Set size or TRS） | 可执行代码占用的物理内存大小，单位为：KB
DATA （the Data Resident Set size or DRS）| 可执行代码以外的部分（数据段+栈）占用的物理内存大小，单位：KB
SHR  | 共享内存大小，单位：KB
S    | 进程状态：
       D：不可中断的睡眠状态
       R：运行，该进程目前正在运行，或者说可以被运行
       S：睡眠，该进程目前正在睡眠当中，可被某些信号唤醒
       T：跟踪或停止，该进程目前正在侦测或被停止了
       Z：僵尸进程，该进程应该已经被终止，但其父进程却无法正常终止它，造成僵尸状态
COMMAND | 命令名或命令行

执行 `top` 命令后，默认显示CPU整体情况，按左上角 `1` 键，显示每个 `CPU` 的负载情况

输入 top 命令，快捷键使用如下：

按 ‘X’ 键，再按 ‘B’ 键，默认按 CPU 使用率降序排列

按住 ‘Shift’ 键，再按 ‘P’ 键，是按 CPU使用率 降序排列。

按住 ‘Shift’ 键，再按 ‘M’ 键，是按 内存使用率 降序排列。

按住 ‘Shift’ 键，再按 ‘T’ 键，是按 进程运行时间 降序排列。

按 ‘F’ 键，进入字段管理页面，使用上下键控制光标移动，使用光标选中某字段，按 ‘D’ 或者空格，取消该列的显示，按 ‘q’ 或 ‘Esc’ 再次进入 top 命令页面，可以看到刚才选中的列已经不显示了。

在字段管理页面，使用光标选中某字段后，按 ‘S’ 键，可将该字段设置为排序字段，然后按 ‘Esc’ 或 ‘Q’ 键退出，默认按降序排列。若要改为升序排列，按住 ‘Shift’ 键，然后按 ‘R’ 键，即可按照排序字段升序排列。


### uniq 命令
uniq 命令用于报告或忽略文件中的重复行，一般与sort命令结合使用

选项如下：

* -c，--count：在每列前面显示该行重复出现的次数。
* -u，--unique：仅显示出现一次的行。
* -d，--repeated：仅显示重复出现的行，与uniq的区别是：uniq显示所有出现的行，包括出现一次的，而-d选项去除了只出现一次的。
* -i，--ignore-case：不区分大小写。


### sort 命令
sort 命令将文件内容进行排序，并将排序结果标准输出，默认为字符排序和升序排列。

选项如下：

* -n：依照数值的大小排序。
* -k：指定需要排序的栏位。
* -h：以人类可读的形式显示。
* -r：以相反的顺序来排序，即降序排列。
* -t：指定栏位分隔符

1、查看nginx日志中出现地IP数
```markdown
cat access.log | awk -F '|' '{print $1}' | sort | uniq -c | sort -k1nr | head -n 10
```
示例如下：
```markdown
[root@localhost nginx]# cat xdhuxc.log | awk -F '|' '{print $1}' | sort | uniq -c | sort -k1nr| head -n 5
   5522 172.20.26.127
   4873 172.20.13.111
   2426 172.20.26.128
    876 172.20.17.6
    806 172.20.17.8
```
### ps 命令
1、查看进程下的线程
```markdown
ps -T -p 4561          # 2561 为进程 ID。
```

2、查看进程树，并输出指定属性
```markdown
[root@k8s-master kubepods]# ps xf -o pid,ppid,stat,args
  PID  PPID STAT COMMAND
ps xf -o pid,ppid,stat,args
22013     1 Ssl  /usr/bin/dockerd --exec-opt native.cgroupdriver=cgroupfs --storage-driver=devicemapper --insecure-registry 0.0.0.0/0 --registry-mirror http://172.20.2
22023 22013 Ssl   \_ docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0 --start-timeout 2m --state-dir /var/run/dock
22324 22023 Sl        \_ docker-containerd-shim 0df7c0ad8b966b62944775ceeab92f337565ae5230176e63e9a835f611fd6618 /var/run/docker/libcontainerd/0df7c0ad8b966b62944775ce
22350 22324 Ss        |   \_ /pause
22424 22023 Sl        \_ docker-containerd-shim 1b46c083a0c1b8220985830a21ceb47aba66bba19e8c502c3a962cc8e4610c23 /var/run/docker/libcontainerd/1b46c083a0c1b8220985830a
22446 22424 Ss        |   \_ /pause
22555 22023 Sl        \_ docker-containerd-shim b6600a35e42def755b300f470e09982644026cb4bcff47425b67dd29deb6c279 /var/run/docker/libcontainerd/b6600a35e42def755b300f47
22575 22555 Ss        |   \_ /pause
22615 22023 Sl        \_ docker-containerd-shim aab94460ba50336a123ef79874be9a57d48b8a9ca5df0440034be804be21dd46 /var/run/docker/libcontainerd/aab94460ba50336a123ef798
22640 22615 Ss        |   \_ /pause
22717 22023 Sl        \_ docker-containerd-shim 055666c9918be5042a0e8450e68fd716698f74db8d17ed31a477a65df5f5f61c /var/run/docker/libcontainerd/055666c9918be5042a0e8450
22746 22717 Ss        |   \_ /pause
22823 22023 Sl        \_ docker-containerd-shim fc6644e7c274a6695291afb927705a60de34dc232afdcb32f4cbe71ced2bde1c /var/run/docker/libcontainerd/fc6644e7c274a6695291afb9
22843 22823 Ssl       |   \_ /usr/bin/kube-controllers
22926 22023 Sl        \_ docker-containerd-shim fc115ec286f1f90ef9ba3a30f93e8636fec97ff32394dc067642b98695399c2a /var/run/docker/libcontainerd/fc115ec286f1f90ef9ba3a30
22967 22926 Ss        |   \_ /pause
22992 22023 Sl        \_ docker-containerd-shim 5335322da47f532e81bd49ce19047d7dce9de3772201e165d417b4c3a2f3061f /var/run/docker/libcontainerd/5335322da47f532e81bd49ce
23033 22992 Ss        |   \_ /pause
23091 22023 Sl        \_ docker-containerd-shim 558e3570397e4b178d1e03828bc4094b8544f5e8021192692509502ed6c41f62 /var/run/docker/libcontainerd/558e3570397e4b178d1e0382
23114 23091 Ss        |   \_ /pause
23178 22023 Sl        \_ docker-containerd-shim 630bb2f866da362faee80b00ff771f4c3900e442d0efc730470e9ebd5c89ef5c /var/run/docker/libcontainerd/630bb2f866da362faee80b00
23201 23178 Ss        |   \_ /pause
23269 22023 Sl        \_ docker-containerd-shim 4fe2e9adc614057e37aa9e6f1428fe244e8e79720b36f1044d2fdffe0627a151 /var/run/docker/libcontainerd/4fe2e9adc614057e37aa9e6f
23290 23269 Ss        |   \_ /usr/bin/dumb-init /nginx-ingress-controller --default-backend-service=ingress-nginx/default-http-backend --configmap=ingress-nginx/nginx-
23313 23290 Ssl       |       \_ /nginx-ingress-controller --default-backend-service=ingress-nginx/default-http-backend --configmap=ingress-nginx/nginx-configuration -
23655 23313 S         |           \_ nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
23356 22023 Sl        \_ docker-containerd-shim d24b9bd89b0614770bab8e4022f9c478bbf1f95961ae03733ea4ba089b2d1c2d /var/run/docker/libcontainerd/d24b9bd89b0614770bab8e40
23376 23356 Ss        |   \_ /sbin/runsvdir -P /etc/service/enabled
24256 23376 Ss        |       \_ runsv felix
24267 24256 Sl        |       |   \_ calico-felix
24257 23376 Ss        |       \_ runsv bird
24268 24257 S         |       |   \_ bird -R -s /var/run/calico/bird.ctl -d -c /etc/calico/confd/config/bird.cfg
24258 23376 Ss        |       \_ runsv bird6
24262 24258 S         |       |   \_ bird6 -R -s /var/run/calico/bird6.ctl -d -c /etc/calico/confd/config/bird6.cfg
24259 23376 Ss        |       \_ runsv confd
24263 24259 Sl        |           \_ confd -confdir=/etc/calico/confd -interval=5 -watch --log-level=info -node=http://172.20.26.150:2379 -client-key= -client-cert= -c
23475 22023 Sl        \_ docker-containerd-shim d5582f7b927c731966c6e75d0619f16fec661c1d8b287e7b47020c13f4f29879 /var/run/docker/libcontainerd/d5582f7b927c731966c6e75d
23503 23475 Ss        |   \_ /pause
23583 22023 Sl        \_ docker-containerd-shim 9b680676ec0fd4434fef03a614e32908849947f7d87be73894304745909ae308 /var/run/docker/libcontainerd/9b680676ec0fd4434fef03a6
23604 23583 Ssl       |   \_ /usr/bin/kube-controllers
23720 22023 Sl        \_ docker-containerd-shim 95054e9ec8211a283e5b5e2fe271687cbc8a6febc28b6a58811871c9c70abf26 /var/run/docker/libcontainerd/95054e9ec8211a283e5b5e2f
23749 23720 Ssl       |   \_ /usr/local/bin/etcd -data-dir /var/etcd/data -listen-client-urls http://127.0.0.1:2379,http://127.0.0.1:4001 -advertise-client-urls http:/
24159 22023 Sl        \_ docker-containerd-shim cacf746cbac262377a3925c9c47bd36e5a06a2de688d8257949b4cedfdf0e552 /var/run/docker/libcontainerd/cacf746cbac262377a3925c9
24180 24159 Ssl       |   \_ /usr/bin/kube-controllers
24215 22023 Sl        \_ docker-containerd-shim 4c294ff5706f5f45ece29911d508d94513c1728f900cc808653377c5d92b9a0d /var/run/docker/libcontainerd/4c294ff5706f5f45ece29911
24239 24215 Ssl       |   \_ /usr/bin/kube-controllers
24404 22023 Sl        \_ docker-containerd-shim c260f89fc132757701cf374ffa3c336ea09561c0ec2fdb62a7b955c5086ec635 /var/run/docker/libcontainerd/c260f89fc132757701cf374f
24422 24404 Ss        |   \_ /bin/sh -c /run.sh $FLUENTD_ARGS
24457 24422 S         |       \_ /bin/sh /run.sh --no-supervisor
24459 24457 Sl        |           \_ /usr/bin/ruby2.3 /usr/local/bin/fluentd --no-supervisor
24499 22023 Sl        \_ docker-containerd-shim 23be602627713a4d4a8f6022c0149e7ed12ded42d8b6821b778412fe879d3349 /var/run/docker/libcontainerd/23be602627713a4d4a8f6022
24521 24499 Ss        |   \_ /bin/sh /install-cni.sh
 2160 24521 S         |       \_ sleep 10
24539 22023 Sl        \_ docker-containerd-shim a0b332204da15546ae376fae91bd93488a54e19ad15bcb4074f4e4d6c703d007 /var/run/docker/libcontainerd/a0b332204da15546ae376fae
24566 24539 Ssl       |   \_ /usr/bin/kube-controllers
24683 22023 Sl        \_ docker-containerd-shim 45538bf87293a303e784c1f2b4c9d05613dc26e284a9ff714e0a4ab78952d903 /var/run/docker/libcontainerd/45538bf87293a303e784c1f2
24712 24683 Ssl       |   \_ /kube2sky -domain=kube.local
24746 22023 Sl        \_ docker-containerd-shim 8d1012c2cfebea10d9f250aa803c523860f6213ba057d85611385ce55de01639 /var/run/docker/libcontainerd/8d1012c2cfebea10d9f250aa
24909 22023 Sl        \_ docker-containerd-shim 5381a8ce1f7fdf31aa0b87a4d6b63469bd99b3a814ce0f38c3e2dddfbb13cc68 /var/run/docker/libcontainerd/5381a8ce1f7fdf31aa0b87a4
24928 24909 Ssl       |   \_ /skydns -machines=http://localhost:4001 -addr=0.0.0.0:53 -domain=kube.local
24992 22023 Sl        \_ docker-containerd-shim 1cc405561a9ed15554658b1237339273b57ae5e68c85f4497741fa0b16248e7e /var/run/docker/libcontainerd/1cc405561a9ed15554658b12
25010 24992 Ssl       |   \_ /exechealthz -cmd=nslookup kubernetes.default.svc.kube.local localhost >/dev/null -port=8080
31505 22023 Sl        \_ docker-containerd-shim 39fd7f660d705e6406d6e5bedeb3082e384370f0557c7c0b8edc91e97e1a945f /var/run/docker/libcontainerd/39fd7f660d705e6406d6e5be
31523 31505 Ss        |   \_ /pause
31636 22023 Sl        \_ docker-containerd-shim 2b4014ca44a5752cd827734f49fcbd58724c5373a90dd06ffeef33a5f627d953 /var/run/docker/libcontainerd/2b4014ca44a5752cd827734f
31653 31636 Ssl           \_ /dashboard --insecure-bind-address=0.0.0.0 --bind-address=0.0.0.0 --auto-generate-certificates
```

### tree 命令

1、查看当前目录下的目录及文件详情
```markdown
tree -a # 显示当前目录下的所有文件及目录
```

2、查看当前目录三级以内的文件及目录详情
```markdown
# -L：指定目录深度。
tree -L 3 # 显示当前目录三级以内的文件及目录详情
```

3、查看当前目录三级以内的文件及目录详情及文件和目录的大小，并以可读的方式显示
```markdown
tree -L --du -h # 显示当前目录三级以内的文件及目录详情，并以可读方式显示目录和文件的大小。
```

### w 命令

w 命令用于显示已经登录系统的用户列表，并显示用户正在执行的命令。执行此命令可以知道目前登录进系统的用户以及他们正在执行的程序，还包括他们登录的 IP 地址。

```markdown
[root@xdhuxc ~]# w
 16:04:06 up 27 days, 23 min,  2 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/1    10.6.198.249     Mon10   24:15m  0.13s  0.13s -bash
root     pts/4    10.4.100.45      09:32    6.00s  0.01s  0.00s w
```

### cut 命令

指定分隔符截取文件内容，而不是默认的tab
```markdown
cat /etc/passwd | cut -d ":" -f 1 # 查询linux系统中的所有用户 
```


