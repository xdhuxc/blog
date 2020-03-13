+++
title = "Mac 功能指南"
date = "2019-06-17"
lastmod = "2019-06-17"
description = ""
tags = [
    "Mac"
]
categories = [
    "技术"
]
+++

本篇博客记录一些 Mac 下常用的操作或功能，以备后需。

<!--more-->

### 显示隐藏文件和目录
在终端中输入如下命令，即可显示隐藏文件和目录：
```markdown
defaults write com.apple.finder AppleShowAllFiles -boolean true
killall Finder
```

如果想要隐藏原本隐藏的文件和目录，可以使用如下命令：
```markdown
defaults write com.apple.finder AppleShowAllFiles -boolean false 
killall Finder
```

### 常见问题及解决
1、更新系统之后，使用 `make` 命令时，报如下错误：
```markdown
wanghuans-MacBook-Pro:scmp-cmdb wanghuan$ make build
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```
解决：在命令行中输入如下命令安装命令行工具
```markdown
xcode-select --install
```

2、关闭 MacOS 上的默认启动程序

解决：依次点击 `Finder` -> `System Preferences` -> `Users & Groups`，在弹出的对话框中，点击 `Login Items`，在下方的列表中删除不需要的自启动程序，再点击左下角的 `Click the lock to make changes`。

3、Mac 系统将 `bash` 更换为 `zsh` 后，原来配置的很多环境变量不见了，程序运行出错。

Mac 系统的环境变量，加载顺序为：`/etc/profile`，`/etc/paths`，`~/.bash_profile`， `~/.bash_login`， `~/.profile`， `~/.bashrc`，其中，`/etc/profile` 和 `/etc/paths` 是系统级别的，系统启动时就会自动加载，其他几个是当前用户的环境变量。

`~/.bash_profile`, `~/.bash_login`，`~/.profile` 按照从前往后的顺序读取，如果 `~/.bash_profile` 文件存在，则后面几个文件就会被忽略；如果 `~/.bash_profile` 文件不存在，才会读取后面的文件，以此类推。`~/.bashrc` 没有上述规则，它是 `bash` `shell` 打开的时候载入的。

解决：

使用 `zsh` 后，我们在 ~/.zshrc 文件中写入环境变量，关闭当前终端，重新打开新的终端，即可看到写入的环境变量。

3、有时候 Mac 从睡眠状态恢复之后没有声音，这是因为 Mac OS X 的核心音频守护进程（coreaudiod）出了问题，杀死该进程即可：（会自动重启）
```markdown
sudo killall coreaudiod
```
