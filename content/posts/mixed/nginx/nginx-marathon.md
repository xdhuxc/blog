+++
title = "nginx 配置 marathon "
date = "2017-08-26"
lastmod = "2017-10-22"
tags = [
    "Nginx"
]
categories = [
    "技术"
]
+++

本篇博客记录了配置 nginx 转发 marathon 管理页面到其他地址的方法。

<!--more-->

问题描述：

`marathon` 平时是带端口访问的，现在需要将其统一到 `80` 端口访问，使用 `nginx` 作为代理。

一般情况下，其访问地址为：
```markdown
http://172.20.17.4:8080
```

返回的显示地址为：
```markdown
http://172.20.17.4:8080/ui/#/apps
```
我们注意到，浏览器地址栏中变动的部分在 `/ui/#/` 之后

在 `nginx` 中配置如下
```markdown
server {
    listen 80;
    
    location ^~ /marathon/ {
        proxy_set_header Host $http_host;
        proxy_set_header X-Forward-For $proxy_add_x_forward_for;
        proxy_pass http://172.20.17.4:8080/;
    }
}
```
`8080` 后面的斜杠至关重要。

访问如下地址：
```markdown
http://172.20.17.4/marathon
```
浏览器地址栏显示：
```markdown
http://172.20.17.4/marathon/ui/#/apps
```

