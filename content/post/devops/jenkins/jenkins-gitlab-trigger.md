+++
title = "在 Jenkins 中配置 gitlab 触发器"
date = "2019-06-17"
lastmod = "2019-12-14"
tags = [
    "DevOps",
    "Jenkins",
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了在 Jenkins 中配置 Gitlab 触发器的过程，从而使得当我们向 gitlab 提交代码时，打上标签，就可以直接触发构建。

<!--more-->

### 操作和配置

1、在 Jenkins 和 Gitlab 之间配置触发构建，希望在 Gitlab 上提交代码时，打上标签提交时，触发该工程在 Jenkins 中的构建。

1）在 GitLab 中使用管理员账户，生成 GitLab API Token，

<center>
<img src="/image/devops/jenkins/WechatIMG71.jpeg" width="800px" height="300px" />
</center>

在 Jenkins 中，`系统设置` -> `Add Credentials` 中，添加用于认证的 Credentials

<center>
<img src="/image/devops/jenkins/WechatIMG72.jpeg" width="800px" height="300px" />
</center>

使得 Jenkins 可以访问 GitLab 的 API 接口。

2）在 Jenkins 中，选中 `Build when a change is pushed to GitLab`，将 `GitLab webhook URL` 地址

<center>
<img src="/image/devops/jenkins/WechatIMG610.jpeg" width="800px" height="300px" />
</center>

填写至 GitLab 工程的 `设置` ->`集成` 中 Web hook 下的 `链接` 输入框中；

<center>
<img src="/image/devops/jenkins/WechatIMG612.jpeg" width="800px" height="300px" />
</center>

在 Jenkins 中，`Build when a change is pushed to GitLab` 下，点击 `Advanced`，再点击 `Generate`，

<center>
<img src="/image/devops/jenkins/WechatIMG68.jpeg" width="800px" height="300px" />
</center>

将生成的 `Secret token` 填写至 GitLab 工程 `设置` -> `集成` 中 Web hook 下的 `安全令牌` 输入框中

<center>
<img src="/image/devops/jenkins/WechatIMG619.jpeg" width="800px" height="300px" />
</center>

在触发器部分，取消 `推送事件` 触发器，选择 `标签推送事件` 触发器触发。

<center>
<img src="/image/devops/jenkins/WechatIMG621.jpeg" width="800px" height="300px" />
</center>

保存后，可进行测试。

3）在项目 `设置` -> `仓库` -> `部署秘钥` -> `展开`，使用 Jenkins 所在机器的公钥创建部署秘钥并为当前工程启用之。

<center>
<img src="/image/devops/jenkins/WechatIMG617.jpeg" width="800px" height="300px" />
</center>

2、使用 Jenkins 进行应用的持续集成并构建 docker 镜像，想使用推送代码时的标签迁出代码并以标签作为镜像版本，可以安装 `Git Tag Message Plugin` 插件来实现。

安装 `Jenkins Git Plugin` 插件后，默认可以获取如下 7 个环境变量：

* GIT_COMMIT：对当前 Git 提交的安全哈希算法（SHA）的引用；
* GIT_COMMITTER_NAME（GIT_AUTHOR_NAME）：发布新 Git 提交时使用的名称；
* GIT_COMMITTER_EMAIL（GIT_AUTHOR_EMAIL）：发布新的 Git 提交时使用的电子邮件地址；
* GIT_URL：远程 Git 仓库的基本名称；
* GIT_URL_N：如果正在使用多个远程 Git 仓库，这将以数字方式列出它们；
* GIT_BRANCH：Jenkins Git 插件正在操作的当前 Git 分支的名称；
* GIT_LOCAL_BRANCH：本地 Git 分支的名称，当 Jenkins Git 插件中 “checkout to specific local branch” 选项被选中的时候；
* GIT_PREVIOUS_COMMIT：当前分支上前一个提交的 id；
* GIT_PREVIOUS_SUCCESSFUL_COMMIT：这个变量将会输出最后一次成功的构建时提交的哈希值；

安装 `Git Tag Message Plugin` 后，可以在脚本中使用环境变量 `GIT_TAG_NAME` 和 `GIT_TAG_MESSAGE` 来获取代码提交的标签信息，只迁出该提交的代码进行集成。

如果该方法失效，可以直接在 shell 脚本中使用环境变量获取提交代码得标签
```markdown
tag=${gitlabSourceBranch##*/}
if [ -z "$tag" ];then
  echo "the absent of git tag"
  exit 1
fi
```

3、配置钉钉通知构建结果

1）安装 Dingding 插件

2）增加 `Post-build Actions`，添加`钉钉通知器配置`

<center>
<img src="/image/devops/jenkins/WechatIMG615.jpeg" width="800px" height="300px" />
</center>

4、从 Jenkins 向需要授权的 docker registry 中推送镜像
安装 docker-commons 插件，在 系统管理 中，在 docker 部分，添加 docker 镜像仓库的地址，并使用任意有权限的的账户和密码创建 credentials，保存之，即可从 shell 脚本中直接向需要认证的 docker 镜像仓库中推送镜像。


### 常见问题及解决
1、在 GitLab 中某项目的 `设置` -> `集成` 中配置 Jenkins webhook，配置完成后点击 `Test`，报错如下：
```
Hook execution failed: URL 'https://jenkins.xdhuxc.com/project/transform' is blocked: Requests to the local network are not allowed
```
解决：在 `管理员区域` 中 `设置` 下，在 `Outbound requests`部分，选择 `Allow requests to the local network from hooks and services`，然后保存之。

参考链接：https://gitlab.com/gitlab-org/gitlab-ce/issues/46490

