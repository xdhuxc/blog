+++
title = "使用 docker 容器方式部署 FastDFS"
date = "2018-07-20"
lastmod = "2018-01-28"
tags = [
    "FastDFS",
    "Docker",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客介绍了使用 docker 容器方式部署 FastDFS 的方法。

<!--more-->

> 在 `/home/xdhuxc/fastdfs/` 目录下创建 `tracker`，`conf`，`storage/data`，`store_path` 目录。

1、拉取 fastdfs 镜像
```markdown
docker pull season/fastdfs:1.2
```

2、启动 tracker 容器
```markdown
docker run -d \
    -p 22122:22122 \
    --net host \
    -v /home/xdhuxc/fastdfs/tracker:/fastdfs/tracker/data \
    -v /home/xdhuxc/fastdfs/conf:/fdfs_conf \
    --name fastdfs-tracker \
    season/fastdfs:1.2 tracker
```

3、启动 storage 容器
```markdown
docker run -d \
    --net host \
    -v /home/xdhuxc/fastdfs/storage/data:/fastdfs/storage \
    -v /home/xdhuxc/fastdfs/store_path:/fastdfs/store_path \
    -e TRACKER_SERVER=192.168.244.128:22122 \
    --name fastdfs-storage \
    season/fastdfs:1.2 storage
```

容器内配置文件目录为：
```markdown
/fdfs_conf
```

4、测试程序见 git@github.com:xdhuxc/integration.git


