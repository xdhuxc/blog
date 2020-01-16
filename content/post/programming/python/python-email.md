+++
title = "Python 发送邮件"
date = "2017-09-18"
lastmod = "2017-09-18"
tags = [
    "Python"
]
categories = [
    "技术"
]
+++

本篇博客介绍下在 Python 邮件的发送。

<!--more-->

### 发送邮件

python的smtplib提供了一种很方便的途径发送电子邮件。它对smtp协议进行了简单的封装。

Python创建SMTP 对象语法如下：
```markdown
import smtplib

smtpObj = smtplib.SMTP( [host [, port [, local_hostname]]] )
```
参数说明：

* host: SMTP 服务器主机。 你可以指定主机的ip地址或者域名如: xdhuxc.com，这个是可选参数。
* port: 如果你提供了 host 参数, 你需要指定 SMTP 服务使用的端口号，一般情况下 SMTP 端口号为25。
* local_hostname: 如果 SMTP 在你的本机上，你只需要指定服务器地址为 localhost 即可。

Python SMTP 对象使用 sendmail 方法发送邮件，语法如下：
```markdown
SMTP.sendmail(from_addr, to_addrs, msg[, mail_options, rcpt_options]
```
参数说明：

* from_addr: 邮件发送者地址。
* to_addrs: 字符串列表，邮件发送地址。
* msg: 发送消息，msg 是字符串，表示邮件。我们知道邮件一般由标题，发信人，收件人，邮件内容，附件等构成，发送邮件的时候，要注意 msg 的格式。这个格式就是 smtp 协议中定义的格式

#### 使用本地邮件服务器

执行示例需要本机已安装了支持 SMTP 的服务，如：sendmail。

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.header import Header
 
sender = 'xdhuxc@163.com'
receivers = ['xdhuxc@126.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
# 三个参数：第一个为文本内容，第二个 plain 设置文本格式，第三个 utf-8 设置编码
message = MIMEText('Python 邮件发送测试...', 'plain', 'utf-8')
message['From'] = Header("菜鸟教程", 'utf-8')
message['To'] =  Header("测试", 'utf-8')
 
subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')
 
 
try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"
```
使用三个引号来设置邮件信息，标准邮件需要三个头部信息： From, To, 和 Subject ，每个信息直接使用空行分割。

通过实例化 smtplib 模块的 SMTP 对象 smtpObj 来连接到 SMTP 访问，并使用 sendmail 方法来发送信息。

执行以上程序，如果你本机安装 sendmail（邮件传输代理程序），就会输出：
```markdown
$ python test.py
邮件发送成功
```

#### 使用其他邮件服务商的 SMTP 访问（QQ、网易、Google等）。
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.header import Header
 
# 第三方 SMTP 服务
mail_host="smtp.163.com"  #设置服务器
mail_user="XXXX"    #用户名
mail_pass="XXXXXX"   #口令 
 
 
sender = 'xdhuxc@163.com'
receivers = ['xdhuxc@126.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
message = MIMEText('Python 邮件发送测试...', 'plain', 'utf-8')
message['From'] = Header("xdhuxc 测试", 'utf-8')
message['To'] =  Header("测试", 'utf-8')
 
subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')
 
 
try:
    smtpObj = smtplib.SMTP() 
    smtpObj.connect(mail_host, 25)    # 25 为 SMTP 端口号
    smtpObj.login(mail_user,mail_pass)  
    smtpObj.sendmail(sender, receivers, message.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"
```

#### 发送HTML格式的邮件

Python发送HTML格式的邮件与发送纯文本消息的邮件不同之处就是将MIMEText中_subtype设置为html。具体代码如下:
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.header import Header
 
sender = 'xdhuxc@163.com'
receivers = ['xdhuxc@126.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
mail_msg = """
<p>Python 邮件发送测试...</p>
<p><a href="http://www.xdhuxc.org">这是一个链接</a></p>
"""
message = MIMEText(mail_msg, 'html', 'utf-8')
message['From'] = Header("xdhuxc 测试", 'utf-8')
message['To'] =  Header("测试", 'utf-8')
 
subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')
 
 
try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"
```

#### 发送带附件的邮件

发送带附件的邮件，首先要创建MIMEMultipart()实例，然后构造附件，如果有多个附件，可依次构造，最后利用smtplib.smtp发送。
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.header import Header
 
sender = 'xdhuxc@163.com'
receivers = ['xdhuxc@126.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
#创建一个带附件的实例
message = MIMEMultipart()
message['From'] = Header("xdhuxc 测试", 'utf-8')
message['To'] =  Header("测试", 'utf-8')
subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')
 
#邮件正文内容
message.attach(MIMEText('这是 xdhuxc 测试Python 邮件发送测试……', 'plain', 'utf-8'))
 
# 构造附件1，传送当前目录下的 test.txt 文件
att1 = MIMEText(open('test.txt', 'rb').read(), 'base64', 'utf-8')
att1["Content-Type"] = 'application/octet-stream'
# 这里的filename可以任意写，写什么名字，邮件中显示什么名字
att1["Content-Disposition"] = 'attachment; filename="test.txt"'
message.attach(att1)
 
# 构造附件2，传送当前目录下的 xdhuxc.txt 文件
att2 = MIMEText(open('xdhuxc.txt', 'rb').read(), 'base64', 'utf-8')
att2["Content-Type"] = 'application/octet-stream'
att2["Content-Disposition"] = 'attachment; filename="xdhuxc.txt"'
message.attach(att2)
 
try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"
```
#### 在 HTML 文本中添加图片

邮件的 HTML 文本中一般邮件服务商添加外链是无效的，正确添加突破的实例如下所示：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header
 
sender = 'xdhuxc@163.com'
receivers = ['xdhuxc@126.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
msgRoot = MIMEMultipart('related')
msgRoot['From'] = Header("xdhuxc 测试", 'utf-8')
msgRoot['To'] =  Header("测试", 'utf-8')
subject = 'Python SMTP 邮件测试'
msgRoot['Subject'] = Header(subject, 'utf-8')
 
msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)
 
 
mail_msg = """
<p>Python 邮件发送测试...</p>
<p><a href="http://www.xdhuxc.com">xdhuxc 测试链接</a></p>
<p>图片演示：</p>
<p><img src="cid:image1"></p>
"""
msgAlternative.attach(MIMEText(mail_msg, 'html', 'utf-8'))
 
# 指定图片为当前目录
fp = open('test.png', 'rb')
msgImage = MIMEImage(fp.read())
fp.close()
 
# 定义图片 ID，在 HTML 文本中引用
msgImage.add_header('Content-ID', '<image1>')
msgRoot.attach(msgImage)
 
try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, msgRoot.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"
```

#### 使用第三方 SMTP 服务发送

使用第三方 SMTP 服务发送邮件，SMTP服务器地址为：smtp.xxx.com，端口为：25

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
 
my_sender='xdhuxc@126.com'    # 发件人邮箱账号
my_pass = 'xxxxxxxxxx'              # 发件人邮箱密码
my_user='xdhuxc@126.com'      # 收件人邮箱账号，我这边发送给自己
def mail():
    ret=True
    try:
        msg=MIMEText('填写邮件内容','plain','utf-8')
        msg['From']=formataddr(["Fromxdhuxc",my_sender])  # 括号里的对应发件人邮箱昵称、发件人邮箱账号
        msg['To']=formataddr(["FK",my_user])              # 括号里的对应收件人邮箱昵称、收件人邮箱账号
        msg['Subject']="xdhuxc 测试发送邮件测试"                # 邮件的主题，也可以说是标题
 
        server=smtplib.SMTP_SSL("smtp.qq.com", 465)  # 发件人邮箱中的SMTP服务器，端口是25
        server.login(my_sender, my_pass)  # 括号中对应的是发件人邮箱账号、邮箱密码
        server.sendmail(my_sender,[my_user,],msg.as_string())  # 括号中对应的是发件人邮箱账号、收件人邮箱账号、发送邮件
        server.quit()  # 关闭连接
    except Exception:  # 如果 try 中的语句没有执行，则会执行下面的 ret=False
        ret=False
    return ret
 
ret=mail()
if ret:
    print("邮件发送成功")
else:
    print("邮件发送失败")
```
### 线程

Python中使用线程有两种方式：函数或者用类来包装线程对象。

#### 函数式
> 调用thread模块中的start_new_thread()函数来产生新线程。

语法如下：
```markdown
thread.start_new_thread ( function, args[, kwargs] )
```
参数说明：
* function - 线程函数。
* args - 传递给线程函数的参数,他必须是个tuple类型。
* kwargs - 可选参数。

示例：
```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import thread
import time
 
# 为线程定义一个函数
def print_time( threadName, delay):
   count = 0
   while count < 5:
      time.sleep(delay)
      count += 1
      print "%s: %s" % ( threadName, time.ctime(time.time()) )
 
# 创建两个线程
try:
   thread.start_new_thread( print_time, ("Thread-1", 2, ) )
   thread.start_new_thread( print_time, ("Thread-2", 4, ) )
except:
   print "Error: unable to start thread"
 
while 1:
   pass
```
线程的结束一般依靠线程函数的自然结束；也可以在线程函数中调用thread.exit()，他抛出SystemExit exception，达到退出线程的目的。

#### 线程模块

Python通过两个标准库thread和threading提供对线程的支持。thread提供了低级别的、原始的线程以及一个简单的锁。

thread 模块提供的其他方法：

* threading.currentThread(): 返回当前的线程变量。
* threading.enumerate(): 返回一个包含正在运行的线程的list。正在运行指线程启动后、结束前，不包括启动前和终止后的线程。
* threading.activeCount(): 返回正在运行的线程数量，与len(threading.enumerate())有相同的结果。

除了使用方法外，线程模块同样提供了Thread类来处理线程，Thread类提供了以下方法:

* run(): 用以表示线程活动的方法。
* start():启动线程活动。
* join([time]): 等待至线程中止。这阻塞调用线程直至线程的join() 方法被调用中止-正常退出或者抛出未处理的异常-或者是可选的超时发生。
* isAlive(): 返回线程是否活动的。
* getName(): 返回线程名。
* setName(): 设置线程名。

#### 使用Threading模块创建线程

使用Threading模块创建线程，直接从threading.Thread继承，然后重写__init__方法和run方法

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import threading
import time
 
exitFlag = 0
 
class myThread (threading.Thread):   #继承父类threading.Thread
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
    def run(self):                   #把要执行的代码写到run函数里面 线程在创建后会直接运行run函数 
        print "Starting " + self.name
        print_time(self.name, self.counter, 5)
        print "Exiting " + self.name
 
def print_time(threadName, delay, counter):
    while counter:
        if exitFlag:
            threading.Thread.exit()
        time.sleep(delay)
        print "%s: %s" % (threadName, time.ctime(time.time()))
        counter -= 1
 
# 创建新线程
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)
 
# 开启线程
thread1.start()
thread2.start()
 
print "Exiting Main Thread"
```

#### 线程同步

如果多个线程共同对某个数据修改，则可能出现不可预料的结果，为了保证数据的正确性，需要对多个线程进行同步。

使用Thread对象的Lock和Rlock可以实现简单的线程同步，这两个对象都有acquire方法和release方法，对于那些需要每次只允许一个线程操作的数据，可以将其操作放到acquire和release方法之间。

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import threading
import time
 
class myThread (threading.Thread):
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
    def run(self):
        print "Starting " + self.name
       # 获得锁，成功获得锁定后返回True
       # 可选的timeout参数不填时将一直阻塞直到获得锁定
       # 否则超时后将返回False
        threadLock.acquire()
        print_time(self.name, self.counter, 3)
        # 释放锁
        threadLock.release()
 
def print_time(threadName, delay, counter):
    while counter:
        time.sleep(delay)
        print "%s: %s" % (threadName, time.ctime(time.time()))
        counter -= 1
 
threadLock = threading.Lock()
threads = []
 
# 创建新线程
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)
 
# 开启新线程
thread1.start()
thread2.start()
 
# 添加线程到线程列表
threads.append(thread1)
threads.append(thread2)
 
# 等待所有线程完成
for t in threads:
    t.join()
print "Exiting Main Thread"
```

#### 线程优先级队列（ Queue）

Python的Queue模块中提供了同步的、线程安全的队列类，包括FIFO（先入先出)队列Queue，LIFO（后入先出）队列LifoQueue，和优先级队列PriorityQueue。这些队列都实现了锁原语，能够在多线程中直接使用。可以使用队列来实现线程间的同步。

Queue模块中的常用方法:

* Queue.qsize() 返回队列的大小
* Queue.empty() 如果队列为空，返回True,反之False
* Queue.full() 如果队列满了，返回True,反之False
* Queue.full 与 maxsize 大小对应
* Queue.get([block[, timeout]])获取队列，timeout等待时间
* Queue.get_nowait() 相当Queue.get(False)
* Queue.put(item) 写入队列，timeout等待时间
* Queue.put_nowait(item) 相当Queue.put(item, False)
* Queue.task_done() 在完成一项工作之后，Queue.task_done()函数向任务已经完成的队列发送一个信号
* Queue.join() 实际上意味着等到队列为空，再执行别的操作

```markdown
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import Queue
import threading
import time
 
exitFlag = 0
 
class myThread (threading.Thread):
    def __init__(self, threadID, name, q):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.q = q
    def run(self):
        print "Starting " + self.name
        process_data(self.name, self.q)
        print "Exiting " + self.name
 
def process_data(threadName, q):
    while not exitFlag:
        queueLock.acquire()
        if not workQueue.empty():
            data = q.get()
            queueLock.release()
            print "%s processing %s" % (threadName, data)
        else:
            queueLock.release()
        time.sleep(1)
 
threadList = ["Thread-1", "Thread-2", "Thread-3"]
nameList = ["One", "Two", "Three", "Four", "Five"]
queueLock = threading.Lock()
workQueue = Queue.Queue(10)
threads = []
threadID = 1
 
# 创建新线程
for tName in threadList:
    thread = myThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1
 
# 填充队列
queueLock.acquire()
for word in nameList:
    workQueue.put(word)
queueLock.release()
 
# 等待队列清空
while not workQueue.empty():
    pass
 
# 通知线程是时候退出
exitFlag = 1
 
# 等待所有线程完成
for t in threads:
    t.join()
print "Exiting Main Thread"
```

### JSON
> JSON(JavaScript Object Notation) 是一种轻量级的数据交换格式，易于人阅读和编写。

#### JSON 函数
使用 JSON 函数需要导入 json 库：import json。

函数 | 描述
---|---
json.dumps | 将 Python 对象转换成 JSON 字符串
json.loads | 将已编码的 JSON 字符串转换为 Python 对象

#### json.dumps

json.dumps 用于将 Python 对象转换成 JSON 字符串。

语法为：
```markdown
json.dumps(obj, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, encoding="utf-8", default=None, sort_keys=False, **kw)
```
##### 示例
```
#!/usr/bin/python
import json

data = [ { 'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5 } ]

json = json.dumps(data)
print json
```
执行结果为：
```
[{"a": 1, "c": 3, "b": 2, "e": 5, "d": 4}]
```
使用参数让 JSON 数据格式化输出：
```
>>> import json
>>> print json.dumps({'a': 'xdhuxc', 'b': 7}, sort_keys=True, indent=4, separators=(',', ': '))
{
    "a": "xdhuxc",
    "b": 7
}
```
python 原始类型向 json 类型的转化对照表：
Python | JSON
---|---|---
dict |	object
list, tuple	| array
str, unicode   | string
int, long, float	| number
True	| true
False	| false
None	| null

### json.loads

json.loads 用于解码 JSON 数据。该函数返回 Python 字段的数据类型。

语法为：
```
json.loads(s[, encoding[, cls[, object_hook[, parse_float[, parse_int[, parse_constant[, object_pairs_hook[, **kw]]]]]]]])
```

```markdown
#!/usr/bin/python
import json

jsonData = '{"a":1,"b":2,"c":3,"d":4,"e":5}';

text = json.loads(jsonData)
print text
```

以上代码执行结果为：
```markdown
{u'a': 1, u'c': 3, u'b': 2, u'e': 5, u'd': 4}
```

json 类型转换到 python 的类型对照表：

JSON |	Python
---|---|---
object | dict
array |	list
string | unicode
number (int) | int, long
number (real) |	float
true | True
false |	False
null | None
