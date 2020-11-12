+++
title = "nginx 常见问题及解决"
date = "2017-12-29"
lastmod = "2018-01-29"
tags = [
    "Nginx"
]
categories = [
    "技术"
]
+++

本篇博客记录了 nginx 使用时常见的问题及解决方法。

<!--more-->

1、启动nginx时，报错如下：
```markdown
[root@xdhuxc nginx]# ./sbin/nginx -s reopen
nginx: [error] invalid PID number "" in "/var/run/nginx.pid"
[root@xdhuxc nginx]# ./sbin/nginx -s reload
nginx: [error] invalid PID number "" in "/var/run/nginx.pid"
```
解决：
执行如下命令即可：
```markdown
[root@xdhuxc nginx]# ./sbin/nginx -c conf/nginx.conf
[root@xdhuxc nginx]# ./sbin/nginx -s reload
```
