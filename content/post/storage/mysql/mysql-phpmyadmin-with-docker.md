+++
title = "基于 docker 容器方式部署 MySQL 数据库管理工具 phpMyAdmin"
date = "2018-06-12"
lastmod = "2018-07-29"
tags = [
    "MySQL",
    "phpMyAdmin",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了基于 docker 容器方式部署 MySQL 数据库管理工具 phpMyAdmin 的方法。

<!--more-->

### phpmyadmin

`phpmyadmin` 是一个 `MySQL` 数据库管理工具，使用 `phpmyadmin` 实现在网页中连接、操作数据库，实现数据迁移。使用前，必须确保主机上数据库 `mysqld` 服务已经启动。

1、拉取 phpMyAdmin 镜像
```markdown
docker pull phpmyadmin/phpmyadmin
```

2、启动 phpMyAdmin 镜像

连接单个数据库时启动 phpmyadmin 容器
```markdown
docker run --name=myadmin -p 8080:80 -e PMA_HOST=192.168.244.128 -e MYSQL_ROOT_PASSWORD=286X326_h -d phpmyadmin
```
参数说明：
```markdown
PMA_HOST：待连接的 MySQL 数据库服务器所在主机；
MYSQL_ROOT_PASSWORD：MySQL 数据库 root 用户密码；
```

3、在同一个页面中连接多个数据库时启动 phpmyadmin 容器
```markdown
docker run --name=myadmin -p 8080:80 -e PMA_HOSTS=192.168.244.128,192.168.244.134 -e PMA_ARBITRARY=1 -d phpmyadmin
```
参数说明
```markdown
PMA_HOSTS：待连接的 MySQL 数据库所在主机 IP 地址，多个 IP 地址以 `,` 分隔；
PMA_ARBITRARY：允许连接多个 MySQL 数据库；
```
在
```markdown
/* Arbitrary server connection */                                     
if (isset($_ENV['PMA_ARBITRARY']) && $_ENV['PMA_ARBITRARY'] === '1') {                              
    $cfg['AllowArbitraryServer'] = true;                                                            
} 
```

4、访问 phpMyAdmin

访问地址为：
```markdown
http://172.20.1.161:8080
```
在启动容器时，更改端口后访问地址为：
```markdown
http://172.20.1.161:8090/
或
http://172.20.1.161:8090/index.php
```

在MySQL服务器所在主机上，以root用户登陆进去，执行如下命令，为用户赋予远程访问权限：
```markdown
GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.17.0.2' IDENTIFIED BY '286X326_h' WITH GRANT OPTION;
```
286X326_h为数据库root用户密码

### 将 phpMyAdmin 嵌入其他页面

进入容器中，复制 `/www/libraries/config.default.php` 到 `/www` 目录下
```markdown
cp /www/libraries/config.default.php /www/config.inc.php
```
更改 `/www/config.inc.php` 的配置参数
```markdown
$cfg['AllowThirdPartyFraming'] = true; 
```

修改 `/www/libraries/Header.php` 文件中的 sendHttpHeaders 函数，将 `X-Frame-Options `由 `deny` 改为 `ALLOW-FROM`，并加入待嵌入页面的地址，例如：`ALLOW-FROM http://123.103.9.208:6081/#outer/index/28`
```markdown
 if (! $GLOBALS['cfg']['AllowThirdPartyFraming']) {                                          
            header(                                                                                 
                'X-Frame-Options: ALLOW-FROM http://123.103.9.208:6081/#outer/index/28'             
            );                                                                                      
        }             
```

修改 `/www/js/cross_framing_protection.js` 文件中的内容如下所示：
```markdown
/* vim: set expandtab sw=4 ts=4 sts=4: */
/**
 * Conditionally included if framing is not allowed
 */
if (self == top) {
    document.documentElement.style.display = 'block';
    //var style_element = document.getElementById("cfs-style");
    // check if style_element has already been removed
    // to avoid frequently reported js error
    //if (typeof(style_element) != 'undefined' && style_element != null) {
    //    style_element.parentNode.removeChild(style_element);
    //}
} else {
    //top.location = self.location;
    document.documentElement.style.display = 'block';
}
```

### 参考资料

phpmyadmin同步功能 http://www.360doc.com/content/12/1204/15/1440938_252069458.shtml

嵌入其他页面，需要修改配置 http://blog.csdn.net/l6807718/article/details/51179507

解决问题的 http://vps.gl/vps/161.html

官方文档 https://docs.phpmyadmin.net/en/latest/setup.html#installing-using-docker

在centos中安装phpmyadmin，包括安装httpd，php http://www.cnblogs.com/xjxz/p/6550397.html



