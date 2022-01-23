+++
title = "Linux 中 systemd 的使用"
date = "2018-10-23"
lastmod = "2018-12-09"
tags = [
    "Linux",
    "systemd"
]
categories = [
    "Linux"
]
+++

本篇博客介绍下 Linux 下 服务管理工具 systemd 的使用。

<!--more-->

### systemd service

一种以 `.service` 结尾的单元（unit）配置文件，用于控制由systemd控制或监视的进程。简单来说，用于在后台以守护进程的方式运行程序。

其基本特征有：

* 支持并行化任务
* 同时采用 `socket` 式与 `D-Bus` 总线式激活服务
* 按需启动守护进程（daemon）
* 利用 `linux` 的 `cgroups` 监视进程
* 支持快照和系统恢复
* 维护挂载点和自动挂载点
* 各服务间基于依赖关系进行精密控制

### systemd

#### 基本结构

systemd 服务的主要内容分为三个部分：

- 控制单元的定义
- 服务的定义
- 安装部分

#### 说明

1、`systemd` 单元文件中的以 `#` 开头的行后面的内容会被认为是注释。

2、`systemd` 下的布尔值：`1`、`yes`、`on`、`rue` 都是开启；`0`、`no`、`off`、`false` 都是关闭，仅限于 `systemd` 文件，不适用于该文件中嵌入的 `shell` 语句。

3、`systemd` 下的时间单位默认是秒，因此，使用毫秒，分钟时要显式说明。

#### 示例说明

以如下service文件为示例进行语法说明
```markdown
[Unit]
Description=Network Manager
After=syslog.target
Wants=remote-fs.target network.target

[Service]
Type=dbus
BusName=org.freedesktop.NetworkManager
ExecStart=/usr/sbin/NetworkManager --no-daemon
EnvironmentFile=/etc/sysconfig/network/config
ExecStartPre=/usr/bin/test "x${NETWORKMANAGER}" = xyes
# Suppress stderr to eliminate duplicated messages in syslog. NM calls openlog()
# with LOG_PERROR when run in foreground. But systemd redirects stderr to
# syslog by default, which results in logging each message twice.
StandardError=null

[Install]
WantedBy=multi-user.target
Also=NetworkManager-wait-online.service
```

#### 定义控制单元

在 `systemd` 中，所有引导过程中 `systemd` 要控制的东西都是一个单元。`systemd` 的单元类型有：

* 系统服务（.service）
* 套接字（.sockets）
* 设备（.device）
* 挂载点（.mount）
* 自动挂载点（）
* 交换分区（.swap）
* 分区（）
* 启动对象（.target）
* 文件系统路径（.path）
* 定时器（）

单元名即 `.service` 文件的名称。但不只有 `.service` 后缀的文件才可以是一个 单元，单元还可以有 `.target`, `.path`等后缀，具体可以在 `/usr/lib/systemd/system` 下了解。但这些后缀要么由 systemd 上游开发者写好随 systemd 软件包分发，要么由 Base:system 团队添加，一般用户是不太需要写其它后缀的控制单元的。

单元文件可以从两个地方进行加载，优先级从低到高分别是：

- /usr/lib/systemd/system/ ：软件包安装的单元
- /etc/systemd/system/ ：系统管理员安装的单元

1）声明我们在定义控制单元，如下所示：
```markdown
[Unit]
```

2）添加单元描述，如下所示：
```markdown
[Unit]
Description=Daemon to start He.net IPv6
```

3）systemd对各个单元之间关系的控制：
```markdown
[Unit]
Description=Daemon to start He.net IPv6
Wants=network-online.target
```

* Requires，当前单元启动了，那么它所需要的单元也会被启动；当前单元需要的单元被停止了，那么它自己也活不了。但是请注意，这个设定并不能控制某单元与其所需要的单元的启动顺序（启动顺序是另外控制的），即 systemd 不是先启动本单元所需要的单元，再启动本单元，而是在本单元被激活时，并行启动两者，因此会产生争分夺秒的问题。如果当前单元所需要的单元先启动成功，那么皆大欢喜; 如果当前单元所需要的单元启动得慢，那么本单元就会启动失败（systemd 没有自动重试）。因此，为了系统的健壮性，不建议使用这个标记，而建议使用 Wants 标记。可以使用多个 Requires。

* RequiresOverridable：跟 Requires 很像。但是如果这条服务是由用户手动启 动的，那么 RequiresOverridable 后面的服务即使启动不成功也不报错。跟 Requires 比增加了一定的容错性，但是你要确定你的服务是有等待功能的。另外，如果不由用户手动启动而是随系统开机启动，那么依然会有 Requires 面临的问题.

* Requisite：强势版本的Requires，要是这里需要的服务启动不成功，那本单元文件不管能不能检测，等不能等待都会立刻就失败。

* Wants：推荐使用。本单元启动了，它所需要的单元也会被启动，如果启动不成功，对本单元没有影响。

* Conflicts：一个单元的启动会停止与它冲突的单元，反之亦然。注意这里和后面的启动顺序是“正交”的：
两个相互冲突的单元被同时启动，要么两个都启动不了（两者都是第三个单元的 Requires），要么启动一个（有一个是第三个单元的Requires，另一个不是），不是 Requires 的那个会被停止。要是两者都不是任何一个单元的Requires，那么 Conflicts 别的那个单元优先启动，被Conflicts的后启动，要是互相写了，那么两个都启动不了。

* OnFailure：很明显，如果本单元启动失败了，那么启动什么单元作为折衷。
我们的单元，Ipv6 隧道，应该想要什么呢？很显然是一个连通着的网络。有一个 systemd 默认提供的对象叫做 network-online.target（默认的 target 列表可见 [systemd.special](https://www.freedesktop.org/software/systemd/man/systemd.special.html)，因为你大多数时候Wants的都是一个固定的系统状态而不是其它 systemd服务），正好能够提供我们需要的环境。

4）定义服务启动顺序
```markdown
[Unit]
Description=Daemon to start He.net IPv6
Wants=network-online.target
After=network.target
```
systemd 服务启动顺序主要使用以下两个标记定义的：
    
Before/After：要是一个服务在另一个服务之前启动，那么在并行启动时（systemd 总是用进程 0 并行启动所有东西，然后通过这两个标记来二次等待排序），另一个服务这时就会等这个服务先启动并返回状态，注意是先启动，而不是先启动成功，因为失败也是一种状态，一定要成功才启动另一个服务是通过依赖关系定义的。反之 After 亦然。

`关机`（可以是挂起，这时候有些服务依然在运行，比如网络唤醒等）时候的顺序：如果两个服务都是要关掉的，Before 是先停止自己，After 是先停止别人； 但如果一个服务要停止，而另一个服务要启动，那么不管 Before/After 如何写，总是优先关闭而不是开始。也就是比如服务 A Before 服务 B，但是服务 B 是在关，而服务 A 是在 restart，那么服务 B 的顺序在服务 A 的前面。

我们的单元应该在什么服务的前后启动呢？它不需要一定在什么服务前面跑起来，这不像 ifup 和 dhcp，网络起不来获取 ip 肯定没用。我们只需要有网就可以了。`有网` 在 systemd 中也是由一个默认 `target：network.target` 提供的，

#### 定义服务本体

1）声明服务本体，如下所示：
```markdown
[Service]
```

2）声明服务的类型，如下所示：
```markdown
[Service]
Type=
```
systemd 支持的服务类型有以下几类：

* simple， 默认服务类型，最简单的服务类型。就是说启动的程序就是主体程序，该程序要是退出，那么一切皆休。这在图形界面里非常好理解，用户打开一个窗口，退出它就没有了。但是命令行中的大部分程序都不会这样设计，因为命令行程序的一个最基本的原则就是：一个好的程序不能独占命令行窗口。因此，输入命令，回车，接着马上返回提示符，但程序已经执行了。在这种类型下，如果主程序是要响应其它程序的，那么你的通信频道应该在启动本服务前就设好（套接字等），因此这种类型的服务，Systemd 运行它后会立刻就运行下面的服务（需要它的服务），这时没有套接字后面的服务会失败，写 After 也没用，因为 simple 类型不存在主进程退出的情况，也就不存在有返回状态的情况，所以它一旦启动就认为是成功的，除非没起来。

* forking，标准 Unix Daemon 使用的启动方式。启动程序后会调用 fork() 函数，把必要的通信频道都设置好之后父进程退出，留下守护进程的子进程。使用这种方式，最好也指定下 PIDFILE=，不要让 systemd 去猜，非要猜也可以，把 GuessMainPID 设为 yes。

    `判断是 forking 还是 simple 类型非常简单，命令行里运行下程序，持续占用命令行要按 Ctrl + C 才可以的，就不会是 forking 类型。`

    `创建 PIDFILE 是为它写服务的程序的任务，而不是 systemd 的功能，甚至也不是 SysV init 脚本的功能。因此，如果你的程序确实是 forking 类型，但没有实现创建 PIDFILE 的功能，那么建议使用 ExecStartPost= 结合 shell 命令来手动抓取进程编号并写到 /var/run/xxx.pid文件中。`

* oneshot，一次性的，这种服务类型就是启动，完成，没进程了。常见的，比如设置网络，ifup eth0 up，就是一次性的，不存在 ifup 的子进程，也不存在主进程，运行完成后便了无痕迹。由于这类服务运行完就没有进程了，我们经常会需要 `RemainAfterExit=yes`。后面配置的意思是说，即使没进程了, systemd 也认为该服务是存在并成功了。所以如果你有一个这样的服务，服务启动后，你再去 ifup eth0 up，这时你再看服务，依然显示是 running 的。因为只要在执行那条一次性命令的时候没出错，那么它就永远认为它是成功并一直存在的，直到你关闭服务。

* dbus，程序启动时需要获取一块 DBus 空间，所以需要和 BusName= 一起使用。只有它成功获得了 DBus 空间，依赖它的程序才会被启动。

一般情况下，只能用到上面四个，还有两种少见的类型：

* notify， 程序在启动完成后会通过 sd_notify 发送一个通知消息。所以还需要配合 NotifyAccess 来让 systemd 接收消息，后者有三个级别：none，所有消息都忽略掉; main，只接受程序的主进程发过去的消息; all，程序的所有进程发过去的消息都算。NotifyAccess 要是不写的话，默认是 main。

* idle，程序要等它里面调度的全部其它东西都运行完才会运行它自己。比如你 ExecStart 的是个 shell 脚本，里面可能运行了一些别的东西，如果不这样的话，那很可能别的东西的控制台输出里会多一个“启动成功”这样的 systemd 消息。

由于 He.net 的 IPv6 是用 iproute2 的 ip 命令来弄的，所以是一个 oneshot 一次性服务。
```markdown
[Service]
Type=oneshot
RemainAfterExit=yes
```
接下来要设置 ExecStart, ExecStop。如果程序支持的话，还可以去设置 ExecReload，Restart 等。注意，这里设置的是它们 Reload/Restart 的方式，但并不代表没有它们， systemd 就不能完成比如 `systemctl restart xxx.service` 这样的任务，程序有支持自然最好，程序不支持那就先 stop 再 start。同样，有特殊要求的时候也可以去设置比如 ExecStartPre，ExecStartPost，RestartSec，TimeoutSec 等其它东西。

这里要特殊讲一下 ExecStart：

如果你服务的类型不是 `oneshot` ，那么它只可以接受一个命令，参数不限，比如你先 `ip tunnel create` 再 `ip tunnel0 up`，那是两个 ip 命令，如果不是 `oneshot` 类型这样是不行的。
如果有多条命令（oneshot 类型），命令之间以分号 `;` 分隔，跨行可用反斜杠 `\`。除非你的服务类型是 `forking` ，否则在这里输入的命令都会被认为是主进程，不管它是不是。

#### 安装服务

这里说的 `安装` 是一种内部状态，默认放对service文件位置，显示的是 disabled，unloaded，因此要在 systemd 内部对它进行加载，没人需要的东西是不需要安装的，所以要告诉 systemd 它是有人需要的，被谁需要。一般都是被需要的（`multi-user.target` 表示多用户系统，简单理解就是你可以登入了）。这样在 `multi-user.target` 启用时，我们的服务也就会被启用了。
```markdown
[Install]
WantedBy=multi-user.target
```
[Install] 部分下除了 WantedBy 还有两种属性，分别是：

`Alias=` ，别名，这样 `systemctl command xxx.service` 的时候就可以不输入完整的单元名称。比如你给 `NetworkManager` 取一个别名叫 `Alias=nm`，那就可以 `systemctl status nm.service` 查看实际是 `NetworkManager.service` 的服务了。
`Also=` ，安装本服务的时候还要安装别的什么服务。比如我们的 He.net 脚本按理应该需要一个 `iproute2.service` 作为 also，但是 iproute2 实际上不需要 systemd 控制，所以就没写。它和 [Unit] 定义里面的依赖关系相比，它管理的不是运行时依赖，而是安装时。安装好了之后启动谁先谁后，谁依赖谁，和 `Also=` 都没有关系。


### systemd 常用命令

1、检查docker服务环境变量是否加载
```markdown
systemctl show docker --property Environment
```

2、异步启动服务
```markdown
systemctl --no-block start etcd
```
