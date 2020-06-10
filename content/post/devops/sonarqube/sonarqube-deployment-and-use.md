+++
title = "使用 SonarQube 来进行代码质量检查"
date = "2020-04-28"
lastmod = "2020-04-28"
tags = [
    "SonarQube",
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍 SonarQube 的部署和常用编程语言的应用，另外给出在 Kubernetes 中使用的方法。

<!--more-->


### SonarQube

SonarQube 是一个用于代码质量管理的开源平台，用于管理源代码的质量。同时 SonarQube 还对大量的持续集成工具提供了接口支持，可以很方便地在持续集成中使用 SonarQube。此外 SonarQube 的插件还可以对 Java 以外的其他编程语言提供支持，对国际化以及报告文档化也有良好的支持。

特性：

* 多语言的平台： 支持超过20种编程语言，包括Java、Python、C#、C/C++、JavaScript等常用语言
* 自定义规则： 用户可根据不同项目自定义Quality Profile以及Quality Gates
* 丰富的插件： SonarQube 拥有丰富的插件，从而拥有强大的可扩展性
* 持续集成： 通过对某项目的持续扫描，可以对该项目的代码质量做长期的把控，并且预防新增代码中的不严谨和冗余
* 质量门： 在扫描代码后可以通过对“质量门”的比对判定此次“构建”的结果是否通过，质量门可以由用户定义，由多维度判定是否通过


### 安装 PostgreSQL
```markdown
docker run -d \
    --name postgresql \
    --network=host \
    -p 5423:5423 \
    -e POSTGRES_PASSWORD=postgrs@2020 \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /root/postgresql/data:/var/lib/postgresql/data \
    postgres
```

创建 sonarqube 使用的数据库和用户
```markdown
CREATE DATABASE sonarqube;
```

请注意，生产环境不要使用容器来运行 PostgreSQL，最好是创建 sonarqube 用户并赋予其相应权限，可以参考：https://docs.sonarqube.org/latest/setup/install-server/

### 启动 SonarQube 容器

1、创建存储卷
```markdown
docker volume create --name sonarqube_data
docker volume create --name sonarqube_extensions
docker volume create --name sonarqube_logs
```
2、使用 PostgreSQL 启动 SonarQube 容器
```markdown
docker run -d --name sonarqube \
    --network=host \
    -p 9000:9000 \
    -e SONAR_JDBC_URL=jdbc:postgresql://10.20.0.18/sonarqube \
    -e SONAR_JDBC_USERNAME=postgres \
    -e SONAR_JDBC_PASSWORD=postgrs@2020 \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
    sonarqube
```

SonarQube 默认用户名/密码为：admin/admin

创建一个外部使用的 Token：
```markdown
Token 的生成方式：User > My Account > Security
```
scmp-sonarqube: 33f42c54b432a9124cb966f8b6dd06daeda6f12b


### Kubernetes 部署

部署到 kubernetes 中的 yaml 文件为：
```markdown
kind: Deployment
apiVersion: apps/v1
metadata:
  name: sonarqube
  namespace: sgt
  labels:
    app: sonarqube
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sonarqube
  template:
    metadata:
      labels:
        app: sonarqube
    spec:
      volumes:
        - name: sonarqube-data
          persistentVolumeClaim:
            claimName: sonarqube-data
        - name: sonarqube-extensions
          persistentVolumeClaim:
            claimName: sonarqube-extensions
        - name: sonarqube-logs
          persistentVolumeClaim:
            claimName: sonarqube-logs
      containers:
        - name: sonarqube
          image: "sonarqube:latest"
          env:
            - name: SONAR_JDBC_URL
              value: "jdbc:postgresql://10.20.0.18/sonarqube"
            - name: SONAR_JDBC_USERNAME
              value: "postgres"
            - name: SONAR_JDBC_PASSWORD
              value: "postgrs@2020"
          resources:
            limits:
              cpu: "1"
              memory: "2Gi"
            requests:
              cpu: "1"
              memory: "2Gi"
          ports:
            - containerPort: 9000
              name: sonarqube
          volumeMounts:
            - name: sonarqube-data
              mountPath: /opt/sonarqube/data
              subPath: data
            - name: sonarqube-extensions
              mountPath: /opt/sonarqube/extensions
              subPath: extensions
            - name: sonarqube-logs
              mountPath: /opt/sonarqube/logs
              subPath: logs
          imagePullPolicy: IfNotPresent
          livenessProbe:
            httpGet:
              path: /sessions/new
              port: 9000
            initialDelaySeconds: 600
      imagePullSecrets:
        - name: default-secret
      securityContext:
        fsGroup: 999
        runAsUser: 999
      terminationGracePeriodSeconds: 3600

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: sonarqube
  name: sonarqube
  namespace: sgt
spec:
  type: ClusterIP
  ports:
    - name: sonarqube-port
      port: 80
      targetPort: 9000
  selector:
    app: sonarqube
```
注意，内存至少2Gi，initialDelaySeconds 设置为 300 或 600 或更大点，否则程序尚未启动，就被 kubernetes 健康检查杀死

必须使用三个 PVC 来分别挂载 data，extensions，logs目录，如果只使用一个 PVC，使用 subPath 来区别，ES 会报各种各样的错误。

还可以增加环境变量：SONARQUBE_WEB_JVM_OPTS，指定额外的 JVM 参数。虽然官网说 SONARQUBE_JDBC_USERNAME, SONARQUBE_JDBC_PASSWORD, and SONARQUBE_JDBC_URL 会在未来弃用，但在 SONAR_VERSION=8.2.0.32929 时，docker 容器启动时，使用的环境变量名称分别为：SONAR_JDBC_URL，SONAR_JDBC_USERNAME，SONAR_JDBC_PASSWORD；而使用 kubernetes 时，则需要使用带 QUBE 的环境变量名称，否则不会使用我们提供的 PostgreSQL，而是使用默认的 H2 数据库。

```markdown
2020-04-27T13:55:28.492308527Z Caused by: java.nio.file.AccessDeniedException: /opt/sonarqube/data/es6
2020-04-27T13:55:28.49231103Z   at sun.nio.fs.UnixException.translateToIOException(Unknown Source) ~[?:?]
2020-04-27T13:55:28.49231393Z   at sun.nio.fs.UnixException.rethrowAsIOException(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492316385Z  at sun.nio.fs.UnixException.rethrowAsIOException(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492318764Z  at sun.nio.fs.UnixFileSystemProvider.createDirectory(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492321152Z  at java.nio.file.Files.createDirectory(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492323672Z  at java.nio.file.Files.createAndCheckIsDirectory(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492326051Z  at java.nio.file.Files.createDirectories(Unknown Source) ~[?:?]
2020-04-27T13:55:28.492328386Z  at org.elasticsearch.bootstrap.Security.ensureDirectoryExists(Security.java:413) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492330853Z  at org.elasticsearch.bootstrap.FilePermissionUtils.addDirectoryPath(FilePermissionUtils.java:68) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492333438Z  at org.elasticsearch.bootstrap.Security.addFilePermissions(Security.java:299) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492339522Z  at org.elasticsearch.bootstrap.Security.createPermissions(Security.java:254) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492342118Z  at org.elasticsearch.bootstrap.Security.configure(Security.java:123) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.49234464Z   at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:207) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492347213Z  at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:333) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492349763Z  at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:159) ~[elasticsearch-6.8.0.jar:6.8.0]
2020-04-27T13:55:28.492352443Z  ... 6 more
2020-04-27T13:55:28.614501888Z 2020.04.27 13:55:28 WARN  app[][o.s.a.p.AbstractManagedProcess] Process exited with exit value [es]: 1
2020-04-27T13:55:28.614954443Z 2020.04.27 13:55:28 INFO  app[][o.s.a.SchedulerImpl] Process[es] is stopped
2020-04-27T13:55:28.615619259Z 2020.04.27 13:55:28 INFO  app[][o.s.a.SchedulerImpl] SonarQube is stopped
```

解决：在 sonarqube pod 中加入如下内容：（注意是 Pod 级别的）
```markdown
securityContext:
  fsGroup: 999
  runAsUser: 999
```
ES 不能以 root 用户启动，sonarqube 用户在容器内的 uid 和 gid 是：999:999

如果 ES 索引报错，可以删除 /opt/sonarqube/data 目录下 的 es6 目录，然后重启 SonarQube

参考资料：

https://blog.csdn.net/qq_40460909/article/details/102797137

https://gitlab.com/afireinside/kubernetes-sonarqube

注意，SonarQube 官方文档一直强调不能在多个 SonarQube 实例上应用相同的存储卷


### Sonarqube 的使用

#### Java Maven 项目
1、在 ~/.m2/ 目录下创建 settings.xml 文件，内容如下：
```markdown
<settings>
    <pluginGroups>
        <pluginGroup>org.sonarsource.scanner.maven</pluginGroup>
    </pluginGroups>
    <profiles>
        <profile>
            <id>sonar</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <!-- Optional URL to server. Default value is http://localhost:9000 -->
                <sonar.host.url>http://10.20.13.120:9000</sonar.host.url>
            </properties>
        </profile>
     </profiles>
</settings>
```

2、运行命令进行代码检查
```markdown
maven clean install
maven sonar:sonar
```

结果报告：http://10.20.13.120:9000/dashboard?id=com.scmp:scmp-notify（组件 Key）

http://10.20.13.120:9000/api/ce/task?id=AXGmIOnNdU_TwfUPe-cA（任务 id）
```markdown
{
  task: {
    id: "AXGmIOnNdU_TwfUPe-cA",
    type: "REPORT",
    componentId: "AXGmDlrMdU_TwfUPe-bz",
    componentKey: "com.scmp:scmp-notify",
    componentName: "scmp-notify",
    componentQualifier: "TRK",
    analysisId: "AXGmIPDs509z86A1PbWI",
    status: "SUCCESS",
    submittedAt: "2020-04-23T08:21:47+0000",
    startedAt: "2020-04-23T08:21:48+0000",
    executedAt: "2020-04-23T08:21:50+0000",
    executionTimeMs: 1413,
    logs: false,
    hasScannerContext: true,
    organization: "default-organization",
    warningCount: 0,
    warnings: [ ]
  }
}
```


#### Java Gradle 项目

1、在 ~/.gradle/gradle.properties 文件中加入如下内容：
```markdown
# gradle.properties
systemProp.sonar.host.url=http://10.20.0.18:9000

#----- Token generated from an account with 'publish analysis' permission
systemProp.sonar.login=33f42c54b432a9124cb966f8b6dd06daeda6f12b
```

Token 的生成方式：User > My Account > Security

2、在项目的 build.gradle 目录中加入如下内容：
```markdown
plugins {
    id "org.sonarqube" version "2.7"
}
```

3、运行命令进行代码检查
```markdown
gradle sonarqube -Dsonar.projectName=scmp-gradle（项目在 SonarQube 中的项目名称） -Dsonar.projectKey=scmp-gradle（在 SonarQube 中的访问地址标识）
```

也可以直接在 build.gradle 中加入如下内容：
```markdown
sonarqube {
    properties {
        property "sonar.sourceEncoding", "UTF-8"
        property "sonar.projectKey", "java-spring-boot-gradle"  // 项目 ID，也即 SonarQube 中的项目路径
        property "sonar.projectName", "java-spring-boot-gradle" // 项目在 SonarQube 中的名称
    }
}
```
然后直接使用 `gradle sonarqube` 命令进行代码静态检测


#### golang（python） 项目
1、安装 sonar-scanner

1）下载适合所有平台的安装包（实际使用时使用 Linux 系统下的安装包）

2）添加 bin 到环境变量中
```markdown
export SONAR_SCANNER_HOME="/Users/xdhuxc/Applications/sonar-scanner-4.2.0"
export PATH="${PATH}:${SONAR_SCANNER_HOME}/bin/"
```

2、运行代码检测命令
```markdown
sonar-scanner \
  -Dsonar.projectKey=scmp-cicd \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://10.20.0.18:9000 \
  -Dsonar.login=33f42c54b432a9124cb966f8b6dd06daeda6f12b
```

在 SonarQube 中的访问地址为：http://10.20.0.18:9000/dashboard?id=scmp-cicd（为 sonar.projectKey 的值）


#### C/C++ 项目

1、将社区版的 C/C++ 插件下载到 `SONARQUBE_HOME/extensions/plugins/` 目录下，下载地址为：
```markdown
https://github.com/SonarOpenCommunity/sonar-cxx/releases
```
然后重启 SonarQube

2、从 `SonarCloud` 获取 `build-wrapper`，原来的从 `SonarQube` 服务器获取的方式已经失效
```markdown
wget https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip（Linux 系统）
或
wget https://sonarcloud.io/static/cpp/build-wrapper-macosx-x86.zip（MacOS 系统）
或
wget https://sonarcloud.io/static/cpp/build-wrapper-win-x86.zip（Windows 系统）
```

3、将 `build-wrapper-linux-x86` 加入到 `PATH` 路径下，并重命名为：`build-wrapper`

4、执行如下命令进行代码检查：
```markdown
build-wrapper --out-dir build_wrapper_output_directory make clean all（Linux 或 MacOS）
sonar-scanner \
  -Dsonar.sourceEncoding=UTF-8 \
  -Dsonar.projectKey=scmp-cxx-project \
  -Dsonar.projectName=scmp-cxx-project \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://10.20.0.18:9000 \
  -Dsonar.login=33f42c54b432a9124cb966f8b6dd06daeda6f12b
```
此处具体项目的使用方式可参考：

https://github.com/SonarSource/sonar-scanning-examples/tree/master/sonarqube-scanner-build-wrapper-linux


参考资料：

https://github.com/SonarOpenCommunity/sonar-cxx

https://github.com/SonarOpenCommunity/sonar-cxx/wiki/Installation

https://github.com/SonarOpenCommunity/sonar-cxx/wiki


### 本地使用
1、创建 token

2、下载对应平台的二进制文件
```markdown
https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873.zip
```
解压后将 sonar-scanner-cli-4.2.0.1873/bin 目录加入到 PATH 环境变量中

3、运行测试命令
在项目目录下，运行如下命令：
```markdown
sonar-scanner \
  -Dsonar.projectKey=scmp-cicd \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://10.20.0.18:9000 \
  -Dsonar.login=33f42c54b432a9124cb966f8b6dd06daeda6f12b
```

在 SonarQube 中的访问地址为：http://10.20.0.18:9000/dashboard?id=scmp-cicd（为 sonar.projectKey 的值）

scmp-sonarqube: 33f42c54b432a9124cb966f8b6dd06daeda6f12b


### 参数

常用参数含义：

* sonar.projectKey：项目唯一标识，将作为 dashboard URL 中的参数
* sonar.projectName：项目在 SonarQube 管理界面中的名称，最好取一个独特的唯一标识
* sonar.host.url：sonarqube 服务器的地址
* sonar.login：登录 sonarqube 服务器的 token，可在 `User > My Account > Security` 中创建，可以多个项目通用。
* sonar.sources：指定源代码目录
* sonar.sourceEncoding：源代码编码格式
* sonar.exclusions/sonar.test.exclusions：排除源代码目录下的目录和文件，支持通配符，可以使用分号分隔多个要排除的目录或文件模式
* sonar.inclusions/sonar.test.inclusions：只分析源代码目录中符合此通配符的文件和目录
* sonar.verbose=true：显示详细的 debug 日志信息

其他参数可参考：

https://docs.sonarqube.org/latest/analysis/analysis-parameters/

### 注意事项
1、sonar.exclusions 的表达式在 zsh 模式下会出问题，返回：
```markdown
zsh: no matches found: -Dsonar.exclusions=venv/**,templates/*.html
```
zsh 自作聪明地给解析这个表达式了，错误时直接返回，而不是把命令参数直接传递给 sonar-scanner，切换到 bash 下执行。

2、`-Dsonar.exclusions=venv/**,templates/*.html` 部分，可以使用逗号分隔多个目录或文件模式，但是逗号之间不能有空格，有空格时会报错：
```markdown
ERROR: Unrecognized option: templates/cloudfront.html
INFO:
INFO: usage: sonar-scanner [options]
INFO:
INFO: Options:
INFO:  -D,--define <arg>     Define property
INFO:  -h,--help             Display help information
INFO:  -v,--version          Display version information
INFO:  -X,--debug            Produce execution debug output
```

3、目录排除写法：
```markdown
venv/**（或者vendor/**）：排除 venv 目录，位于 venv 目录下的文件均不进行扫描
**/*.html（或者**/*.css）：排除所有目录下后缀为 .html 的文件
```

4、对于 golang，python 等项目的 vendor 或 venv 等目录，一定要使用 sonar.exclusions 参数排除掉该目录，不然，既消耗时间，也没价值。


### 其他事项

1、SonarQube 可以配置 webhook，当项目分析完毕时，可以通过 POST 请求发送数据到 URL。详细使用方法参考：http://10.20.0.18:9000/admin/webhooks

2、SonarQube 从 v7.9 之后，不再支持 MySQL，仅支持 PostgreSQL，Oracle，Microsoft SQL Server，具体原因见：https://community.sonarsource.com/t/end-of-life-of-mysql-support/8667

### 常见问题及解决

1、sonarqube 报如下警告：
```markdown
SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor in the project settings.
```

增加 `sonar.scm.disabled=true` 配置，禁用 SCM。


### 参考资料

SonarQube 官方常用编程语言静态代码检查示例：https://github.com/SonarSource/sonar-scanning-examples

https://www.zhang21.cn/2019/02/22/SonarQube/
