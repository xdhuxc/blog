+++
title = "GitHub 上 fork 项目后同步原项目"
date = "2019-06-17"
lastmod = "2019-06-17"
description = ""
tags = [
    "Git",
    "GitHub"
]
categories = [
    "技术"
]
+++

在 GitHub 上 fork 其他项目后，过一段时间后，自己账户下的项目就会和原项目主分支差异比较大，提交 Pull Requests 时就会产生冲突，此时就需要和主分支同步代码。操作如下：

<!--more-->

1、向本地项目添加远程主分支
```markdown
wanghuans-MacBook-Pro:go-common wanghuan$ pwd
/Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/go-common
wanghuans-MacBook-Pro:go-common wanghuan$ ls
LICENSE         blog            glog            middleware      pkg             src
wanghuans-MacBook-Pro:go-common wanghuan$ git remote add upstream git@github.com:iyacontrol/go-common.git
```
可以使用 git branch -v 查看是否已添加过远程分支，若已添加，则可跳过此步骤。

2、获取主分支的最新修改到本地
```markdown
wanghuans-MacBook-Pro:go-common wanghuan$ git fetch upstream
remote: Enumerating objects: 25, done.
remote: Counting objects: 100% (25/25), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 20 (delta 7), reused 18 (delta 5), pack-reused 0
Unpacking objects: 100% (20/20), done.
From github.com:iyacontrol/go-common
 * [new branch]      master     -> upstream/master
```
3、将 upstream 分支修改的内容合并到本地个人分支
```markdown
git merge upstream/master
```
此处需要解决合并过程中产生的冲突。

或者使用如下步骤来实现：
```markdown
git checkout master # 切换到 master 分支
git merge upstream  # 合并主分支修改到本地分支。
```

4、将本地修改提交到 github 上的个人项目
```markdown
git push
```
现在，主分支修改的代码完全同步到 fork 出来的的个人项目分支上，此时在个人项目中提交 `Pull requests` 就不会发生冲突。
