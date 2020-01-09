+++
title = "HTTP 的长连接和短连接"
date = "2018-07-12"
lastmod = "2018-12-22"
description = ""
tags = [
    "HTTP"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 HTTP 协议中的长连接和短连接，算是 HTTP 协议中进阶的内容。

<!--more-->

#### HTTP 协议与 TCP/IP 协议的关系

HTTP 的长连接和短连接本质上是 TCP 的长连接和短连接。HTTP 协议属于应用层协议，在传输层使用 TCP 协议，在网络层使用 IP 协议。IP 协议主要解决网络路由和寻址问题，TCP 协议主要解决如何在 IP 层之上可靠地传输数据包，使在网络上的另一端收到发送端发出的所有包，并且接收顺序与发送顺序一致，TCP 有可靠、面向连接的特点。

#### HTTP 协议是无状态的

HTTP 协议是无状态的，指的是协议对于事务的处理没有记忆能力，服务端不知道客户端是什么状态。也就是说，打开一个服务器上的网页和之前打开这个服务器上的同一网页之间没有任何联系。HTTP 是一个无状态的面向连接的协议，无状态不代表 HTTP 不能保持 TCP 连接，更不能代表 HTTP 使用的是 UDP 协议（无连接的协议）

#### 长连接，短连接

在 HTTP/1.0 中，默认使用的是短连接。也就是说，`浏览器和服务器每进行一次 HTTP操作，就建立一次连接，但任务结束就中断连接`。如果客户端浏览器访问的某个 HTML 或其他类型的 Web 页中包含有其他的 Web 资源，如 JavaScript文件、图像文件、CSS文件等；当浏览器每遇到这样一个 Web 资源，就会建立一个 HTTP 会话。

但从 HTTP/1.1 起，默认使用长连接，用以保持连接特性。使用长连接的 HTTP 协议，会在响应头有加入这行代码：
```markdown
Connection:keep-alive
```
在使用长连接的情况下，当一个网页打开完成后，客户端和服务器之间用于传输 HTTP 数据的 TCP 连接不会关闭。如果客户端再次访问这个服务器上的网页，会继续使用这一条已经建立的连接。Keep-Alive 不会永久保持连接，它有一个保持时间，可以在不同的服务器软件中设定这个时间。实现长连接要客户端和服务端都支持长连接。

HTTP 协议的长连接和短连接，实质上是 TCP 协议的长连接和短连接。

### TCP 连接
当网络通信采用TCP协议时，在真正的读写操作之前，服务器与客户端之间必须建立一个连接，当读写操作完成后，双方不再需要这个连接时，它们可以释放这个连接，连接的建立是需要三次握手的，而释放则需要四次挥手，所以说每个连接的建立都是需要资源消耗和时间消耗的。

经典的三次握手示意图：

![image](C:/Users/wanghuan/Desktop/电子书/three_times.jpg)

经典的四次挥手示意图：

![image](C:/Users/wanghuan/Desktop/电子书/four_times.jpg)

#### TCP 短连接
TCP短连接的情况，客户端向服务器发起连接请求，服务器接收到请求，然后双方建立连接。客户端向服务器发送消息，服务器回应客户端，然后一次读写操作就完成了。

这时候双方任何一个都可以发起close操作，不过一般都是客户端先发起close操作，因为一般的服务器不会响应完客户端后立即关闭连接的，当然不排除有特殊的情况。所以，短连接一般只会在客户端/服务器之间传递一次读写操作。

短连接的优点是：管理起来比较简单，存在的连接都是有用的连接，不需要额外的控制手段。

### TCP 长连接
TCP 长连接的情况，客户端向服务端发起连接请求，服务端接收到客户端的连接请求，双方建立连接。客户端与服务端完成一次读写之后，他们之间的连接并不会主动关闭，后续的读写操作会继续使用这个连接。

TCP的保活功能，保活功能主要为服务器应用提供，服务器应用希望知道客户主机是否崩溃，从而可以代表客户端使用资源。如果客户端已经消失，使得服务器上保留着一个半开放的连接，而服务器又在等待来自客户端的数据，则服务器将永远等待客户端的数据。保活功能就是试图在服务器端检测到这种半开放的连接。

如果一个给定的连接在两个小时内没有任何的动作，则服务器就向客户端发一个探测报文段，客户端必须处于以下四个状态之一：

* 客户端依然正常运行，并从服务器可达。客户端的TCP响应正常，而服务器也知道对方是正常的，服务器在两个小时后将保活定时器复位。
* 客户端已经崩溃，并且关闭或者正在重新启动。在任何一种情况下，客户端的TCP都没有响应。服务端将不能收到对探测的响应，并在75秒后超时。服务器总共发送10个这样的探测，每个间隔75秒。如果服务器没有收到一个响应，它就认为客户端已经关闭并终止连接。
* 客户端崩溃并已经重新启动。服务器将收到一个对其保活探测的响应，这个响应是一个复位，使得服务器终止这个连接。
* 客户端正常运行，但是服务器不可达，这种情况与第二种情况类似，TCP能发现的就是没有收到探查的响应。

### 长连接和短连接的操作过程
短连接的操作步骤是：
```markdown
建立连接->数据传输->关闭连接...建立连接->数据传输->关闭连接
```
长连接的操作步骤是：
```markdown
建立连接->数据传输...(保持连接)...数据传输->关闭连接
```

### 长连接和短连接的优点和缺点
长连接可以省去较多的TCP建立和关闭操作，减少浪费，节约时间。对于频繁请求资源的客户来说，比较适用长连接。不过这里存在一个问题，存活功能的探测周期太长，还有就是它只是探测TCP连接的存活，属于比较斯文的做法。遇到恶意的连接时，保活功能就不够使了。在长连接的应用场景下，客户端一般不会主动关闭它们之间的连接，客户端与服务器之间的连接如果一直不关闭的话，会存在一个问题，随着客户端连接越来越多，服务器早晚有扛不住的时候，这时候服务器需要采取一些策略，如关闭一些长时间没有读写事件发生的连接，这样可以避免一些恶意连接导致服务端服务受损；如果条件再允许的话，就可以以客户端机器为颗粒度，限制每个客户端的最大长连接数，这样可以完全避免某个客户端连累后端服务。

短连接对于服务器来说管理较为简单，存在的连接都是有用的连接，不需要额外的控制手段。但如果客户端请求频繁，将在TCP的建立和关闭操作上浪费时间和带宽。

长连接和短连接的产生在于客户端和服务器采取的关闭策略，具体的应用场景采用具体的策略，没有十全十美的选择，只有合适的选择。

### 长连接和短连接的使用场景
长连接多用于操作频繁、点对点的通讯，而且连接数不能太多的情况。每个TCP连接都需要三次握手，这需要时间。如果每个操作都是先连接，再操作的话，那么处理速度会降低很多，所以每个操作完后都不断开，再次处理时直接发送数据包就行，不用建立TCP连接。例如，数据库的连接使用长连接，如果用短连接频繁地通信会造成socket错误，而且频繁的socket创建也是对资源的浪费。

而像Web网站的HTTP服务一般都用短连接，因为长连接对于服务器来说会耗费一定的资源，而像Web网站这么频繁的成千上万甚至上亿客户端的连接用短连接会更省一些资源，如果使用长连接，而且同时有成千上万的用户，如果每个用户都占用一个连接的话，那么服务器端肯定承受不了。所以，并发量大，但每个用户无需频繁操作的情况下，使用短连接较好。

### 参考资料

https://maimai.cn/article/detail?fid=469286418

