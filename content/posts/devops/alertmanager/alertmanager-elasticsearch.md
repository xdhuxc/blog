+++
title = "将 AlertManager 的报警存储到 ElasticSearch 中"
date = "2020-03-06"
lastmod = "2020-06-06"
tags = [
    "DevOps",
    "AlertManager",
    "ElasticSearch"
]
categories = [
    "技术"
]
+++

本篇博客介绍下将 `AlertManager` 中的报警存储到 `ElasticSearch` 中的方法，以便我们使用 `Kibana` 等可视化工具将其做成各种图表进行分析。

<!--more-->

### 背景

当我们的监控-告警系统建立起来后，告警系统将会面临这样的问题：警报消息太多，接收人很容易麻木，不再继续理会，关键的告警常常被淹没。所以，我们需要做好告警的收敛工作。

我们可以考虑把告警信息收集起来，做统计分析，基于统计数据按周、月生成告警报告，比如，哪些应用在哪段时间里产生了最多的报警，哪些指标在哪段时间里产生了最多的报警，某个报警阈值的 90% 分位数、95% 分位数、99% 分位数，哪个部门产生了最多的报警数等等。一来要求业务团队改造程序或结构，调整资源配置，比如有些代码写得性能特别差，资源占用高，导致告警信息频繁发送；二来可以作为我们设置各种资源阈值的统计参考数据，取代常用的经验值或习惯值，比如，根据历史报警数据的统计，采取百分位数，使得某告警在 `95%` 的情况下不再发送告警信息。

我们决定使用 ElasticSearch 来存储报警信息，后续使用 Kibana 制作报警信息图表

### 代码开发

#### 思考问题

我们想把 `AlertManager` 发送的报警收集起来，那么，由于 `AlertManager` 会把从 `Prometheus` 发送来的报警信息进行分组聚合，抑制等操作，从而导致实际产生的报警一般会多于发送出来的报警。

如果我们想把 `AlertManager` 的报警信息收集起来，那么，我们是应该在 `AlertManager` 接收到报警的时候收集，还是在真正发送报警之前进行收集？

如果是在接收到报警时收集，那么我们实际上会收集到所有产生的报警，数据量大，信息详尽。如果使用这些进行分析，进而改进代码、程序架构和资源配置，那么，将会从上游彻底地减少报警，并且促进整个研发运维的进步和系统的稳定性。

如果是在实际发送时收集，那么我们收集到的数据量就会比较小，报警是经过聚合的，被抑制的报警不发送，经过分析优化后，将会使得接收到的报警数量减少，但是产生的报警（按原来的标准，这种情况下会产生报警）却可能增多，比如在不做上游改变的情况下，调整阈值，使得 `99%` 的报警不发送，问题则会堆积在 `Prometheus` 那边，不会向 `AlertManager` 发送报警，造成更大的系统风险，使用不当时，会造成自自欺人的窘境。

根据以上分析，我们选择在 `AlertManager` 接收到报警时即收集之。

#### 代码

`Prometheus` 使用 `AlertManager` 的 `API` `v1` 来向 `AlertManager` 发送报警，所以我们先改造 `AlertManager` 的 `v1` 版本 `API`。

1、在 `alertmanager/config/config.go` 中 `GlobalConfig` 结构体中加入如下代码：

```markdown
type GlobalConfig struct {
    // ES
    ESEnable            bool     `yaml:"es_enable,omitempty" json:"es_enable,omitempty"`
    ESAddresses         []string `yaml:"es_addresses,omitempty" json:"es_addresses,omitempty"`
    ESUserName          string   `yaml:"es_user_name,omitempty" json:"es_user_name,omitempty"`
    ESPassword          string   `yaml:"es_password,omitempty" json:"es_password,omitempty"`
    ESMaxRetries        int      `yaml:"es_max_retries,omitempty" json:"es_max_retries,omitempty"`
    ESDisableRetry      bool     `yaml:"es_disable_retry,omitempty" json:"es_disable_retry,omitempty"`
    ESEnableMetrics     bool     `yaml:"es_enable_metrics,omitempty" json:"es_enable_metrics,omitempty"`
    ESEnableDebugLogger bool     `yaml:"es_enable_debug_logger,omitempty" json:"es_enable_debug_logger,omitempty"`
    
    // ES index
    ESIndexName    string `yaml:"es_index_name,omitempty" json:"es_index_name,omitempty"`
    ESIndexRefresh string `yaml:"es_index_refresh,omitempty" json:"es_index_refresh,omitempty"`
}
```

以上参数含义如下：

* ESEnable：是否启用存储报警信息到 ES 中功能，默认为：false
* ESAddresses：ES 节点地址数组，形式为："http://10.20.13.158:9200"，必须指定
* ESUserName：ES 用户名，必须指定
* ESPassword：ES 密码，必须指定
* ESMaxRetries：请求 ES 服务器的最大重试次数，默认为：3
* ESDisableRetry：禁用请求重试功能，默认为：false
* ESEnableMetrics：允许收集指标，默认为：false
* ESEnableDebugLogger：允许 debug 级别日志，默认为：false
* ESIndexName：ES 索引名称，必须指定
* ESIndexRefresh：是否启用索引刷新，启用后，每次操作文档后，都会对相关分片及副本进行刷新，保证了数据操作的结果可以立刻被搜索到，在操作频率比较低时，可以设置为："true"，默认为："false"

2、在 `alertmanager/api/v1/api.go` 中的 `API` 结构体中加入如下代码：
```markdown
package v1

import "github.com/elastic/go-elasticsearch/v7"

type API struct {
	es       *elasticsearch.Client
}
```

3、创建 ES 客户端，修改 `alertmanager/api/v1/api.go` 文件中 `func (api *API) Update(cfg *config.Config)` 方法代码，加入如下内容：
```markdown
// Create ES client
if cfg.Global.ESEnable {
    esClient, err := elasticsearch.NewClient(elasticsearch.Config{
        Addresses:         cfg.Global.ESAddresses,
        Username:          cfg.Global.ESUserName,
        Password:          cfg.Global.ESPassword,
        DisableRetry:      cfg.Global.ESDisableRetry,
        MaxRetries:        cfg.Global.ESMaxRetries,
        EnableMetrics:     cfg.Global.ESEnableMetrics,
        EnableDebugLogger: cfg.Global.ESEnableDebugLogger,
    })
    if err != nil {
        level.Error(api.logger).Log("msg", "Create ES client error", "err", err)
    } else {
        // Ping
        _, pingError := esClient.Ping()
        if pingError == nil {
            api.es = esClient
        } else {
            level.Error(api.logger).Log("msg", "Ping ES service error", "err", pingError)
        }
    }
}
```

4、由于 AlertManager 报警信息的数据格式的键值均为字符串，而实际的报警数据中，经常会用到数值类型，比如内存使用率，CPU 使用率，请求次数等等，考虑到以字符串表示的数值在 ES 中将会被当做字符串存储，无法进行某些统计，比如百分位数的计算。我们需要将以字符串表示的数值类型数据转为数值类型。

在 `alertmanager/api` 目录下创建 `es` 目录，在其中创建 `alert.go` 文件，内容如下：（为了 v1 和 v2 版本代码均可引用此部分代码）
```markdown
package es

import (
	"fmt"
	"strconv"
	"time"

	"github.com/prometheus/alertmanager/types"
	"github.com/prometheus/common/model"
)

type LabelValue interface{}

type LabelSet map[model.LabelName]LabelValue // 此处使用 Prometheus 中报警的 LabelSet 的键类型，不要使用 string 类型或自定义 string 类型，否则要进行非常麻烦的类型转换

const (
	labelNameValue model.LabelName = "value" // 在我们的报警中，数值类型的键名统一为：value，值为 CPU 使用率，内存使用率，请求数量等等
)

// for ES number type index
type Alert struct {
	// 使用自定义的 LabelSet 类型
	Labels LabelSet `json:"labels"` 

	// Extra key/value information which does not define alert identity.
	Annotations model.LabelSet `json:"annotations"`

	// The known time range for this alert. Both ends are optional.
	StartsAt     time.Time `json:"startsAt,omitempty"`
	EndsAt       time.Time `json:"endsAt,omitempty"`
	GeneratorURL string    `json:"generatorURL"`

	// The authoritative timestamp.
	UpdatedAt time.Time
	Timeout   bool
}

func Convert(alert *types.Alert) *Alert {
	esAlert := new(Alert)

	esAlert.EndsAt = alert.EndsAt
	esAlert.StartsAt = alert.StartsAt
	esAlert.Annotations = alert.Annotations
	esAlert.GeneratorURL = alert.GeneratorURL
	esAlert.Timeout = alert.Timeout
	esAlert.UpdatedAt = alert.UpdatedAt
	esls := make(LabelSet)
	// 注意，此处不能使用反射将所有字符串数值都转换为数值类型，各个不同的报警中可能有相同的键名，而值的类型不同，可能是字符串，可能是字符串数值，如果转换过去了，向 ES 中创建索引时，就会因为类型而出现错误
	for k, v := range alert.Labels {
		if k == labelNameValue { // 处理数值类型
			result, err = strconv.ParseFloat(fmt.Sprintf("%s", v), 32)
			if err != nil {
			    esls[k] = v
			} else {
			    esls[k] = result
			}
		} else {
			esls[k] = v
		}
	}
	esAlert.Labels = esls

	return esAlert
}
```


5、编写代码向 ES 中插入数据，有两种方式可以实现，一种是常规的一条一条地插入数据，另一种是批量插入数据，向 `alertmanager/api/v1/api.go` 中添加如下代码：
```markdown
import (
    uuid "github.com/satori/go.uuid"
    "github.com/elastic/go-elasticsearch/v7/esapi"
)

// 一条一条地插入数据
func (api *API) Insert(alerts ...*types.Alert) error {
	var total int
	for _, alert := range alerts {
		esAlert := es.Convert(alert)
		dataInBytes, err := json.Marshal(esAlert)
		if err != nil {
			total = total + 1
			level.Error(api.logger).Log("msg", "Marshal alerts to string error", "err", err)
			continue
		}
		req := esapi.IndexRequest{
			Index:      api.config.Global.ESIndexName,
			DocumentID: uuid.NewV4().String(),       // 使用 UUID 作为文档 ID
			Body:       strings.NewReader(string(dataInBytes)),
			Refresh:    api.config.Global.ESIndexRefresh,
		}

		_, err = req.Do(context.Background(), api.es)
		if err != nil {
			total = total + 1
			level.Error(api.logger).Log("msg", "Insert alerts to ES error", "err", err)
			continue
		}
	}

	if total > 0 {
		return level.Error(api.logger).Log("msg", "There are several errors", "total", total)
	}

	return nil
}

// 批量插入数据
func (api *API) Batch(alerts ...*types.Alert) error {
	var buf bytes.Buffer
	for _, alert := range alerts {
	    // 将 AlertManager 的报警格式转化为 ES 需要的报警格式，差别在于数值类型数据的处理
		esAlert := es.Convert(alert)

		metadata := []byte(fmt.Sprintf(`{ "index" : { "_id" : "%s" } }%s`, uuid.NewV4().String(), "\n"))
		data, err := json.Marshal(esAlert)
		if err != nil {
			level.Error(api.logger).Log("msg", "Marshal ESAlerts to string error", "err", err)
			continue
		}

		data = append(data, "\n"...)
		buf.Grow(len(metadata) + len(data))
		buf.Write(metadata)
		buf.Write(data)
	}

	_, err := api.es.Bulk(bytes.NewReader(buf.Bytes()), api.es.Bulk.WithIndex(api.config.Global.ESIndexName), api.es.Bulk.WithRefresh(api.config.Global.ESIndexRefresh))
	if err != nil {
		level.Error(api.logger).Log("msg", "doing ES Bulk API error", "err", err)
		return err
	}

	return nil
}
```
建议使用批量插入数据的方式，在我们的测试中，插入 1000 条数据，一条一条插入需要使用 197.13s，而使用批量插入仅需要 1.97s。


6、将 AlertManager 接收到的报警数据存储到 ES 中，修改 `alertmanager/api/v1/api.go` 文件中的方法 `func (api *API) insertAlerts(w http.ResponseWriter, r *http.Request, alerts ...*types.Alert)`，将代码加到 `api.alerts.Put(validAlerts...)` 代码块之前
```markdown
// insert alerts to ES
if api.es != nil {
    _ = api.Batch(validAlerts...)
}

// Put 方法用于合并报警到已有的报警之中
if err := api.alerts.Put(validAlerts...); err != nil {
    api.respondError(w, apiError{
        typ: errorInternal,
        err: err,
    }, nil)
    return
}
```

参照以上代码修改 API v2 的代码，由于 AlertManager 代码结构的问题，v1 和 v2 版本的 API 无法共用此部分代码。

### 测试

编写单元测试进行测试，在文件 `alertmanager/api/v1/api_test.go` 中加入如下代码：
```markdown
func newAPIClient() *API {
	apiClient := New(nil, nil, nil, nil, nil, nil)
	cfg := &config.Config{
		Global: &config.GlobalConfig{
			ESEnable:            true,
			ESAddresses:         []string{"http://127.0.0.1:9200"},
			ESUserName:          "elastics",
			ESPassword:          "AlertManager@2020",
			ESMaxRetries:        3,
			ESDisableRetry:      false,
			ESEnableMetrics:     true,
			ESEnableDebugLogger: true,
			ESIndexName:         "alertmanager-alerts",
			ESIndexRefresh:      "true",
		},
		Route: &config.Route{
			Receiver:   "test",
			GroupByAll: false,
		},
	}

	apiClient.Update(cfg)

	return apiClient
}

func generateAlerts() []*types.Alert {
	groups := []string{"A", "B", "C", "D"}
	severities := []string{"critical", "warning"}
	alertNames := []string{"the usage rate of container related to kube-admin greater than 80%", "kafka was down"}

	var alerts []*types.Alert

	for i := 0; i < 1000; i++ {
		ls := model.LabelSet{
			model.LabelName(model.AlertNameLabel): model.LabelValue(alertNames[rand.Intn(len(alertNames))]),
			model.LabelName("group"):              model.LabelValue(groups[rand.Intn(len(groups))]),
			model.LabelName("severity"):           model.LabelValue(severities[rand.Intn(len(severities))]),
			model.LabelName("value"):              model.LabelValue(fmt.Sprintf("%.2f", rand.Float32()*100)),
		}
		alert := &types.Alert{
			Alert: model.Alert{
				Labels:      ls,
				Annotations: nil,
				StartsAt:    time.Now(),
				EndsAt:      time.Now(),
			},
			Timeout:   false,
			UpdatedAt: time.Now(),
		}
		alerts = append(alerts, alert)
	}

	return alerts
}

func TestAPI_Insert(t *testing.T) {
	apiClient := newAPIClient()
	alerts := generateAlerts()

	err := apiClient.Insert(alerts...)
	require.NoError(t, err)
}

func TestAPI_Batch(t *testing.T) {
	apiClient := newAPIClient()
	alerts := generateAlerts()

	err := apiClient.Batch(alerts...)
	require.NoError(t, err)
}
```

### 总结

至此，向 AlertManager 中添加存储报警信息到 ES 中的代码开发就完成了，有两点需要特别注意，一是我们是在 AlertManager 接收到发送来的报警信息时将其报警数据存储到 ES 中的（我们将时机选在了去除空标签及标签合法性验证和合并报警消息之间），不是报警从 AlertManager 发送出去时的报警信息；二是由于 AlertManager 代码本身的问题，我们无法复用一些代码，比如创建 ES 客户端的代码，向 ES 中写数据的代码等。









