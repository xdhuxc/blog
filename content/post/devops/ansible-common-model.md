+++
title = "Ansible 学习之常用模块"
linktitle = "Ansible 学习之常用模块"
date = "2018-05-02"
lastmod = "2018-05-02"
description = ""
tags = [
    "ansible",
    "DevOps"
]
categories = [
    "技术"
]
+++

### 模块相关命令
（1）列出 ansible 支持的模块
```
ansible-doc -l
```
（2）查看该模块的帮助信息
```
ansible-doc ping # 查看 ping 模块的帮助信息
```
> 以下实验均是在 IP 地址为： 192.168.91.128 的虚拟机上操作的。
> /etc/ansible/hosts 文件中配置如下：
```
# This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups

# Ex 1: Ungrouped hosts, specify before any group headers.

## green.example.com
## blue.example.com
## 192.168.100.1
## 192.168.100.10
[Client]
192.168.91.130

# Ex 2: A collection of hosts belonging to the 'webservers' group

## [webservers]
## alpha.example.org
## beta.example.org
## 192.168.1.100
## 192.168.1.110

# If you have multiple hosts following a pattern you can specify
# them like this:

## www[001:006].example.com

# Ex 3: A collection of database servers in the 'dbservers' group

## [dbservers]
##
## db01.intranet.mydomain.net
## db02.intranet.mydomain.net
## 10.25.1.56
## 10.25.1.57

# Here's another example of host ranges, this time there are no
# leading 0s:

## db-[99:101]-node.example.com

```
### 常用模块示例
#### ping 模块
检查指定节点机器能否连通，如果主机在线，则回复pong。
例如：
```
[root@xdhuxc ~]# ansible Client -m ping
192.168.91.130 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
[root@xdhuxc ~]#
```
##### 远程命令模块（command、script、shell）
command 作为 ansible 的默认模块，可以运行远程权限范围所有的 shell 命令，不支持管道符。
例如：
```
ansible Client -m command -a "free -h" # 查看 Client 分组主机内存使用情况。
```
执行结果为：
```
[root@xdhuxc ~]# ansible Client -m command -a "free -h"
192.168.91.130 | SUCCESS | rc=0 >>
              total        used        free      shared  buff/cache   available
Mem:           976M        153M        599M        6.7M        223M        638M
Swap:          2.0G          0B        2.0G

```
script 的功能是在远程主机执行主控端存储的 shell 脚本文件，相当于 scp + shell 组合。
例如：
```
ansible Client -m script -a "/root/xdhuxc.sh string buffer"   # 远程执行本地脚本。
```
xdhuxc.sh 脚本的内容为：
```
[root@xdhuxc ~]# pwd
/root
[root@xdhuxc ~]# ls
xdhuxc.sh
[root@xdhuxc ~]# cat xdhuxc.sh
#!/usr/bin/env bash
echo "Hello Shell."
echo $1
echo $2 >> /root/abc.sh
```
执行结果为：
```
[root@xdhuxc ~]# ansible Client -m script -a "/root/xdhuxc.sh string buffer"
192.168.91.130 | SUCCESS => {
    "changed": true,
    "rc": 0,
    "stderr": "Shared connection to 192.168.91.130 closed.\r\n",
    "stdout": "Hello Shell.\r\nstring\r\n",
    "stdout_lines": [
        "Hello Shell.",
        "string"
    ]
}
```
在 192.168.91.130上，在 root 目录下，会产生 abc.sh 文件。
```
[root@xdhuxc ~]# pwd
/root
[root@xdhuxc ~]# ls
abc.sh  anaconda-ks.cfg  ~None
[root@xdhuxc ~]# cat abc.sh
buffer
[root@xdhuxc ~]#
```
~None 目录下
```
[root@xdhuxc ~None]# pwd
/root/~None
[root@xdhuxc ~None]# tree -a
.
└── .ansible
    └── tmp

2 directories, 0 files
```
shell 的功能是执行远程主机上的 shell 脚本文件，支持管道符。
例如：
```
ansible Client -m shell -a "/root/xdhuxc.sh" # 执行远程机器上的脚本。
```
在 root 目录下创建 xdhuxc.sh 文件，
```
[root@xdhuxc ~]# pwd
/root
[root@xdhuxc ~]# ll
total 12
-rw-r--r--  1 root root    7 Jun 11 22:19 abc.sh
-rw-------. 1 root root 1424 Apr  9 21:56 anaconda-ks.cfg
drwx------  3 root root   22 Jun 10 11:55 ~None
-rw-r--r--  1 root root   43 Jun 11 22:34 xdhuxc.sh   # xdhuxc.sh 没有执行权限。
[root@xdhuxc ~]# cat xdhuxc.sh
#!/usr/bin/env bash
echo -n "Hello World!"
```
在 xdhuxc.sh 没有被赋予执行权限时，执行 ansible 命令。
```
[root@xdhuxc ~]# ansible Client -m shell -a "/root/xdhuxc.sh"
192.168.91.130 | FAILED | rc=126 >>
/bin/sh: /root/xdhuxc.sh: Permission deniednon-zero return code

```
很明显，xdhuxc.sh 没有可执行权限导致的，修改该命令，重新执行，命令执行成功。
```
[root@xdhuxc ~]# ansible Client -m shell -a "chmod +x /root/xdhuxc.sh ; /root/xdhuxc.sh"
 [WARNING]: Consider using the file module with mode rather than running chmod.  If you need to use command because
file is insufficient you can add warn=False to this command task or set command_warnings=False in ansible.cfg to
get rid of this message.

192.168.91.130 | SUCCESS | rc=0 >>
Hello World!

```

##### copy 模块
copy 模块用于实现主控端向目标机器复制文件，类似于 scp 功能。
例如：
```
ansible Client -m copy -a "src=/root/xdhuxc.sh dest=/tmp/ owner=root group=root mode=0755" # 向 Client 组中主机复制 xdhuxc.sh 到 /tmp 目录下，文件属主、属组都为 root，权限为：0755
```
执行结果如下：
```
[root@xdhuxc ~]# pwd
/root
[root@xdhuxc ~]# ls
xdhuxc.sh
[root@xdhuxc ~]# ansible Client -m copy -a "src=/root/xdhuxc.sh dest=/tmp/ owner=root group=root mode=0755"
192.168.91.130 | SUCCESS => {
    "changed": true,
    "checksum": "406eb4b32e5fe321308cfd40365f765685d64d58",
    "dest": "/tmp/xdhuxc.sh",
    "gid": 0,
    "group": "root",
    "md5sum": "1abf4cb799e8858ab96bb7035837f248",
    "mode": "0755",
    "owner": "root",
    "size": 72,
    "src": "~None/.ansible/tmp/ansible-tmp-1528728245.0-152168028566440/source",
    "state": "file",
    "uid": 0
}
```
在 192.168.91.130 机器上
```
[root@xdhuxc ~None]# pwd
/root/~None
[root@xdhuxc ~None]# tree -a
.
└── .ansible
    └── tmp
        └── ansible-tmp-1528728229.03-131422320501562

3 directories, 0 files
[root@xdhuxc ~None]# ls /tmp
xdhuxc.sh
```

##### stat 模块
stat 模块用于获取远程文件状态信息，atime/ctime/mtime/md5/uid/gid等信息。
例如：
```
ansible Client -m stat -a "path=/etc/sysctl.conf"
```
执行结果如下：
```
[root@xdhuxc ~]# ansible Client -m stat -a "path=/etc/resolv.conf"
192.168.91.130 | SUCCESS => {
    "changed": false,
    "stat": {
        "atime": 1528725838.9349997,
        "attr_flags": "",
        "attributes": [],
        "block_size": 4096,
        "blocks": 8,
        "charset": "us-ascii",
        "checksum": "dfebfbbbb5ea787130ffb53eaab925c743f50a56",
        "ctime": 1528725836.281,
        "dev": 64768,
        "device_type": 0,
        "executable": false,
        "exists": true,
        "gid": 0,
        "gr_name": "root",
        "inode": 17073255,
        "isblk": false,
        "ischr": false,
        "isdir": false,
        "isfifo": false,
        "isgid": false,
        "islnk": false,
        "isreg": true,
        "issock": false,
        "isuid": false,
        "mimetype": "text/plain",
        "mode": "0644",
        "mtime": 1528725836.281,
        "nlink": 1,
        "path": "/etc/resolv.conf",
        "pw_name": "root",
        "readable": true,
        "rgrp": true,
        "roth": true,
        "rusr": true,
        "size": 73,
        "uid": 0,
        "version": "1617439728",
        "wgrp": false,
        "woth": false,
        "writeable": true,
        "wusr": true,
        "xgrp": false,
        "xoth": false,
        "xusr": false
    }
}
```
显示了 /etc/sysctl.conf 文件的所有状态信息。

##### get_url 模块
get_url 模块可以实现从远程主机下载指定 URL 到本地，支持 sha256sum 文件教验。
例如：
```
ansible Client -m get_url -a "url=http://www.baidu.com dest=/tmp/index.html mode=0440 force=yes"
```
执行命令的结果为：
```
[root@xdhuxc ~]# ansible Client -m get_url -a "url=http://www.baidu.com dest=/tmp/index.html mode=0440 force=yes"
192.168.91.130 | SUCCESS => {
    "changed": true,
    "checksum_dest": "69676fdd06a44063439b46a7df1e326eeae98ed4",
    "checksum_src": "063ec2b31e5fa4d889076b948994ed4934d8ad62",
    "dest": "/tmp/index.html",
    "gid": 0,
    "group": "root",
    "md5sum": "b4715e7fb51d60a983e29f3dc6d7a51a",
    "mode": "0440",
    "msg": "OK (unknown bytes)",
    "owner": "root",
    "size": 117044,
    "src": "/tmp/tmpXgrOKe",
    "state": "file",
    "status_code": 200,
    "uid": 0,
    "url": "http://www.baidu.com"
}
[root@xdhuxc ~]# ansible Client -m command -a "ls /tmp"
192.168.91.130 | SUCCESS | rc=0 >>
ansible_EsBCHn
index.html                              # 下载下来的文件
```
##### yum 模块
yum 模块用于实现软件包管理。
例如：
```
ansible Client -m yum -a "name=curl state=latest"
```
命令执行的结果为：
```
[root@xdhuxc ~]# ansible Client -m yum -a "name=curl state=latest"
192.168.91.130 | SUCCESS => {
    "changed": true,
    "msg": "Repository base is listed more than once in the configuration\nRepository updates is listed more than once in the configuration\nRepository extras is listed more than once in the configuration\nRepository centosplus is listed more than once in the configuration\nRepository base is listed more than once in the configuration\nRepository updates is listed more than once in the configuration\nRepository extras is listed more than once in the configuration\nRepository centosplus is listed more than once in the configuration\nRepository base is listed more than once in the configuration\nRepository updates is listed more than once in the configuration\nRepository extras is listed more than once in the configuration\nRepository centosplus is listed more than once in the configuration\nRepository base is listed more than once in the configuration\nRepository updates is listed more than once in the configuration\nRepository extras is listed more than once in the configuration\nRepository centosplus is listed more than once in the configuration\nRepository epel is listed more than once in the configuration\nRepository epel-debuginfo is listed more than once in the configuration\nRepository epel-source is listed more than once in the configuration\nhttps://mirrors.aliyun.com/centos/7.4.1708/virt/x86_64/kubernetes19/repodata/repomd.xml: [Errno 14] HTTPS Error 404 - Not Found\nTrying other mirror.\nTo address this issue please refer to the below knowledge base article \n\nhttps://access.redhat.com/articles/1320623\n\nIf above article doesn't help to resolve this issue please create a bug on https://bugs.centos.org/\n\n",
    "rc": 0,
    "results": [
        "Loaded plugins: fastestmirror\nLoading mirror speeds from cached hostfile\n * epel: mirrors.aliyun.com\nResolving Dependencies\n--> Running transaction check\n---> Package curl.x86_64 0:7.29.0-42.el7 will be updated\n---> Package curl.x86_64 0:7.29.0-46.el7 will be an update\n--> Processing Dependency: libcurl = 7.29.0-46.el7 for package: curl-7.29.0-46.el7.x86_64\n--> Running transaction check\n---> Package libcurl.x86_64 0:7.29.0-42.el7 will be updated\n---> Package libcurl.x86_64 0:7.29.0-46.el7 will be an update\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package          Arch            Version                   Repository     Size\n================================================================================\nUpdating:\n curl             x86_64          7.29.0-46.el7             base          268 k\nUpdating for dependencies:\n libcurl          x86_64          7.29.0-46.el7             base          220 k\n\nTransaction Summary\n================================================================================\nUpgrade  1 Package (+1 Dependent package)\n\nTotal download size: 488 k\nDownloading packages:\nDelta RPMs disabled because /usr/bin/applydeltarpm not installed.\n--------------------------------------------------------------------------------\nTotal                                              960 kB/s | 488 kB  00:00     \nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Updating   : libcurl-7.29.0-46.el7.x86_64                                 1/4 \n  Updating   : curl-7.29.0-46.el7.x86_64                                    2/4 \n  Cleanup    : curl-7.29.0-42.el7.x86_64                                    3/4 \n  Cleanup    : libcurl-7.29.0-42.el7.x86_64                                 4/4 \n  Verifying  : curl-7.29.0-46.el7.x86_64                                    1/4 \n  Verifying  : libcurl-7.29.0-46.el7.x86_64                                 2/4 \n  Verifying  : libcurl-7.29.0-42.el7.x86_64                                 3/4 \n  Verifying  : curl-7.29.0-42.el7.x86_64                                    4/4 \n\nUpdated:\n  curl.x86_64 0:7.29.0-46.el7                                                   \n\nDependency Updated:\n  libcurl.x86_64 0:7.29.0-46.el7                                                \n\nComplete!\n"
    ]
}
[root@xdhuxc ~]# ansible Client -m yum -a "name=curl state=latest"
192.168.91.130 | SUCCESS => {
    "changed": false,
    "msg": "",
    "rc": 0,
    "results": [
        "All packages providing curl are up to date",
        ""
    ]
}
```
从 msg 和 results 输出的信息可以看到，这就是一个 yum 安装软件包的过程。

##### cron 模块
cron 模块用于配置远程主机 crontab
例如：
```
ansible Client -m cron -a "name='check' minute='1' job='ntpdate asia.pool.ntp.org'"
```
运行效果：
```
[root@xdhuxc ~]# ansible Client -m cron -a "name='check' minute='1' job='ntpdate asia.pool.ntp.org'"
192.168.91.130 | SUCCESS => {
    "changed": true,
    "envs": [],
    "jobs": [
        "check"
    ]
}
[root@xdhuxc ~]# ansible Client -m command -a "crontab -l"
192.168.91.130 | SUCCESS | rc=0 >>
#Ansible: check
1 * * * * ntpdate asia.pool.ntp.org

[root@xdhuxc ~]#
```

##### service 模块
service 模块可以用来管理远程主机的系统服务。
例如：
```
ansible Client -m service -a "name=haproxy state=stopped"
ansible Client -m service -a "name=haproxy state=restarted"
ansible Client -m service -a "name=haproxy state=reloaded"
```
命令执行的结果为：
```
[root@xdhuxc ~]# systemctl status haproxy
● haproxy.service - HAProxy Load Balancer
   Loaded: loaded (/usr/lib/systemd/system/haproxy.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2018-06-11 23:17:21 CST; 2s ago
 Main PID: 2135 (haproxy-systemd)
   Memory: 1.9M
   CGroup: /system.slice/haproxy.service
           ├─2135 /usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
           ├─2136 /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
           └─2137 /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds

Jun 11 23:17:21 xdhuxc systemd[1]: Started HAProxy Load Balancer.
Jun 11 23:17:21 xdhuxc systemd[1]: Starting HAProxy Load Balancer...
Jun 11 23:17:21 xdhuxc haproxy-systemd-wrapper[2135]: haproxy-systemd-wrapper: executing /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
[root@xdhuxc ~]# ansible Client -m service -a "name=haproxy state=stopped"
192.168.91.128 | SUCCESS => {
    "changed": true,
    "name": "haproxy",
    "state": "stopped",
    "status": {
        "ActiveEnterTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "ActiveEnterTimestampMonotonic": "4444399885",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "active",
        "After": "basic.target system.slice network.target systemd-journald.socket syslog.target",
        "AllowIsolate": "no",
        "AmbientCapabilities": "0",
        "AssertResult": "yes",
        "AssertTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "AssertTimestampMonotonic": "4444398724",
        "Before": "shutdown.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "18446744073709551615",
        "CPUAccounting": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "18446744073709551615",
        "CanIsolate": "no",
        "CanReload": "yes",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "18446744073709551615",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "ConditionTimestampMonotonic": "4444398724",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/haproxy.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "Delegate": "no",
        "Description": "HAProxy Load Balancer",
        "DevicePolicy": "auto",
        "EnvironmentFile": "/etc/sysconfig/haproxy (ignore_errors=no)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "2135",
        "ExecMainStartTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "ExecMainStartTimestampMonotonic": "4444399843",
        "ExecMainStatus": "0",
        "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -USR2 $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStart": "{ path=/usr/sbin/haproxy-systemd-wrapper ; argv[]=/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid $OPTIONS ; ignore_errors=no ; start_time=[Mon 2018-06-11 23:17:21 CST] ; stop_time=[n/a] ; pid=2135 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FragmentPath": "/usr/lib/systemd/system/haproxy.service",
        "GuessMainPID": "yes",
        "IOScheduling": "0",
        "Id": "haproxy.service",
        "IgnoreOnIsolate": "no",
        "IgnoreOnSnapshot": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestampMonotonic": "0",
        "InactiveExitTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "InactiveExitTimestampMonotonic": "4444399885",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "0",
        "KillMode": "mixed",
        "KillSignal": "15",
        "LimitAS": "18446744073709551615",
        "LimitCORE": "18446744073709551615",
        "LimitCPU": "18446744073709551615",
        "LimitDATA": "18446744073709551615",
        "LimitFSIZE": "18446744073709551615",
        "LimitLOCKS": "18446744073709551615",
        "LimitMEMLOCK": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitNICE": "0",
        "LimitNOFILE": "4096",
        "LimitNPROC": "3818",
        "LimitRSS": "18446744073709551615",
        "LimitRTPRIO": "0",
        "LimitRTTIME": "18446744073709551615",
        "LimitSIGPENDING": "3818",
        "LimitSTACK": "18446744073709551615",
        "LoadState": "loaded",
        "MainPID": "2135",
        "MemoryAccounting": "no",
        "MemoryCurrent": "2060288",
        "MemoryLimit": "18446744073709551615",
        "MountFlags": "0",
        "Names": "haproxy.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "PermissionsStartOnly": "no",
        "PrivateDevices": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "ProtectHome": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "RemainAfterExit": "no",
        "Requires": "basic.target",
        "Restart": "no",
        "RestartUSec": "100ms",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitInterval": "10000000",
        "StartupBlockIOWeight": "18446744073709551615",
        "StartupCPUShares": "18446744073709551615",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "no",
        "TasksCurrent": "18446744073709551615",
        "TasksMax": "18446744073709551615",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UMask": "0022",
        "UnitFilePreset": "disabled",
        "UnitFileState": "disabled",
        "Wants": "system.slice",
        "WatchdogTimestamp": "Mon 2018-06-11 23:17:21 CST",
        "WatchdogTimestampMonotonic": "4444399872",
        "WatchdogUSec": "0"
    }
}
[root@xdhuxc ~]# systemctl status haproxy
● haproxy.service - HAProxy Load Balancer
   Loaded: loaded (/usr/lib/systemd/system/haproxy.service; disabled; vendor preset: disabled)
   Active: inactive (dead)

Jun 11 23:17:21 xdhuxc systemd[1]: Started HAProxy Load Balancer.
Jun 11 23:17:21 xdhuxc systemd[1]: Starting HAProxy Load Balancer...
Jun 11 23:17:21 xdhuxc haproxy-systemd-wrapper[2135]: haproxy-systemd-wrapper: executing /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
Jun 11 23:17:51 xdhuxc systemd[1]: Stopping HAProxy Load Balancer...
Jun 11 23:17:51 xdhuxc haproxy-systemd-wrapper[2135]: haproxy-systemd-wrapper: SIGTERM -> 2137.
Jun 11 23:17:51 xdhuxc systemd[1]: Stopped HAProxy Load Balancer.
Jun 11 23:17:51 xdhuxc haproxy-systemd-wrapper[2135]: haproxy-systemd-wrapper: exit, haproxy RC=0
[root@xdhuxc ~]# ansible Client -m service -a "name=haproxy state=restarted"
192.168.91.128 | SUCCESS => {
    "changed": true,
    "name": "haproxy",
    "state": "started",
    "status": {
        "ActiveEnterTimestampMonotonic": "0",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "inactive",
        "After": "network.target syslog.target systemd-journald.socket basic.target system.slice",
        "AllowIsolate": "no",
        "AmbientCapabilities": "0",
        "AssertResult": "no",
        "AssertTimestampMonotonic": "0",
        "Before": "shutdown.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "18446744073709551615",
        "CPUAccounting": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "18446744073709551615",
        "CanIsolate": "no",
        "CanReload": "yes",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "18446744073709551615",
        "ConditionResult": "no",
        "ConditionTimestampMonotonic": "0",
        "Conflicts": "shutdown.target",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "Delegate": "no",
        "Description": "HAProxy Load Balancer",
        "DevicePolicy": "auto",
        "EnvironmentFile": "/etc/sysconfig/haproxy (ignore_errors=no)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "0",
        "ExecMainStartTimestampMonotonic": "0",
        "ExecMainStatus": "0",
        "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -USR2 $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "ExecStart": "{ path=/usr/sbin/haproxy-systemd-wrapper ; argv[]=/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid $OPTIONS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FragmentPath": "/usr/lib/systemd/system/haproxy.service",
        "GuessMainPID": "yes",
        "IOScheduling": "0",
        "Id": "haproxy.service",
        "IgnoreOnIsolate": "no",
        "IgnoreOnSnapshot": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestampMonotonic": "0",
        "InactiveExitTimestampMonotonic": "0",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "0",
        "KillMode": "mixed",
        "KillSignal": "15",
        "LimitAS": "18446744073709551615",
        "LimitCORE": "18446744073709551615",
        "LimitCPU": "18446744073709551615",
        "LimitDATA": "18446744073709551615",
        "LimitFSIZE": "18446744073709551615",
        "LimitLOCKS": "18446744073709551615",
        "LimitMEMLOCK": "65536",
        "LimitMSGQUEUE": "819200",
        "LimitNICE": "0",
        "LimitNOFILE": "4096",
        "LimitNPROC": "3818",
        "LimitRSS": "18446744073709551615",
        "LimitRTPRIO": "0",
        "LimitRTTIME": "18446744073709551615",
        "LimitSIGPENDING": "3818",
        "LimitSTACK": "18446744073709551615",
        "LoadState": "loaded",
        "MainPID": "0",
        "MemoryAccounting": "no",
        "MemoryCurrent": "18446744073709551615",
        "MemoryLimit": "18446744073709551615",
        "MountFlags": "0",
        "Names": "haproxy.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "PermissionsStartOnly": "no",
        "PrivateDevices": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "ProtectHome": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "RemainAfterExit": "no",
        "Requires": "basic.target",
        "Restart": "no",
        "RestartUSec": "100ms",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitInterval": "10000000",
        "StartupBlockIOWeight": "18446744073709551615",
        "StartupCPUShares": "18446744073709551615",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "dead",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "no",
        "TasksCurrent": "18446744073709551615",
        "TasksMax": "18446744073709551615",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UMask": "0022",
        "UnitFilePreset": "disabled",
        "UnitFileState": "disabled",
        "Wants": "system.slice",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "0"
    }
}
[root@xdhuxc ~]# systemctl status haproxy
● haproxy.service - HAProxy Load Balancer
   Loaded: loaded (/usr/lib/systemd/system/haproxy.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2018-06-11 23:19:46 CST; 25s ago
 Main PID: 2351 (haproxy-systemd)
   Memory: 1.9M
   CGroup: /system.slice/haproxy.service
           ├─2351 /usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
           ├─2354 /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
           └─2355 /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds

Jun 11 23:19:46 xdhuxc systemd[1]: Started HAProxy Load Balancer.
Jun 11 23:19:46 xdhuxc systemd[1]: Starting HAProxy Load Balancer...
Jun 11 23:19:46 xdhuxc haproxy-systemd-wrapper[2351]: haproxy-systemd-wrapper: executing /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
```

##### user 模块
user 模块用来进行远程主机用户的管理。
例如：
```
ansible Client -m user -a "name=wang comment='user wang'"     # 创建用户 wang
ansible Client -m user -a "name=wang state=absent remove=yes" # 删除用户 wang
```
执行命令结果如下：
```
[root@xdhuxc ~]# cat /etc/passwd | grep wang
[root@xdhuxc ~]# ansible Client -m user -a "name=wang comment='user wang'"     # 创建用户 wang
192.168.91.128 | SUCCESS => {
    "changed": true,
    "comment": "user wang",
    "create_home": true,
    "group": 1001,
    "home": "/home/wang",
    "name": "wang",
    "shell": "/bin/bash",
    "state": "present",
    "system": false,
    "uid": 1001
}
[root@xdhuxc ~]# cat /etc/passwd | grep wang
wang:x:1001:1001:user wang:/home/wang:/bin/bash
[root@xdhuxc ~]# ansible Client -m user -a "name=wang state=absent remove=yes"  # 删除用户 wang
192.168.91.128 | SUCCESS => {
    "changed": true,
    "force": false,
    "name": "wang",
    "remove": true,
    "state": "absent"
}
[root@xdhuxc ~]# cat /etc/passwd | grep wang
[root@xdhuxc ~]#
```
