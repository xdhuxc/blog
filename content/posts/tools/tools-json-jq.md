+++
title = "JSON 格式数据工具 JQ 的使用"
date = "2018-03-07"
lastmod = "2018-10-07"
tags = [
    "JSON"
]
categories = [
    "技术"
]
+++

本篇博客介绍下处理 JSON 格式数据的工具 JQ 的使用。

<!--more-->

### JQ 工具

#### CentOS 安装 JQ
```markdown
curl -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x ./jq
mv ./jq /usr/bin
```

#### JQ 语法
1、获取如下的 JSON 格式文件 xdhuxc.json 中 lastName 的值
```markdown
{
  "uid": "2378",
  "nameInfo": [
    {
      "firstName": "nova",
      "lastName": "jos"
    }
  ]
}
```
使用如下命令：
```markdown
cat xdhuxc.json | jq -r '.nameInfo[].lastName'
```

获取如下的 JSON 格式文件 xdhuxc.json 中 value 的值
```markdown
{
    "action": "get",
    "node": {
        "createdIndex": 356,
        "key": "token.key",
        "modifiedIndex": 356,
        "value": "abcdefg"
    }
}
```
使用如下命令：
```markdown
cat xdhuxc.json | jq -r '.node.value'
```
-r：该选项控制 jq 是输出 raw 格式内容或 JSON 格式内容。所谓 JSON 格式是指符合 JSON 标准的格式。例如，假设我们要查询 JSON 字符串 {"name":"tom"} 中 name 的值，使用 -r 选项时返回的是 tom，不使用 -r 选项时，返回的是 "tom"，返回值多了一对双引号。


