+++
title = "Python 常见问题及解决"
date = "2019-09-25"
lastmod = "2018-07-08"
tags = [
    "Python"
]
categories = [
    "Python"
]
+++

本篇博客主要记录一些在使用 Python 语言进行开发的过程中经常遇到的问题及其可能的解决方法，记录下来以备后需。

<!--more-->

### ModuleNotFoundError: No module named 'Crypto'
代码里面从 Crypto 中导入 AES 类，
```markdown
from Crypto.Cipher import AES
```
已经安装了 Crypto 包，但是执行时还是报如下错误：
```markdown
Traceback (most recent call last):
  File "/Users/wanghuan/PycharmProjects/scmp-dingtalk-callback/xyzdfg.py", line 7, in <module>
    from Crypto.Cipher import AES
ModuleNotFoundError: No module named 'Crypto'
```
在 python 3 中，包名已经变成了 pycryptodomex 或 pycryptodome，使用如下命令安装 pycryptodomex 包
```markdown
pip install pycryptodomex
```
修改导入代码为：
```markdown
from Cryptodome.Cipher import AES
```

### Python 环境的 Docker 容器看不到 print() 函数的输出

编写 python 脚本，使用 docker 容器运行，启动命令为 `ENTRYPOINT ["python3", "/usr/local/bin/test.py"]`，容器启动正常，脚本执行正常，但是使用 `docker logs` 命令却不见 `print()` 函数的输出内容。
原因：

python 的缓存机制，stdout 和 stderr 默认都是指向屏幕的，但 stderr 是无缓存的，程序向 stderr 输出的字符，会直接打印到屏幕上。而 stdout 是有缓存的，只有遇到换行或积累到一定的大小，才会输出到屏幕上。

解决：

python 命令后面加上 `-u` （unbuffered）参数，强制其标准输出不通过缓存，直接打印到屏幕上。所以，将 `Dockerfile` 中的 `ENTRYPOINT` 命令改写为：`ENTRYPOINT ["python3", "-u", "/usr/local/bin/test.py"]`

### 脚本运行时间长

python 程序运行时间特别长，一个脚本运行了一个小时才出结果，使用 line_profiler 进行分析，发现在迭代时使用了 hasattr() 进行属性存在判断，导致占用时间特别长。

### ValueError: embedded null byte 

执行脚本时，报错如下：
```markdown
Traceback (most recent call last):
  File "/Users/wanghuan/PycharmProjects/common_test/image_table.py", line 59, in <module>
    request_id = request_api(image_bin)
  File "/Users/wanghuan/PycharmProjects/common_test/image_table.py", line 20, in request_api
    image = get_file_content(image_bin)
  File "/Users/wanghuan/PycharmProjects/common_test/image_table.py", line 14, in get_file_content
    with open(file_path, 'rb+') as fp:
ValueError: embedded null byte
```
检查一下代码，可能是函数中调用了函数自身。

### \xe8\xb4\xbe\xe5\xbf\x97\xe7\x8c\x9b

使用 pymysql 连接数据库时，取回的数据中的中文不是 unicode 码，而是如下的乱码。
```markdown
'\xe8\xb4\xbe\xe5\xbf\x97\xe7\x8c\x9b'
```
创建数据库连接时，原来没有指定字符集，默认的字符集是从文件 `/etc/my.cnf` 中的 `default-character-set` 配置项读取而来，如果没有该文件或者该配置项，则默认的字符集为：`utf8mb4`

解决：创建数据库连接时，显式指定字符集为 utf8
```markdown
db = pymysql.connect('127.0.0.1', 'root', 'Xdhuxc375', 'xdhuxc', charset='utf8')
```

### 'ascii' codec can't decode byte 0xe4 in position 40: ordinal not in range(128)
使用 Python 开始时，报错如下：
```markdown
'ascii' codec can't decode byte 0xe4 in position 40: ordinal not in range(128)
```
解决：在文件代码开头处增加如下代码：
```markdown
reload(sys)                      # reload 才能调用 setdefaultencoding 方法
sys.setdefaultencoding('utf-8')  # 设置 'utf-8'
```

### json dumps 字典数据时出现乱码
```markdown
{"msg": "\u5ba2\u6237\u7aef\u8bf7\u6c42\u9519\u8bef\uff0c\u7f3a\u5c11\u67e5\u8be2\u53c2\u6570 secretkey \u6216
otp\u3002", "code": 4}
```
解决：添加 ensure_ascii=False 参数，ensure_ascii=True 保证 dumps() 之后的结果里所有的字符都能够被 ascii 表示，因此经过 dumps() 以后的str里，汉字会变成对应的 unicode。因此，当字典中含有中文时，一定要使用 ensure_ascii=False。

### `docker logs` 命令却不见 `print()` 函数的输出内容
编写 python 脚本，使用 docker 容器运行，启动命令为 `ENTRYPOINT ["python3", "/usr/local/bin/test.py"]`，容器启动正常，脚本执行正常，但是使用 `docker logs` 命令却不见 `print()` 函数的输出内容。

原因：python 的缓存机制，stdout 和 stderr 默认都是指向屏幕的，但 stderr 是无缓存的，程序向 stderr 输出的字符，会直接打印到屏幕上。而 stdout 是有缓存的，只有遇到换行或积累到一定的大小，才会输出到屏幕上。

解决：python 命令后面加上 `-u` （unbuffered）参数，强制其标准输出不通过缓存，直接打印到屏幕上。所以，将 `Dockerfile` 中的 `ENTRYPOINT` 命令改写为：`ENTRYPOINT ["python3", "-u", "/usr/local/bin/test.py"]`
