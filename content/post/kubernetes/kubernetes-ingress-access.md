+++
title = "Kubernetes 中使用 Ingress 时的访问链路"
date = "2018-08-17"
lastmod = "2018-08-18"
tags = [
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客记录了在使用 Kubernetes 的 Ingress 时，应用的访问链路，这可以为应用访问不通时排查问题提供帮助。

<!--more-->

### 部署应用及 Ingress
使用如下所示的 YAML 文件部署 nginx 及其 Service 和 Ingress
```markdown
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          protocol: TCP
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          timeoutSeconds: 30
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          timeoutSeconds: 30

---
kind: Service
apiVersion: v1
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    targetPort: 80
    name: http
  selector:
    app: nginx

---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
          serviceName: nginx
          servicePort: 80
    host: xdhuxc.com
```

访问测试
```markdown
curl -Lv --resolve xdhuxc.com:80:${ingress-node-ip} xdhuxc.com
```
例如：
```markdown
curl -Lv --resolve xdhuxc.com:80:172.31.40.84 xdhuxc.com
```

### 访问链路
   域名           主机                    ingress         service         pod/容器  
xdhuxc.com -> 172.20.26.150:80 -> ingress-controller -> [service] -> 192.168.235.231:80 

### 参考资料

https://blog.csdn.net/cj2580/article/details/80017904#comments
