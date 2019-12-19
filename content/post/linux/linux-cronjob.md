+++
title = "Linux 中 crontab 的使用"
date = "2018-09-07"
lastmod = "2018-09-07"
tags = [
    "Linux",
    "Shell"
]
categories = [
    "Linux",
    "Shell"
]
+++

我们有时需要用到定时任务来备份数据或者发送邮件，此时，一般会使用 Linux 系统中的 crontab 来实现。其他各种系统的定时任务使用的定时策略描述方式与 Linux 系统的 crontab 基本一样。

<!--more-->

### 定时任务

1、命令格式
```markdown
crontab [-u user] file crontab [-u user] [-e | -l | -r | -i]
```
参数说明：

* -u user：设定指定用户的 crontab 服务；
* file：命令文件的名字，表示将 file 作为 crontab 的任务列表文件并载入 crontab。如果在命令行中没有指定这个文件，crontab 命令将接收标准输入上输入的命令，并将它们载入 crontab；
* -e：编辑 crontab 文件内容；
* -l：显示 crontab 文件内容；
* -r：从 /var/spool/cron 目录中删除 crontab 文件；
* -i：在删除 crontab 文件时给确认提示


2、crontab 文件格式
```markdown
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * command to execute
```
依次分别是：分钟 小时 日 月份 星期 运行命令，分别使用空格分隔。

特殊字符含义：

* *：表示任何时刻都能接受；
* ,：表示分隔时段，例如：`30 10,17 * * * command` 表示上午九点半和下午五点半分别执行 command；
* -：表示一段时间范围，例如：`30 7-10 * * * command` 表示从七点到十点的每个小时的30分钟都执行 command；
* /n：n 代表数字，表示每个 n 单位间隔，例如：`*/5 * * * * command` 表示每隔 5 分钟执行一次 command；

### 示例
1、每周一至周五早上10点和下午5点各执行一次
```markdown
0 10,17 * * 0-5 command
```
2、每小时的第21分钟和第37分钟执行
```markdown
21,37 * * * * command
```
3、在上午7点到10点的每小时的第11和第47分钟执行
```markdown
11,47 7-10 * * * command
```
4、每晚 10:30 执行
```markdown
30 22 * * * command
```
5、每周六、周日的12点30分执行
```markdown
30 12 * * 6,0
```


### 注意事项
1、脚本中涉及文件路径时需要绝对路径；

2、脚本执行时要用到环境变量时，通过 source 命令引入环境变量；
```markdown
source /etc/profile
```

3、当手动执行脚本可以正确执行，但是 crontab 却不执行时，很可能是没有配置环境变量导致的，可在 crontab 中直接引入环境变量解决问题
```markdown
0 * * * * source /etc/profile & /bin/sh /home/xdhuxc/abc.sh
```

4、新创建的 cron job，不会马上执行，至少要过2分钟才执行，但是如果重启 crond，则马上执行；

5、清理系统用户的邮件日志，每条任务调度完毕，系统都会将任务输出信息通过电子邮件的形式发送给当前系统用户，这样日积月累，日志信息会非常大，可能会影响系统的正常运行。因此，将每条任务进行重定向处理非常重要，如下所示：
```markdown
0 * * * * /bin/sh /home/xdhuxc/abc.sh >/dev/null 2>&1
```

### 参考资料

https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/crontab.html

https://code.kpman.cc/2015/02/11/%E5%88%A9%E7%94%A8-crontab-%E4%BE%86%E5%81%9A-Linux-%E5%9B%BA%E5%AE%9A%E6%8E%92%E7%A8%8B/

https://en.wikipedia.org/wiki/Cron
