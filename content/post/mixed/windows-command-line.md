+++
title = "Windows 常用命令总结"
date = "2017-11-22"
lastmod = "2017-11-26"
description = ""
tags = [
    "Windows"
]
categories = [
    "技术"
]
+++

本篇博客记录了些 `Windows` 系统中常用的命令，在 `Windows` 系统中进行命令行操作时，会用到。

<!--more-->

1、查看系统 `BIOS` 创建时间：`WMIC BIOS get releasedate`
```markdown
$ WMIC BIOS get releasedate
ReleaseDate
20140210000000.000000+000
```

2、调出Windows服务窗口：`services.msc`

3、使用Windows自带的计算器：`calc`

4、Windows自带的远程桌面连接命令：`mstsc`

5、查看本机IP地址和MAC地址：`ipconfig /all`

6、查看当前正在运行的进程：`tasklist`

7、强制杀死进程ID为process_id的进程：`taskkill /pid process_id -f`

8、命令行启动或停止服务：`net start/stop service_name`
例如，启动 `MySQL` 服务，使用命令为：`net start mysql57`


9、查看端口占用：`netstat -ano|findstr "8080"`
```markdown
$ netstat -ano|findstr "8080"
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING       8552
  TCP    10.4.100.48:49235      192.168.8.81:8080      CLOSE_WAIT      1584
  TCP    10.4.100.48:49653      10.10.24.177:8080      ESTABLISHED     7428
  TCP    10.4.100.48:49655      10.10.24.177:8080      ESTABLISHED     7428
  TCP    10.4.100.48:49657      10.10.24.177:8080      ESTABLISHED     7428
  TCP    [::]:8080              [::]:0                 LISTENING       8552
  TCP    [::1]:51102            [::1]:8080             TIME_WAIT       0
```
10、查找某个进程：`tasklist|findstr "bash.exe"`
```markdown
$ tasklist|findstr "bash"
git-bash.exe                  9820 Console                    1      2,912 K
bash.exe                     10064 Console                    1      8,784 K
bash.exe                      7736 Console                    1      6,100 K
bash.exe                      9400 Console                    1      6,068 K
```

11、查看Windows版本和激活的过期时间
```
slmgr.vbs -xpr
```

12、下载文件
```markdown
start powershell
$client = new-object System.Net.WebClient
$client.DownloadFile('http://101.36.79.71:8081/IXC3470347d25cba57732165d795bb3beb6/sw-search-sp/software/1334d9c2b2fb7/ChromeStandalone_66.0.3359.139_Setup.exe', 'C:\Users\wanghuan\Desktop\ChromeStandalone_66.0.3359.139_Setup.exe')
```

13、删除命令

* del /S abc：递归地删除文件夹 abc 及其之下的文件，但是删除每个文件时均需要确认。
* del abc.txt：删除文件 abc.txt。
* del /Q：删除文件时采用安静模式。删除全局通配符时，不要求确认。
* rd abc：删除空文件夹 abc
* rd /s abc：删除文件夹 abc 及其所有子文件夹和文件
* rd /s/q abc：强制删除文件夹及所有子文件夹和文件，不需要确认。
