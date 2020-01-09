+++
title = "一些计算机科学和技术中的概念区分"
date = "2018-12-02"
lastmod = "2018-12-22"
description = ""
tags = [
    "Java"
]
categories = [
    "技术"
]
+++

本篇博客记录了些计算机科学和技术中常见的概念的差别，属于基础知识。

<!--more-->

### URI，URL和URN的区别
1）URI

URI 是 uniform resource identifier 的首字母大写，即统一资源标识符，用来唯一地标识一个资源。

2）URL

URL 是 uniform resource locator 的首字母大写，即统一资源定位符，是一种具体的 URI，即 URL 不仅可以用来标识一个资源，还指明了如何获取这个资源。

3）URN

URN 是 uniform resource name 的首字母大写，即统一资源命名，是通过名字来标识资源，比如mailto:java-net@java.sun.com。

也就是说，URI 是以一种抽象的、高层次概念定义统一资源标识，而URL和URN则是具体的资源标识方式，URL 和 URN 都是一种 URI。

在 Java 的 URI 中，一个 URI 实例可以代表绝对的，也可以是相对的，只要其符合 URI 的语法规则。

而 URL 类则不仅符合语义，还包含了定位该资源的信息，因此它不能是相对的，schema 必须被指定。

### Web 服务器和应用服务器

1）Web服务器

Web服务器的基本功能就是提供Web信息浏览服务。它只需支持HTTP协议、HTML文档格式及URL，与客户端的网络浏览器配合，只能发送静态页面的内容。因为Web服务器主要支持的协议就是HTTP，所以通常情况下HTTP服务器和WEB服务器是相等的。Web服务器包括Nginx，Apache，IIS等

2）应用服务器

应用程序服务器让多个用户可以同时使用应用程序，通常是客户创建的应用程序。应用服务器包括WebLogic，JBoss，Tomcat，websphere等。

### 127.0.0.1 和 localhost

1、含义不同：

* `localhost` 也叫 `local` ，是一个域名，可以调用 gethostname() 解析出对应的 IP 地址，其值为：`hosts` 文件中的值，正确的解释是: 本地服务器
* `127.0.0.1`，是一个 IPv4 的地址， 在 `windows` 等系统的正确解释是: 本机地址(本机服务器)

2、与防火墙和网卡的关系

* `localhost` 是不经网卡传输！这点很重要，它不受网络防火墙和网卡相关的的限制。

* `127.0.0.1` 是通过网卡传输，依赖网卡，并受到网络防火墙和网卡相关的限制。
