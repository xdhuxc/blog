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

在 `Metrics` 下的 `Slice size` 中选择聚合器 `Count`，Count 返回所选索引模式中元素的原始计数，`Custom label` 中填入这个 `Count` 的含义，即报警总数。

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

保存该图标，命名为：各报警统计

2、我们或许还想观察各个报警的总数随时间的变化情况，此时，我们可以制作一个折线图，选择 `Visualize`，点击 `Create visualization`，点击 `Line`，选择索引模式 `alertmanager-alerts*`，来到图表编辑页面

<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG760.png" width="800px" height="300px" />
</center>

在 `Metrics` 下的 `Slice size` 中选择聚合器 `Count`，`Custom label` 中填入 `报警总数`。

接下来设置 X 轴，在 `Buckets` 中增加 `X-axis`，聚合器选择 `Date Histogram`，`Field` 选择 `startAt`，`Minimum interval` 填写 `1h`，`Custom label` 填写 `时间`，我们以报警发生的时间作为 X 轴数据，每小时的数据统计在一个点上。
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG761.png" width="800px" height="300px" />
</center>

接下来继续增加 `Bucket`，选择 `Split series`，使用 `Terms` 聚合器，`Field` 字段选择 `labels.alertname.keyword`，`Order by` 选择 `Metric：报警总数`，`Order` 默认即可，`Size` 设置为：`50`，打开 `Group other values in separate bucket`（将所有不在报警名称之中的归入此类），在 `Label for other bucket` 下方填写 其他，`Custom label` 中填写 `报警名称`
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG764.png" width="800px" height="300px" />
</center>

数据部分的工作做完了，接下来进行配置：

1、设置 Y 轴，在 `Metrics & axes` 中，`Chart type` 选择 `Line`，使用线图；`Line mode` 选择 `Smoothed`，使用平滑曲线；`Line width` 用来设置线宽，可自行设置。
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG765.png" width="800px" height="300px" />
</center>

2、设置 X 轴，`Position` 为 `Bottom`，x 轴显示在图表下方；打开 `Show axis lines and labels`，否则将不显示 x 轴的标签；`Align` 使用 `Horizontal`，横向排列 x 轴标签。
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG766.png" width="800px" height="300px" />
</center>

3、其他设置，在 `Panel settings` 中，打开 `Show tooltip`，这样当鼠标放到数据点上时，会显示该点的数据和标签；打开 Current time marker，将会以垂线的方式显示当前时间线；在 Grid 部分，打开 `Show X-axis lines`，`Y-axis lines` 选择 `LeftAxis-1`，这样会在坐标轴中显示网格线，更加直观。
<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG767.png" width="800px" height="300px" />
</center>

最后显示的折线图为：

<center>
<img src="/image/storage/elasticsearch/elasticsearch-kibana-visualizations/WechatIMG768.png" width="800px" height="300px" />
</center>

保存该图标，命名为：各报警随时间的变化情况

### 总结
