+++
title = "Git 常用命令备忘录"
date = "2018-06-19"
lastmod = "2018-06-19"
description = ""
tags = [
    "Git"
]
categories = [
     "技术"
]
+++

本篇博客记录了一些 git 使用过程中常用的命令，方便查看。

<!--more-->

### Git 命令

#### tag
> tag 命令用于创建一个标签，表示一个提交点，默认情况下，基于本地当前分支的最后一个提交创建标签。

1、创建本地标签
```markdown
git tag tagName
```

2、推送至远程仓库
```markdown
git push origin tagName
```

3、查看某个 tag 的信息
```markdown
git show tagName
```

4、查看本地所有 tag
```markdown
git tag -l
或
git tag
```

5、基于某个特定的提交创建标签
```markdown
git log --pretty=oneline    # 查看当前分支的提交历史，其中包含提交 ID
git tag -a tagName commitID # 基于特定的 commitID 提交创建标签
```

6、查看远程所有标签
```markdown
git ls-remote --tags origin
```

7、删除标签
```markdown
git tag -d tagName       # 删除本地标签
git push origin :tagName # 删除远程标签
```

8、重命名标签，采取的方法是：删除旧标签，创建新标签的策略
```markdown
# 如果标签只存在于本地，那么只需要删除本地旧标签，创建新的标签即可
git tag oldTagName
git tag newTagName
git push origin newTagName
# 如果标签已经推送至远程，则不仅要删除本地的，还要删除远程的，再重新创建和推送
git tag -d oldTagName
git push origin:oldTagName
git tag newTagName
git push origin newTagName
```

9、迁出标签
```markdown
git checkout -b branchName tagName
```

#### clone
1、迁出指定标签的代码
```markdown
git clone --branch tagName git@github.xdhuxc/xdhuxc.git
```

#### remote
1、列出已经存在的远程分支
```markdown
wanghuans-MacBook-Pro:xdhuxc wanghuan$ git remote
origin
```

2、列出已经存在的远程分支的地址
wanghuans-MacBook-Pro:xdhuxc wanghuan$ git remote get-url origin
git@github.xdhuxc/xdhuxc.git

3、添加远程仓库
```markdown
git remote add origin git@github.xdhuxc/xdhuxc.git
```


#### head
HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令git reset --hard commit_id

在Git中，用HEAD表示当前版本，上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100

#### log
可以查看提交历史，包括提交的时间，作者，和提交是的说明（即-m 命令后的内容），以便确定要回退到哪个版本。

#### relog
查看命令历史，查到每次提交的id号，即commit id,以及提交时的说明，以便确定要回到未来的哪个版本。


### 从功能到命令
#### 切换分支
1、使用本地 git 命令创建新分支
```markdown
git branch xdhuxc
```
2、切换到新分支，master 分支上的内容自动同步
```markdown
git checkout xdhuxc
```
3、将新分支发布到 github 上
```markdown
git push origin xdhuxc
```
#### git 将一个本地工程推向多个远程仓库
推送时，可以同时推送至多个远程仓库
1、添加另外一个远程仓库
```markdown
git remote set-url --add origin git@github.com:xdhuxc/xdhuxc.git
```
2、推送
```markdown
git push origin master:master
```

#### 生成SSH-key
github的SSH配置如下：

1、设置GitHub用户的用户名和邮箱
设置命令为：
```markdown
 git config --global user.name "xdhuxc" #设置GitHub用户的用户名

git config --global user.email "xdhuxc@163.com" #设置GitHub用户的邮箱
```
2、查看是否已经有了ssh密钥：`cd ~/.ssh`，如果没有密钥则不会有此文件夹，有则备份删除；生成密钥：
```markdown
ssh-keygen -t rsa -C "xdhuxc@163.com"
```
按三个“Enter”，密码为空，在此过程中，将会在 `~/.ssh` 目录下生成 `id_rsa` 和 `id_rsa.pub` 两个文件。

3、在github上添加SSH密钥，即添加id_rsa.pub文件中的内容至“settings”->“SSH and GPG keys”。

4、测试是否能够连接成功。
```markdown
ssh git@github.com
```
