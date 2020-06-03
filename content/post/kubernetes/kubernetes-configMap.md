+++
title = "Kubernetes ConfigMap 使用"
date = "2020-05-29"
lastmod = "2020-05-29"
tags = [
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客介绍下 kubernetes ConfigMap 的一些用法。

<!--more-->

### ConfigMap 简介

在 Kubernetes 中，应用程序都被打成镜像，会有很多需要自定义的参数和配置，例如，资源的消耗、日志的级别和位置等，这些配置可能会有很多。Kubernetes 提供了 ConfigMap 来实现向容器中提供配置文件或环境变量来实现配置的注入，从而实现了应用配置和镜像的分离，使容器应用不依赖于配置。

利用 ConfigMap 可以解耦部署与配置的关系，对于同一个应用部署文件，可以使用 valueFrom 字段引用一个在测试环境和生产环境都有的 ConfigMap，这样就可以降低环境管理和部署的复杂度。

ConfigMap 是 kubernetes 中的一种资源，主要用于保存配置文件等信息。其声明格式如下：
```markdown
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app: kubernetes-transform
  name: kubernetes-transform-cm
  namespace: xdhuxc
data:
  config.prod.yaml: |-
    addr: 8080
    env: "prod"
    app: "kubernetes-transform"
    debug: false
    db:
      host: "127.0.0.1:3306"
      user: "root"
      password: "IAmRoot"
      name: "xdhuxc"
      log: true
      maxIdleConns: 10
      maxOpenConns: 100
```
保存为 kubernetes-transform-cm.yaml

使用如下命令创建 ConfigMap：
```markdown
kubectl create -f kubernetes-transform-cm.yaml
```


### ConfigMap 引用

可以通过三种方式来引用 ConfigMap：
* 环境变量方式
* 命令行参数
* 配置文件方式

#### 环境变量方式

通过如下方式从 ConfigMap 中引用环境变量：
```markdown
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    env:
    - name: app
      valueFrom:
        configMapKeyRef:
          name: app
          key: app

```

#### 命令行参数

```markdown
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    command: ["/bin/sh", "-c", "echo $(PROJECT) ${ENV}"]
    env:
    - name: PROJECT
      valueFrom:
        configMapKeyRef:
          name: kubernetes-transform-cm
          key: project
    - name: ENV
      valueFrom: 
        configMapKeyRef:
          name: kubernetes-transform-cm
          key: env
```
以上配置会将 ConfigMap kubernetes-transform-cm 中的 project，env 的值分别赋给环境变量 PROJECT，ENV



#### 配置文件方式

通过如下方式将单个文件保存到 Pod 中指定目录下，且不影响该目录下其他文件和目录，注意 subPath 的使用。

```markdown
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: java-build-container
    image: xdhuxc.com/java-maven-build:3.6.4
    imagePullPolicy: Always
    volumeMounts:
    - mountPath: /usr/bin/docker
      name: docker
      readOnly: true
    - mountPath: /var/run/docker.sock
      name: docker-sock
      readOnly: true
    - mountPath: /root/.password/
      name: docker-login
    - mountPath: /root/.ssh/
      name: jenkins-ssh-key
    - mountPath: /root/.m2/
      name: java-package-cache
    - mountPath: /root/.m2/settings.xml
      name: sonarqube-maven-settings
      subPath: settings.xml
    tty: true
  imagePullSecrets:
  - name: default-secret
  volumes:
  - name: docker
    hostPath:
      path: /usr/bin/docker
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
  - name: docker-login
    configMap:
      name: docker-login
  - name: jenkins-ssh-key
    secret:
      secretName: jenkins-ssh-key
      defaultMode: 384
  - name: java-package-cache
    persistentVolumeClaim:
      claimName: jenkins-package-cache
  - name: sonarqube-maven-settings
    configMap:
      name: sonarqube-maven-cm
      items:
      - key: settings.xml
        path: settings.xml
```



### 注意事项

使用 ConfigMap 时，需要注意如下事项：

* ConfigMap 必须在 Pod 之前创建，如果引用了一个不存在的 ConfigMap，则创建 Pod 时会报错
* ConfigMap 属于某个特定的命名空间，只有处于相同命名空间中的 Pod 才可以引用它
* 如果以挂载卷的形式挂载到容器内部，只能挂载到某个目录下，该目录下原有的文件会被覆盖
* 静态 Pod 不能使用 ConfigMap
* ConfigMap 中的配额管理尚未实现
* 更新 ConfigMap 后，如果是以目录方式挂载的，会自动将挂载的存储卷更新；如果是以文件形式挂载的，则不会自动更新，需要重启 Pod，但是注意可能会有时延


### 参考资料



