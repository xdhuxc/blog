+++
title = "HTTP 协议基础知识"
date = "2018-07-02"
lastmod = "2018-12-22"
description = ""
tags = [
    "HTTP"
]
categories = [
    "技术"
]
+++

本篇博客介绍了些 HTTP 协议的基本知识，可用于复习 HTTP 协议的基础知识。

<!--more-->

### HTTP 简介
HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写，用于从万维网服务器传输超文本到本地浏览器的传送协议。

HTTP 是一个基于TCP/IP协议来传输数据（HTML文件、图片文件等）的协议

### HTTP 工作原理
HTTP 协议工作于客户端-服务器架构上，浏览器作为HTTP客户端通过URL向HTTP服务端发送所有请求，HTTP服务器根据接收到的请求，向客户端发送响应信息。

一次 HTTP 操作称为一个事务，其工作过程可分为四步：

1）首先，客户端与服务器需要建立连接，只要用户点击某个超链接，HTTP的工作就开始。

2）建立连接后，客户端发送一个请求给服务器，请求方法的格式为：统一资源标识符（URL）、协议版本号，后边是MIME信息，包括请求修饰符、客户端信息和可能的内容。

3）服务器接收到请求后，给予相应的响应信息，其格式为：一个状态行，包括信息的协议版本号、一个成功或错误的代码，后边是MIME信息，包括服务器信息、实体信息和可能的内容。

4）客户端接收到服务器所返回的信息，通过浏览器显示在用户的显示屏上，然后客户端与服务器断开连接。

如果在以上过程中的某一步出现错误，那么产生错误的信息将返回到客户端，由显示屏输出。

### HTTP 特点
* HTTP是无连接的
无连接的含义是限制每次连接只处理一个请求，服务器处理完客户的请求，并收到客户的应答后，即断开连接，采用这种方式可以节省传输时间。
* HTTP是媒体独立的
这意味着，只要客户端和服务器知道如何处理数据内容，任何类型的数据都可以通过HTTP发送，客户端以及服务器指定使用适合的MIME-TYPE内容类型。
* HTTP是无状态的
无状态是指协议对于事务处理没有记忆能力。缺少状态意味着如果后续处理需要前面的信息，则它必须重传，这样可能导致每次连接传送的数据量增大。另一方面，在服务器不需要先前信息时它的应答就较快。


### 请求消息Request
客户端发送一个HTTP请求到服务器的请求消息包括以下格式：
请求行，请求头，空行和请求数据四个部分组成
![image](C:/Users/wanghuan/Desktop/电子书/http-request.png)

* 请求行，用来说明请求类型，要访问的资源以及所使用的HTTP协议版本。
* 请求头部，紧接着请求行（即第一行）之后的部分，用来说明服务器要使用的附加信息。
* 空行，请求头部后面的空行是必须的，即使第四部分的请求数据为空，也必须有空行。
* 主体，即请求数据，可以添加任意的其他数据。

### 响应消息Response
一般情况下，服务器接收并处理客户端发过来的请求后会返回一个HTTP的响应消息。
HTTP 响应也由四个部分组成，分别是：状态行、消息报头、空行和响应正文。
![image](C:/Users/wanghuan/Desktop/电子书/http-response.jpg)

* 状态行，由HTTP协议版本号、状态码和状态消息三部分组成。
* 响应头部，用来说明客户端要使用的一些附加信息。
* 空行，消息报头后面的空行是必须的。
* 响应正文，服务器返回给客户端的文本信息。


### HTTP 请求方法
根据HTTP标准，HTTP请求可以使用多种请求方法。
HTTP 1.0 定义了三种请求方法：GET，POST和HEAD方法。
HTTP 1.1 新增了五种请求方法：OPTIONS，PUT，DELETE，TRACE 和 CONNECT 方法。

在 HTTP/1.0 中，默认使用短连接，也就是说，浏览器和服务器每进行一次 HTTP操作，就建立一次连接，但任务结束就中断连接。

在 HTTP/1.1 中，默认使用长连接，用以保持连接特性。在使用长连接的情况下，当一个网页打开完成后，客户端和服务器之间用于传输 HTTP 数据的 TCP 连接不会关闭。如果客户端再次访问这个服务器上的网页，会继续使用这一条已经建立的连接。Keep-Alive 不会永久保持连接，它有一个保持时间，可以在不同的服务器软件中设定这个时间。实现长连接要客户端和服务端都支持长连接。

* GET：请求指定的页面信息，并返回实体主体。
* HEAD：类似于GET请求，只不过返回的响应中没有具体的内容，用于获取报头。
* POST：向指定资源提交数据进行处理请求（例如提交表单或上传文件）。数据被包含在请求体中，POST请求可能会导致新的资源的建立或已有资源的修改。
* PUT：从客户端向服务器传送的数据取代指定的文档内容。
* DELETE：请求服务器删除指定的页面。
* CONNECT：HTTP/1.1协议中预留给能够将连接改为管道方式的代理服务器。
* OPTIONS：允许客户端查看服务器的性能。
* TRACE：回显服务器收到的请求，主要用于测试或诊断。

### GET 请求和 POST 请求的区别
#### 请求数据
GET请求，请求的数据会附在URL之后，即把数据放置在HTTP协议头中，以?分隔URL和传输数据，多个参数使用&连接。

POST请求，把提交的数据放置在HTTP包的包体中。

因此，GET提交的数据会在浏览器地址栏中显示出来，而POST方式提交数据时，浏览器地址栏不会改变。

#### 传输数据大小
首先，HTTP协议没有对传输的数据大小进行限制，HTTP协议规范也没有对URL长度进行限制。

但在实际开发过程中，对于GET请求，特定的浏览器和服务器对URL的长度有限制，因此，在使用GET请求时，传输数据会受到URL长度的限制。

对于POST请求，由于不是URL传值，理论上是不会受限制的，但是实际上各个服务器会规定对POST提交数据大小进行限制，Apache，IIS都有各自的配置。

#### 安全性
POST的安全性比GET的高。这里的安全是指真正的安全，而不同于上面GET提到的安全方法中的安全，上面提到的安全仅仅是不修改服务器的数据。比如，在进行登录操作，通过GET请求，用户名和密码都会暴露再URL上，因为登录页面有可能被浏览器缓存以及其他人查看浏览器的历史记录的原因，此时的用户名和密码就很容易被他人拿到了。除此之外，GET请求提交的数据还可能会造成Cross-site request frogery攻击


GET请求和POST请求本质上都是TCP连接，并无差别，但是由于HTTP的规定和浏览器/服务器的限制，导致它们在应用过程中体现出一些不同。

GET请求产生一个TCP数据包，POST请求产生两个TCP数据包。具体来讲，对于GET请求，浏览器会把HTTP请求头部和请求数据一起发送出去，服务器端响应200，返回数据。

对于POST请求，浏览器先发送请求头部，服务器响应100，continue，浏览器再发送数据，服务器端响应200，返回数据。

根据研究，在网络环境好的情况下，发一次包的时间和发两次包的时间差别基本可以无视。而在网络环境差的情况下，两次包的TCP在验证数据包完整性上，有非常大的优点。


### 状态码含义
* 100：Continue，服务器仅接收到部分请求，但是一旦服务器并没有拒绝该请求，客户端应该继续发送其余的请求。
* 200：OK，请求成功，一般用于GET和POST请求
* 301：Moved Permanently，永久移动，请求的资源已被永久地移动到新的URI，返回信息会包含新的URI，浏览器会自动重定向到新的URI，今后任何新的请求都应使用新的URI代替。
* 302：Found，临时移动，与301类似，但是资源只是临时被移动，客户端应继续使用原来的URI。
* 400：Bad Request，客户端请求的语法错误，服务器无法理解。
* 403：Forbidden，服务器理解请求客户端的请求，但是拒绝执行此请求。
* 404：Not Found，服务器无法根据客户端的请求找到资源。
* 500：Internal Server Error，服务器内部错误，无法完成请求。
* 502：Bad Gateway，充当网关或代理的服务器，从远端服务器接收到了一个无效的请求。
* 503：Service Unavailable，由于超载或系统维护，服务器暂时无法处理客户端的请求。
* 504：Gateway Time-out，充当网关或代理的服务器，未及时从远端服务器获取请求。

### curl

使用 curl 发送 POST 请求
```
curl -v -H "Content-Type:application/json" -H "Host:www.baidu.com" -X POST --data ./xdhuxc.json www.baidu.com
```
```
[root@xdhuxc ~]# curl -v -H "Content-Type:application/json" -H "Host:www.baidu.com" -X POST --data ./xdhuxc.json www.baidu.com
* About to connect() to www.baidu.com port 80 (#0)
*   Trying 14.215.177.38...
* Connected to www.baidu.com (14.215.177.38) port 80 (#0)
> POST / HTTP/1.1                       # 请求行
> User-Agent: curl/7.29.0               # 请求头部
> Accept: */*                           # 请求头部
> Content-Type:application/json         # 请求头部
> Host:www.baidu.com                    # 请求头部
> Content-Length: 13                    # 请求头部
>                                       # 空行
* upload completely sent off: 13 out of 13 bytes
< HTTP/1.1 302 Found                    # 状态行
< Connection: Keep-Alive                # 响应头部
< Content-Length: 17931                 # 响应头部
< Content-Type: text/html               # 响应头部
< Date: Sat, 21 Jul 2018 02:54:33 GMT   # 响应头部
< Etag: "54d9748e-460b"                 # 响应头部 
< Server: bfe/1.0.8.18                  # 响应头部
<                                       # 空行
<html>                                  # 以下为响应体
<head>
* Connection #0 to host www.baidu.com left intact  # 响应体
</body></html>
```
注意：
-H，--header：设置头部信息Content-Type为application/json。
-d，--data：添加发送的数据。
-X：指定HTTP请求的方法，如果使用了-d，默认使用POST方法，可以省略-X参数。

使用curl发送GET请求
```
curl -G -d "name=xdhuxc&password=Xdhuxc163" -F "file=@/Users/fungleo/Downloads/401.png" http://www.baidu.com
```

### HTTP 请求头

请求头 | 说明 | 示例
---|---|---
Accept | 客户端可接受的响应内容类型（Content-Type）| Accept: text/plain
Accept-Charset | 客户端可接受的字符集 | Accept-Charset: utf-8
Host|表示服务器的域名以及服务器所监听的端口号。如果所请求的端口是对应的服务的标准端口（80），则端口号可以省略|Host:www.baidu.com或Host:www.baidu.com:80
Referer|表示浏览器所访问的前一个页面，可以认为是之前访问页面的链接将浏览器带到了当前页面。Referer其实是Referrer这个单词，但RFC制作标准时给拼错了，后来也就将错就错使用Referer了。
Connection|客户端浏览器想要优先使用的连接类型 | Connection: keep-alive;Connection:Upgrade
Content-Type|请求体的MIME类型（用于POST和PUT请求中）|Content-Type: application/x-www-from-urlencoded
Accept-Encoding|客户端可接受的响应内容的编码方式|Accept-Encoding: gzip,deflate
Accept-Language|客户端可接受的响应内容语言列表|Accept-Language:zh-CN,en-US
Cache-Control|用来指定当前的请求/响应中，是否使用缓存机制|Cache-Control: no-cache
Content-Length|以八进制表示的请求体长度|Content-Length: 348
User-Agent|浏览器的身份标识字符串|User-Agent：Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36
Upgrade|要求服务器升级到一个高版本协议|Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11

https://blog.csdn.net/qq_30553235/article/details/79282113
### HTTP 响应头

响应头 | 说明 | 示例
---|---|---
Status | 通用网关接口的响应头字段，用来说明当前HTTP连接的响应状态|Status: 200 OK
Server | 服务器的名称 | Server: nginx/1.6.3
ETag| 一个代表响应服务端资源（如页面）版本的报文头属性，如果某个服务端资源发生变化了，这个ETag就会相应发生变化。它是Cache-Control的有益补充，可以让客户端更智能地处理什么时候需要从服务端获取资源，什么时候可以直接从缓存中返回响应。对于服务器端某个资源的某个特定版本的一个标识符，通常是一个 消息散列|ETag: "737060cd8c284d8af7ad3082f209582d"
Age|响应对象在代理缓存中存在的时间，以秒为单位|Age: 12
Allow|对于特定资源的有效动作|Allow: GET, HEAD
Cache-Control|通知从服务器到客户端内的所有缓存机制，表示它们是否可以缓存这个对象及缓存有效时间，单位为秒|Cache-Control: max-age=3600
Connection|针对该连接所预期的选项|Connection: close
Content-Encoding|服务器端响应资源所使用的编码类型|Content-Encoding: gzip
Content-Language|服务器端响应资源所使用的语言|Content-Language: zh-cn
Content-Length|服务端响应消息体的长度，用八进制字节表示|Content-Length: 348
Content-Type|当前内容的MIME类型|Content-Type: text/html; charset=utf-8
Expires|指定一个日期/时间，超过该时间则认为此回应已经过期|Expires: Thu, 01 Dec 1994 16:00:00 GMT
Refresh|用于重定向，或者当一个新的资源被创建时，默认会在5秒后刷新重定向|Refresh: 5; url=http://itbilu.com

### 参考资料
https://blog.csdn.net/u012361288/article/details/54425689

https://www.cnblogs.com/wangning528/p/6388464.html

http://www.runoob.com/http/http-status-codes.html

