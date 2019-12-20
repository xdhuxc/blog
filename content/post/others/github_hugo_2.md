+++
title = "基于 Hugo 和 GitHub 搭建个人网站（二）"
linktitle = "基于 Hugo 和 GitHub 搭建个人网站（二）"
date = "2019-05-14"
lastmod = "2019-5-18"
description = ""
tags = [
    "GitHub",
    "Hugo"
]
categories = [
    "技术"
]
+++
摘要：

　　本篇博客主要介绍了使用 Hugo 和 GitHub搭建个人网站的一些高级功能，包括在云端存储图片、评论功能、网站统计、阅读数量统计、文字统计和阅读时长预估等功能。

<!--more-->

### 图片存储
随着我们撰写的博客篇数的增多，博客中的图片也可能会相应的增加。本地存储图片对我们而言，不仅占用本地磁盘存储空间，而且还可能因磁盘损坏而丢失。此时，我们可以选择使用云端存储来保存我们博客中使用的图片，将图片上传到云服务商提供的云端存储后，在我们的 markdown 文档中，只需要引入其外部链接即可显示图片。

使用 [七牛云](https://portal.qiniu.com/signup?code=3lcz1eyk5rq6q) 的对象存储来存放我们的图片，然后将图片的外部链接写在 markdown 文档之中，如下所示：
```markdown
<center>
<img src="http://pr9wm50t1.bkt.clouddn.com/image/png/point.png" width="800px" height="300px" />
图 1 · 输入中 `·` 号 （图注）
</center>
```

需要注册 [七牛云](https://portal.qiniu.com/signup?code=3lcz1eyk5rq6q) 账户，并使用身份证信息实名认证。

为什么使用 [七牛云](https://portal.qiniu.com/signup?code=3lcz1eyk5rq6q)的对象存储呢？因为其免费提供 10G 存储空间，足够我们使用了。

### 添加评论功能

#### 基于 Disqus 实现评论功能
Hugo 默认支持 [Disqus](https://disqus.com/) 的评论，并且已经在模板中添加好了，需要我们去 Disqus 注册一个账号，然后进行配置

在 `config.toml` 中加入如下内容：
```markdown
disqusShortname = "yourdisqusShortname"
```
yourdisqusShortname 就是 disqus 个人主页下的 Account 部分的 Username 的值。

但是在本地无法测试该功能，需要上线到 github 进行测试。

遗憾的是，Disqus 最近似乎出问题了，该功能实际不可用。

#### 基于 Valine 实现评论功能
有关 Valine 的详细信息，参考 [Valine 官方网站](https://valine.js.org/)

[Valine](https://valine.js.org/) 评论系统依赖于 [Leancloud](https://leancloud.cn/)，需要先在 [Leancloud](https://leancloud.cn/) 中进行相关的准备工作。

① 创建 `开发版应用` HugoComment，点击该应用，点击左侧菜单 `设置`，点击 `应用 Key`，可以看到 `App ID` 和 `App Key`，后面需要用到 `App ID` 和 `App Key`。

② 创建存储 Class comment，用于储存评论内容。

③ 在 `设置` 的 `安全中心` 里，将自己网站的域名保存到 Web 安全域名中。

此处假定一个互联网用户可以无障碍地完成上述准备工作。

1、在 `config.toml` 中添加配置
```markdown
[params]
  [params.valine]
    # 控制开启此评论系统
    enable = true
    # LeanCloud 的 AppID
    appId = 'the AppID of LeanCloud'
    # LeanCloud 的 AppKey
    appKey = 'the AppKey of LeanCloud'
    # 用于控制是否开启邮件通知功能
    notify = false
    # 用于控制是否开启评论验证码功能
    verify = false
    # 用于配置评论项中用户头像样式，有多种选择：mm, identicon, monsterid, wavatar, retro, hide
    avatar = 'identicon'
    # 评论框的提示符
    placeholder = '说点什么吧...'
    # 控制是否开启文章阅读数的统计功能
    visitor = true
```

2、创建 `layouts/partials/comment.html` 文件，加入如下内容：
```markdown
{{ if .Site.Params.valine.enable }}
<span id="{{ .Permalink | relURL }}" class="leancloud_visitors" data-flag-title="{{ .Title }}">
    <span class="post-meta-item-text">文章阅读量 </span>
    <span class="leancloud-visitors-count"></span>
    <p></p>
</span>
<div id="vcomments"></div>
<script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
<script src='//unpkg.com/valine/dist/Valine.min.js'></script>
<script type="text/javascript">
    new Valine({
        el: '#vcomments' ,
        appId: '{{ .Site.Params.valine.appId }}',
        appKey: '{{ .Site.Params.valine.appKey }}',
        notify: '{{ .Site.Params.valine.notify }}',
        verify: '{{ .Site.Params.valine.verify }}',
        avatar:'{{ .Site.Params.valine.avatar }}',
        placeholder: '{{ .Site.Params.valine.placeholder }}',
        visitor: '{{ .Site.Params.valine.visitor }}'
    });
</script>
{{ end }}
```
注意，不要把 `if` 改成 `with`，否则会出现解析不了模板的问题。

3、在 `layouts/post/single.html` 文件中加入如下内容：
```markdown
<div class="content">
  <!--
  {{ partial "disqus.html" . }}
  -->
  {{ partial "comment.html" . }}
</div>
```

4、评论功能效果如下图所示：
<center>
<img src="http://pr9wm50t1.bkt.clouddn.com/image/png/comment_result.png" width="800px" height="300px" />
图 1 · 评论功能效果
</center>

5、可以在 [Leancloud](https://leancloud.cn/) 的 `HugoComment` 中的存储 `Comment` 中看到提交的评论信息。 

### 添加网站统计功能
我们可以使用 google 统计或者百度统计来统计我们网站相关的数据，比如浏览量、访客数、平均访问时长等。

#### Google Analytics

使用 Google 的网站分析功能，登录 [Google Analytics]( https://marketingplatform.google.com/about/)，注册账号，获取 Track ID，填写到 config.toml 中 `[params]` 下 `googleAnalytics` 的值处。

Hugo 默认支持 Google Analytics，但是 Google Analytics 有些复杂，后续再研究其使用方法。 

#### 百度统计
使用百度统计来做网站分析，一则使用方法相对简单，数据可以满足我们的需求，二则不需要考虑翻墙。


1、注册 [百度统计](https://tongji.baidu.com/web/welcome/login) 账号，在 `管理`，`代码管理`，`代码获取` 下获取到如下代码：
```markdown
<script>
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?ad57771d1b8d25cbd18d12f67bc32135";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
</script>
```
注意，该代码中包含特殊的字符串 `ad57771d1b8d25cbd18d12f67bc32135`，仅供本网站使用，其他网站使用无效。

2、在 `config.toml` 文件中添加如下内容：
```markdown
[params]
  [params.baidu]
    enable = true
```

3、在 `layouts/partials/` 目录下创建 `baidu_analytics.html` 文件，内容如下：
```markdown
{{ if .Site.Params.baidu.enable }}
<script>
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "https://hm.baidu.com/hm.js?ad57771d1b8d25cbd18d12f67bc32135";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
{{ end }}
```

4、在 `layouts/partials/footer.html` 中添加如下内容：
```markdown
{{ if not .Site.IsServer  }}
    {{ partial "baidu_analytics.html" . }}
{{ end }}
```
注意，为了避免在本地开发时，错误提交和统计，加入了过滤条件。

5、百度统计效果图
<center>
<img src="http://pr9wm50t1.bkt.clouddn.com/image/png/baidu_analytics_result.png" width="800px" height="300px" />
图 2 · 百度统计效果图
</center>


### 添加阅读数量和 PV，UV 统计功能
统计访问网站的 `PV` 和 `UV` 及每篇博客的阅读数也是一件重要的事情，可以直接在页面上看到我们网站的 `PV` 和 `UV`及每篇文章的阅读数，我们使用 [不蒜子](http://ibruce.info/2015/04/04/busuanzi/) 来实现。

使用 [不蒜子](http://ibruce.info/2015/04/04/busuanzi/) 时，首先需要引用 [不蒜子](http://ibruce.info/2015/04/04/busuanzi/) 的 `JavaScript` 探针脚本。

在 `layouts/partials/head.html` 中的 `head` 标签中加入如下内容：
```markdown
<!-- Reading Statistics -->
<script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
```

然后需要在 `HTML` 代码中加入显示内容的代码。

#### PV，UV 统计
我们将 PV 和 UV 放置在 `版权申明` 部分，在 `layouts/partials/copyright.html` 中加入如下内容：
```markdown
<div class="small-print">
    <small id="busuanzi_container_site_pv" style='display:none'> 访问量 <span id="busuanzi_value_site_pv"></span> 次</small>
    <br>
    <small id="busuanzi_container_site_uv" style='display:none'> 访客数 <span id="busuanzi_value_site_uv"></span> 人次 </small>
</div>    
```
注意，要确保 `id` 是正确的，才能正常计数。

另外，本地测试时，显示的 `PV` 和 `UV` 数据非常惊人。加入官方网站提供的 QQ 群后提问该问题，答案是：由于网络上大量用户使用 [不蒜子](http://ibruce.info/2015/04/04/busuanzi/)，本地主机都是 `localhost` 和 `127.0.0.1`，本地 JavaScript 可能是以 当前机器 IP 地址或主机名为键，获取 `PV` 和 `UV` 并上传到云端的，也就说，此时的 `PV` 和 `UV` 是使用不蒜子的所有 `localhost` 的总数。

但是不必担心，当网站上传到 GitHub 上之后，统计数据就正常了。

#### 阅读数量统计
我们将阅读数量的统计显示在博客详情页面中大标题的下方。

在 `layouts/post/single.html` 中加入如下内容：
```markdown
<div class="header">
  <h1>{{ .Title }}</h1>
  <h2>{{ .Description }}</h2>
  <div>
    <font style="font-family: 'STKaiti';">
      <span id="busuanzi_container_page_pv"> 阅读量 <span id="busuanzi_value_page_pv"></span> 次</span>
    </font>
  </div>
</div>
```
注意，要确保 `id` 是正确的。 

### 博客字数和阅读时长统计
Hugo 内置了博客字数统计和阅读时长统计功能，我们将其添加到博客详情页即可。

1、在 config.toml 中添加如下内容：
```markdown
hasCJKLanguage = true # 设置为 true，则会在内容中自动检测中文/日文/韩文语言，这将使得 .Summary 和 .WordCount 在 CJK 语言中正常工作。

```
2、在 `layouts/post/single.html` 中加入如下内容：
```markdown
<div class="header">
  <h1>{{ .Title }}</h1>
  <h2>{{ .Description }}</h2>
  <div>
    <font style="font-family: 'STKaiti';">
      <span>创建于 {{ .Date.Format "2006-01-02" }}</span> |
      <span>修改于 {{ .Lastmod.Format "2006-01-02" }}</span> |
      <span>总字数 {{ .WordCount }}</span> |
      <span>预估阅读时长 {{ .ReadingTime }} 分钟</span> |
    </font>
  </div>
</div>
```
说明：

* .Date：数据取自博客顶端的配置 `date` 字段的值，使用 `2006-01-02` 格式进行格式化。
* .Lastmod：如果在博客顶端的配置中设置 `lastmod` 字段，则数据取自 `lastmod` 字段的值，使用 `2006-01-02` 格式进行格式化。
* .WordCount：文章中的字数。
* .ReadingTime：预估的阅读时长，以分钟为单位。

3、博客字数和阅读时长统计显示效果如下图所示：
<center>
<img src="http://pr9wm50t1.bkt.clouddn.com/image/png/word_count.png" width="800px" height="300px" />
图 3 · 博客字数和阅读时长统计显示效果
</center>

### 参考资料

http://ibruce.info/2015/04/04/busuanzi/

https://valine.js.org/quickstart.html

https://www.smslit.top/2018/07/08/hugo-valine/

https://www.yangcs.net/posts/hugo-add-busuanzi/

https://blog.csdn.net/xr469786706/article/details/78166227

http://note.qidong.name/2017/06/24/hugo-word-count/

https://gohugo.io/content-management/front-matter/

https://github.com/heartnn/hugo-theme-test

https://gohugo.io/getting-started/configuration/
