+++
title = "Maven 常用配置"
date = "2018-4-25"
lastmod = "2018-11-25"
description = ""
tags = [
    "Maven",
    "Java"
]
categories = [
    "Maven",
    "Java"
]
+++

本篇博客介绍了使用 maven 时的一些常用的配置。

<!--more-->

### 配置 maven 仓库
配置阿里云的 `maven` 仓库，在 `windows` 系统中，在 `apache-maven-3.5.2/conf/settings.xml` 中配置如下：
```markdown
<mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
</mirrors>
```
或者在 `pom.xml` 的 `repositories` 中添加如下配置
```markdown
<repositories>
    <repository>
        <id>aliyunmaven</id>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    </repository>
</repositories>
```

### Properties 的配置
```markdown
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
</properties>
```

### 设置 maven 工程使用的 Java 版本

#### 全局配置
在 `maven` 的安装目录下，`apache-maven-3.5.2/conf` 目录下的 `settings.xml` 文件中，在 `<profiles></profiles>` 之间添加如下内容：
```markdown
<profile>  
    <id>jdk18</id>  
    <activation>  
        <activeByDefault>true</activeByDefault>  
        <jdk>1.8</jdk>  
    </activation>  
    <properties>  
        <maven.compiler.source>1.8</maven.compiler.source>  
        <maven.compiler.target>1.8</maven.compiler.target>  
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>  
    </properties>   
</profile>
```

#### 局部配置
在该工程的pom文件中，添加如下内容：
```markdown
<build>  
    <plugins>  
        <plugin>  
            <groupId>org.apache.maven.plugins</groupId>  
            <artifactId>maven-compiler-plugin</artifactId>  
            <configuration>  
                <source>1.8</source>  
                <target>1.8</target>  
            </configuration>  
        </plugin>  
    </plugins>  
</build>
```

