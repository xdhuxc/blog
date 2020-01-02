+++
title = "SVN 的安装，配置和使用"
date = "2017-12-07"
lastmod = "2017-12-17"
tags = [
    "SVN"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了版本控制管理工具 SVN 的安装，配置和使用。

<!--more-->

### SVN 安装和配置

#### 安装 `svn` 服务器

```markdown
yum install -y subversion
```

#### 查看版本

```markdown
svnserve --version
```
输出如下：
<center>
<img src="/image/tools/svn/WechatIMG651.jpeg" width="800px" height="300px" />
</center>

#### 创建版本库

```markdown
mkdir -p /root/svn   #创建svn仓库目录
svnadmin create /root/svn/xdhuxc  #使用svn管理员创建xdhuxc库
```
查看库中的文件
<center>
<img src="/image/tools/svn/WechatIMG652.png" width="800px" height="300px" />
</center>

出现上图中的文件，说明svn代码库已经创建成功。
Subversion目录说明：

* db：所有版本控制的数据存放文件
* hooks：放置hook脚本文件的目录
* locks：用来放置subversion建库锁定数据的目录，用来追踪存取文件库的客户端
* format：是一个文本文件，里面只放了一个整数，表示当前文件库配置的版本号
* conf：是这个仓库的配置文件（仓库的用户访问账号、权限等）

进入conf目录，该目录存放当前svn版本库的配置文件：

* authz：权限控制文件
* passwd：账号密码文件
* svnserve.conf：SVN服务配置文件

#### subversion 配置

1、设置账号密码

修改 `conf/passwd` 文件，在 `[users]` 块中添加用户和密码，格式为：username=password
<center>
<img src="/image/tools/svn/WechatIMG653.png" width="800px" height="300px" />
</center>

2、设置权限

修改conf/authz文件，在末尾添加如下内容
```markdown
[/] #指定svn仓库目录，[/]代表根目录
xdhuxc=rw  # 用户xdhuxc的权限，r：读；w：写
```
<center>
<img src="/image/tools/svn/WechatIMG654.png" width="800px" height="300px" />
</center>

3、修改 `svnserve.conf` 文件

打开下面几个注释：
```markdown
anon-access = read # 匿名用户可读
auth-access = write # 授权用户可写
password-db = passwd # 使用哪个文件作为账号文件
authz-db = authz # 使用哪个文件作为权限文件
realm = /root/svn/xdhuxc # 认证空间名，版本库所在目录
```
注意，红色箭头指向的参数，全部要定格写，即前面不能有空格
<center>
<img src="/image/tools/svn/WechatIMG655.jpeg" width="800px" height="300px" />
</center>

#### 启动 svn 版本库

启动 `svn` 版本库，并查看 `svn` 服务是否开启，默认监听在 `3690` 端口
```markdown
svnserve -d -r /root/svn/xdhuxc
ps -ef|grep svn
```
参数说明：
* -d：表示后台运行svn服务
* -r：指定svn目录

#### 停止 svn 命令
使用如下命令停止 svn 服务
```markdown
killall svnserve
```

### svn 使用

1、下载并安装 `TorwoiseSVN` 测试

2、创建空目录 `xdhuxc-svn`，右键并选择 `SVN Checkout`，`checkout` 就是把 `SVN` 服务器上的文件下载到本地工作目录内的操作，输入 `SVN` 服务器地址，导出文件存放目录 `xdhuxc-svn`，点击 `OK`
<center>
<img src="/image/tools/svn/WechatIMG656.jpeg" width="800px" height="300px" />
</center>

第一次登陆时，需要输入认证信息 `xdhuxc/Xdhuxc1994`，点击 `OK`

<center>
<img src="/image/tools/svn/WechatIMG657.png" width="800px" height="300px" />
</center>

如果不是空目录，就会出现下图的提示框，选择 `Checkout`
<center>
<img src="/image/tools/svn/WechatIMG658.jpeg" width="800px" height="300px" />
</center>

登录成功后便可以在该工作目录里进行编辑或创建文件，操作完成后对该目录右键，选择 `Check commit` 提交，这个操作等于是上传到 `SVN` 服务器

3、添加新文件

将文件拖放至xdhuxc-svn目录下，右键，选择“TortoiseSVN”，选择“Repo browser”，右键点击“svn://192.168.91.128”，点击“Add file”
<center>
<img src="/image/tools/svn/WechatIMG659.jpeg" width="800px" height="300px" />
</center>
选择要添加的文件 `abc.txt`，点击 `打开`

<center>
<img src="/image/tools/svn/WechatIMG660.jpeg" width="800px" height="300px" />
</center>
输入提交信息，点击 `OK`

<center>
<img src="/image/tools/svn/WechatIMG661.jpeg" width="800px" height="300px" />
</center>
可到 `linux` 服务器下验证提交结果。

### SVN 命令行
1、使用Linux的SVN命令进行checkout操作
```markdown
svn checkout svn://192.168.91.128 /svndir
```
第一次使用checkout命令时，需要输入用户名和密码，以后就不用输入用户名和密码了
/svndir为svn仓库文件保存目录
checkout下来的文件夹放到本地就叫做working copy，里面带着.svn目录，该目录是本地文件与svn服务器的连接文件，在这个目录里才能进行svn操作。svn添加文件，要先把要添加的文件放到working copy相应的目录下，执行add，再commit即可。

2、创建一个文件并添加至SVN
```markdown
cd /svndir
touch xyz.txt ; echo "XYZ" >> xyz.txt ; cat xyz.txt
svn add xyz.txt
```
如下图所示：
<center>
<img src="/image/tools/svn/WechatIMG662.png" width="800px" height="300px" />
</center>

3、提交该文件
```markdown
svn commit -m "XYZ commit"
```
如下图所示：
<center>
<img src="/image/tools/svn/WechatIMG663.png" width="800px" height="300px" />
</center>

4、更新本地仓库文件
```markdown
svn up
或
svn update
```
如下图所示：
<center>
<img src="/image/tools/svn/WechatIMG664.png" width="800px" height="300px" />
</center>

### 常见问题及解决
1、点击 `Checkout` 后，报错如下：
<center>
<img src="/image/tools/svn/WechatIMG665.jpeg" width="800px" height="300px" />
</center>

原因：`CentOS 7` 默认不对外开放 `3690` 端口，因此，开放防火墙 `3690` 端口，重启防火墙即可

```markdown
iptables -I INPUT -p tcp --dport 3690 -j ACCEPT
systemctl restart iptables
```



