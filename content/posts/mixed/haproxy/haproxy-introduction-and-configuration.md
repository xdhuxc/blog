+++
title = "HAProxy 及其配置详解"
date = "2019-05-14"
lastmod = "2019-5-18"
description = ""
tags = [
    "HAProxy"
]
categories = [
    "技术"
]
+++

本篇博客主要介绍了 HAProxy 及其配置的详细含义。

<!--more-->

### HAProxy

HAProxy 提供高可用性、负载均衡以及基于 TCP 和 HTTP 应用的代理，支持虚拟主机，是免费、快速并且可靠的一种解决方案。HAProxy特别适用于那些负载特大的 web 站点，这些站点通常又需要会话保持或七层处理。HAProxy 运行在当前的硬件上，完全可以支持数以万计的并发连接，并且它的运行模式使得它可以很简单、安全地整合进当前的架构中，同时可以保护 web 服务器不被暴露在网络上。

### HAProxy 配置

#### 配置部分

HAProxy 配置中分成五部分内容，分别如下：

1、global：参数是进程级的，通常是和操作系统相关，这些参数一般只配置一次，如果配置无误，就不需要再次进行修改。

2、defaults：配置默认参数，这些参数可以被用到 frontend、backend、Listen 组件。

3、frontend：接收请求的前端虚拟节点，Frontend 可以更加规则直接指定具体使用后端的 backend。

4、backend：后端服务集群的配置，是真实服务器，一个 Backend 对应于一个或者多个实体服务器。

5、Listen：Frontend 和 backend 的组合体。

#### haproxy.cfg
```markdown
### 全局配置信息 ###
# 参数是进程级的，通常和操作系统有关
global 
  maxconn 20480         # 默认最大连接数。
  log 127.0.0.1 local3  # 定义 haproxy 日志级别，可以为：err、warning、info、debug。
  chroot /var/haproxy   # chroot运行的路径。
  uid 99                # 运行haproxy进程的用户ID。
  gid 99                # 运行haproxy进程的用户组ID。
  daemon                # 以守护进程方式运行haproxy。
  nbproc 1              # 进程数量，可以设置为多个进程以提高性能。
  pidfile /var/run/haproxy.pid # haproxy进程的pid存放路径，启动进程的用户必须有权限访问此文件。
  ulimit -n 65535       # ulimit 的数量限制
### 默认配置选项 ###
# 参数可以被配置到frontend、backend和listen组件。
defaults
  log global
  mode http             # 所处理的类别，七层http，四层tcp。
  maxconn 20480         # 最大连接数。
  option httplog        # 日志类别，HTTP日志格式。
  option httpclose      # 每次请求完毕后主动关闭 http 通道。
  option dontlognull    # 不记录健康检查的日志信息。
  option forwardfor     # 如果后端服务器需要获得客户端的真实IP需要配置的参数，可以从 Http Header 中获取客户端IP。
  option redispatch     # serverId 对应的服务器挂掉后，强制定向到其他健康的服务器。
  option abortonclose   # 当服务器负载很高的时候，自动结束掉当前队列处理比较久的连接。
  stats refresh 30      # 统计页面刷新间隔。
  retries 3             # 3 次连接失败就认为服务不可用，也可以通过 “后面” 设置。
  balance roundrobin    # 设置默认的负载均衡方式，轮询方式。
  # balance source      # 设置默认的负载均衡方式，类似于 nginx 的 IP_Hash。
  # balance leastconn   # 设置默认的负载均衡方式，最小连接方式。
  contimeout 5000       # 连接超时时间。
  clitimeout 50000      # 客户端连接超时时间。
  srvtimeout 50000      # 服务器超时时间。
  timeout check 2000    # 心跳检测超时。
  
### 监控页面设置 ###
listen admin_status     # Fronted 和 Backend 的组合体，监控组的名称，按需求自定义名称。
  bind 0.0.0.0:65535    # 监听端口。
  mode http             #http 的七层模式。
  log 127.0.0.1 local3 err # 错误日志记录。
  stats refresh 5s      # 每隔5秒自动刷新监控页面。
  stats uri /admin?stats # 监控页面的url。
  stats realm xdhuxc\ xdhuxc # 监控页面显示信息。
  stats auth admin:admin     # 监控页面的用户名和密码，可以设置多个用户名。
  stats auth xdhuxc:xdhuxc   # 监控页面的用户名和密码xdhuxc/xdhuxc。
  stats hide-version         # 隐藏统计页面上的HAproxy版本信息。
  stats admin if TRUE        # 手工启用/禁用后端服务器（HAproxy-1.4.9以后版本）。
  
  errorfile 403 /etc/haproxy/errorfiles/403.http
  errorfile 500 /etc/haproxy/errorfiles/500.http
  errorfile 502 /etc/haproxy/errorfiles/502.http
  errorfile 503 /etc/haproxy/errorfiles/503.http
  errorfile 504 /etc/haproxy/errorfiles/504.http
  
  ### HAProxy 的日志记录内容设置
  capture request header Host len 40
  capture request header Content-Length len 10
  capture request header Referer len 200
  capture response header Server len 40
  capture response header Content-Length len 10
  capture response header Cache-Control len 8
  
  ### 网站监测 listen 配置
  ### 主要是监控 haproxy 后端服务器的监控状态
listen site_status
  bind 0.0.0.0:9090         # 监听端口
  mode http                 # http 的七层模式
  log 127.0.0.1 local3 err  # 日志级别
  monitor-uri /site_status  # 网站健康检查URL，用来检测HAproxy管理的网站是否可用，正常返回200，不正常返回503。
  acl site_dead nbsrv(server_web) lt 2 # 定义网站down时的策略，当挂在负载均衡上的指定backend中有效机器数小于1台时返回true。
  acl site_dead nbsrv(server_blog) lt 2
  acl site_dead nbsrv(server_bbs) lt 2
  monitor fail if site_dead  # 当满足策略的时候，返回503。
  monitor-net 192.168.16.2/32 # 来自192.168.16.2的日志信息不会被记录和转发
  monitor-net 129.168.16.3/32
  
  ### frontend 配置
  ### frontend配置里可定义多个acl进行匹配操作
frontend http_web_in
  bind 0.0.0.0:80  # 监听端口，即haproxy提供web服务的端口，和lvs的VIP端口类似。
  mode http        # http 的七层模式。
  log global       # 应用全局的日志配置。
  option httplog   # 启用http的log。
  option httpclose # 每次请求完毕后主动关闭http通道，HAProxy不支持keep-alive模式。
  option forwardfor # 如果后端服务器需要获得客户端的真实IP地址，需要配置此参数，将可以从Http header 中获得客户端IP。
  
  ### acl策略配置
  acl is_a hdr_beg(host) -i www.xdhuxc.org   # 判断域名是不是 www.xdhuxc.org，是则给予 a 服务器集群服务。
  acl is_b hdr_beg(host) -i www.xdhuxc.ocg # 判断域名是不是 www.xdhuxc.ocg，是则给予 b 服务器集群服务。
  
  use_backend a_server if is_a
  use_backend b_server if is_b
  
backend a_server
    mode http
    stats uri /haproxy
    balance roundrobin
    cookie JSESSIONID prefix
    stats hide-version
    option httpclose
    server web1 192.168.91.128:80 check
    server web2 192.168.91.129:80 check
    
backend b_server
    mode http
    stats uri /haproxy
    balance roundrobin
    cookie JSESSIONID
    stats hide-version
    option httpclose
    server web1 192.168.91.130 check
```

### 参考资料

http://blog.51cto.com/itnihao/915537
