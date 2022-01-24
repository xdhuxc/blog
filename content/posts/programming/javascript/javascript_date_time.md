+++
title = "JavaScript 中的日期和时间格式化"
date = "2019-05-19"
lastmod = "2019-05-19"
description = ""
tags = [
    "JavaScript"
]
categories = [
    "JavaScript"
]
+++

本篇博客主要介绍 JavaScript 中的日期时间与Unix时间戳的转换及日期的格式化，都是在前端开发中经常会用到技术。

<!--more-->

### 日期时间与 Unix 时间戳的转换
最近项目中使用到了 Prometheus，从前端页面向后端接口发送请求时，传递的参数中有查询 Prometheus 指标的起止时间范围，格式为 Unix 时间戳，这就需要使用 JavaScript 在前端页面获取当前时间，然后转换为 Unix 时间戳。

以下方法返回当前时间至 GMT 时间1970年1月1日00时00分00秒对应的毫秒数.
```markdown
new Date().getTime()
Date.parse(new Date())
(new Date()).valueOf()
```
而 Unix 时间戳定义为从 GMT 时间1970年01月01日00时00分00秒起至当前时间的总秒数。因此，给上述代码除以 1000，即可得到其对应的 Unix 时间戳：
```markdown
(new Date().getTime()) / 1000
(Date.parse(new Date())) / 1000
(new Date()).valueOf() / 1000
```

这同时也意味着，当我们从后端获取到 Unix 时间戳，再通过 JavaScript 代码格式化为日期时间时，需要给相应时间戳乘 1000，然后再格式化，否则会得到错误的日期。


### 日期的格式化
JavaScript 没有提供常用的类似 `yyyy-MM-dd hh:mm:ss` 日期时间格式化函数，仅仅提供了获取年月日、时分秒等函数。

借助于 prototype 属性，我们可以为 Date 对象自定义格式化函数。

```markdown
Date.prototype.format = function(fmt) {
  var o = {
    'M+' : this.getMonth() + 1,                 // 月份
    'd+' : this.getDate(),                    // 日
    'h+' : this.getHours(),                   // 小时
    'm+' : this.getMinutes(),                 // 分
    's+' : this.getSeconds(),                 // 秒
    'q+' : Math.floor((this.getMonth() + 3) / 3), // 季度
    'S'  : this.getMilliseconds()             // 毫秒
  };
  if(/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
  }
  for(var k in o) {
    if(new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)));
    }
  }
  return fmt;
};
```
这样，我们就可以这样格式化 Date 对象了：
```markdown
new Date(metrics_time_unix_stamp_format * 1000).format('yyyy-MM-dd hh:mm:ss') # 2019-05-19 15:23:34
```
当然也可以这样格式化：
```markdown
new Date(metrics_time_unix_stamp_format * 1000).format('yyyy-MM-dd') # 2019-05-19
```


### Golang 时间字符串的格式化
后台 API 接口使用 golang 开发时，传到前端的时间字符串是这样的：
```markdown
2019-05-19T15:23:34Z
```
而 JavaScript 没有提供这样的格式化方法，我们可以将其认为是个固定模式的字符串，对其进行字符串操作，以空格代替其中的 `T` 和 `Z` 即可，如下所示：
```markdown
create_time.replace('T', ' ').replace('Z', ' ') # 2019-05-19 15:23:34
```
这样就得到我们常用的日期时间字符串了。


### 参考资料

http://www.w3school.com.cn/jsref/jsref_obj_date.asp



