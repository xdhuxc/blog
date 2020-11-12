+++
title = "基于 Hugo 和 GitHub 搭建个人网站（一）"
linktitle = "基于 Hugo 和 GitHub 搭建个人网站"
date = "2019-05-09"
lastmod = "2019-05-09"
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
　　本篇文章介绍了基于 GitHub 和 Hugo 搭建个人网站的具体操作过程，其中有诸多的注意事项，另外，对原有的模板和配置进行了一些改动，还附加了很多可以优化的地方。

<!--more-->

### Hugo 的安装的基本使用
1、准备工作，创建工作目录 `blog`
```markdown
wanghuans-MacBook-Pro:~ wanghuan$ mkdir blog
wanghuans-MacBook-Pro:blog wanghuan$ pwd
/Users/wanghuan/blog
```

2、安装 Hugo
```markdown
wanghuans-MacBook-Pro:blog wanghuan$ brew install hugo   # 安装 hugo
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/core).
==> Updated Formulae
allure

==> Downloading https://homebrew.bintray.com/bottles/hugo-0.55.5.mojave.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/2c/2c88f996c36157b5e451274663b867ad4e1c3f6f04c57d1d43cdd8c631a5b209?__gda__=exp=1557368278~hmac=afe54c6d07b0ae0a78089e030533b7dae7
######################################################################## 100.0%
==> Pouring hugo-0.55.5.mojave.bottle.tar.gz
==> Caveats
Bash completion has been installed to:
  /usr/local/etc/bash_completion.d
==> Summary
🍺  /usr/local/Cellar/hugo/0.55.5: 31 files, 40.7MB
==> `brew cleanup` has not been run in 30 days, running now...
Removing: /Users/wanghuan/Library/Caches/Homebrew/dep--0.5.0.mojave.bottle.tar.gz... (3.2MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/gettext--0.19.8.1.high_sierra.bottle.tar.gz... (7.8MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/libunistring--0.9.10.mojave.bottle.tar.gz... (1.4MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/nginx--1.15.8.mojave.bottle.3.tar.gz... (1.2MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/openssl--1.0.2q.mojave.bottle.tar.gz... (3.7MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/pcre2--10.32.high_sierra.bottle.tar.gz... (1.8MB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/telnet--60.mojave.bottle.tar.gz... (52.5KB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/tree--1.8.0.high_sierra.bottle.tar.gz... (50.5KB)
Removing: /Users/wanghuan/Library/Caches/Homebrew/portable-ruby-2.3.7.leopard_64.bottle.tar.gz... (12.4MB)
Removing: /Users/wanghuan/Library/Logs/Homebrew/ucl... (64B)
Removing: /Users/wanghuan/Library/Logs/Homebrew/upx... (64B)
Removing: /Users/wanghuan/Library/Logs/Homebrew/nginx... (64B)
Removing: /Users/wanghuan/Library/Logs/Homebrew/pcre... (64B)
wanghuans-MacBook-Pro:Blog wanghuan$ hugo version   # 查看 hugo 的版本
Hugo Static Site Generator v0.55.5/extended darwin/amd64 BuildDate: unknown
```

3、创建网站
```markdown
wanghuans-MacBook-Pro:blog wanghuan$ hugo new site xdhuxc
Congratulations! Your new Hugo site is created in /Users/wanghuan/blog/xdhuxc.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/, or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
```

4、安装主题
```markdown
wanghuans-MacBook-Pro:blog wanghuan$ cd xdhuxc/themes/
wanghuans-MacBook-Pro:themes wanghuan$ git clone https://github.com/yoshiharuyamashita/blackburn.git
Cloning into 'blackburn'...
remote: Enumerating objects: 25, done.
remote: Counting objects: 100% (25/25), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 908 (delta 14), reused 17 (delta 11), pack-reused 883
Receiving objects: 100% (908/908), 469.15 KiB | 53.00 KiB/s, done.
Resolving deltas: 100% (563/563), done.
wanghuans-MacBook-Pro:xdhuxc wanghuan$ pwd
/Users/wanghuan/blog/xdhuxc
wanghuans-MacBook-Pro:xdhuxc wanghuan$ ls
archetypes	config.toml	content		data		layouts		static		themes
```
目录及文件说明：

* archetypes：包括内容类型，在创建新内容时自动生成内容的配置。
* content：包括网站内容，全部使用 markdown 格式。
* layouts：包括了网站的模板，决定内容如何呈现。
* static：包括了 css，js，fonts，media 等，决定网站的外观。
* themes：保存下载的网站主题。
* config.toml：网站的配置文件，包括 baseurl，title，copyright 等网站参数。

在 `config.toml` 中加入如下内容
```markdown
baseurl = "https://xdhuxc.github.io/" # Make sure to end baseurl with a '/'
title = "xdhuxc"
author = "xdhuxc"
# Shown in the side menu
copyright = "&copy; 2019. xdhuxc All rights reserved."
canonifyurls = true
paginate = 10

[indexes]
  tag = "tags"
  topic = "topics"

[params]
  # Shown in the home page
  subtitle = "技术 - 文章"
  brand = "xdhuxc"
  googleAnalytics = "Your Google Analytics tracking ID"
  disqus = "Your Disqus shortname"
  # CSS name for highlight.js
  highlightjs = "androidstudio"
  highlightjs_extra_languages = ["yaml"]
  dateFormat = "02 Jan 2006, 15:04"
  # Include any custom CSS and/or JS files
  # (relative to /static folder)
  # custom_css = ["css/my.css"]
  # custom_js = ["js/my.js"]

  [params.piwikAnalytics]
    siteid = 2
    piwikroot = "//analytics.example.com/"

[menu]
  # Shown in the side menu.
  [[menu.main]]
    name = "主页"
    pre = "<i class='fa fa-home fa-fw'></i>"
    weight = 1
    identifier = "home"
    url = "/"
  [[menu.main]]
    name = "博客"
    pre = "<i class='fa fa-list fa-fw'></i>"
    weight = 2
    identifier = "post"
    url = "/post/"
  [[menu.main]]
    name = "关于"
    pre = "<i class='fa fa-user fa-fw'></i>"
    weight = 3
    identifier = "about"
    url = "/about/"
  [[menu.main]]
    name = "联系作者"
    pre = "<i class='fa fa-phone fa-fw'></i>"
    weight = 4
    url = "/contact/"

[social]
  # Link your social networking accounts to the side menu
  # by entering your username or ID.
  # Techie
  github = "xdhuxc"
  gitlab = "*"
  bitbucket = "*"
  stackoverflow = "*"
  serverfault = "*"
```
注意：

`[social]` 部分的键值将渲染到 `layouts/partials/social.html` 文件中，和各种网站的域名组合起来，作为作者本人在各种网站中的主页的路径；在该文件中删除无用的网站信息，只保留作者自己有效地网站主页。

将 `themes/blackburn` 目录下的 `static` 和 `layouts` 目录中的内容复制到 `xdhuxc` 目录下的同名目录中。

在 `content/post` 目录中撰写 `markdown` 格式的文档，在每个 `.md` 文档的最上方加入类似如下内容，用于设置文章属性：
```markdown
+++
title = "Ansible 学习之常用模块"     # 文章标题。
linktitle = "Ansible 学习之常用模块"
date = "2018-05-02"                # 在菜单 "博客" 中，文章按时间顺序排列，会自动增加时间标签，页面上默认显示n篇最新的文章。
draft = false                      # 设置为 false 的时候会被编译为 HTML，设置为 true 则不会被编译和发表。
description = ""
tags = [                           
    "ansible",
    "DevOps",
    "IT"
]                                  # 文章的标签，可以设置多个，用逗号分隔开，Hugo 会自动在博客主页下生成标签的子 URL，通过这个 URL，可以看到所有具有该标签的文章。
categories = [
    "ansible",
    "DevOps",
]                                  # 文章分类。
+++
```

baseurl 的值在本地测试时无关紧要，但是当部署到 GitHub 上时，需要将其配置为 xdhuxc.github.io 这样的域名。另外，如果使用自有域名，还需要在 GitHub 上进行关联，具体方法可参考：https://help.github.com/en/articles/using-a-custom-domain-with-github-pages

5、启动网站
```markdown
hugo server --buildDrafts -w
```
参数说明：

* -w：监视文件内容的变化，如果此后修改了网站的内容，会直接显示在浏览器的页面上，不需要重新启动 hugo 进程，方便我们进行修改，但是不能监测 config.toml 文件中的参数变化。
* --buildDrafts：生成被标记为草稿的页面。
* -t hyde：使用 hyde 主题。

### 使用 GitHub Pages 托管网站
1、在 GitHub 上创建代码仓库，托管 Hugo 的输入文件，将 blog 目录下的所有文件存储到该仓库中，在 `.gitignore` 文件中写入如下内容：
```markdown
.idea
.DS_Store
public/*
```

2、在 GitHub 上创建代码仓库，用于托管 public 目录，此处仓库的名称一定要用自己的用户名，例如 xdhuxc.github.io，只有这样，才会被 GitHub 当做是个人主页。

3、编译 blog 工程，生成 public 目录
```markdown
wanghuans-MBP:blog wanghuan$ pwd
/Users/wanghuan/WebstormProjects/blog
wanghuans-MBP:blog wanghuan$ ls
README.md       config.toml     data            layouts         resources       themes
archetypes      content         images          public          static
wanghuans-MBP:blog wanghuan$ hugo

                   | EN  
+------------------+----+
  Pages            | 40  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  8  
  Processed images |  0  
  Aliases          |  1  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 98 ms
```

4、将 `public` 目录添加为子模块，与 `xdhuxc.github.io` 同步
```markdown
wanghuans-MBP:blog wanghuan$ rm -rf public/
wanghuans-MBP:blog wanghuan$ git submodule add git@github.com:xdhuxc/xdhuxc.github.io.git public
```

5、编译并推送至仓库 xdhuxc.github.io
```markdown
wanghuans-MBP:blog wanghuan$ hugo

                   | EN  
+------------------+----+
  Pages            | 40  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  8  
  Processed images |  0  
  Aliases          |  1  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 33 ms
wanghuans-MBP:blog wanghuan$ cd public/
wanghuans-MBP:public wanghuan$ ls
README.md       css             index.html      js              page            sitemap.xml     topics
contact         img             index.xml       media           post            tags
wanghuans-MBP:public wanghuan$ git add -A
wanghuans-MBP:public wanghuan$ git commit -m "initial the xdhuxc website"
[master a3a6a28] initial the xdhuxc website
 49 files changed, 9972 insertions(+)
 create mode 100644 contact/index.html
 create mode 100644 css/blackburn.css
 create mode 100644 css/side-menu-old-ie.css
 create mode 100644 css/side-menu.css
 create mode 100644 img/favicon.ico
 create mode 100644 index.html
 create mode 100644 index.xml
 create mode 100644 js/menus.js
 create mode 100644 js/ui.js
 create mode 100644 media/disqus.png
 create mode 100644 page/1/index.html
 create mode 100644 post/ansible-common-model/index.html
 create mode 100644 post/ansible-simple-use/index.html
 create mode 100644 post/centos7-install-mongodb/index.html
 create mode 100644 post/github_hugo/index.html
 create mode 100644 post/index.html
 create mode 100644 post/index.xml
 create mode 100644 post/linux-shell-execute/index.html
 create mode 100644 post/mongodb-simple-use/index.html
 create mode 100644 post/springboot-jmx/index.html
 create mode 100644 sitemap.xml
 create mode 100644 tags/ansible/index.html
 create mode 100644 tags/ansible/index.xml
 create mode 100644 tags/centos7/index.html
 create mode 100644 tags/centos7/index.xml
 create mode 100644 tags/database/index.html
 create mode 100644 tags/database/index.xml
 create mode 100644 tags/devops/index.html
 create mode 100644 tags/devops/index.xml
 create mode 100644 tags/github/index.html
 create mode 100644 tags/github/index.xml
 create mode 100644 tags/hugo/index.html
 create mode 100644 tags/hugo/index.xml
 create mode 100644 tags/index.html
 create mode 100644 tags/index.xml
 create mode 100644 tags/it/index.html
 create mode 100644 tags/it/index.xml
 create mode 100644 tags/jmx/index.html
 create mode 100644 tags/jmx/index.xml
 create mode 100644 tags/linux/index.html
 create mode 100644 tags/linux/index.xml
 create mode 100644 tags/mongodb/index.html
 create mode 100644 tags/mongodb/index.xml
 create mode 100644 tags/shell/index.html
 create mode 100644 tags/shell/index.xml
 create mode 100644 tags/springboot/index.html
 create mode 100644 tags/springboot/index.xml
 create mode 100644 topics/index.html
 create mode 100644 topics/index.xml
wanghuans-MBP:public wanghuan$ git push origin master
Enumerating objects: 81, done.
Counting objects: 100% (81/81), done.
Delta compression using up to 4 threads
Compressing objects: 100% (68/68), done.
Writing objects: 100% (80/80), 179.84 KiB | 396.00 KiB/s, done.
Total 80 (delta 34), reused 0 (delta 0)
remote: Resolving deltas: 100% (34/34), done.
To github.com:xdhuxc/xdhuxc.github.io.git
   07acdac..a3a6a28  master -> master
wanghuans-MBP:public wanghuan$ 
```

6、此时，访问 `https://xdhuxc.github.io/`，即可看到我们的网站。

### 优化

#### 菜单栏图标修改
我们在左侧菜单部分去除了默认含有的 Twitter，Facebook等，新加了微信和简书，但是其使用的图标却不是图片，而是使用 CSS 渲染出来的。在 https://fontawesome.com/ 上搜索图标，找到微信的图标所对应的 CSS class，
```markdown
<i class="fab fa-weixin"></i>
```
将其修改至 `layouts/partials/social.html` 中如下部分：
```markdown
{{ with .Site.Social.wechat }}
    <li class="pure-menu-item">
      <a class="pure-menu-link" href="https://github.com/{{ . }}" rel="me" target="_blank"><i class="fa fa-weixin fa-fw"></i>微信</a>
    </li>
{{ end }}
```

该网站上没有简书的图标，可以随便找一个图标填充之。

#### 博客的时间格式优化，

1、默认情况下，首页中博客的时间格式是这样的：
```markdown
25 Oct 2018, 00:00
```
包含英文，不易为国人识别，我们可以将其改造为常用的日期格式，修改 `layouts/partials/post_meta.html` 文件中如下内容：
```markdown
<time>{{ with .Site.Params.dateFormat }}{{ $.Date.Format . }}{{ else }}{{ .Date.Format "02 Jan 2006, 15:04" }}{{ end }}</time>
```
改为
```markdown
<time>{{ with .Site.Params.dateFormat }}{{ $.Date.Format "2006-01-02" }}{{ else }}{{ .Date.Format "2006-01-02" }}{{ end }}</time>
```
如果需要时分秒，可以改为如下格式：
```markdown
<time>{{ with .Site.Params.dateFormat }}{{ $.Date.Format "2006-01-02 15:04:05" }}{{ else }}{{ .Date.Format "2006-01-02 15:04:05" }}{{ end }}</time>
```

2、菜单 `博客` 中的博客列表中的时间默认情况下的格式为：
```markdown
25 Oct 2018, 00:00
```
在 config.toml 中将 `dateFormat` 的值由 `02 Jan 2006, 15:04` 修改为：`2006-01-02`，则其日期显示就变为：`2019-05-09`

3、如果想在 `博客` 菜单中按照月份显示自己的博客列表，可以对 `layouts/post/post.html` 进行修改，将
```markdown
{{ range .Data.Pages.GroupByDate "2006" }}
```
改为
```markdown
{{ range .Data.Pages.GroupByDate "2006-01" }}
```

#### 自动化部署
编写脚本 `deploy.sh`（需要给脚本添加执行权限） 部署我们的网站，脚本内容如下：
```markdown
#!/usr/bin/env bash
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Commit changes.
msg="change the website's domain when it compiling"
if [[ "$#" -eq 1 ]]; then
    msg="$1"
fi

# Push Hugo content
git add -A
git commit -m "$msg"
git push origin master


# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .


git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
```

本地编写 markdown 文件完成后，执行 `./deploy.sh` 脚本即可完成部署工作。

### 参考资料
http://nanshu.wang/post/2015-01-31/

https://jimmysong.io/posts/building-github-pages-with-hugo/

https://www.jianshu.com/p/e68fba58f75c

https://gohugo.io/hosting-and-deployment/hosting-on-github/

https://gohugo.io/templates/internal/#google-analytics

https://blog.olowolo.com/post/hugo-quick-start/

https://blog.pytool.com/language/golang/hugo/hugo/
