+++
title = "基于 docker 方式部署 infludb"
date = "2018-08-29"
lastmod = "2019-01-29"
description = ""
tags = [
    "InfluxDB",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了基于 docker 容器方式部署 influxdb 的详细过程。

<!--more-->

### 拉取 docker 镜像
```markdown
docker pull influxdb:latest
```

### 启动 influxDB 容器
```markdown
docker run -d \
      --restart=always \
      --name=influxdb \
      -p 8086:8086 \
      -p 8083:8083 \
      -e INFLUXDB_DB=db0 -e INFLUXDB_ADMIN_ENABLED=true \
      -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=Admin321 \
      -e INFLUXDB_USER=texadg -e INFLUXDB_USER_PASSWORD=Texadg123 \
      -v /data/influxdb:/var/lib/influxdb \
      influxdb
```

### 测试数据的读写

1）创建数据库
```markdown
-bash-4.2# curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE xdb"
HTTP/1.1 200 OK
Content-Type: application/json
Request-Id: 338ce607-147a-11e9-8002-0242ac110008
X-Influxdb-Build: OSS
X-Influxdb-Version: 1.7.2
X-Request-Id: 338ce607-147a-11e9-8002-0242ac110008
Date: Thu, 10 Jan 2019 01:51:09 GMT
Transfer-Encoding: chunked

{"results":[{"statement_id":0}]}
```

2）插入数据
```markdown
-bash-4.2# curl -i -XPOST 'http://localhost:8086/write?db=xdb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
HTTP/1.1 204 No Content
Content-Type: application/json
Request-Id: 6f10117d-147a-11e9-8003-0242ac110008
X-Influxdb-Build: OSS
X-Influxdb-Version: 1.7.2
X-Request-Id: 6f10117d-147a-11e9-8003-0242ac110008
Date: Thu, 10 Jan 2019 01:52:49 GMT
```

3）查询数据
```markdown
-bash-4.2# curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=xdb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='us-west'"
{
    "results": [
        {
            "statement_id": 0,
            "series": [
                {
                    "name": "cpu_load_short",
                    "columns": [
                        "time",
                        "value"
                    ],
                    "values": [
                        [
                            "2015-06-11T20:46:02Z",
                            0.64
                        ]
                    ]
                }
            ]
        }
    ]
}
```

#### 参考资料

https://hub.docker.com/_/influxdb/?tab=description

https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/

https://docs.influxdata.com/influxdb/v1.7/guides/querying_data/


