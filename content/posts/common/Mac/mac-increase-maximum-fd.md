+++
title = "Mac 下增加最大文件描述符数量"
date = "2021-12-08"
lastmod = "2021-12-08"
description = ""
tags = [
    "Mac"
]
categories = [
    "Mac"
]
+++

本篇文章记录了在 Mac 下增加进程最大文件描述符数量的方法。

<!--more-->

### 背景

开发了一个运行在 Mac 系统上的 agent，运行后向 metrics 系统上报指标时，日志中一直报 "too many open files" 错误，除去 agent 中使用的打点 SDK 本身没有使用批量上传的方式外，随着 agent 功能的增多，对文件描述符的占用也必然会增加。

然而，Mac 系统中默认的文件描述符是这样的：
```markdown
wanghuan@wanghuans-MBP ~ % launchctl limit maxfiles
	maxfiles    256            unlimited
wanghuan@wanghuans-MBP ~ % ulimit -n
256
```
默认情况下，一个进程能打开的最大文件描述符数量只有 256 个，这显然不能满足程序日益增长的功能需要。

于是，我们需要将其调大，这样就有两种选择：
1. 将系统的最大文件描述符调大；
2. 将当前进程可使用的最大文件描述符调大；

下面我们分别来介绍这两种方法


### 修改系统最大文件描述符限制

修改系统最大文件描述符限制地操作步骤如下：
1. 在 `/Library/LaunchDaemons` 目录下创建 `limit.maxfiles.plist` 文件，增加如下内容：
```markdown
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"  
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">  
  <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>64000</string>
      <string>524288</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
```
2、修改文件的权限
```markdown
sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
```
3、加载新的配置文件
```markdown
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
```
卸载时使用的命令为：
```markdown
sudo launchctl unload /Library/LaunchDaemons/limit.maxfiles.plist
```
4、检查设置的 limit 是否生效
```markdown
launchctl limit maxfiles
```

这样做会带来一个严重的问题，所有进程的最大文件描述符数量都会同步增大，而操作系统使用 limit 的本来意义就是限制单一进程所能使用的最大文件描述符数量，以防止某些进程不断地创建子进程或者创建网络连接，把系统资源给占尽了，其他进程无法工作。

所以，此方法可以作为临时方法救急和测试，绝不要在生产环境中使用。


### 修改当前进程可使用的最大文件描述符数量

在程序启动的时候，使用 cgo 调用 strlimit 来设置当前进程的最大文件描述符数量，这样就不会影响系统的设置了，代码如下：
```markdown
package main

import (
    "os"
    "syscall"

    log "github.com/sirupsen/logrus"
)

func main() {
    var limit syscall.Rlimit
    err := syscall.Getrlimit(syscall.RLIMIT_NOFILE, &limit)
    if err != nil {
        log.Errorf("get rlimit error: %s", err)
        os.Exit(1)
    }

	log.Infof("the rlimit current: %d, max: %d", limit.Cur, limit.Max)
	old := limit.Cur

	limit.Cur = 1024
	err = syscall.Setrlimit(syscall.RLIMIT_NOFILE, &limit)
	if err != nil {
		log.Errorf("set rlimit error: %s", err)
		os.Exit(1)
	}
	log.Infof("change rlimit from %d to %d successfully", old, limit.Cur)

	err = syscall.Getrlimit(syscall.RLIMIT_NOFILE, &limit)
	if err != nil {
		log.Errorf("get rlimit error: %s", err)
		os.Exit(1)
	}
	log.Infof("after change, the rlimit cur: %d, max: %d", limit.Cur, limit.Max)
}
```
执行这段代码，结果如下：
```markdown
INFO[0000] the rlimit current: 10240, max: 9223372036854775807 
INFO[0000] change rlimit from 10240 to 1024 successfully 
INFO[0000] after change, the rlimit cur: 1024, max: 9223372036854775807
```
可以看到，经过修改后，程序访问到的 limit 值已经被修改了，可以实现既限制当前进程所能打开的最大文件描述符数量，又能保持系统原有的配置。

### 参考资料

https://superuser.com/questions/302754/increase-the-maximum-number-of-open-file-descriptors-in-snow-leopard