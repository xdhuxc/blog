+++
title = "部署 clickhouse_exporter"
date = "2019-06-25"
lastmod = "2019-07-08"
tags = [
    "ClickHouse"
]
categories = [
    "技术"
]
+++

本篇博客记录下部署 ClickHouse Exporter 的过程，使用 prometheus 监控 ClickHouse 时会用到。

<!--more-->

1、项目地址：https://github.com/f1yegor/clickhouse_exporter

2、下载该项目并编译为二进制文件，移动至 /usr/bin/ 目录下，并添加执行权限。

3、配置如下环境变量
```markdown
export CLICKHOUSE_USER="default"
export CLICKHOUSE_PASSWORD=""
```

4、以 Linux 系统服务方式启动之
```markdown
[Unit]
Description=Clickhouse Exporter
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/clickhouse_exporter -scrape_uri=http://192.168.33.10:8123/
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

或者可以基于 docker 容器方式部署
```markdown
docker run -d -p 9116:9116 f1yegor/clickhouse-exporter -scrape_uri=http://192.168.33.10:8123/
```
