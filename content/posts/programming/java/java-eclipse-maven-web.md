+++
title = "在 Eclipse 中部署基于 Maven 构建的 Java Web 项目"
date = "2018-08-24"
lastmod = "2018-08-24"
tags = [
    "Java",
    "Maven"
]
categories = [
    "技术"
]
+++

本篇博客记录了在 Eclipse 中部署基于 Maven 构建的 Java Web 项目的过程。

<!--more-->

### 使用 Tomcat 部署 Web 应用

#### Tomcat部分

下载解压 `apache-tomcat-8.0.47`，在Eclipse中添加 Tomcat 服务器（`Window`->`Preferences`->`Server`->`Runtime Environments`->`Add`->`Apache`->`Apache Tomcat v8.0`->`Next`->`Browse`->`apache-tomcat-8.0.47所在目录`->`Finish`）。

在`apache-tomcat-8.0.47/conf/tomcat-users.xml`中添加如下内容：
```markdown
<role rolename="admin-gui"/>
<role rolename="admin-script"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
# 用户信息
<user username="admin" password="admin123" roles="admin-gui,admin-script,manager-gui,manager-script,manager-jmx,manager-status"/>
```
#### Maven部分
下载解压 `apache-maven-3.5.2`，在Eclipse中添加Maven（`Window`->`Preferences`->`Maven`->`Installations`->`Add`->`Directory`->`apache-maven-3.5.2所在目录`->`选中自己添加的Maven`->`Finish`），

在`apache-maven-3.5.2/conf/settings.xml`中添加如下内容：
```markdown
<servers>
	<server>
      <id>tomcat</id> #随意起，没有特殊要求
      # username和password的与tomcat-users.xml中保持一致
      <username>admin</username> 
      <password>admin123</password>
    </server>
</servers>
```

在 `pom.xml` 文件中加入如下内容：（也适用于Tomcat 8）
```markdown
<build>
      <plugins>
        <plugin>
          <groupId>org.apache.tomcat.maven</groupId>
          <artifactId>tomcat6-maven-plugin</artifactId>
          <version>2.2</version>
          <configuration>
          	<url>http://localhost:8080/manager/text</url>
          	# server与settings.xml中的server保持一致
          	<server>tomcat</server>
          	# username和password的与tomcat-users.xml中保持一致
          	<username>admin</username>
          	<password>admin123</password>
          </configuration>
        </plugin>
        <plugin>
          <groupId>org.apache.tomcat.maven</groupId>
          <artifactId>tomcat7-maven-plugin</artifactId>
          <version>2.2</version>
          <configuration>
          	<url>http://localhost:8080/manager/text</url>
          	<server>tomcat</server>
          	<username>admin</username>
          	<password>admin123</password>
          </configuration>
        </plugin>
      </plugins>
</build>
```

#### 运行访问
在Eclipse中，右键点击项目名->`Run as`->`Maven Build`-> 在Goals中输入：`tomcat7:run`，点击`Run`启动Tomcat服务器。

常用的Goal

命令 | 描述
---|---
tomcat:deploy | 部署一个web war包
tomcat:reload |	重新加载web war包
tomcat:start | 启动tomcat
tomcat:stop | 停止tomcat
tomcat:undeploy | 停止一个war包
tomcat:run |	启动嵌入式tomcat ，并运行当前项目


### 使用 Jetty 部署 Web 应用

1、在Eclipse中安装Jetty插件

打开 Eclipse，`Help`->`Install New Software...`->在`Work with`后的输入框中输入`http://eclipse-jetty.github.io/update/`->遇Next则Next，遇Accept则Accept->重启Eclipse

2、在pom.xml中添加如下内容：
```markdown
<properties> #定义变量，常用于定义框架、jar包等的版本号和项目相关的名称
    <javaVersion>1.8</javaVersion>
    <springVersion>5.0.1.RELEASE</springVersion>
    <jettyVersion>9.4.7.v20170914</jettyVersion>  
</properties>  
<plugin>
	<groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>${jettyVersion}</version>
    <configuration>
    	<scanIntervalSeconds>10</scanIntervalSeconds>
	    <webApp>
	      <contextPath>/demonstrate</contextPath>
	    </webApp>
        <httpConnector>
            <port>8090</port> #项目发布的端口号，访问时即访问该端口
        </httpConnector>
    </configuration>
</plugin>
```
3、启动项目

在Eclipse中，右键点击项目名->`Run as`->`Maven Build`->在`Goals`中输入`jetty:run`->`Run`。

4、访问项目

在浏览器中，输入`http://localhost:8090/demonstrate`，回车后可访问首页。
