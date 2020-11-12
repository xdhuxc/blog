+++
title = "MySQL 常见问题及解决"
date = "2018-08-01"
lastmod = "2019-07-29"
tags = [
    "MySQL",
    "数据库"
]
categories = [
    "技术"
]
+++

本篇博客记录了一些使用 MySQL 过程中常见的问题及解决方式，留作后查。

<!--more-->

### 常见问题及解决
1、能看到数据库和表，但是select时报不存在
```markdown
mysql> select * from sys_prompt limit 5;
ERROR 1146 (42S02): Table 'xdhuxc.sys_prompt' doesn't exist
```
或
```markdown
mysql> drop database yhtdb;
ERROR 1010 (HY000): Error dropping database (can't rmdir './yhtdb', errno: 39)
```
解决：在`/var/lib/mysql`下，删除该数据库对应的目录，重新导入sql文件。


2、 mysql 服务启动失败
可能原因：
```markdown
1、可能是端口号被占用。
2、可能是 mysql 配置文件修改错误，导致某些配置参数名称错误。
```


3、向数据库表中插入数据时，报错如下：
```markdown
(1265, "Data truncated for column 'income' at row 1")
```
数据库表定义时，定义的字段 income 长度太短，更改该数据类型，增大其长度。


4、在 Mac 上安装的 MySQL 8.0.1，使用 DbVisualizer 连接时，报错如下：
```markdown
Product: DbVisualizer Free 10.0.17 [Build #2882]
OS: Mac OS X
OS Version: 10.14.3
OS Arch: x86_64
Java Version: 1.8.0_191
Java VM: Java HotSpot(TM) 64-Bit Server VM
Java Vendor: Oracle Corporation
Java Home: /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
DbVis Home: /Applications/DbVisualizer.app/Contents/Resources/app
User Home: /Users/wanghuan
PrefsDir: /Users/wanghuan/.dbvis
SessionId: 112
BindDir: null

An error occurred while establishing the connection:

Long Message:
Unable to load authentication plugin 'caching_sha2_password'.
```

解决：使用 root 用户登录进去，执行如下命令：
```markdown
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root@20190322';
```


5、连接 MySQL 时，报错如下：
```markdown
Long Message:
Access denied for user 'root'@'localhost' (using password: YES)
```
解决：可能是 mysql 密码配置错误，重新修改 mysql 密码。
```markdown
use mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'wh19940423';
flush privileges;
```


6、更新数据时，报错如下：
```markdown
Error 1062: Duplicate entry '23viewer12fgdfdsgsd' for key 'name'
```
检查数据库，确实没有重复的名称，删除数据库表，重新创建表结构。


7、使用 GORM 框架时，插入含时间戳类型的结构体字段时，报错如下：
```markdown
Error 1292: Incorrect datetime value: '0000-00-00' for column 'create_time' at row 1
```
原因：时间戳类型字段 CreateTime，UpdateTime 没有赋值，导致类型为 datetime类型，从而报错。


8、使用用户名和密码连接 MySQL 时，可能会报如下错误：
```markdown
Unable to load authentication plugin 'caching_sha2_password'.
```
这是 mysql 5.x 和 8.x 的区别，5.x 版本的认证插件是：default_authentication_plugin=mysql_native_password，8.x 的认证插件是：default_authentication_plugin=caching_sha2_password。
 
mysql 驱动已经更新适配了caching_sha2_password 的密码规则，升级到最新版本即可。


9、使用用户名和密码连接 MySQL 时，可能会报如下错误：
```markdown
public key retrieval is not allowed
```
在连接 MySQL 的参数中，设置 `allowPublicKeyRetrieval=true`，如果用户使用了 sha256_password 认证，密码在传输过程中必须使用 TLS 协议保护，但是如果 RSA 公钥不可用，可以使用服务器提供的公钥；可以在连接中通过 ServerRSAPublicKeyFile 指定服务器的 RSA 公钥，或者AllowPublicKeyRetrieval=True参数以允许客户端从服务器获取公钥；但是需要注意的是 AllowPublicKeyRetrieval=True可能会导致恶意的代理通过中间人攻击(MITM)获取到明文密码，所以默认是关闭的，必须显式开启。

参考：https://mysqlconnector.net/connection-options/

10、我们在一个 for 循环中，对于每一个元素，启动一个 golang 协程去操作数据库，日志中报错如下：
```markdown
[2020-08-08 11:12:28]  [0.13ms]  DELETE FROM `messages`  WHERE (isCurrentUpdate = false)  
[0 rows affected or returned ] 
[mysql] 2020/08/08 11:12:28 packets.go:446: busy buffer
[mysql] 2020/08/08 11:12:28 packets.go:427: busy buffer

(/Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/xdhuxc-message/src/service/message.go:246) 
[2020-08-08 11:12:28]  driver: bad connection 
ERRO[2020-08-08 11:12:28]/Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/xdhuxc-message/src/service/message.go:247 github.com/xdhuxc/xdhuxc-message/src/service.(*messageService).message() 删除数据时出错，错误为：driver: bad connection 
```

这是由于程序执行太快，可用连接不足导致的，增大程序可以打开的最大连接数，适当减慢程序运行。

具体代码实现如下：
1、将程序可以打开的连接数增大
```markdown
db.DB().SetMaxOpenConns(5000)
```

2、减慢程序运行
```markdown
for _, stock := range stocks {	
	time.Sleep(50*time.Millisecond)

	go func(user model.User) {}	
}
```


