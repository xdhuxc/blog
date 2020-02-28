+++
title = "AlertManager 报警收敛的若干种方法"
date = "2020-02-27"
lastmod = "2020-02-27"
tags = [
    "DevOps",
    "AlertManager"
]
categories = [
    "技术"
]
+++

本篇博客介绍了 `AlertManager` 报警收敛的若干种方法。

<!--more-->

### 背景

当一个监控-告警系统建立起来后，告警系统将会面临这样的问题：警报消息太多，接收人很容易麻木，不再继续理会，关键的告警常常被淹没。

对于这一问题，`AlertManger` 提供了非常好的解决方案。`Prometheus` 把一条告警信息发送给了 `AlterManager`，`AlterManager` 并不是简简单单地直接发送出去，而是对告警信息进行了一些诸如分组、延时等收敛处理。

对报警收敛的支持，`AlertManager` 提供了以下四种方式：
* 分组
* 抑制
* 静默
* 延时


### 告警分组

告警分组是通过对具有相同属性值的告警进行分组聚合，可以有效的减少告警消息的数量。

对应 `AlertManager` 的配置，通过 `route` 部分的 `group_by` 字段对具有相同属性的告警进行分组聚合。
```markdown
route:
  # AlertManager 将会把具有相同 alertname 的告警分到相同的组  
  group_by: ['alertname']
```


### 告警抑制 

当告警发出后，停止重复发送由此告警引发的其他告警。一般是由更高级别的告警抑制低级别的告警。这可以消除冗余的告警，仅发送关键警报，避免误导运维排查问题的方向。

在 `AlertManager` 的配置中，通过 `inhibit_rules` 部分来配置
```markdown
inhibit_rules:
  - source_match:        # source_match：匹配当前告警发生后其他告警抑制掉
      severity: 'critical'
    target_match:        # target_match：抑制告警
      severity: 'warning'
    equal: ['alertname'] # equal：只有包含指定标签才可成立规则
```
以上配置告诉 `AlertManager`，对于具有相同 `alertname` 的告警，含 `severity: 'critical'` 标签的告警将会抑制含 `severity: 'warning'` 标签的告警。

  
### 告警静默

对可预期的告警，在特定时间段阻止告警的发送，比如，线上环境资源调整或上线，可能会导致告警，此时，可以增加告警静默，阻止相关的告警发送。

可以在 `http://localhost:9093/#/silences` 中进行创建。


### 告警延时

当故障发生时，若故障未能及时解决，频繁地发送告警是令人崩溃的。`group_wait` 把开始产生的告警收集起来，最后作为一条告警信息发送出来，`repeat_interval` 可以将重复的告警以更大的时间间隔发送。

在 `AlertManager` 的配置中进行如下配置：
```markdown
route:
  group_wait: 60s       # 分组等待的时间为 60 秒，收到告警后并不是马上发送出去，看是否还有具有 alertname 这个标签的报警发过来，如果有的话，一起发出报警
  group_interval: 60s   # 上一组报警与下一组报警的间隔时间为 60 秒
  repeat_interval: 15m  # 重复报警时间
```


### 其他方式

我们也可以考虑把告警信息都收集起来，做统计分析。一来要求业务团队改造程序或结构，调整资源配置，比如有些代码写得性能特别差，资源占用高，导致告警信息频繁发送；二来可以作为我们设置各种资源阈值的统计参考数据，取代常用的经验值或习惯值，比如，根据历史报警数据的统计，采取百分位数，使得某告警在 `95%` 的情况下不再发送告警信息。


### 总结和思考

做好告警的收敛是很有必要的，也有多种方法。借助于 `AlertManager`，我们可以通过分组、抑制、静默和延时等方法来做告警的收敛。

就 `AlertManager` 而言，在告警抑制上，我们还可以考虑更多的告警抑制规则，比如，在多种告警级别（`critical`、`emergency`、`warning`等）的情况下，每一种高级别告警抑制所有比它低的级别的告警；在告警延时上，高级别告警的延时参数缩短，低级别告警的延时参数增长。

另外，基于统计数据按周、月生成告警报告，改进应用程序和架构，合理设置阈值，更好和更准确地报警。 

















