+++
title = "Kubernetes 常用命令总结"
date = "2018-11-14"
lastmod = "2018-11-17"
tags = [
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客记录了在 Kubernetes 中常用的命令，以备后需。

<!--more-->

## 常用命令
> 以下操作均假设在含 kubelet 的节点上执行命令

### 集群信息
1、查看集群信息
```markdown
[root@k8s-master ~]# kubectl cluster-info
Kubernetes master is running at https://172.20.26.150:6443
KubeDNS is running at https://172.20.26.150:6443/api/v1/namespaces/kube-system/services/kube-dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

2、查看当前上下文
```markdown
[root@k8s-master ~]# kubectl config current-context
kubernetes-admin@kubernetes
```

3、查看各组件状态
```markdown
kubectl -s http://192.168.8.8:8080 get componentstatuses
```

4、获取 kubectl 版本信息
```markdown
kubectl version
```

5、获取集群信息
```markdown
kubectl cluster-info
```

### 标签操作
1、给 master 节点打标签
```markdown
kubectl label nodes xxxxxx node-role.kubernetes.io/master=
```

2、给 ingress 节点打标签
```markdown
kubectl label nodes k8s-172.20.27.215 node-role.kubernetes.io/ingress=
```

### 资源操作
1、查看所有的 deployment
```markdown
kubectl get deployment --all-namespaces
```

2、查看所有的命名空间
```markdown
kubectl -s http://172.20.27.207:8080 get pods --all-namespaces
```

3、查看当前节点状态
```markdown
kubectl get nodes
```
当 节点的 STATUS 为 ready 时，说明情况正常。

4、查看所有 pod 信息
```markdown
kubectl get pod --all-namespaces
```
当 pod 的 STATUS 为 running 时，说明情况正常。

5、查看指定命令空间下的pod
```markdown
kubectl get pod -n kube-system # 通过 -n 参数指定待查命名空间。
```

6、查看 pod 的详细情况
假定pod的名称为：ai2yzbme-8f7c9f77f-66cwv，所属命名空间为：kube-system
```markdown
kubectl describe pod ai2yzbme-8f7c9f77f-66cwv -n kube-system
```

7、查看 node 的情况
假设node的名称为：k8s-master
```markdown
kubectl describe node k8s-master
```

8、查看 ConfigMap
```markdown
kubectl get configMap -n kube-system
```

9、查看指定的 ConfigMap
```markdown
kubectl get configMap calico-config  -n kube-system -o yaml
```

10、创建资源对象
```markdown
kubectl create -f ./xdhuxc.yaml
kubectl create -f ./xdhuxc.yaml -f ./zabuqk.yaml
kubectl create -f ./xdhuxc
kubectl create -f http://xdhuxc/xdhuxc.yaml
```

11、显示带有标签 env=production 的所有 pod
```markdown
kubectl get pods -l env=production
```

12、列出所有的服务，并通过名称排序
```markdown
kubectl get services --sort-by=.metadata.name
```

13、给 pod 打标签
```markdown
kubectl label pods xdhuxc-message new-label=xdhuxc
```

14、给 pod 添加注解
```markdown
kubectl annotate pods xdhuxc-message icon-url=http://xdhuxc.com
```

15、扩容及缩容
```markdown
kubectl scale --replicas=3 deployment nginx
```

16、在已有 pod 里面运行命令，pod 中含有多个容器的情况下
```markdown
kubectl exec xdhuxc-message -c xdhuxc-message -- ls /
```

17、在已运行的 pod 里面运行命令，仅有一个容器的情况下
```markdown
kubectl exec xdhuxc-message -- ls / #
```

18、将服务转发到端口
```markdown
kubectl port-forward xdhuxc-message 8080
```

19、将 Pod 的端口转发到本地机器
```markdown
kubectl port-forward web-port 8080
```

20、以交互式 shell 运行 pod
```markdown
kubectl run -i --tty busybox --image=busybox -- sh
```

21、连接到运行着的容器里
```markdown
kubectl attach -i xdhuxc-message
```

22、 DNS 查找
```markdown
kubectl exec busybox -- nslookup kubernetes
kubectl exec busybox -- nslookup kubernetes.default
kubectl exec busybox -- nslookup kubernetes.default.svc.cluster.local
```

23、暴露服务
```markdown
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

24、查看指定ServiceAccount的token
```markdown
[root@k8s-master dashboard]# kubectl get ServiceAccount kubernetes-dashboard -n kube-system -o jsonpath="{.secrets[].name}"
kubernetes-dashboard-token-ncx5g
[root@k8s-master dashboard]# kubectl get secret kubernetes-dashboard-token-ncx5g -o jsonpath="{.data.token}"  -n kube-system  | base64 -d
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC10b2tlbi1uY3g1ZyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjgxMTZmNDE3LTlkNDctMTFlOC04NDVlLTA2MjY2ODAwMWYxNSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTprdWJlcm5ldGVzLWRhc2hib2FyZCJ9.OnhxsBYnuC47R9j411bq8d2NZDRWGMqUysC9rpITIy3r-4eTKNFL6Hf9jMQzIHME29re3PpKZ6EvV4n-VPTtL-PYbatXu5pegyX4jewQwCHn6VMzqJFaBN-hwK9wbY-1Mp63vZGEYZdRQYqB832SRyWwPoGGX8YSDa5dwk7hOJUJUBl4iBYpNt2nxxSTHgkqeh2QhzpaGZhgBx7c5UhfdNFRZVeQYns-k7f10c_36TuPmT98X3WSe7UEyAV1AhFu0b0z7WqUAAEJvRwxxEI0aYze3UWWGO9wr0sqzt7ZkhPy1GIQsLWOLO_g1vnviVaQcqhLiQU8ZNNjX2UqitF_eQ
```

25、强制删除 pod
```markdown
kubectl delete pod kubernetes-dashboard-55556f66c5-4zc77 -n kube-system --grace-period=0 --force
```
该命令也可以用于强制删除其他 kubernetes 资源。


### 日志查看
1）查看指定行数的日志
```markdown
kubectl logs --tail=5 dingtalk-callback-5ff4757745-g448n -n xdhuxc
```

2）查看指定时间段的日志
```markdown
kubectl logs --since=1h dingtalk-callback-5ff4757745-g448n -n xdhuxc
```

## 组合命令
1）删除状态为 Error 的 Pod
```markdown
kubectl get pods -n xdhuxc | grep Error | awk '{ print $1 }'| xargs kubectl delete pod -n xdhuxc
```
