+++
title = "JavaScript 常用代码"
date = "2019-07-23"
lastmod = "2019-07-23"
tags = [
    "JavaScript"
]
categories = [
    "JavaScript"
]
+++

JavaScript 开发时的常用代码，方便自己查找。

<!--more-->

### 数组和对象相互转换
在开发中，我们经常需要将如下所示的对象 
```markdown
{
  key1: value1,
  key2: value2,
  key3: value3
}
```
转换成如下形式的数组
```markdown
[
    {
        key: key1,
        value: value1
    },
    {
        key: key2,
        value: value2
    },
    {
        key: key3,
        value: value3
    }
]
```
或者反过来转换，我们可以编写公用函数来完成这个功能。

1、将数组转换为对象
```markdown
export function convertArray2Object(source) {
  const len = source.length;
  const target = {};
  for (let i = 0; i < len; i++) {
    target[source[i].key] = source[i].value;
  }
  return target;
}
```

2、将对象转换为数组
```markdown
export function convertObject2Array(source) {
  const target = [];
  for (const k in source) {
    const temp = {
      key: k,
      value: source[k]
    };
    target.push(temp);
  }
  return target;
}
```
### 删除对象的属性
可以使用 delete 操作符来删除对象的属性
```markdown
const a = {
    name: 'hulk',
    env: 'prod',
    image: 'nginx'
}
// 删除 a 对象的属性 env
delete a.env 
```

### 设置 cookie 的过期时间
```markdown
import Cookies from 'js-cookie';
const expires = new Date(new Date().getTime() + 8 * 60 * 60 * 1000);
  return Cookies.set(TokenKey, token, {
    expires: expires
});
```
