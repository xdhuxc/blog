+++
title = "brew 的使用"
date = "2021-11-07"
lastmod = "2021-11-07"
description = ""
tags = [
    "Mac"
]
categories = [
    "Mac"
]
+++

本篇文章记录了在 Mac 下使用 brew 的方法。

<!--more-->

### 安装 brew 
使用如下命令安装 brew：
```markdown
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### brew 常用命令
1. 安装软件
```markdown
brew install gcc
```
默认情况下，每次安装软件时，brew 会更新 homebrew 管理的所有软件包并清理缓存，这可能会把一些软件不必要地升级到高版本，带来一些问题。

如果需要只安装软件而不更新 homebrew，可以导入如下环境变量到系统中：
```markdown
export HOMEBREW_NO_AUTO_UPDATE=true
```

2. 卸载软件
```markdown
brew uninstall gcc
```

3. 搜索软件
```markdown
brew search gcc
```
会显示搜索的软件的各种版本
```markdown
➜  ~ brew search gcc
==> Formulae
gcc ✔             gcc@5             gcc@8             libgccjit         ghc ✔             ncc
gcc@10            gcc@6             gcc@9             x86_64-elf-gcc    scc
gcc@4.9           gcc@7             i686-elf-gcc      grc               tcc

==> Casks
gcc-arm-embedded
```

4. 更新软件
```markdown
brew upgrade gcc
```

5. 查看安装列表
```markdown
brew list
```

6. 更新 homebrew
```markdown
brew update
```

7. 安装指定版本的软件
```markdown
brew install gcc@7
```

### 参考资料

https://www.jianshu.com/p/dff8c837b7dd



