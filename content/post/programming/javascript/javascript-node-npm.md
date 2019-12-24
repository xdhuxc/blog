+++
title = "升级 NPM 和 Node"
date = "2019-10-16"
lastmod = "2019-10-16"
tags = [
    "JavaScript",
    "Node",
    "npm"
]
categories = [
    "技术"
]
+++

记录下 npm 和 node 的升级方法。

<!--more-->

### 升级 NodeJS

npm 中有一个模块叫做 n，专门用来做 node.js 版本管理的。

使用如下命令更新 node.js 到最新版本
```markdown
npm install -g n # 安装 n 模块
n stable         # 更新到最新稳定版的 node.js
n latest         # 更新到最新版本的 node.js
n v10.14.2       # 更新到指定版本的 node.js
```

### 升级 npm
使用如下命令升级 npm
```markdown
npm -g install npm@next
```

### 查看当前 node.js 版本对 ES6 的支持程度
可以通过 es-checker 工具查看当前 node.js 版本对 ES6 的支持程度

1、安装 es-checker
```markdown
npm install -g es-checker
```
2、使用 es-checker 命令检测
```markdown
wanghuans-MacBook-Pro:ushareit-hawkeye-frontend wanghuan$ node -v
v10.14.2
wanghuans-MacBook-Pro:ushareit-hawkeye-frontend wanghuan$ es-checker

ECMAScript 6 Feature Detection (v1.4.1)

Variables
  √ let and const
  √ TDZ error for too-early access of let or const declarations
  √ Redefinition of const declarations not allowed
  √ destructuring assignments/declarations for arrays and objects
  √ ... operator

Data Types
  √ For...of loop
  √ Map, Set, WeakMap, WeakSet
  √ Symbol
  √ Symbols cannot be implicitly coerced

Number
  √ Octal (e.g. 0o1 ) and binary (e.g. 0b10 ) literal forms
  √ Old octal literal invalid now (e.g. 01 )
  √ Static functions added to Math (e.g. Math.hypot(), Math.acosh(), Math.imul() )
  √ Static functions added to Number (Number.isNaN(), Number.isInteger() )

String
  √ Methods added to String.prototype (String.prototype.includes(), String.prototype.repeat() )
  √ Unicode code-point escape form in string literals (e.g. \u{20BB7} )
  √ Unicode code-point escape form in identifier names (e.g. var \u{20BB7} = 42; )
  √ Unicode code-point escape form in regular expressions (e.g. var regexp = /\u{20BB7}/u; )
  √ y flag for sticky regular expressions (e.g. /b/y )
  √ Template String Literals

Function
  √ arrow function
  √ default function parameter values
  √ destructuring for function parameters
  √ Inferences for function name property for anonymous functions
  × Tail-call optimization for function calls and recursion

Array
  √ Methods added to Array.prototype ([].fill(), [].find(), [].findIndex(), [].entries(), [].keys(), [].values() )
  √ Static functions added to Array (Array.from(), Array.of() )
  √ TypedArrays like Uint8Array, ArrayBuffer, Int8Array(), Int32Array(), Float64Array()
  √ Some Array methods (e.g. Int8Array.prototype.slice(), Int8Array.prototype.join(), Int8Array.prototype.forEach() ) added to the TypedArray prototypes
  √ Some Array statics (e.g. Uint32Array.from(), Uint32Array.of() ) added to the TypedArray constructors

Object
  √ __proto__ in object literal definition sets [[Prototype]] link
  √ Static functions added to Object (Object.getOwnPropertySymbols(), Object.assign() )
  √ Object Literal Computed Property
  √ Object Literal Property Shorthands
  √ Proxies
  √ Reflect

Generator and Promise
  √ Generator function
  √ Promises

Class
  √ Class
  √ super allowed in object methods
  √ class ABC extends Array { .. }

Module
  × Module export command
  × Module import command


=========================================
Passes 39 feature Detections
Your runtime supports 92% of ECMAScript 6
=========================================
```
可以看到，当前 node.js 版本 v10.14.2 对 ES6 的支持程度达到 92 %。

