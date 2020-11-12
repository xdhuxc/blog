+++
title = "使用 prometheus 监控 etcd"
date = "2019-03-12"
lastmod = "2019-09-10"
tags = [
    "etcd",
    "prometheus"
]
categories = [
    "技术"
]
+++

本篇博客介绍了使用 prometheus 监控 etcd 的配置方法，还包括在 grafana 中显示 etcd 指标图标，以及基于 AlertManager 的报警配置。

<!--more-->

### 使用 prometheus 监控 etcd 及报警

#### 前提条件

1、已经部署好 etcd 环境（单节点或集群）

2、已经部署好 prometheus

3、已经部署好 grafana 并配置了数据源，数据源类型为：Prometheus，数据源名称为：prometheus

#### 监控 etcd

grafana dashboard 配置：

使用 [etcd_rev3.json](https://grafana.com/api/dashboards/3070/revisions/3/download)文件，修改其中的 datasource 为 Prometheus 数据源的名称，在 grafana 中导入该文件，可以将该 dashboard 命名为：etcd-monitor

在 etcd 中未配置证书的情况下，在 prometheus.yml 文件中增加如下配置内容：
```markdown
global:
  scrape_interval:     15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['127.0.0.1:9090']
  - job_name: 'etcd'
    scheme: 'http'    # 默认为：http，所以此处可省略
    static_configs:
    - targets: ['172.27.126.226:2379', '172.27.126.227:2379', '172.27.126.228:2379'] # 以 YAML 数组方式填写 etcd 端点
```
重启 prometheus

在 `etcd` 中 配置证书的情况下，在 `prometheus.yml` 文件中增加如下配置内容：
```markdown
global:
  scrape_interval:     15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['127.0.0.1:9090']
  - job_name: 'etcd'
    scheme: 'https'   # 由于使用了证书，所以此处必须配置为：https
    tls_config:
      ca_file: '/etc/ssl/etcd/ca.pem'          # 这几处放置 etcd 证书文件路径，不能直接放置文件内容
      cert_file: '/etc/ssl/etcd/client.pem'
      key_file: '/etc/ssl/etcd/client-key.pem'
    static_configs:
    - targets: ['172.27.126.226:2379', '172.27.126.227:2379', '172.27.126.228:2379'] # 以 YAML 数组方式填写 etcd 端点
```
重启 prometheus

#### etcd 报警配置

在 prometheus.yml 中添加 [etcd3_alert.yml](https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/etcd3_alert.rules.yml) 文件路径
```markdown
alerting:
  alertmanagers:
  - static_configs:
    - targets: ["127.0.0.1:9093"]
rule_files:
  - '/data/prometheus/etcd3_alert.yml'
```



