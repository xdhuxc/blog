+++
title = "sessionStorage，localStorage 和 Cookie 的异同"
date = "2019-04-01"
lastmod = "2019-06-02"
description = ""
tags = [
    "Web",
    "SessionStorage",
    "LocalStorage",
    "Cookie"
]
categories = [
    "技术"
]
+++

本篇博客记录下在 Web 开发过程中常用的存储客户端数据的 SessionStorage，LocalStorage 和 Cookie 的异同，对于我们存储客户端数据时的选型很有帮助。

<!--more-->

### sessionStorage, localStorage 和 cookie 的异同 

特性 | Cookie | localStorage | sessionStorage
---|---|---|---
数据的生命周期 | 一般由服务器生成，可设置失效时间。如果在浏览器端生成 Cookie，默认是关闭浏览器后失效。| 除非被清除，否则永久保存。 | 仅在当前会话下有效，关闭页面或浏览器后被清除，刷新页面数据依旧存在。
存放数据大小  | 4K左右   |   一般为5MB |
与服务器端通信  | 每次都会携带在 HTTP 头中，如果使用 Cookie 保存过多数据会带来性能问题 | 仅在客户端（即浏览器）中保存，不参与和服务器的通信  | sdgsd
易用性  | 需要程序员自己封装，原生的 Cookie 接口不友好 | 原生接口可以接受，亦可再次封装对 Object 和 Array 有更好的支持  | dsgd

localStorage 和 sessionStorage 是 HTML5 才应用的新特性，可能有些浏览器并不支持，需要注意：

 特性         | Chrome | FireFox | IE  | Opera | Safari 
 ---          | ---    | ---     | --- | --- | --- 
 localStorage | 4      | 3.5     | 8   | 10.50 | 4      
 sessionStorage | 5  |     2   |   8  |   10.50   |   4     


### 参考资料

https://juejin.im/post/5a191c47f265da43111fe859

