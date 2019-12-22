+++
title = "Kubernetes 常见问题及解决"
date = "2018-11-17"
lastmod = "2018-11-18"
tags = [
    "Kubernetes"
]
categories = [
    "技术"
]
+++

本篇博客记录了在使用 Kubernetes 的过程中常见的问题及解决方法。

<!--more-->

1、使用 kubectl 命令时，要求输入用户名和密码

解决：删除 ~/.kube 目录下的 config 文件。

2、kubernetes 禁用 Swap 的原因

当前的 QOS 策略都是假定主机不启用内存 Swap。如果主机启用了 Swap，那么 QOS 策略可能会失效。

例如，两个 Pod 都刚好达到了内存限制上限，由于内存 Swap 机制，它们还可以继续申请使用更多内存，如果 Swap 空间不足，那么最终这两个 Pod 中的进程可能会被杀掉。

目前 Kubernetes 和 Docker 尚不支持内存 Swap 空间的隔离机制。

3、在node节点上使用kubectl命令时，报错如下：
```markdown
[root@k8s-172 ~]# kubectl get nodes
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
由提示可知，kubectl找不到master节点，所以，需要设置参数，让它找到master。

解决：

1）在node节点的/etc/profile文件中加入如下环境变量：
```markdown
export KUBERNETES_MASTER=http://192.168.91.128:8080
```
然后执行 `source /etc/profile` 或 `. /etc/profile` 命令使配置生效。

192.168.91.128为kubernetes集群master节点的IP地址。

2）在执行kubectl命令时，在命令中指定master的IP地址，如下所示：
```markdown
[root@k8s-172 ~]# kubectl -s http://172.20.27.207:8080 get nodes
NAME                STATUS    ROLES     AGE       VERSION
k8s-172.20.27.208   Ready     ingress   5h        v1.8.4
k8s-master          Ready     master    1d        v1.8.4
```

3）在 ~/.kube/config 中配置 kubectl 访问 API server 的地址
```markdown
mkdir ~/.kube/ && \cp -f /etc/kubernetes/admin.conf ~/.kube/config
```

4）在 /etc/kubernetes/admin.conf 中配置 kubectl 访问 API server 的地址

4、删除 pod 后，pod 一直处于 Terminating 状态，可以使用如下方法删除

1）强制删除该 pod
```markdown
kubectl delete pod aym91ga9-5c7c8ccc94-lfrfb -n c87e2267-1001-4c70-bb2a-ab41f3b81aa3 --grace-period=0 --force
```
2）删除该 pod 所在的 namespace
```markdown
kubectl delete namespace c87e2267-1001-4c70-bb2a-ab41f3b81aa3
```

5、删除 namespace 后，提示删除成功，但是却一直处于 Terminating 状态，
强制删除该 namespace 下的所有 pod，然后该 namespace 将会被系统自动删除。

6、应用部署完毕后，状态全部正常，但是访问却 504，

注意，不要使虚拟机的 IP 地址和 calico 的子网 IP 地址一样。如果有冲突，需要进行修改 calico.yaml 中环境变量 CALICO_IPV4POOL_CIDR 的值，修改为新的子网地址，然后删除原有的 calico，ingress 和 kube-dns，依次重新创建 calico，ingress，kube-dns
