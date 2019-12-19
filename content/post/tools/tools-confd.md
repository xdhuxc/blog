+++
title = "配置拉取工具 confd 的使用及说明"
date = "2019-06-05"
lastmod = "2019-06-05"
tags = [
    "confd",
    "DynamoDB"
]
categories = [
    "confd",
    "DynamoDB"
]
+++

本篇博客主要介绍配置拉取工具 confd 的使用，以备后需。

<!--more-->

confd 可以从后台数据源拉取数据，以 golang 模板的方式编写配置文件，渲染到本地文件，这对于一些需要动态或定时更改配置文件的程序非常方便。但是，有些数据源具有发布/订阅的特性，可以向 confd 推送数据，另外一些，就只能采用定时拉取的方式了。

### confd 安装
下载二进制安装文件并复制到 PATH 目录下
```markdown
# 下载二进制文件
wget https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64
# 重命名该文件
mv confd-0.16.0-linux-amd64 confd
# 移动至 PATH 路径下
cp confd /usr/bin/
```

也可自行根据 [confd 源码](https://github.com/kelseyhightower/confd) 构建

### confd 配置及运行
1、创建 confdir，用于存放 confd 的配置文件和模板文件
```markdown
mkdir -p /etc/confd/conf.d    // 存放 confd 使用的配置文件
mkdir -p /etc/confd/templates // 用于存放模板文件，生成最终的配置文件
```

2、创建模板文件及其 confd 配置文件

模板文件 /etc/confd/templates/alertmanager.yaml.tmpl
```markdown
global:
  resolve_timeout: 5m
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 15m
  receiver: send_to_dingding_ai

  routes:{{range gets "/alertmanager/routes/*"}}{{$item := json .Value}} # 渲染 JSON 格式数据
  - match_re: {{range $key, $value := json $item.match_re}}
      {{$key}}: "{{$value}}"{{end}}
    continue: true  
    receiver: {{$item.receiver}}{{end}} # {{end}} 写在行尾，处理多余的空行，否则生成的文件中会有多余的空行
    # continue: true # 注意，continue 写在此处，会将数据渲染完毕后，只有一个 continue

inhibit_rules:
- source_match:
    severity: 'critical'
  target_match:
    severity: 'warning'
  equal: ['alertname']

receivers:{{range gets "/alertmanager/receivers/*"}}{{$item := json .Value}}{{ if eq $item.type "dingtalk" }} # 条件判断
- name: {{$item.name}}
  dingtalk_configs:
  - send_resolved: {{$item.resolved}}
    webhook_url: {{$item.url}}{{ else if eq $item.type "email" }}
- name: {{$item.name}}
  email_configs:
  - send_resolved: {{$item.resolved}}
    to: {{$item.url}}{{end}}{{end}}
```

在本地启动 DynamoDB 数据库实例，配置如下环境变量：（confd 需要使用这些环境变量）
```markdown
export AWS_REGION=ap-southeast-1
export DYNAMODB_LOCAL=http://localhost:8000
```

存储在 DynamoDB 中的数据格式为：
```markdown
{
  "key": "/xdhuxc/alertmanager/receivers/10",
  "value": "{\"name\":\"send_to_dingding_bigdata\",\"resolved\":false,\"type\":\"dingtalk\",\"url\":\"https://oapi.dingtalk.com/robot/send?access_token=238c10a8984980a1f34228cab29cbbdaaaceb80ef82ee125c96e3166628e2c44\"}"
}
```

```markdown
{
  "key": "/xdhuxc/alertmanager/routes/25",
  "value": "{\"receiver\":\"send_to_dingding_business\",\"match_re\":\"{\\\"namespace\\\": \\\"business\\\"}\"}"
}
```

这些数据由页面加入，以结构化数据存储到 mysql 中，再组织成 key-value 格式存储到 DynamoDB 中。

此处要特别注意 key 的组成方式和获取值得方式。key 由配置文件中的 tamplate 部分的 prefix + 模板中的前缀路径 + 记录在数据库中的 ID 组成

配置文件 /etc/confd/conf.d/alertmanager.yaml.toml
```markdown
[template]
prefix = "/xdhuxc"
src = "alertmanager.yaml.tmpl"
dest = "/tmp/alertmanager.yaml"
keys = [
    "/alertmanager"  # 需要获取数据的键
]
nodes = [
    ""
]

reload_cmd = "curl -X POST http://localhost:9093/-/reload" # 更新配置文件后重启进程的命令
```

3、启动 confd 进程
```markdown
confd -onetime -backend dynamodb -node http://localhost:8000 -table xdhuxc --log-level debug
```

4、最终渲染出来的配置文件内容为：
```markdown
global:
  resolve_timeout: 5m
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 15m
  receiver: send_to_dingding_ai

  routes:
  - match_re:
      namespace: "business"
    continue: true
    receiver: send_to_dingding_business

inhibit_rules:
- source_match:
    severity: 'critical'
  target_match:
    severity: 'warning'
  equal: ['alertname']

receivers:
- name: send_to_dingding_bigdata
  dingtalk_configs:
  - send_resolved: false
    webhook_url: https://oapi.dingtalk.com/robot/send?access_token=238c10a8984980a1f34228cab29cbbdaaaceb80ef82ee125c96e3166628e2c44
```

### 以 Linux 系统服务方式运行 confd
以 Linux 系统服务方式部署 confd，每 5 分钟拉取一次配置文件，confd.service 文件内容为：（/usr/lib/systemd/system/confd.service）
```markdown
[Unit]
Description=confd
Documentation=http://www.confd.io/
After=network.target

[Service]
Type=simple
Environment="AWS_REGION=ap-southeast-1"
Environment="DYNAMODB_LOCAL="
Environment="HOME=/root"
ExecStart=/usr/bin/confd -backend dynamodb -table xdhuxc --interval 300 --profile xdhuxc --log-level debug
Restart=always

[Install]
WantedBy=multi-user.target
```
以上使用 AWS DynamoDB 数据源作为示例，其他数据源可参考 [confd 配置指南](https://github.com/kelseyhightower/confd/blob/master/docs/configuration-guide.md) 修改环境变量和启动命令

当后端存储为 redis 时，confd.service（/usr/lib/systemd/system/confd.service）文件内容为：：
```markdown
[Unit]
Description=confd
Documentation=http://www.confd.io/
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/confd --backend redis --node 8.8.8.8:6379 --client-key qZ2$0bHBL --interval 300 --log-level debug
Restart=always

[Install]
WantedBy=multi-user.target
```

命令说明：

* --backend：指明数据源，默认为 etcd；
* -table：当数据源为 DynamoDB 时，指定 DynamoDB 表，仅用于数据源为 DynamoDB 时；
* --interval：后台轮询间隔，以秒为单位，默认值为：600；
* --profile：在使用 DynamoDB 作为数据源时，使用 AWS AccessKey 和 Secret Key 的 profile，防止和其他程序使用的 AccessKey 和 Secret Key 冲突，源代码中没有此选项，此处使用的是改造过的[代码](https://github.com/xdhuxc/confd)；
* --log-level：confd 日志级别，默认为： info；

添加如下 profile 到 ~/.aws/credentials 文件中
```markdown
[xdhuxc]
aws_access_key_id = '${AWS_ACCESS_KEY_ID}'
aws_secret_access_key = '${AWS_SECRET_ACCESS_KEY}'
```
该 profile 需要有读 AWS DynamoDB 的权限。

启动命令为：
```markdown
systemctl daemon-reload
systemctl restart confd
```

### 参考资料

https://github.com/kelseyhightower/confd


