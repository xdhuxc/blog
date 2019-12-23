+++
title = "Linux 常用知识总结"
date = "2018-08-03"
lastmod = "2018-08-19"
tags = [
    "Linux"
]
categories = [
    "技术"
]
+++

本篇博客记录了些 Linux 系统的常用知识。

<!--more-->

### 文件和目录权限

root 默认对所有文件具有读写权限，但默认没有执行权限。

#### 目录权限知识
对于目录来说，
r 查看目录中的内容
w 可以在目录中创建、删除、修改、重命名文件。
x 表示是否可以进入到目录中，是否能查看或修改目录中文件的属性信息。

目录的 r 权限，需要 x 权限配合。
目录的 w 权限，需要 x 权限配合。
单独的 x 权限没有用。

### ulimit

设置当前shell以及由它启动的进程的资源限制。

linux 对于每个用户，系统限制其最大进程数。为提高性能，可以根据设备资源情况，设置各linux 用户的最大进程数。

可以用 `ulimit -a` 来显示当前的各种用户进程限制。

可以通过 `ulimit -n 4096` 将每个进程可以打开的文件数目加大到4096，缺省为1024。
其他建议设置成无限制（unlimited）的一些重要设置是：
```markdown
数据段长度：ulimit -d unlimited
最大内存大小：ulimit -m unlimited
堆栈大小：ulimit -s unlimited
CPU 时间：ulimit -t unlimited
虚拟内存：ulimit -v unlimited
```
 暂时地，适用于通过 ulimit 命令登录 shell 会话期间。
永久地，通过将一个相应的 ulimit 语句添加到由登录 shell 读取的文件中， 即特定于 shell 的用户资源文件。

#### ulimit 的硬限制和软限制
硬限制使用 -H 参数，软限制使用 -S 参数。

ulimit -a 看到的是软限制，可以通过 ulimit -a -H 查看其硬限制。

如果 ulimit 不限定使用 -H 或 -S，此时它会同时把两类限制都改掉的。

软限制可以限制用户/组对资源的使用，硬限制的作用是控制软限制。

超级用户和普通用户都可以扩大硬限制，但是超级用户可以缩小硬限制，普通用户则不能缩小硬限制。

硬限制设定后，设定软限制时只能是小于或者等于硬限制。

#### 解除资源限制
1、解除 Linux 系统的最大进程数和最大文件打开数限制：
在 `/etc/security/limits.conf` 中添加如下行：
```
* soft noproc 11000
* hard noproc 11000
* soft nofile 4100
* hard nofile 4100
```
说明：* 代表针对所有用户，`noproc` 是代表最大进程数，`nofile` 是代表最大文件打开数。

2、修改所有Linux用户的环境变量文件：
在`/etc/profile`中添加如下内容
```
ulimit -u 10000
ulimit -n 4096
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited
```
保存后运行`source /etc/profile` 使其生效。

#### 参考资料
https://blog.csdn.net/csq_year/article/details/49304895 
https://blog.csdn.net/fengspg/article/details/39646337

### 僵尸进程和孤儿进程
在unix/linux中，正常情况下，子进程是通过父进程创建的，子进程在创建新的进程。子进程的结束和父进程的运行是一个异步过程,即父进程永远无法预测子进程 到底什么时候结束。 当一个 进程完成它的工作终止之后，它的父进程需要调用wait()或者waitpid()系统调用取得子进程的终止状态。
	孤儿进程：一个父进程退出，而它的一个或多个子进程还在运行，那么那些子进程将成为孤儿进程。孤儿进程将被init进程(进程号为1)所收养，并由init进程对它们完成状态收集工作。
	僵尸进程：一个进程使用fork创建子进程，如果子进程退出，而父进程并没有调用 wait 函数或 waitpid 函数获取子进程的状态信息，那么子进程的进程描述符仍然保存在系统中。这种进程称之为僵死进程。

unix提供了一种机制可以保证只要父进程想知道子进程结束时的状态信息， 就可以得到。这种机制就是: 在每个进程退出的时候,内核释放该进程所有的资源,包括打开的文件,占用的内存等。 但是仍然为其保留一定的信息(包括进程号，退出状态，运行时间等)。直到父进程通过wait / waitpid来取时才释放。 但这样就导致了问题，如果父进程不调用wait / waitpid的话， 那么保留的那段信息就不会释放，其进程号就会一直被占用，但是系统所能使用的进程号是有限的，如果大量的产生僵死进程，将因为没有可用的进程号而导致系统不能产生新的进程. 此即为僵尸进程的危害，应当避免。

孤儿进程是没有父进程的进程，孤儿进程这个重任就落到了init进程身上，init进程就好像是一个民政局，专门负责处理孤儿进程的善后工作。每当出现一个孤儿进程的时候，内核就把孤 儿进程的父进程设置为init，而init进程会循环地wait()它的已经退出的子进程。这样，当一个孤儿进程凄凉地结束了其生命周期的时候，init进程就会出面处理它的一切善后工作。因此孤儿进程并不会有什么危害。

任何一个子进程(init除外)在exit()之后，并非马上就消失掉，而是留下一个称为僵尸进程(Zombie)的数据结构，等待父进程处理。这是每个 子进程在结束时都要经过的阶段。如果子进程在exit()之后，父进程没有来得及处理，这时用ps命令就能看到子进程的状态是“Z”。如果父进程能及时 处理，可能用ps命令就来不及看到子进程的僵尸状态，但这并不等于子进程不经过僵尸状态。  如果父进程在子进程结束之前退出，则子进程将由init接管。init将会以父进程的身份对僵尸状态的子进程进行处理。

解决方法：
1)	通过信号机制，子进程退出时向父进程发送 `SIGCHILD` 信号，父进程处理 `SIGCHILD` 信号。在信号处理函数中调用wait进行处理僵尸进程。

2)	Fork两次，原理是将子进程成为孤儿进程，从而其的父进程变为init进程，通过init进程可以处理僵尸进程。

### 守护进程

守护进程（Daemon Process），是Linux中的后台服务进程，是一个生存期较长的进程，通常独立于控制终端并且周期性地执行某种任务或等待处理某些发生的事件。

守护进程是个特殊的孤儿进程，这种进程脱离终端，为什么要脱离终端呢？之所以脱离于终端是为了避免进程被任何终端所产生的信息所打断，其在执行过程中的信息也不在任何终端上显示。由于在 linux 中，每一个系统与用户进行交流的界面称为终端，每一个从此终端开始运行的进程都会依附于这个终端，这个终端就称为这些进程的控制终端，当控制终端被关闭时，相应的进程都会自动关闭。

Linux 的大多数服务器就是用守护进程实现的。比如，Internet 服务器 inetd，Web 服务器 httpd 等。

### 系统平均负载
系统平均负载被定义为在特定时间间隔内运行队列中的平均进程数。如果一个进程满足以下条件，则其就会位于运行队列中：
* 没有在等待I/O操作的结果。
* 没有主动进入等待状态（也就是没有调用wait）。
* 没有被停止。

```markdown
[root@xdhuxc ~]# uptime
 04:10:38 up 19 days,  4:56,  3 users,  load average: 0.90, 0.52, 0.42
```
命令输出的最后内容表示在过去的1、5、15分钟内运行队列中的平均进程数量。

一般来说只要每个CPU的当前活动进程数不大于3那么系统的性能就是良好的，如果每个CPU的任务数大于5，那么就表示这台机器的性能有严重问题。对于 上面的例子来说，假设系统有两个CPU，那么其每个CPU的当前任务数为：0.90/2=0.45。这表示该系统的性能是良好的。

### vm.swappiness 
Linux 会使用硬盘的一部分作为 Swap 分区，用来进行进程的调度。如果内存够大，应当告诉 Linux 不必太多地使用 Swap 分区，可以通过修改 swappiness 的数值实现。

swappiness=0 的时候表示最大限度地使用物理内存，然后才是 swap 空间；

swappiness=100 的时候表示积极地使用 swap 分区，并且把内存上的数据及时地搬运到 swap 空间里面。

在 Linux 中，swappiness 的默认值为：60 