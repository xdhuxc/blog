+++
title = "GitLab 常见问题及解决"
date = "2018-07-19"
lastmod = "2018-08-19"
description = ""
tags = [
    "Git",
    "GitLab"
]
categories = [
     "Git"
]
+++

本篇博客记录了使用 GitLab 时遇到的若干问题及解决方法，以备后需。

<!--more-->

### 使用指南
1、在 `Jenkins` 中编写 `shell` 脚本拉取公司 `GitLab` 中的代码，会缺少拉取权限，由管理员操作，点击 `设置` -> `仓库` -> `部署秘钥` -> `展开`，使用 Jenkins 所在机器的 SSH 公钥创建一个 `部署秘钥`，然后在各工程中启用之，即可获得拉取代码得权限。

### 常见问题及解决
1、在 `GitLab` 中某项目的 `设置` -> `集成` 中配置 `Jenkins webhook`，配置完成后点击 `Test`，报错如下：
```
Hook execution failed: URL 'https://jenkins.xdhuxc.me/project/xdhuxc' is blocked: Requests to the local network are not allowed
```
解决：在 `管理员区域` 中 `设置` 下，在 `Outbound requests`部分，选择 `Allow requests to the local network from hooks and services`，然后保存之。

参考链接：https://gitlab.com/gitlab-org/gitlab-ce/issues/46490
