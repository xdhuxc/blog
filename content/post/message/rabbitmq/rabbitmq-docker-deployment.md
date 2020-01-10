+++
title = "使用 docker 容器方式部署 RabbitMQ"
date = "2018-08-06"
lastmod = "2018-10-17"
tags = [
    "RabbitMQ",
    "Docker"
]
categories = [
    "技术"
]
+++

本篇博客介绍了使用 docker 容器方式部署 RabbitMQ 的方法。

<!--more-->

### 使用 docker 容器方式部署 RabbitMQ

1、拉取 rabbitmq 镜像
```markdown
docker pull rabbitmq:3.7.0
或
docker pull rabbitmq:3.7.0-management # 附带管理界面
```

2、启动 rabbitmq 容器
```markdown
docker run -d \
    --privileged=true \
    -p 4369:4369 \
    -p 5671:5671 \
    -p 5672:5672 \
    -p 25672:25672 \
    --net host \
    --name rabbitmq \
    -v /home/xdhuxc/rabbitmq/data:/var/lib/rabbitmq \
    rabbitmq:3.7.0
```
或 启动附带管理界面的 RabbitMQ 容器，修改默认的用户名和密码（guest/guest）
```markdown
docker run -d \
    --privileged=true \
    -p 4369:4369 \
    -p 5671:5671 \
    -p 5672:5672 \
    -p 15672:15672 \
    -p 25672:25672 \
    --net host \
    --name rabbitmq \
    -e RABBITMQ_DEFAULT_USER=xdhuxc \
    -e RABBITMQ_DEFAULT_PASS=123456 \
    -v /home/xdhuxc/rabbitmq/data:/var/lib/rabbitmq \
    rabbitmq:3.7.0-management
```
或
```markdown
docker run -d \
    --privileged=true \
    --net host \
    --name rabbitmq \
    -e RABBITMQ_DEFAULT_USER=xdhuxc \
    -e RABBITMQ_DEFAULT_PASS=123456 \
    -v /home/xdhuxc/rabbitmq/data:/var/lib/rabbitmq \
    rabbitmq:3.7.4-management
```

### 使用 Java 访问 RabbitMQ 
测试代码如下：

在 `pom.xml` 中添加如下依赖：
```markdown
<dependencies>
	<!-- https://mvnrepository.com/artifact/com.rabbitmq/amqp-client -->
	<dependency>
		<groupId>com.rabbitmq</groupId>
		<artifactId>amqp-client</artifactId>
		<version>5.2.0</version>
	</dependency>
	<!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-log4j12 -->
	<dependency>
		<groupId>org.slf4j</groupId>
		<artifactId>slf4j-log4j12</artifactId>
		<version>1.7.25</version>
		<scope>test</scope>
	</dependency>
</dependencies>
```

生产者代码示例：
```markdown
package com.xdhuxc.cloud.app;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

public class Producer {
	
	private final static String QUEUE_NAME = "xdhuxc";

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost("192.168.91.128");
		factory.setPort(5672);
		factory.setUsername("guest");
		factory.setPassword("guest");
		factory.setConnectionTimeout(50000);
		factory.setRequestedHeartbeat(60);
		factory.setVirtualHost("/");
		Connection conn = null;
		Channel channel = null;
		
		try {
			conn = factory.newConnection();
			channel = conn.createChannel();
			channel.queueDeclare(QUEUE_NAME, false, false, false, null);
			String message = "Hello World!";
			channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
			System.out.println("Sent " + message);
		} catch (IOException | TimeoutException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (channel != null) {
					channel.close();
				}
			} catch (IOException | TimeoutException e) {
				e.printStackTrace();
			}
		}
	}
}
```

消费者示例代码如下：
```markdown
package com.xdhuxc.cloud.app;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Consumer;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;
import com.rabbitmq.client.AMQP.BasicProperties;

public class Receiver {

	private final static String QUEUE_NAME = "xdhuxc";
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost("192.168.91.128");
		factory.setPort(5672);
		factory.setUsername("guest");
		factory.setPassword("guest");
		Connection conn = null;
		Channel channel = null;
		try {
			conn = factory.newConnection();
			channel = conn.createChannel();
			channel.queueDeclare(QUEUE_NAME, false, false, false, null);
			System.out.println("正在等待接收消息！");
			Consumer consumenr = new DefaultConsumer(channel) {
				@Override
				public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties properties,
						byte[] body) throws IOException {
					String message = new String(body, "UTF-8");
					System.out.println("Received " + message);
				}
			};
			channel.basicConsume(QUEUE_NAME, true, consumenr);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TimeoutException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (channel != null) {
					channel.close();
				}
			} catch (IOException | TimeoutException e) {
				e.printStackTrace();
			}
		}
	}
}
```

### 相关问题
1、启动 `rabbitmq` 容器时，报错如下：
```markdown
Error: Failed to initialize erlang distribution: 
{
	{
		shutdown,
		{
			failed_to_start_child,
			net_kernel,
			{
				'EXIT',
				nodistribution
			}
		}
	},
    {
		child,
		undefined,
		net_sup_dynamic,
		{	
			erl_distribution,
			start_link,
			[
				['rabbitmq-cli-24',shortnames],
				false
			]
		},
		permanent,
		1000,
		supervisor,
		[erl_distribution]
	}
}
epmd_close
Protocol 'inet_tcp': register/listen error:
```

解决：安装 `iptables` 和 `iptables.service`，然后关闭 `iptables`，重新启动 `rabbitmq` 容器即可。
