+++
title = "Consul 的基本使用"
date = "2019-08-20"
description = ""
tags = [
    "Consul"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 consul 的部署及配置和基本使用。

<!--more-->

### 基于 docker 安装 consul
1、使用 docker 安装 consul
```markdown
docker pull consul
```
2、启动容器
```markdown
docker run -d --name=consul --network=host -e CONSUL_BIND_INTERFACE=eth0 consul
```

### 原生方式安装 consul
1、下载 [安装包](https://www.consul.io/downloads.html)
```markdown
wget https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip
```

2、解压
```markdown
unzip consul_1.6.2_linux_amd64.zip 
```

3、启动 consul

1）添加执行权限并移动 consul 到 /usr/bin 目录下
```markdown
chmod +x consul && cp consul /usr/bin
```

2）配置 consul.service（/usr/lib/systemd/system/consul.service），文件内容为：
```markdown
[Unit]
Description=confd
Documentation=http://www.consul.io/
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/consul agent -dev -client 0.0.0.0 -ui

Restart=always

[Install]
WantedBy=multi-user.target
```
agent 启动参数说明：

* -dev：以开发环境模式运行，这种模式下 consul节点既是 client，也是 server
* -client：指定客户端访问的地址，客户端通过 RPC，DNS，HTTP，gRPC 访问都需要用这个地址，可以指定其为：0.0.0.0 绑定所有客户端地址
* -ui：启动内置的 UI Web 服务
* -bind：指定 consul 集群节点之间通信的地址
* -data-dir：指定 consul 节点存放数据的目录
* -bootstrap-expect：指定期望的 server 节点数量

3）启动 consul
```markdown
systemctl daemon-reload && systemctl restart consul
```

### 读写数据
1）添加或更新数据
```markdown
consul kv put xdhuxc/consul/1 dc1
```

2）查询数据
```markdown
consul kv get xdhuxc/consul/1
或
consul kv get --detailed xdhuxc/consul/1
或 
consul kv get -recurse # 查询所有数据
```

3）删除数据
```markdown
consul kv delete xdhuxc/consul/1
```

### 常用命令
1、查看集群成员
```markdown
consul members 
```
如果想知道更详细的信息，可以添加 `--detailed` 参数来获得

2、停止 consul agent
```markdown
consul leave
```

### 参考资料

官方安装指南 https://www.consul.io/docs/install/index.html

https://www.jianshu.com/p/f4e2b2aabd21
