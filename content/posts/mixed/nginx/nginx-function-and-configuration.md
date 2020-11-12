+++
title = "nginx 常用功能及配置详解"
date = "2018-04-26"
lastmod = "2018-10-29"
tags = [
    "Nginx"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 nginx 的常用功能和其配置的详细含义。

<!--more-->

### nginx 简介

nginx 是一个轻量级高性能的 web 服务器，它是为快速响应大量静态文件请求和高效利用系统资源而设计的。与apache使用面向进程或线程的方式处理请求不同，nginx使用异步事件驱动模型在负载下性能更突出。

nginx 功能丰富，可作为 HTTP 服务器，也可作为反向代理服务器和邮件服务器，支持FastCGI、SSL、Virtual Host、URL Rewrite、Gzip等功能，并且支持很多第三方的模块扩展。

虽然nginx能高效地服务静态文件，但也有人认为nginx处理动态内容并不理想。不像apache服务器，nginx没用使用内嵌解释器的方式来处理动态内容。相反，动态内容被丢给cgi，fastcgi或者像apache这样的web服务器，然后把处理结果返回给nginx，nginx在返给浏览器。这种方式就导致部署起来会更复杂一些。出于这些原因，使用和配置nginx可能会晦涩。nginx的配置感觉更复杂或者不直接。

### nginx 常用功能

1、HTTP 代理，反向代理

作为 Web 服务器最常用的功能之一，尤其是反向代理。nginx 在做反向代理时，提供性能稳定、配置灵活的转发功能。 nginx 可以根据不同的正则匹配，采取不同的转发策略，比如图片文件的转发至文件服务器、动态页面的转发至web服务器。并且， nginx 对返回结果进行错误页跳转、异常判断等。如果被分发的服务器存在异常，可以将请求重新转发给另外一台服务器，然后自动去除异常服务器。

2、负载均衡

nginx 提供的负载均衡策略有两种：内置策略和扩展策略。内置策略包括：轮询，加权轮询，IP hash。扩展策略非常多，几乎涵盖所有的负载均衡算法。

IP Hash算法：对客户端请求的IP地址进行Hash操作，然后根据Hash结果将同一个客户端IP的请求分发给同一台服务器进行处理，可以解决 session 不共享的问题。

3、Web 缓存

nginx 可以对不同的文件做不同的缓存处理，配置灵活，并且支持FastCGI_Cache，主要用于对 FastCGI的动态程序进行缓存。配合第三方的ngx_cache_purge，对指定的 URL 缓存内容可以进行增删管理。

### nginx 配置文件
nginx 的强大都是靠配置文件来实现，nginx 就是一个二进制文件 nginx 读入一个配置文件 nginx.conf (nginx.conf可能include包含若干子配置文件)来实现各种各样的功能。

#### nginx 配置文件结构
```markdown
...                           # 全局块
events {                      # events 块
    ...       
}
http {                        # http 块
    ...                       # http 全局块
    server {                  # server 块
        ...                   # server 全局块
        location [PATTERN] {  # location 块  
            ...
        }   
        location [PATTERN] {
            ...
        }
    }
    server {
        ...
    }
    ...                       # http 块
}

```
1、全局块

配置影响 nginx 全局的指令。一般有运行 nginx 服务器的用户组， nginx 进程 pid 存放路径，日志文件存放路径，配置文件引入，允许生成的 worker process数等。

2、events 块

配置影响 nginx 服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网络连接，开启多个网络连接序列化等。

3、http 块

可以嵌套多个 server块，配置代理、缓存、日志定义等绝大多数功能和第三方模块的配置，如文件引入、mime-type定义、日志自定义、是否使用 sendfile 传输文件、连接超时时间、单连接请求数等。

4、server 块

配置虚拟主机的相关参数，一个 http 块中可以有多个 server 块。

5、location 块

配置请求的路由，以及各种页面的处理情况。

#### nginx 配置文件示例
nginx.conf文件示例
```markdown
user administrator administrator; # 配置用户或者用户组，默认为nobody nobody。
worker_processes 2;               # 允许生成的进程数，设置值和CPU核心数一致，默认为：1。在nginx1.3.8和1.2.5之后的版本开始支持auto，自动匹配进程数。
pid /var/nginx/nginx.pid # 指定 nginx 进程运行文件存放地址。
error_log /var/log/nginx/error.log debug # 指定错误日志存放路径及级别，该设置可以放入全局块、http块、server块，日志级别依次为：debug|info|notice|warn|error|crit|alert|emerg。
events {
    accept_mutex on; # 设置网络连接序列化，防止惊群现象发生，默认为：on。
    multi_accept on; # 设置一个进程是否同时接受多个网络连接，默认为：off。
    use epoll;        # 指定事件驱动模型，可以为：select|poll|kqueue|epoll|resig|/dev/poll|eventport。
    worker_connections 1024; # 设置最大连接数，默认为：512。
}
http {
    include mime.types; # 文件扩展名与文件类型映射表。
    default_type application/octet-stream; # 指定默认文件类型，默认为：text/plain。
    #access_log off # 取消服务日志。
    
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';  # 自定义格式
    access_log /var/log/nginx/access.log main; # combined为日志格式的默认值。
    sendfile on; # 允许sendfile方式传输文件，默认为：off，可以在http块、server块、location块中定义。
    sendfile_max_chunk 100K; # 每个进程每次调用传输数量不能大于设定的值，默认值为：0，即不设上限。
    keepalive_timeout 65;    # 连接超时时间，默认为：75s，可以在http块、server块和location块中设置。
    
    upstream xdhuxc {
        server 127.0.0.1:8080;
        server 192.168.91.128:9090 backup; # 热备，
    }
    
    error_page 404 https://www.baidu.com # 错误页。
    
    server {
        listen 8080;            # 监听端口。
        server_name 127.0.0.1;  # 监听地址。
        keepalive_requests 120; # 单连接请求上限次数。
        location ~*^.+$ {       # 请求的 url 过滤，正则匹配，~ 为区分大小写，~* 为不区分大小写。
            # root path;   # 根目录。
            # index index.html index.htm; # 设置默认页。
            proxy_pass http://xdhuxc; # 请求转向 xdhuxc 定义的服务器列表。
            deny 127.0.0.1; # 拒绝的IP。
            allow 172.18.5.54; 允许的IP。
        }
        
    }
}
```
注意：

1、log_format中参数的含义
```markdown
$remote_addr 和 $http_x_forwarded_for 用以记录客户端的IP地址。
$remote_user 用来记录客户端用户名称。
$time_local 用来记录访问时间与时区。
$request 用来记录请求的url与http协议。
$status 用来记录请求状态，成功为200。
$body_bytes_sent 记录发送给客户端文件主体内容大小。
$http_referer 用来记录从哪个页面链接访问过来的。
$http_user_agent 用来记录客户端浏览器的相关信息。
```

2、惊群现象：一个网络连接到来，多个睡眠的进程被同时叫醒，但只有一个进程能获得连接，这样会影响系统性能。

3、每个指令必须有分号结尾。

### 负载均衡和反向代理配置

#### 代理服务配置
1、在 http 块中有如下配置：
```markdown
error_page 404 https://www.baidu.com # 设置错误页，当代理遇到状态码为404时，把错误页面导向百度。
```
要想让该语句起作用，必须配合着下面的配置一起使用：
```markdown
proxy_intercept_errors on; # 如果被代理服务器返回的状态码为400或者大于400，设置的error_page配置起作用，默认为：off。
```

2、如果我们的代理只允许接受get、post请求方法的一种，可进行如下配置：
```markdown
proxy_method get; # 支持客户端的请求方法，post/get。 
```

3、设置支持的http协议版本
```markdown
proxy_http_version 1.0; # nginx 服务器提供代理服务的http协议版本1.0、1.1，默认为：1.0版本。
```

4、如果 nginx 服务器给两台 web 服务器做代理，负载均衡算法采用轮询。那么当一台服务器 web 程序不能访问时，nginx服务器分发请求还是会给这台不能访问的 web 服务器。如果这里的响应连接时间过长，就会导致客户端的页面一直在等待，严重影响客户体验。

如果负载均衡中，web 服务器乙发生这样的情况，nginx 首先会去 web 服务器甲请求，但是 nginx 在配置不当的情况下会继续分发请求到 web 服务器乙，然后等待 web 服务器乙响应，直到响应时间超时，才会把请求重新分发给 web 服务器甲。这里的响应时间如果过长，用户等待的时间就会越长。

以下配置可以作为解决方案：
```markdown
proxy_connect_timeout 1; # nginx 服务器与被代理服务器建立连接的超时时间，默认为：60s。
proxy_read_timeout 1; # nginx 服务器向被代理服务器组发出 read 请求后，等待响应的超时时间，默认为：60s。
proxy_send_timeout 1; # nginx 服务器向被代理服务器组发出 write 请求后，等待响应的超时时间，默认为：60s。
proxy_ignore_client_abort on; # 客户端断网时，nginx 服务器是否中断对被代理服务器的请求，默认为：off。
```

5、如果使用 upstream 指令配置了一组服务器作为被代理服务器，服务器中的访问算法遵循配置的负载均衡规则，同时可以使用该指令配置在发生哪些异常情况时，将请求顺次交由下一组服务器处理。
```markdown
proxy_next_upstream timeout; # 反向代理 upstream 中设置的服务器组，出现故障时，被代理服务器返回的状态值。
```
可以设置为：
```markdown
error | timeout | invalid_header | http_500 | http_502 | http_503 | http_504 | http_404 | off 
```

* error：建立连接或向被代理的服务器发送请求或读取响应信息时，服务器发生错误。
* timeout：建立连接或向被代理服务器发送请求或读取响应信息时，服务器发生超时。
* invalid_header：被代理服务器返回的响应头异常。
* off：无法将请求分发给被代理的服务器。
* http_404,http_500,...：被代理服务器返回的状态码为404，500，502等。

6、如果想通过 http 获取客户端的真实IP地址，而不是获取代理服务器的IP地址，那么需要做如下配置：
```markdown
proxy_set_header Host $host; # 只要用户在浏览器中访问的域名绑定了VIP，VIP下面有RS，则就用$host；host 是访问的URL中的域名和端口，比如，www.taobaoc.com:80
proxy_set_header X-Real-IP $remote_addr; # 把源IP（$remote_add，建立HTTP连接header里面的信息）赋值给X-Real-IP，这样在代码中，$X-Real-IP就可以获得源IP。
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; # 在nginx 作为代理服务器时，设置的IP列表，会把经过的机器IP、代理机器IP都记录下来，用","隔开，代码中使用 `echo $x-forwarded-for | awk -F, '{print $1}'` 来作为源IP。
```

7、nginx 代理配置的配置文件
```markdown
include       mime.types;                  # 文件扩展名与文件类型映射表
default_type  application/octet-stream;    # 设置默认文件类型，默认为text/plain
#access_log off;                           # 取消服务日志    
log_format main ' $remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
access_log log/access.log main;            # combined 为日志格式的默认值
sendfile on;                               # 允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
sendfile_max_chunk 100k;                   # 每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
keepalive_timeout 65;                      # 连接超时时间，默认为75s，可以在http，server，location块。
proxy_connect_timeout 1;                   # nginx服务器与被代理的服务器建立连接的超时时间，默认60秒
proxy_read_timeout 1;                      # nginx服务器想被代理服务器组发出read请求后，等待响应的超时间，默认为60秒。
proxy_send_timeout 1;                      # nginx服务器想被代理服务器组发出write请求后，等待响应的超时间，默认为60秒。
proxy_http_version 1.0 ;                   # Nginx服务器提供代理服务的http协议版本1.0，1.1，默认设置为1.0版本。
#proxy_method get;                         # 支持客户端的请求方法。post/get；
proxy_ignore_client_abort on;              # 客户端断网时，nginx服务器是否终端对被代理服务器的请求。默认为off。
proxy_ignore_headers "Expires" "Set-Cookie";  #Nginx服务器不处理设置的http相应投中的头域，这里空格隔开可以设置多个。
proxy_intercept_errors on;                 # 如果被代理服务器返回的状态码为400或者大于400，设置的error_page配置起作用。默认为off。
proxy_headers_hash_max_size 1024;          # 存放http报文头的哈希表容量上限，默认为512个字符。
proxy_headers_hash_bucket_size 128;        # nginx服务器申请存放http报文头的哈希表容量大小。默认为64个字符。
proxy_next_upstream timeout;               # 反向代理upstream中设置的服务器组，出现故障时，被代理服务器返回的状态值。error|timeout|invalid_header|http_500|http_502|http_503|http_504|http_404|off
#proxy_ssl_session_reuse on;               # 默认为：on，如果我们在错误日志中发现“SSL3_GET_FINSHED:digest check failed”的情况时，可以将该指令设置为off。
```

#### 负载均衡配置

upstream 配置是写一组被代理的服务器地址，然后配置负载均衡的算法。这里的被代理服务器地址有两种写法：

1）、
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080;
    server 192.168.91.129:8080;
}
server {
    ...
    location ~*^.+$ {
        proxy_pass http://xdhuxc   # 请求转向 xdhuxc 定义的服务器列表。
    }
}
```

2）、
```markdown
upstream xdhuxc {
    server http://192.168.91.128:8080;
    server http://192.168.91.129:8080;
}
server {
    ...
    location ~*^.+$ {
        proxy_pass xdhuxc;         # 请求转向 xdhuxc 定义的服务器列表。
    }
}
```

1、热备

如果有两台服务器，当一台服务器发生故障时，才启用第二台服务器给用户提供服务。服务器处理请求的顺序：AAAA（突然A挂了）BBBBBBB...
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080;
    server 192.168.91.129:8080 backup; # 热备
}
```

2、轮询

nginx 默认就是轮询，其权重默认都为：1。服务器处理请求的顺序为：ABABABAB...
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080;
    server 192.168.91.129:8080;
}
```

3、加权轮询

nginx 根据配置的权重的大小而分发给不同服务器不同数量的请求。如果不设置，则默认为：1。服务器处理请求的顺序为：ABBABBABBABBABB...
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080 weight=1;
    server 192.168.91.129:8080 weight=2;
}
```

4、ip_hash

nginx 会让相同的客户端IP请求相同的服务器。
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080;
    server 192.168.91.129:8080;
    ip_hash;
}
```

nginx 负载均衡配置的几个状态参数：

* down：表示当前 server 暂时不参与负载均衡。
* backup：预留的备份机器，当其他所有的非 backup 机器出现故障或者忙的时候，才会请求 backup 机器，因此这台机器的压力最轻。
* max_fails：允许请求失败的次数，默认为：1。当超过最大次数时，返回 proxy_next_upstream 模块定义的错误。
* fail_timeout：在经历了 max_fails 次失败后，暂停服务的时间。max_fails 可以和 fail_timeout 一起使用。
 
示例如下：
```markdown
upstream xdhuxc {
    server 192.168.91.128:8080 weight=2 max_fails=2 fail_timeout=2;
    server 192.168.91.129:8080 weight=1 max_fails=2 fail_timeout=1;
}
```

### nginx 中 location 的写法

#### location 基础知识
1、location 是在 server 块中配置的。

2、可以根据不同的 URI 使用不同的配置（location 中配置），来处理不同的请求。

3、location 是有顺序的，会被第一个匹配的 location 处理。

#### location 配置语法
```markdown
location [ = | ~ | ~* | ^~ ] uri {...}
或
location @name {...}
```
#### location 配置可以有两种配置方法
1、前缀 + uri （字符串/正则表达式）

2、@ + name

#### 前缀含义
```markdown
=：精确匹配，必须全部相等。
~：大小写敏感。
~*：忽略大小写。
^~：只需匹配 uri 部分。
@：内部服务跳转。
```

#### location 配置示例
（1）=，精确匹配
```markdown
location = / {
    # 规则
}
```
匹配到 http://www.xdhuxc.com/  这种请求。

（2）~，大小写敏感
```markdown
location ~ /getUser/ {
    # 规则
}
```
http://www.xdhuxc.com/getUser/ 请求成功

http://www.xdhuxc.com/GetUser/ 请求失败

（3）~*，大小写忽略
```markdown
location ~* /getUser/ {
    # 规则
}
```
这种写法会忽略 uri 部分的大小写

http://www.xdhuxc.com/getUser/ 请求成功

http://www.xdhuxc.com/GetUser/ 请求成功

（4）^~，只匹配以 uri 开头
```markdown
location ^~ /image/ {
    # 规则
}
```
以 /image/ 开头的请求，都会匹配上

http://xdhuxc.com/image/abc.jpg 请求成功

http://xdhuxc.com/image/cde.mp4 请求成功

5、@，nginx 内部跳转
```markdown
location /image/ {
    error_page 404 @image_error;
}

location @image_error {
    # 规则
}
```
以 /image/ 开头的请求，如果链接的状态为 404，则会匹配到 @image_error 这条规则上。
