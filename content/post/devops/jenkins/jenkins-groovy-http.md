+++
title = "在 Jenkins Pipeline 的 groovy 脚本中发送 HTTP 请求"
date = "2019-06-17"
lastmod = "2019-12-14"
tags = [
    "DevOps",
    "Jenkins",
    "groovy"
]
categories = [
    "技术"
]
+++

本篇博客介绍了在 Jenkins Pipeline 中 groovy 脚本发送 HTTP 请求的用法。

在使用 Jenkins Pipeline 时，有时需要和外部系统以 HTTP 方式交互或集成，此时就需要发送 HTTP 请求给外部系统，并接收响应，继续进行处理，而 curl 等命令不太好处理接收到的响应，此时可以使用 groovy 脚本来处理。

<!--more-->

### 使用方法

1、使用 Jenkins 第一件事情，安装插件，groovy 脚本发送 HTTP 请求需要安装 `HTTP Request` 插件，插件 ID 为：

2、在 pipeline 中编写代码如下：
```markdown
stage('Deploy') {
    steps {
        container('golang-build-container') {
            script {
                ws(projectPath) {  
                    def payload = """
                        { "app": "xdhuxc-app" }
                    """
                    
                    def authorization = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTExNzkzNTYsInVzZXIiOiJ3YW5naHVhbnxbMTcgMyA0IDUgNiA3IDggOSAxMCAxMSAxMiAxMyAxNiAxOSAyMCAyMSAyMiAyMyAyNCAyNSAyNl18YWRtaW4ifQ.WR7GaFdm0y2SE3WHGYfE_VbTiXZovmm5hBojvhLn5NI"
                    def app = "xdhuxc-app"
                    def response = httpRequest acceptType: 'APPLICATION_JSON', contentType: 'APPLICATION_JSON', httpMode: 'PUT', requestBody: payload, url: "http://127.0.0.1:80/xdhuxc/apps?app=${app}&authorization=${authorization}", validResponseCodes: "100:511"
                    
                    if (response.status != 200) {
                        throw new Exception("the request failed, the http response status is ${response.status}, content is ${response.content}")
                    }
                }
            }
        }
    }
}
```

注意，需要加 `validResponseCodes: "100:511"`，默认的 `validResponseCodes` 为 `100:399`，这意味着响应状态码为 `400~511` 的请求会直接抛错，拿不到响应。

此外，还可以添加自定义请求头：
```markdown
def response = httpRequest customHeaders: [[name: 'cid', value: '110']]
```

更多参数，参考：https://www.jenkins.io/doc/pipeline/steps/http_request/#http-request-plugin


### 参考资料

https://www.jenkins.io/doc/pipeline/steps/http_request/#httprequest-perform-an-http-request-and-return-a-response-object

https://www.jenkins.io/doc/pipeline/steps/http_request/#http-request-plugin

https://github.com/jenkinsci/http-request-plugin
