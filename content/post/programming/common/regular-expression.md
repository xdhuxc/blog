+++
title = "程序设计（一）"
date = "2017-12-09"
lastmod = "2018-01-09"
tags = [
    "正则表达式"
]
categories = [
    "技术"
]
+++

本篇博客记录了下正则表达式的常用规则，并收集些常用的正则表达式。

<!--more-->

### 正则表达式

### 特殊字符

* ^：以某个字符串开头，^a，匹配以 a 开头的字符串，^abc，匹配以 abc 开头的字符串。
* *：表示 * 前面的一个字符可以重复任意多次。
* .：可以表示任意一个字符。
* $：以某个字符串结尾，a$，匹配以 a 结尾的字符串，abc$，匹配以 abc 结尾的字符串。
* ?：使用非贪婪匹配模式，从左向右匹配字符串。
* +：表示 + 号前面的字符至少出现一次。
* {2}：表示前面的字符恰好出现两次。
* {2,}：表示前面的字符出现两次以上。
* {2,5}：表示前面的字符出现 2~5 次。
* |：表示多个匹配模式之间或的关系。
* []：[abcd]，表示匹配一个字符，该字符为 a，b，c，d 中的一个。
      [1~9]，表示匹配一个字符，该字符为 1~9 之中的一个。
      [^1]，表示匹配一个字符，该字符不是 1。
* \s: 表示匹配一个空格。
* \S：表示匹配一个非空格。
* \w：表示匹配一个字符，模式等同于：[a~zA~Z0~9_]。
* \W：表示匹配一个字符，该字符不在模式 [a~zA~Z0~9_] 之中。
* [\u4E00-\u9FA5]：匹配一个汉字。
* \d：匹配数字

### 常用正则表达式
1）邮箱
```markdown
^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
```

2）域名
```markdown
[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?
```

3）IP
```markdown
((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))
```

4）电话号码
```markdown
^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$
```

5）URL
```markdown
[a-zA-z]+://[^\s]* 或 ^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$
```