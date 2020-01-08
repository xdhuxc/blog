+++
title = "Kafka 的部署和常用命令"
date = "2018-04-10"
lastmod = "2018-04-17"
tags = [
    "Kafka"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 Kafka 的部署和常用命令。

<!--more-->

### 部署 kafka

#### 原生方式部署 kafka

1、启动 `zookeeper` 的命令
```markdown
./bin/zookeeper-server-start.sh -daemon ./config/zookeeper.properties
```

2、`zookeeper.properties` 文件内容：
```markdown
dataDir=/xdhuxc/zookeeper/data
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=50
tickTime=2000
initLimit=10
syncLimit=5
```

3、启动 `kafka` 的命令：
```markdown
./bin/kafka-server-start.sh -daemon ./config/server.properties
```

在命令行模式下启动生产者
```markdown
./bin/kafka-console-producer.sh --broker-list 192.168.91.128:9092 --topic xdhuxc
```
在提示符后面输入消息

在命令行模式下启动消费者
```markdown
./bin/kafka-console-consumer.sh --zookeeper 192.168.91.128:2181 --topic xdhuxc --from-beginning
```

查看topic是否创建成功
```markdown
./bin/kafka-topics.sh --list --zookeeper 192.168.91.128:2181
```

#### docker 容器部署 kafka
使用如下命令启动 kafka 容器：
```markdown
docker run -d \
    --privileged=true \
    --restart=always \
    --net host \
    --name kafka \
    -p 9092:9092 \
    -e KAFKA_ADVERTISED_HOST_NAME=192.168.91.128 \
    -e KAFKA_ADVERTISED_PORT=9092 \
    -e KAFKA_MESSAGE_MAX_BYTES=2000000 \
    -e KAFKA_ZOOKEEPER_CONNECT=192.168.91.128:2181 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.91.128:9092 \
    -v /xdhuxc/kafka/data:/kafka \
    -v /xdhuxc/kafka/logs:/opt/kafka/logs \
    wurstmeister/kafka
```

### kafka 常用命令

1、创建 topic
```markdown
bin/kafka-topics.sh --create --zookeeper 192.168.91.128:2181 --replication-factor 1 --partitions 3 --topic locallog
```

2、查看 topic
```markdown
bin/kafka-topics.sh --list --zookeeper 192.168.91.128:2181
```
