+++
title = "在 Grafana 中制作 AlertManager 报警相关的图表"
date = "2020-03-25"
lastmod = "2020-03-25"
tags = [
    "ElasticSearch",
    "AlertManager",
    "Grafana",
]
categories = [
    "技术"
]
+++

本篇博客介绍下如何在 `Grafana` 中制作 AlertManager 报警相关的图表，详细介绍其参数和方法。

<!--more-->

### 背景

我们将 `AlertManager` 产生的报警存储到了 ES 中，接下来，需要制作报警图表，以可视化的方式观察报警的数量变化和各报警的比例。

### 安装 grafana 并配置数据源

1、安装 `grafana` 并启动，依次执行如下命令：
```markdown
wget https://dl.grafana.com/oss/release/grafana-6.7.1-1.x86_64.rpm
sudo yum install grafana-6.7.1-1.x86_64.rpm
systemctl restart grafana-server
```

2、打开 grafana 并配置数据源

在浏览器中打开 `127.0.0.1:3000`，在 `Configuration` 中选择 `Add data source`，找到 `ElasticSearch`，点击 Select，配置 ES 数据源的基本信息。

主要包括如下几项：

1）Name 为数据源名称，比如，ElasticSearch，同时打开 Default 选项，使用 ES 作为我们的默认选项。

2）HTTP 部分的 URL：ES 的URL，比如，http://127.0.0.1:9200。

3）Auth 部分打开 Basic auth，在 Basic Auth Details 部分中填入 ES 的用户名和密码。

4）在 ElasticSearch details 部分的 Index name 部分填入索引的名称，比如，alertmanager-alerts，Version 部分选择相应的 ES 版本，比如 7.0+。

5）点击 Save & Test 保存这些信息。

### 图表绘制

我们可能需要知道报警总数（饼图），按业务或部门分类的报警数目（饼图），报警数量按照时间变化的曲线（折线图），某个具体报警的百分位数（折线图）等等，以帮助我们了解报警情况。

#### 线图

我们想观察各个报警的总数随时间的变化情况，此时，我们需要绘制一个折线图。在 grafana 中创建一个 Dashboard，点击 Panel Title，选择 Edit，

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG795.png" width="600px" height="400px"/>
</center>

如上图所示

点击 `Queries`，做如下操作：

1）Query 部分选择数据源 Elasticsearch。

2）Alias 的值为：报警总数随时间变化情况，这会显示在曲线上和图表的左下角。

3）Metric 使用 Count，因为我们是在绘制报警总数随时间变化的曲线，纵坐标是报警的总数，横坐标是时间，具体来说是报警开始的时间。

4）Group by 使用 Date Histogram 类型，根据 startsAt 来进行，也就是使用报警开始的时间来进行聚合，interval 选择 auto，让 grafana 自己根据数据长度来决定使用多大的间距。

点击 `Visualization`，做如下操作：

1）Visualization 选择 Graph。

2）Draw Modes 选择 Lines。

3）Legend 部分，打开 Options 部分的 Show 选项，这样当鼠标在图表中滑过时，会显示当前数据小卡片。


点击 `General`，做如下操作：

1）在 General 的 Title 部分填写此面板的名称，比如，报警总数随时间变化情况，Description 也可以根据需要自行填写。

最终的 `报警总数随时间变化曲线图` 如下所示：

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG796.png" width="600px" height="400px"/>
</center>

保存此 Dashboard，命名为：AlertManager 报警统计。

#### 饼图

假如我们想知道各个报警占报警总数的比例，那我们就需要绘制一张饼图，来直观地展示各个报警在报警总数中所占的比例。

grafana 默认不带饼图，需要安装饼图插件来支持。使用如下命令安装饼图插件，并重启 grafana
```markdown
grafana-cli plugins install grafana-piechart-panel
sudo service grafana-server restart
```

在 Dashboard `AlertManager 报警统计` 中，点击 `New Panel`，选择 `Add Query`，点击 Panel Title，选择 Edit，

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG797.png" width="600px" height="400px"/>
</center>

如上图所示

点击 Queries，进行如下操作：

1）在 Query 部分选择数据源 Elasticsearch。

2）Metric 选择 Count，我们需要聚合各个报警的数量。

3）Group By 选择 Terms，根据 labels.alertname.keyword 来进行聚合，也就是根据报警名称进行分组。

4）Then by 使用 Date Histogram 类型，根据 startsAt 来进行，即使用报警开始的时间再次进行聚合，interval 选择 1h，每一小时内的数据放在一起。


点击 Visualization，进行如下操作：

1）在 Visualization 部分选择 Pie Chart。

2）在 General 部分，Type 选择 Pie，Value 选择 Total。

3）在 Legend 部分，打开 Show Legend， 选择适当的 Position，打开 Legend Values，打开 Show Percentage，将 Percentage Decimals 设置为 2，即保留小数点后两位。

如下图所示：

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG798.png" width="600px" height="400px"/>
</center>

点击 `General`，做如下操作：

1）在 General 的 Title 部分填写此面板的名称，比如，各报警统计情况，Description 也可以根据需要自行填写。

保存此面板。

最终的 `各报警统计情况` 如下所示：

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG799.png" width="600px" height="400px"/>
</center>

#### 百分位图

假如我们想了解某个报警的阈值情况，方便我们设置合理的阈值，抑制该报警的发送。

此处需要特别注意，进行百分位数计算，要求计算依据字段必须是数值类型的，所以，插入 ES 索引数据中字段必须是数值类型的，否则不能用于计算百分位数。

在 Dashboard `AlertManager 报警统计` 中，点击 `New Panel`，选择 `Add Query`，点击 Panel Title，选择 Edit，

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG800.png" width="600px" height="400px"/>
</center>

如上图所示

点击 Queries，进行如下操作：

1）在 Query 部分选择数据源 Elasticsearch。

2）Query 部分填写：`labels.alertname.keyword : "$alertname" and labels.severity.keyword : "critical" and labels.group.keyword : "Xdhuxc"`，用于筛选出我们需要计算阈值的具体报警

3）Metric 选择 Percentiles，根据 labels.value 计算百分位数，分别计算 90，95，99 的百分位数。

4）Group By 选择 Date Histogram，根据 startsAt 来进行分组，interval 选择 1h。

点击 Visualization，进行如下操作：

1）选择 Visualization 为 Graph。

2）在 Draw Modes 部分，打开 Lines，使用线图。

3）在 Axes 部分，设置 Left Y 的 Decimals 为 2；设置 Right Y 的 Decimals 为 2。

4）在 `Legend` 的 `Options` 部分，打开 `Show`，显示绘图点的数据。

点击 General，进行如下操作：

1）在 General 的 Title 输入框中，填写如下内容：`百分位数-$alertname`

我们在上面的 Query 和 Title 中用到了 $alertname，这是 grafana 支持的变量，是 Dashboard 级别的，通过这个变量，我们可以在一个 panel 中画出若干个同类型的图表。

点击右上角的 Dashboard settings，选择 Variables，点击 New，如下图所示：

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG801.png" width="600px" height="400px"/>
</center>

进行如下配置：

1）在 General 部分，Name 表示变量的名字，将会在面板中进行引用；Type 选择 Query，我们将从 ES 中查询出所有的报警名称；Label 是变量的标签，将会显示在 Dashboard 上。

2）在 Query Options 部分，Data source 选择我们的数据源 Elasticsearch，Refresh 表示刷新数据的时机，选择 On Dashboard Load；Query 填入查询数据的表达式，对于我们来说，就是从 ES 中查询所有报警名称的查询表达式，如下所示：
```markdown
{
    "find": "terms", 
    "field": "labels.alertname.keyword", 
    "query": "*"
}
```
Sort 指定查询出的数据的排序方式，可以根据需要自行指定。

保存 alertname 变量的定义，然后就可以在面板中使用了。

最终的 百分位图表如下所示：

<center>
<img src="/image/devops/grafana/elasticsearch-visualizations/WechatIMG803.png" width="600px" height="400px"/>
</center>

保存此面板，可以选择不同的报警名称，查看它们对应的百分位图。

### 导出 AlertManager 报警统计 Dashboard

我们可以将 Dashboard 保存下来，方便后面在其他地方直接引入。

点击右上角的 `Share Dashboard`，选择 `Export`，点击 `Save to file` 保存我们制作的 Dashboard。


### 总结

和 Kibana 相比，grafana 制作出的图表灵活性更大，也更加美观，但是线图却不够平滑，支持变量确实是一个非常好用的功能。我们也可以根据需要，制作其他类型的图表。






































