+++
title = "Docker 存储驱动 overlay 和 overlay2 介绍"
date = "2018-11-10"
lastmod = "2017-08-20"
description = ""
tags = [
    "Docker"
]
categories = [
     "技术"
]
+++

本篇博客介绍了 docker 的存储驱动 overlay 和 overlay2，对于理解 docker 的文件系统非常有帮助。

<!--more-->

### overlay 和 overlay2 

OverlayFS 是一个类似于 AUFS 的联合文件系统，更快，实现更简单。OverlayFS 是内核提供的文件系统，overlay 和overlay2 是 docker 的存储驱动方式。

修改 docker 的存储驱动为 `overlay2`，创建 `/etc/docker/daemon.json`，添加如下内容
```markdown
{
    "storage-driver": "overlay2"   
}
```
如果是 `CentOS7` 或者 `RedHat7` 内核在 `3.10.0-693` 以下的，则添加如下内容
```markdown
{
    "storage-driver":"overlay2",
    "storage-opts":[
        "overlay2.override_kernel_check=true"
    ]
}
```

### overlay 原理

OverlayFS与AUFS相似，也是一种联合文件系统。与AUFS相比，OverlayFS设计更简单，可能更快，也已经被加入Linux内核。

#### OverlayFS 中镜像的分层和共享

OverlayFS将一个Linux主机中的两个目录组合起来，一个在上，一个在下，对外提供统一的视图。这两个目录就是层layer，将两个层组合在一起的技术被称为联合挂载（union mount）。在OverlayFS中，上层的目录被称为upperdir，下层的目录被称为lowerdir，对外提供的统一视图被称为merged。

下图展示了容器和镜像的层与 `OverlayFS` 的 `upperdir`，`lowerdir` 以及 `merged` 之间的对应关系：

<center>
<img src="/image/docker/storage-drive/WechatIMG695.jpeg" width="800px" height="300px" />
图1 · OverlayFS 存储架构
</center>

由上图可以看出，在一个容器中，容器层（container layer）也就是读写层对应于 OverlayFS 的 upperdir，容器使用的对象镜像对应于 OverlayFS 的 lowerdir，容器文件系统的挂载点对应merged。

注意，镜像层和容器层可以有相同的文件，在这种情况下，upperdir 中的文件覆盖 lowerdir 中的文件

OverlayFS 仅有两层，也就是说镜像中的每一层并不对应 OverlayFS中的层，而是镜像中的每一层对应 `/var/lib/docker/overlay` 中的一个目录，目录以该层的UUID命名。然后使用硬链接将下面层的文件引用到上层。这在一定程度上节省了磁盘空间。这样，OverlayFS中的lowerdir就对应镜像层的最上层，并且是只读的。在创建容器时，docker会新建一个目录作为OverlayFS的upperdir，它是可写的。

OverlayFS中容器的读写操作

读：

* 如果该文件在容器层不存在，即文件不存在upperdir中，则从lowerdir中读取。
* 如果该文件只在容器层存在，即文件只存在于upperdir中，则直接从容器中读取该文件。
* 如果文件同时存在于容器层和镜像层，容器层upperdir中的同名文件会覆盖镜像层lowerdir中的文件。


修改：

* 首次写入：第一次修改时，容器层中不存在该文件，在overlay和overlay2中，overlay驱动执行copy-up操作，将文件从loweridr复制到upperdir中，然后对文件的副本做出修改。

需要说明的是，overlay的copy-up操作工作在文件层面，不是块层面，这意味着对文件的修改需要将整个文件复制到upperdir中，不过下面这两点使这一操作的开销很小：

* copy-up操作仅发生在文件第一次被修改时，此后对文件的读写都直接在upperdir中进行。
* OverlayFS中仅有两层，这使得文件的查找效率很高（相对于AUFS）

删除文件和目录

当文件在容器内被删除时，在容器层（upperdir）创建whiteout文件，镜像层的文件是不会被删除的，因为它们是只读的，但whiteout文件会阻止它们展现。

当目录在容器内被删除时，在容器层（upperdir）中创建一个不透明的目录，和上面的whiteout一样，阻止用户继续访问，即使镜像层仍然存在。

#### 性能对比

使用 overlay 和 overlay2 驱动性能好于 aufs 和 devicemapper，在实际生产环境，overlay2的性能高于btrfs，但是还需要注意以下细节：

* 页缓存：OverlayFS支持页缓存共享，也就是说如果多个容器访问同一个文件，可以共享同一个页缓存。这使得Overlay/Overlay2驱动高效地利用了内存。
* copy_up：overlay的复制操作工作在文件层面上，也就是对文件的第一次修改需要复制文件整个文件，这会带来一些性能开销，在修改大文件时尤其如此。但是overlay的复制操作比AUFS还是快一点，因为AUFS有很多层，而overlay只有两层，所以overlay在文件的搜索方面相对于AUFS具有优势。
* inode限制：使用overlay存储驱动可能导致inode过度消耗，特别是当容器和镜像很多的情况下，所以推荐使用overlay2。

overlay和overlay2的本质区别是镜像层之间共享数据的方法不同，overlay共享数据的方式是通过硬链接，而overlay2则是通过每层的lower文件。


### 参考资料

https://blog.csdn.net/vchy_zhao/article/details/70238690

https://blog.csdn.net/vchy_zhao/article/details/70238690

https://blog.csdn.net/zhonglinzhang/article/details/80970411
