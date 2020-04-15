+++
title = "Grafana 常见问题及解决"
date = "2020-04-15"
lastmod = "2020-04-15"
tags = [
    "Grafana",
]
categories = [
    "技术"
]
+++

本篇博客介绍下在使用 Grafana 的过程中经常遇到的问题及解决方法。

<!--more-->

### 忘记密码

grafana 的默认用户名和密码为：admin/admin，配置在 `/etc/grafana/grafana.ini` 中，但如果修改了密码，后面又忘记了，就得重置密码。

grafana 的密码默认存储在 sqlite 中，位于 `/var/lib/grafana/grafana.db`，使用如下命令重置 grafana 密码为 admin/admin：
```markdown
sudo sqlite3 /var/lib/grafana/grafana.db
sqlite> update user set password = '59acf18b94d7eb0694c61e60ce44c110c7a683ac6a8f09580d626f90f4a242000746579358d77dd9e570e83fa24faa88a8a6', salt = 'F3FAxVm33R' where login = 'admin';
sqlite> .exit
```


