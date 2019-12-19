+++
title = "GoTTY 的简单使用"
date = "2018-11-09"
lastmod = "2018-11-09"
tags = [
    "GoTTY"
]
categories = [
    "技术"
]
+++

本篇博客主要记录下 GoTTY 的简单使用方式，或许以后可以在项目中用到。

<!--more-->

### GoTTY 简介

GoTTY 是一个简单的命令行工具，可以将 CLI 工具转换为 Web 应用程序，经常被用来实现 Web 终端。

### GoTTY 部署
1、下载稳定版 gotty 二进制安装文件 

[Gotty - GitHub](https://github.com/yudai/gotty)

2、解压安装包
```markdown
tar -zxf gotty_2.0.0-alpha.3_linux_amd64.tar.gz
```

3、启动 gotty
pod 启动方式：
```markdown
nohup ./gotty -w -p 9988 --permit-arguments --reconnect kubectl exec -it &
```
容器启动方式：
```markdown
nohup ./gotty -w -p 8888 --permit-arguments --reconnect docker exec -it &
```
主机启动方式：
```markdown
 nohup ./gotty -w -p 8899 --permit-arguments --reconnect sh &
```

4、在浏览器中访问 
命令为：
```markdown
kubectl exec -it nginx-567d57d4c4-5spp9 -n default bash
```
浏览器中访问 pod 的 url
```markdown
http://172.20.26.150:8899/?arg=nginx-567d57d4c4-5spp9&arg=-n&arg=default&arg=bash
```
命令为：
```markdown
docker exec -it b96f8e834f51 bash
```
浏览器中访问 docker 容器 url
```markdown
http://172.20.26.150:8899/?arg=b96f8e834f51&arg=bash
```

浏览器中访问宿主机的 url
```markdown
http://172.20.26.150:8899/?
```

需要在每一台机器上都运行一个探针，在一个 gotty 容器中启动三个 gotty 进程，分别在不同的端口监听容器、pod和宿主机的控制台请求。

### 参考资料

https://blog.csdn.net/cj2580/article/details/79318726
