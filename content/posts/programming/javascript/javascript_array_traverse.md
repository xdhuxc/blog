+++
title = "JavaScript 中的数组遍历方式"
date = "2019-07-22"
lastmod = "2019-07-22"
tags = [
    "JavaScript"
]
categories = [
    "JavaScript"
]
+++

JavaScript 中数组遍历的几种方式，都是一般的方法，但是在遍历数组的同时删除元素的方法需要稍微注意下。

<!--more-->

### JavaScript 中的数组遍历方式
1、标准 for 循环方式
```markdown
var a = ['a', 'b', 'c', 'd']
for (let i = 0; i < a.length; i++) {
    console.log(a[i]);
}
```

2、for-in 语句
```markdown
var a =  {
    name: 'hulk',
    env: 'prod',
    project: 'x-role'
}
for (var key in a) {
    console.log(a[key]);
}
```
一般使用 for-in 语句来遍历对象的属性，但是对象的属性需要是可枚举的，才能被读取到，非整数类型的名称和继承的那些原型链上面的属性也能被遍历。

for-in 在遍历的过程中还会遍历继承链，这是其效率比较低的原因。

### 在遍历的过程中删除元素
在遍历的过程中删除元素时，会因为删除元素而导致数组索引变化，删除了错误的元素

```markdown
var a = ['a', 'b', 'c', 'd', 'e', 'f']
for (let i = 0; i < a.length; i++) {
    if (i === 3) {
        a.splice(i, 1); // 删除索引号为 3 的元素
    }
    
}
```
如果需要在遍历数组的过程中删除数组元素，那么我们可以在删除之后调整索引，从而保证下一个操作时索引的正确性
```markdown
var a = ['a', 'b', 'c', 'd']
for (let i = 0; i < a.length; i++) {
    if (a[i] === 'c') {
        a.splice(i, 1);
        i--;             // 索引调整
    }
}
```

