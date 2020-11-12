+++
title = "aws-cli S3 命令行工具使用"
date = "2019-11-21"
lastmod = "2019-11-21"
description = ""
tags = [
    "AWS",
    "S3",
    "CLI"
]
categories = [
    "技术"
]
+++

本篇博客记录了使用 aws-cli 来操作 S3 桶的用法，尽管 AWS 有非常详尽的文档，但我们记录下来后，下次就可以直接复制使用了。

<!--more-->

### 安装 aws-cli 和配置认证信息

1）安装 aws-cli
使用 `pip` 安装 `aws-cli`，命令如下：
```markdown
pip install -y awscli
```

2）配置认证信息
执行 `aws` 命令前，需要在 `~/.aws/credentials` 中配置访问 `AWS` 的 `Access Key` 和 `Secret Key`，如下所示：
```markdown
[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_access_key_id}
```
在 ~/.aws/config 中配置区域，如下所示：
```markdown
[default]
region = ap-southeast-1
```

注意，需要给该 `Access Key` 赋予访问要访问资源的权限。

### 使用 AWS-CLI 操作 S3

1、从一个桶里复制目录到另外一个桶里的目录
```markdown
# 将 S3 桶 bucket1 中的所有对象复制到 S3 桶 expire.backup.xdhuxc 的 bucket1 目录下
aws s3 cp s3://bucket1/ s3://expire.backup.xdhuxc/bucket1/ --recursive 2>./copys3_bucket1_error.log 1>/dev/null
```
由于复制的对象中包含目录，需要使用 `--recursive` 进行递归复制；在测试时，还可以使用 `--dryrun` 参数，只展示输出结果，不实际执行。另外，我们将错误日记记录下来，舍弃标准输出。


### 参考资料

AWS CLI S3 复制对象命令

https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html


