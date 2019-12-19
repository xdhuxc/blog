+++
title = "Kubernetes 常用命令总结"
date = "2018-08-14"
lastmod = "2018-09-07"
tags = [
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客记录下在 Kubernetes 中常用的命令，以备后需。

<!--more-->

### 查询

#### 查看日志命令

1）查看指定行数的日志
```markdown
kubectl logs --tail=5 dingtalk-callback-5ff4757745-g448n -n xdhuxc
```

2）查看指定时间段的日志
```markdown
kubectl logs --since=1h dingtalk-callback-5ff4757745-g448n -n xdhuxc
```

### 删除
1）删除状态为 Error 的 Pod
```markdown
kubectl get pods -n xdhuxc | grep Error | awk '{ print $1 }'| xargs kubectl delete pod -n xdhuxc
```
