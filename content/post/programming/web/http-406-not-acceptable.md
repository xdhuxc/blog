+++
title = "记一次 HTTP PUT/POST 请求 406 错误"
date = "2019-06-01"
lastmod = "2019-06-02"
description = ""
tags = [
    "HTTP",
    "Web"
]
categories = [
    "技术"
]
+++

最近使用 axios 和 go-restful 分别作为前后端 API 开发时，出了个奇怪的 406 问题，记录下来，以备后需。

<!--more-->

我们的项目前端使用 vue 和 element-ui 搭建，后台使用 go-restful 来编写 API。以前开发基本顺利，没有出现过奇怪的问题，但是最近突然出现了个莫名其妙的 406 问题，查阅文档，各种尝试，始终没有找到优雅的解决方法，导致开发进度被推迟了两天。目前，该问题已经解决，特此记录。

前端使用 axios 编写的接口如下：（src/api/kubernetes/deployment.js）
```markdown
import request from '@/utils/kubernetesRequest';
export function restartApp(cid, namespace, appName) {
  return request({
    url: '/apps/' + namespace + '/' + appName + '/restart',
    method: 'PUT',
    headers: {
      cid: cid
    }
  });
}
```
其中，axios 实例的定义为：（src/utils/kubernetesRequest.js）
```markdown
import axios from 'axios';
import store from '../store/index';
import Clear from '../store/modules/user';
import { getToken } from '@/utils/auth';
import router from '../router';
import lang from '@/lang';

// create axios instance
const service = axios.create({
  baseURL: process.env.BASE_API + '/kubernetes',
  timeout: 5000, // the timeout of request
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }
});

// the request interceptor
service.interceptors.request.use(
  config => {
    const token = getToken();
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    } else { // if token is not existed, go to the login page
      store.dispatch('Clear').then(response => {
        router.replace({
          path: '/login',
        });
      }).catch(error => {
        console.log(error);
      });
    }
    return config;
  },
  error => {
    console.log(error);
    Promise.reject(error);
  }
);
// the response interceptor
service.interceptors.response.use(
  response => {
    return response;
  },error => {
    if (error.response) {// in some cases，the error.response is undefined
      switch (error.response.status) {
      case 401:
        store.dispatch('Clear').then(response => {
          router.replace({
            path: '/login',
          });
        });
        break;
      case 403:
        error.message = lang.t('notification.noOperatePrivilege');
        return Promise.reject(error);
      }
    } else {
      return Promise.reject(error);
    }
    return Promise.reject(error);
  }
);

export default service;
```
然后在组件（src/views/kubernetes/application/deployment/index.vue）中调用该方法
```
<script>
import { restartApp } from '@/api/kubernetes/deployment';
import { setCurrentCluster, setCurrentApplication } from '@/utils/auth';
import { handleScaleError } from '@/utils/utils';
import { mapGetters } from 'vuex';

export default {
  name: 'Deployment',
  data() {
    return {
      apps: [],
      currentApp: '',
      temp: {
        app: {},
        revision: '',
      },    
    };
  },
  computed: {
    ...mapGetters([
      'currentGroup',
      'currentCluster',
      'currentApplication'
    ])
  },
  created() {
    
  },
  methods: {
    handleRestart(index, app) {
      this.$confirm(this.$t('confirm.restart'), this.$t('confirm.title'), {
        confirmButtonText: this.$t('confirm.confirm'),
        cancelButtonText: this.$t('confirm.cancel'),
        type: 'warning'
      }).then(() => {
        restartApp(this.currentCluster.id, app.namespace, app.name).then(response => {
          if (response.status === 201) {
            this.$message({
              type: 'success',
              message: this.$t('notification.restartSuccessMessage'),
              duration: 2000,
              offset: 40
            });
          }
          this.getAppsData();
        }).catch(error => {
          if (error.response) {
            if (error.response.status === 403) {
              this.$message({
                type: 'error',
                message: error.message,
                duration: 2000,
                offset: 40
              });
            } else {
              this.$message({
                message: this.$t('notification.restartFailedMessage'),
                type: 'error',
                duration: 2000,
                offset: 40
              });
            }
          } else {
            this.$message({
              type: 'error',
              message: error.message,
              duration: 2000,
              offset: 40
            });
          }
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: this.$t('confirm.cancelRestart'),
          duration: 2000,
          offset: 40
        });
      });
    }
};
</script>
```
点击重启按钮时，传入当前行的值作为 app 的值，请求后台 API。

后台使用 go-restful 开发的 API，主要代码为：
```markdown
type AppController struct {
	*BaseController
}

func newAppController(bc *BaseController) *AppController {
	tags := []string{"deployment"}
	ac := &AppController{}
	ac.BaseController = bc

    ws.Route(ac.ws.PUT("/apps/{namespace}/{app}/restart").To(AppRestart).
        Doc("app restart").
        Param(ac.ws.PathParameter("namespace", "namespace name").DataType("string").Required(true)).
        Param(ac.ws.PathParameter("app", "app name").DataType("string").Required(true)).
        Param(ac.ws.HeaderParameter("cid", "cluster id").DataType("integer").Required(true)).
        Metadata(restfulspec.KeyOpenAPITags, tags).
        Returns(http.StatusOK, "OK", nil).
        Returns(http.StatusBadRequest, "ERROR", nil))  

	return ac
}
    
func AppRestart(req *restful.Request, resp *restful.Response) {
	client, ok := getClusterKClient(req)
	if !ok {
		util.WriteResonse(resp, util.InvalidCluster, fmt.Errorf("cannot get cluster client"))
		return
	}

	namespace := req.PathParameter("namespace")
	if namespace == "" {
		util.WriteResonse(resp, util.InvalidParams, fmt.Errorf("invalid ns name error"))
		return
	}
	namespace = strings.ToLower(namespace)

	appName := req.PathParameter("app")
	if appName == "" {
		util.WriteResonse(resp, util.InvalidParams, fmt.Errorf("invalid app name error"))
		return
	}

	err = bs.AppService.AppRestart(appName, namespace, client)
	if err != nil {
		util.WriteResonse(resp, util.RestartAppError, err)
		return
	}

	resp.WriteHeader(http.StatusCreated)
}      
```

使用 PUT 方法向后台 API 发送请求后，返回的结果为：
```markdown
General
Request URL: http://192.168.1.227:8000/kubernetes/apps/cas//restart
Request Method: PUT
Status Code: 406 Not Acceptable
Remote Address: 159.138.87.227:8000
Referrer Policy: no-referrer-when-downgrade

Response Headers
access-control-allow-origin: http://0.0.0.0:9528
content-length: 19
content-type: text/plain; charset=utf-8
date: Wed, 29 May 2019 02:31:13 GMT
server: envoy
x-envoy-upstream-service-time: 0

Request Headers
Accept: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTkxMjMxNTUsInVzZXIiOiJ3YW5naHVhbnxbMTUgMTddfGFkbWluIn0.VsRlRATa8QYJS8TrF3RrrAI-ZMEdZxIvwszXyH3G880
cid: 5
Origin: http://0.0.0.0:9528
Referer: http://0.0.0.0:9528/
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36
```

查询 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/406) 文档，对 406 解释如下：


HTTP 协议中的 406 Not Acceptable 状态码表示客户端错误，指代服务器端无法提供与  `Accept-Charset` 以及 `Accept-Language` 消息头指定的值相匹配的响应。

在实际应用中，这个错误状态码极少使用：不是给用户返回一个晦涩难懂（且难以更正）的错误状态码，而是将相关的消息头忽略，同时给用户提供一个看得见摸得着的页面。这种做法基于这样一个假设：即便是不能达到用户十分满意，也强于返回错误状态码。

如果服务器返回了这个错误状态码，那么消息体中应该包含所能提供的资源表现形式的列表，允许用户手动进行选择。


根据文档的提示，我检查了 axios 请求实例的 `Accept-Charset` 和 `Accept-Language` 消息头的设置。实际上，我并没有显式指定这两个请求头的值，那么在默认情况下，浏览器和服务器之间协商的结果应该是一致的，所以应该不是这两个请求头不一致导致的。

由于我们使用了 envoy 来做代理，我就搜索了 envoy 相关的资料，envoy 官方网站对 [响应状态码](https://developers.envoy.com/#response-codes) 的解释如下：

Code     | Name                | Description
-------- | --------            | -------
406      | Not&nbsp;Acceptable | The requested resource is only capable of generating content not acceptable according to the Accept headers sent in the request.

也就是说，请求的资源只能根据发送的请求头 Accept 生成不可接受的内容。根据此提示，我注意到 响应头中的 `Accept` 为 `text/plain`，而请求头中的 `accept` 为 `application/json`，所以，应该是由 envoy 返回的 406 错误。

但是另外的代码使用 PUT 方法发送请求却没有这个问题，于是，我就尝试着改造了一下代码，最终发现，由于我的请求数据全部在请求头和路径参数中，所以请求体没有设置，当我把请求体设置上后，返回结果就正常了，虽然请求体的内容为空。改造后的前端 API 如下所示：
```markdown
import request from '@/utils/kubernetesRequest';
export function restartApp(cid, namespace, appName) {
  return request({
    url: '/apps/' + namespace + '/' + appName + '/restart',
    method: 'PUT',
    headers: {
      cid: cid
    },
    data: {}
  });
}
```
整个请求和响应就正常了。

### 参考资料

https://developers.envoy.com/#response-codes

https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/406
