+++
title = "Git 常见问题及解决"
date = "2019-06-19"
lastmod = "2019-06-19"
description = ""
tags = [
    "Git",
    "GitHub",
    "GitLab"
]
categories = [
     "Git"
]
+++

本篇博客记录一些 git 使用过程中常见的问题及其解决方法。

<!--more-->

1、使用 git 拉取大工程时，报错如下：
```
xdhuxc@DESKTOP-AFGTEDSW MINGW64 /d/PycharmProject
$ git clone -b private git@github.com:xdhuxc/xpython.git                                                                                                               .git
Cloning into 'xpython'...
remote: Counting objects: 4608, done.
remote: Compressing objects: 100% (71/71), done.
fatal: pack has bad object at offset 10852763787: inflate returned 1
fatal: index-pack failed
```
解决方法如下：
```
$ git clone -b private --depth=1 git@github.com:xdhuxc/xpython.git
Cloning into 'xpython'...
remote: Counting objects: 913, done.
remote: Compressing objects: 100% (756/756), done.
remote: Total 913 (delta 143), reused 819 (delta 101)
Receiving objects: 100% (913/913), 1.79 GiB | 10.33 MiB/s, done.
Resolving deltas: 100% (143/143), done.
Checking out files: 100% (798/798), done.
```

2、使用 IDEA 复制 GitHub 上的代码时，提示错误如下：
```
Fetch failed: Could not read from remote repository.
```
在 IDEA 中，点击 “File”，选择 “Settings”，找到 “Version Control”，选择 “Git”，修改 “SSH executable” 为 “Native”，重新拉取代码即可。

3、git 添加远程仓库时报错
```
wanghuans-MacBook-Pro:vue-admin-template wanghuan$ git remote add origin git@github.com:xdhuxc/xpython.git
fatal: remote origin already exists.
wanghuans-MacBook-Pro:vue-admin-template wanghuan$ git remote rm origin
wanghuans-MacBook-Pro:vue-admin-template wanghuan$ git remote add origin git@github.com:xdhuxc/xpython.git
```
解决：先删除远程 Git 仓库，然后再添加远程 Git 仓库。

4、拉取代码时，报错如下：
```
wanghuans-MacBook-Pro:k8s wanghuan$ git pull
fatal: refusing to merge unrelated histories
```
原因：本地仓库和远程仓库实际上是两个独立的仓库，可以在 `pull` 命令中加入 ` --allow-unrelated-histories` 选项来解决该问题，该选项可以合并两个独立创建的仓库的历史。
命令为：
```
wanghuans-MacBook-Pro:k8s wanghuan$ git pull origin master --allow-unrelated-histories
From gitlab.ushareit.me:sgt/devops/k8s
 * branch            master     -> FETCH_HEAD
Already up to date!
Merge made by the 'recursive' strategy.
```

5、使用eclipse，选取指定分支，拉取代码，报错如下：
```
Git repository clone failed.
Java heap space
```
解决：修改 `eclipse` 安装目录下的 `eclipse.ini` 文件中如下参数的值：
```
-Xms1024m
-Xmx5120m
```
在 `IDEA` 中，参照修改安装目录 `bin` 下的 `idea.exe.vmoptions` 或 `idea64.exe.vmoptions` 文件。

6、拉取 github 上的代码时，报错如下：
```
warning: no common commits
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From github.com:xdhuxc/checklist
 * branch            HEAD       -> FETCH_HEAD
fatal: refusing to merge unrelated histories
```
添加参数`--allow-unrelated-histories`后重新拉取
```
git pull --allow-unrelated-histories git@github.com:xdhuxc/checklist.git
```

6、本地修改文件后，拉取 gitlab 上的代码时，报错如下：
```
bash-3.2$ git pull origin master --allow-unrelated-histories -f
From gitlab.ushareit.me:sgt/devops/share-ikc
 * branch            master     -> FETCH_HEAD
error: Your local changes to the following files would be overwritten by merge:
  .gitignore .idea/workspace.xml
```
解决方法：
```
git stash
git pull origin master
git stash pop
```
使用以上命令保留刚才本地修改的代码，并把git服务器上的代码pull到本地（本地刚才修改的代码将会被暂时封存起来

7、克隆代码时，报错如下：
```
wanghuans-MacBook-Pro:PycharmProjects wanghuan$ git clone git@github.com:jumpserver/jumpserver.git
Cloning into 'jumpserver'...
remote: Enumerating objects: 83, done.
remote: Counting objects: 100% (83/83), done.
remote: Compressing objects: 100% (68/68), done.
fatal: the remote end hung up unexpectedly55 MiB | 0 bytes/s
fatal: early EOF
Connection to github.com closed by remote host.
fatal: index-pack failed
```
解决方法：
```markdown
wanghuans-MacBook-Pro:~ wanghuan$ git config --global http.postBuffer 1048576000
```

8、由于公司代码仓库迁移，导致拉取代码时，报错如下：
```markdown
Update failed
			@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			@       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
			@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			The ECDSA host key for gitlab.xdhuxc.com has changed,
			and the key for the corresponding IP address 192.168.19.121
			is unknown. This could either mean that
			DNS SPOOFING is happening or the IP address for the host
			and its host key have changed at the same time.
			@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
			@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
			Someone could be eavesdropping on you right now (man-in-the-middle attack)!
			It is also possible that a host key has just been changed.
			The fingerprint for the ECDSA key sent by the remote host is
			SHA256:motujg8AdfKP+cphjzDnsmEykU4vqQi7joDXi3DL9MY.
			Please contact your system administrator.
			Add correct... (show balloon)
```
原因：第一次使用 SSH 连接时，会生成一个认证，存储在客户端的 known_hosts，但是如果服务器端重启，那么认证信息也会改变，用原来的客户端信息连接就会出现上述错误。因此，只要把客户端中的认证信息删除，此后连接时会重新生成认证信息，这样就正常了。

在客户端输入命令：
```markdown
ssh-keygen -R ${SERVER_IP}
或
ssh-keygen -R ${SERVER_DOMAIN}
```
也可以直接删除 `~/.ssh/known_hosts` 文件
