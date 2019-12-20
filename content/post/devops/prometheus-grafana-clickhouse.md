+++
title = "使用 Grafana 监控 Clickhouse"
date = "2019-10-10"
lastmod = "2019-10-10"
tags = [
    "Grafana",
    "DevOps",
    "clickhouse"
]
categories = [
    "技术"
]
+++

公司有业务使用到了 Clickhouse，需要使用 prometheus 监控 Clickhouse，展示 Clickhouse 集群的指标信息，于是进行了一番探索，特此记录。

<!--more-->

使用 github 上的 https://github.com/f1yegor/clickhouse_exporter 项目提供的 clickhouse_exporter 来收集 Clickhouse 的指标信息。


1、克隆 clickhouse_exporter 工程到本地
```markdown
git clone https://github.com/f1yegor/clickhouse_exporter
```

2、编译
```markdown
make build
```
注意使用交叉编译的方式编译目标操作系统上的可执行文件，给文件添加执行权限后，移动至 /usr/bin 目录下

3、部署
以 Linux 系统服务方式运行 `clickhouse_exporter`，`clickhouse_exporter.service`（`/usr/lib/systemd/system/clickhouse_exporter.service`）文件内容为：：
```markdown
[Unit]
Description=clickhouse_exporter
Documentation=http://www.clickhouse_exporter.io/
After=network.target

[Service]
Type=simple
Environment="CLICKHOUSE_USER=default"
Environment="CLICKHOUSE_PASSWORD="
ExecStart=/usr/bin/clickhouse_exporter -scrape_uri=http://192.168.33.10:8123/
Restart=always

[Install]
WantedBy=multi-user.target
```
在非默认情况下，通过 `CLICKHOUSE_USER` 和 `CLICKHOUSE_PASSWORD` 环境变量指定 clickhouse 的认证信息；`http://192.168.33.10:8123/` 为 `clickhouse` 运行的端点

4、在 prometheus.yaml 文件中增加如下内容并重启
```markdown
global:
  scrape_interval:     1s
  evaluation_interval: 1s

scrape_configs:
  - job_name: clickhouse
    static_configs:
      - targets: ['127.0.0.1:9116']
```

`127.0.0.1:9116` 为 `clickhouse_exporter` 运行的端点，如果有多个，以 yaml 格式数组书写在 `targets` 处

5、向 grafana 中加入 clickhouse 仪表板

参考以下链接处的文档向 grafana 中加入 clickhouse 仪表板

https://grafana.com/grafana/dashboards/882


### 参考资料

https://github.com/f1yegor/clickhouse_exporter

https://grafana.com/grafana/dashboards/882
