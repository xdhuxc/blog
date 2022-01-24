+++
title = "Java 常见问题及解决"
date = "2018-11-22"
lastmod = "2018-12-22"
description = ""
tags = [
    "Java"
]
categories = [
    "Java"
]
+++

本篇博客记录了些在 Java 开发过程中常见的问题及解决方法，以备后查。

<!--more-->

### Linux 下验证码无法显示问题
现象： 

web 应用在 windows 和 开发 Linux 服务器验证码显示正常，部署到新的生产 Linux 服务器上，验证码无法显示

异常日志：
```markdown
Can't connect to X11 window server
```

问题原因：

Java 在图形处理时调用了本地的图形处理库。在利用 Java 做图形处理（比如，图片缩放、图片签名、生成报表），如果运行在 windows 上不会出问题。如果将程序移植到 Linux/Unix 上，有可能出现图形不能显示的错误，这是由于 Linux 的图形处理需要一个 X server 服务器。

问题解决方法：

1、检查 JDK 版本，不能使用 OpenJDK。

2、在 Tomcat 中，修改 catalina.sh，加入如下行：
```markdown
JAVA_OPTS="-Djava.awt.headless=True"
```
如果名字为 java.awt.headless 的系统属性被设置为 True，那么 headless 工具包就会被使用。应用程序可以执行如下操作：

* 创建轻量级组件。
* 收集关于可用的字体、字体指标和字体设置的信息。
* 设置颜色来渲染准备图片。
* 创造和获取图像，为渲染准备图片。
* 使用 java.awt.PrintJob，java.awt.print.* 和 javax.print.* 类里的打印方法。

3、在 Jetty 中，修改 jetty.sh 中 JAVA_OPTIONS 参数，加入如下内容：
```markdown
JAVA_OPTIONS+=("-Djava.awt.headless=True")
```

4、终极解决
一般是在程序开始激活 headless 模式，告诉程序，现在要工作在 Headless 模式下，就不要指望硬件帮忙了，得依靠系统的计算能力模拟出这些特性来
```markdown
public void init(ServletConfig config) throws ServletException {
    super.init(config);
    height = Integer.parseInt(getServletConfig().getInitParameter("height"));
    width = Integer.parseInt(getServletConfig().getInitParameter("width"));
    System.setProperty("java.awt.headless", "True");
}
```

### web.xml is missing and <failOnMissingWebXml> is set to true
使用 `maven` 构建工程时，`pom.xml` 报错如下，提示如下：
```markdown
web.xml is missing and <failOnMissingWebXml> is set to true
```
在 `pom.xml` 文件中添加如下内容：
```markdown
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-war-plugin</artifactId>
            <version>3.2.0</version>
            <configuration>
                <failOnMissingWebXml>false</failOnMissingWebXml>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
运行程序时，报错如下：
```markdown
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
```
原因：`log4j` 和 `sl4j` 的版本不匹配，或是缺少 `jar` 包，使用下面这组：
```markdown
<slf4j-log4j12.version>1.7.25</slf4j-log4j12.version>
<slf4j-api.version>1.7.25</slf4j-api.version>
<log4j.version>1.2.17</log4j.version>
<slf4j-nop.version>1.7.25</slf4j-nop.version>
<slf4j-simple.version>1.7.5</slf4j-simple.version>

<!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-log4j12 -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>${slf4j-log4j12.version}</version>
    <scope>test</scope>
</dependency>

<!-- https://mvnrepository.com/artifact/log4j/log4j -->
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>${log4j.version}</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-api -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>${slf4j-api.version}</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-nop -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-nop</artifactId>
    <version>${slf4j-nop.version}</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-simple</artifactId>
    <version>${slf4j-simple.version}</version>
</dependency>
```

### Caused by: java.nio.charset.MalformedInputException: Input length = 1

程序运行时，报错如下：
```markdown
Caused by: java.nio.charset.MalformedInputException: Input length = 1
```
原因：当输入字节序列对于给定 `charset` 来说是不合法的，或者输入字符序列不是合法的 `16` 位 `Unicode` 序列时，抛出此经过检查的异常。

解决：将当前配置文件的编码设置为 `UTF-8`。
