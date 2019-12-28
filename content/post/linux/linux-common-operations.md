+++
title = "Linux 常用操作总结"
date = "2018-07-13"
lastmod = "2018-08-19"
tags = [
    "Linux"
]
categories = [
    "技术"
]
+++

本篇博客记录了些 Linux 系统中的常用操作，以备后需。

<!--more-->

### 清理过大的 cache 内存
清理过大的cache内存，系统中运行大量容器，cache过大
<center>
<img src="/image/linux/common-operations/cache-1.png" width="800px" height="300px" />
</center>

/proc是一个虚拟文件系统，可以通过对它的读写操作，做为与kernel实体间进行通信的一种手段。也就是说，可以通过修改/proc中的文件，来对当前kernel的行为做出调整。我们可以通过调整/proc/sys/vm/drop_caches来释放内存。

1）查看 `/proc/sys/vm/drop_caches` 的值，默认为 `0`
<center>
<img src="/image/linux/common-operations/cache-2.png" width="800px" height="300px" />
</center>

2）执行sync命令
```markdown
sync
```
sync 命令运行 sync 子命令。如果必须停止系统，则运行 sync 命令以确保文件系统的完整性。sync 命令将所有未写的系统缓冲区写到磁盘中，包含已修改的 i-node、已延迟的块 I/O 和读写映射文件。

3）将/proc/sys/vm/drop_caches的值设置为3
```markdown
echo 3 > /proc/sys/vm/drop_caches
#查看/proc/sys/vm/drop_caches的当前值
cat /proc/sys/vm/drop_caches
```

<center>
<img src="/image/linux/common-operations/cache-3.png" width="800px" height="300px" />
</center>

drop_caches 数值的含义：
* echo 1 > /proc/sys/vm/drop_caches #仅清除页面缓存
* echo 2 > /proc/sys/vm/drop_caches #清除目录项和inode
* echo 3 > /proc/sys/vm/drop_caches #清除页面缓存，目录项和inode

### 挂载磁盘
1、使用 `fdisk –l`（查看当前系统所有硬盘及分区情况）， 找到待挂载的磁盘。
<center>
<img src="/image/linux/common-operations/disk.png" width="800px" height="300px" />
</center>

2、创建分区待挂载的目录，例如 `/xdhuxc`，必须是空目录。
```markdown
mkdir /xdhuxc
```
3、格式化新建的磁盘分区。
```markdown
mkfs.ext4 /dev/vdb
```
4、修改 /etc/fstab，添加如下内容，将分区信息写进去。
```markdown
/dev/vdb  /xdhuxc      ext4    defaults        0 0
```
5、执行如下命令，加载所有在fstab中记录的文件系统。
```markdown
mount –a
```

### 打包时的文件格式转换和赋权
```markdown
find ./ -regex '.*\.sh$' -or -regex '.*\.exp$' | xargs chmod 755 > /dev/null
find ./ -regex '.*\.sh$' -or -regex '.*\.exp$' | xargs dos2unix -q
```

### 使用curl不产生输出
```markdown
curl -s http://www.baidu.com 2>&1 > /dev/null
```

### 调整进程优先级

#### nice 命令
nice 命令可以修改进程的优先级，进而调整进程的调度。nice 命令是在进程启动时调整进程的优先级。nice 值的范围为：[-20, 19]，-20 表示进程的最高优先级，19 表示进程的最低优先级。Linux 进程的默认 nice 值为：0。使用 nice 可调整进程的优先级，这样调度器就会依据进程优先级为其分配 CPU 资源。

1、执行命令 `sleep 300 &`，然后查看该进程
<center>
<img src="/image/linux/common-operations/nice-1.png" width="800px" height="300px" />
</center>


没有 nice 命令，进程优先级数值为 0，进程优先级 NI 默认值为：0

2、执行命令 `nice sleep 300 &`，然后查看该进程
<center>
<img src="/image/linux/common-operations/nice-2.png" width="800px" height="300px" />
</center>

使用 nice 命令后，优先级 NI 的数值为 10，nice 命令将 NI 默认调整为 10，降低了该进程的优先级。

3、执行命令 `nice -n 15 sleep 300 &`，然后查看该进程
<center>
<img src="/image/linux/common-operations/nice-3.png" width="800px" height="300px" />
</center>

在默认值 0 的基础上加 15，非管理员可以将 NI 值调整为 0~19 之间的任意值，降低了进程的优先级。

4、执行命令 `nice -n -15 sleep 300 &`，然后查看该进程
<center>
<img src="/image/linux/common-operations/nice-4.png" width="800px" height="300px" />
</center>

仅管理员可以在默认值的基础上 -n，调高进程的优先级，普通用户无权调高进程优先级。

在实际应用中，如果要运行一个 CPU 密集型程序，就可以通过 nice 命令来启动它，这样可以保证其进程获得更高的优先级，即使服务器或者台式机在负载很重的情况下，也可以快速响应。

#### renice 命令

renice 命令可以重新调整进程执行的优先级，可以指定群组或者用户名调整进程优先级等级，并修改隶属于该群组或用户的所有程序优先级。等级范围为：[-20, 19]，同样，只有管理员可以调高优先级，用于调整运行中的进程的优先级。

使用方法和 nice 相同

<center>
<img src="/image/linux/common-operations/renice.png" width="800px" height="300px" />
</center>

一个紧急进程，需要更多的 CPU 资源时，可以调高运行中的该进程。

### 配置 CentOS 但需要不更新 DNS
> 配置CentOS不更新DNS，即不刷新/etc/resolv.conf文件

修改配置 `/etc/NetworkManager/NetworkManager.conf`，添加 `dns=none`，修改完成后，使用 `systemctl restart NetworkManager` 命令重启 `NetworkManager`

