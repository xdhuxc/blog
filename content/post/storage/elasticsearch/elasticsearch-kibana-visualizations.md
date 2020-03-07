+++
title = "在 Kibana 中制作 AlertManager 相关的图表"
date = "2020-03-06"
lastmod = "2020-03-06"
tags = [
    "ElasticSearch",
    "AlertManager",
    "Kibana",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客介绍下如何在 `Kibana` 中制作图表，详细介绍其参数和方法。

<!--more-->

### 背景

我们将 `AlertManager` 中产生的报警存储到了 ES 中，接下来，需要制作报警图表，以可视化的方式观察报警的数量变化。


### Kibana 安装及配置
1、下载 `Kibana` 安装包
```markdown
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.6.1-x86_64.rpm
```

2、安装 `kibana`
```markdown
rpm -ivh kibana-7.6.1-x86_64.rpm
```

3、修改 `Kibana` 配置，修改 `/etc/kibana/kibana.yml` 文件中的如下配置项：
```markdown
server.port: 5601                                  # 指定 Kibana 进程运行的端口号，默认为：5601
server.host: "10.20.13.15"                         # 指定 Kibana 服务器绑定的主机
elasticsearch.hosts: ["http://10.20.13.15:9200"]   # 指定 Kibana 要连接的 ES 的地址
elasticsearch.username: "elastic"                  # 指定 Kibana 要连接的 ES 的用户名
elasticsearch.password: "AlertManager@2020"        # 指定 kibana 要连接的 ES 的密码
```

4、启动 `Kibana`
```markdown
systemctl restart kibana
```

### 图表制作

打开地址 http://10.20.13.15:5601，使用 elastic/{ES密码} 登录 Kibana，

#### 设置和准备

1、选择 `Management`，在 `Kibana` 中点击 `Advanced Settings`，

修改 `General` 中的 `Date format` 为：
```markdown
YYYY-MM-DD HH:mm:ss.SSS
```
修改 `General` 中的 `Date with nanoseconds format` 为：
```markdown
YYYY-MM-DD HH:mm:ss.SSSSSSSSS
```
然后保存。

2、选择 `Kibana` 中的 `Index Patterns`，创建索引模式，名称为：`alertmanager-alerts*`，选择索引 `alertmanager-alerts`，完成后续步骤。


#### 可视化图表

1、我们先制作一个按报警名称聚合的饼图，表示各个报警在报警总数中所占的比例。选择 `Visualize`，点击 `Create visualization`，点击 `Pie`，选择索引模式 `alertmanager-alerts*`，来到图表编辑页面
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG755.png" width="800px" height="300px" />
</center>

在 `Metrics` 下的 `Slice size` 中选择聚合器 `Count`，Count 返回所选索引模式中元素的原始计数，`Custom label` 中填入这个 `Count` 的含义。

点击 `Add` 增加一个 `Bucket`（相当于 `SQL` 中的 `group by`），类型选择 `Split slices`，

<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG756.png" width="800px" height="300px" />
</center>

聚合器选择 `Terms`，`Field` 选择 `labels.alertname.keyword`，表示根据 field 字段的值相等来分组，`Order` 可以默认，`Size` 增大到 100，打开 `Group other values in separate bucket`，在 `Label for other bucket` 中填入 `其他`，`Custom label` 中填入 `报警名称`

<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG757.png" width="800px" height="300px" />
</center>

`Options` 中的参数说明如下：

* Donut：打开后显示为空心饼图，否则填充至饼图圆心。
* Legend position：图例显示的位置，默认显示在右上方
* Show tooltip：是否显示工具提示，如果显示，当鼠标放到扇形上时，会显示该部分的数据
* Show labels：是否显示标签，在此处对应于各报警的名称
* Show values：是否显示值，在此处对应于各报警所占百分比是否显示在标签后面的括号中。

最后显示的饼图为：

<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG758.png" width="800px" height="300px" />
</center>


### 总结
