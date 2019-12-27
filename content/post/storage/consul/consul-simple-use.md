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
ExecStart=/usr/bin/consul agent -dev

Restart=always

[Install]
WantedBy=multi-user.target
```

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
