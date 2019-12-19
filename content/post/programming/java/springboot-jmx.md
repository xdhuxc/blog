+++
title = "SpringBoot 应用启动报错，Unregistering JMX-exposed beans on shutdown"
linktitle = "SpringBoot 应用启动报错，Unregistering JMX-exposed beans on shutdown"
date = "2018-10-25"
lastmod = "2018-10-25"
description = ""
tags = [
    "SpringBoot",
    "JMX"
]
categories = [
    "SpringBoot",
    "JMX"
]
+++

本篇文章介绍了使用 `Spring Boot` 过程中遇到的一个错误及最终的解决方法，控制台输出的主要错误信息为：
```markdown
AnnotationMBeanExporter : Unregistering JMX-exposed beans on shutdown
```

<!--more-->

使用 `Spring Boot` 编写的Java 程序，其 `pom.xml`文件内容为：
```
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>1.5.13.RELEASE</version>
	</parent>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-mongodb</artifactId>
		</dependency>
	</dependencies>
```
运行该程序时，报错如下：
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::       (v1.5.13.RELEASE)

2018-05-19 16:34:04.386  INFO 3332 --- [           main] com.xdhuxc.cloud.MongodbApp              : Starting MongodbApp on DESKTOP-OC6TL9S with PID 3332 (E:\eclipse-workspace\xdhuxc-mongodb\target\classes started by wanghuan in E:\eclipse-workspace\xdhuxc-mongodb)
2018-05-19 16:34:04.389  INFO 3332 --- [           main] com.xdhuxc.cloud.MongodbApp              : No active profile set, falling back to default profiles: default
2018-05-19 16:34:04.430  INFO 3332 --- [           main] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@7b227d8d: startup date [Sat May 19 16:34:04 CST 2018]; root of context hierarchy
2018-05-19 16:34:06.069  INFO 3332 --- [           main] org.mongodb.driver.cluster               : Cluster created with settings {hosts=[192.168.91.128:27017], mode=SINGLE, requiredClusterType=UNKNOWN, serverSelectionTimeout='30000 ms', maxWaitQueueSize=500}
2018-05-19 16:34:06.536  INFO 3332 --- [           main] o.s.j.e.a.AnnotationMBeanExporter        : Registering beans for JMX exposure on startup
2018-05-19 16:34:06.545  INFO 3332 --- [           main] com.xdhuxc.cloud.MongodbApp              : Started MongodbApp in 2.436 seconds (JVM running for 2.755)
2018-05-19 16:34:06.545  INFO 3332 --- [       Thread-2] s.c.a.AnnotationConfigApplicationContext : Closing org.springframework.context.annotation.AnnotationConfigApplicationContext@7b227d8d: startup date [Sat May 19 16:34:04 CST 2018]; root of context hierarchy
2018-05-19 16:34:06.546  INFO 3332 --- [       Thread-2] o.s.j.e.a.AnnotationMBeanExporter        : Unregistering JMX-exposed beans on shutdown
```

使用搜索引擎搜索 `Unregistering JMX-exposed beans on shutdown`，
提出的方案基本都是显式添加 `tomcat` 的依赖，向 `pom.xml` 文件中加入如下内容：
```
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-tomcat</artifactId>
</dependency>
```
但是很遗憾，并没有起多大作用，还是报同样的错误。
最后，尝试着修改了一下 `Spring Boot` 的版本，降级试试，于是，修改 `pom.xml` 文件为：
```
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>1.5.12.RELEASE</version>
</parent>
```
终于可以正常启动 `Spring Boot` 程序了！


这应该是 `Spring Boot` `1.5.12.RELEASE` 的一个bug。
