+++
title = "ElasticSearch 的安装及配置和密码设置等"
date = "2020-03-03"
lastmod = "2020-03-03"
tags = [
    "ElasticSearch",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 ElasticSearch 的安装及配置，密码设置等配置要点。

<!--more-->

### 安装 ElasticSearch

1、下载 `ElasticSearch` 的安装包
```markdown
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.1-x86_64.rpm
```
2、安装 `ElasticSearch`
```markdown
rpm -ivh elasticsearch-7.6.1-x86_64.rpm
```
3、启动 ElasticSearch 
```markdown
systemctl restart elasticsearch
```

由于 `ElasticSearch` 的密码管理是用 `x-pack` 来实现的，安装时，x-pack 默认是不启用的，需要开启。

在配置文件 `elasticsearch.yml`（默认路径为：`/etc/elasticsearch/elasticsearch.yml`） 中增加如下配置：
```markdown
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
``` 

假设 `10.20.13.15` 为机器 IP 地址，需要在外部访问时，需要配置如下内容
```markdown
network.host: 10.20.13.15
http.port: 9200
discovery.seed_hosts: ["10.20.13.15"]
```

修改后重启 `ElasticSearch`

### 设置密码

进入 ElasticSearch 的二进制文件目录下，使用交互式命令行来设置密码

```markdown
[root@localhost /usr/share/elasticsearch/bin]# ./elasticsearch-setup-passwords interactive
Initiating the setup of passwords for reserved users elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user.
You will be prompted to enter passwords as the process progresses.
Please confirm that you would like to continue [y/N]y  # 输入 y


Enter password for [elastic]:      # 为 elasticsearch 设置密码
Reenter password for [elastic]:    # 再次输入 elasticsearch 的密码
Enter password for [apm_system]:   # 为 apm 设置密码
Reenter password for [apm_system]: # 再次输入 apm 的密码
Enter password for [kibana]:       # 为 kibana 设置密码
Reenter password for [kibana]:     # 再次输入 kibana 的密码
Enter password for [logstash_system]:   # 为 logstash 设置密码
Reenter password for [logstash_system]: # 再次输入 logstash 的密码
Enter password for [beats_system]:      # 为 beats 设置密码
Reenter password for [beats_system]:    # 再次输入 beats 的密码
Enter password for [remote_monitoring_user]:   # 为 remote_monitoring_user 设置密码
Reenter password for [remote_monitoring_user]: # 再次输入 remote_monitoring_user 的密码
Changed password for user [apm_system]
Changed password for user [kibana]
Changed password for user [logstash_system]
Changed password for user [beats_system]
Changed password for user [remote_monitoring_user]
Changed password for user [elastic]
[root@sgt-devops-2-test /usr/share/elasticsearch/bin]# 
```

或者使用 API 来设置
```markdown
curl -XPUT -u elastic 'http://10.20.13.15:9200/_xpack/security/user/elastic/_password' -d '{
  "password" : "yourpasswd"
}
```

`ElasticSearch` 的默认账户为 `elastic` 默认密码为 `changme`

### 可视化

使用 `ElasticHQ` 作为 `ElasticSearch` 的可视化工具

启动 `ElasticHQ`

```markdown
docker run -p 5000:5000 -d elastichq/elasticsearch-hq
```

访问：
```markdown
http://10.20.13.15:5000
```

使用如下方式连接 `elasticsearch`
```markdown
http://elastic:PASSWORD@10.20.13.15:9200
```

参考资料：

https://github.com/ElasticHQ/elasticsearch-HQ

https://www.elastic.co/guide/en/elasticsearch/plugins/current/index.html

http://docs.elastichq.org





