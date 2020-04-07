+++
title = "Go Template 的使用"
date = "2019-05-23"
lastmod = "2019-05-23"
description = ""
tags = [
    "Golang"
]
categories = [
    "技术"
]
+++

本部分内容记录下使用 golang 的模板时，需要注意的一些小问题。

<!--more-->

### if-else 语句

在我们的项目中，需要动态渲染 alertmanager 的配置文件。我们选择了 confd 作为工具来获取后台数据并渲染数据到模板中。

在模板渲染中，使用 if-else 语句的时候，当需要判断和某个字符串相等的时候，不能使用常用的 `==`，而是要使用 `eq` 函数，编写模板如下：
```markdown
receivers:{{range gets "/alertmanager/receivers/*"}}{{$item := json .Value}}
{{ if eq $item.type "dingtalk" }}
- name: {{$item.name}}
  dingtalk_configs:
  - send_resolved: {{$item.resolved}}
    webhook_url: {{$item.url}}
{{ else if eq $item.type "email" }}
- name: {{$item.name}}
  email_configs:
  - send_resolved: {{$item.resolved}}
    to: {{$item.url}}{{end}}
{{end}}
```
另外，这种写法可读性好，但是渲染后会多出来一些空行，改为如下模板即可：
```markdown
receivers:{{range gets "/alertmanager/receivers/*"}}{{$item := json .Value}}{{ if eq $item.type "dingtalk" }}
- name: {{$item.name}}
  dingtalk_configs:
  - send_resolved: {{$item.resolved}}
    webhook_url: {{$item.url}}{{ else if eq $item.type "email" }}
- name: {{$item.name}}
  email_configs:
  - send_resolved: {{$item.resolved}}
    to: {{$item.url}}{{end}}{{end}}
```
数据部分以 JSON 格式向模板传递。

### 注意事项

golang template 对于数组循环输出，空数组（数组长度为 0）不进行渲染
