+++
title = "Vue 集成 CodeMirror"
date = "2019-05-24"
lastmod = "2019-05-26"
description = ""
tags = [
    "Vue",
    "CodeMirror"
]
categories = [
    "技术"
]
+++

当我们需要在网页页面中输入不同编程语言代码并高亮显示时，可以使用 CodeMirror 来实现这种需求。

<!--more-->    
    
### CodeMirror 简介
CodeMirror 是一个用于编辑文本框代码高亮的 JavaScript 插件，为各种编程语言实现关键字、函数、变量等代码高亮，丰富的 API 和可扩展功能以及多个主题样式、可以基本满足各种项目的需求。

CodeMirror 支持各种编程语言、标记语言的语法高亮，包括 C、C++、Java、PHP、JavaScript、Python、Go、Ruby、SQL等，以及 LaTex、wiki、Markdown等，同时也支持 JSON、YAML、TOML等配置文件常用格式。此外，CodeMirror 还支持代码自动补全、搜索、替换、HTML预览、显示行号、选择/搜索结果高亮等功能。

CodeMirror 目前已经被集成进各种应用程序中，例如 Adobe Brackets、Light Table等开发环境，经常被用于各种 SQL、JavaScript、JSON、YAML 等的在线编辑器的基础库来使用。

### 原生方式使用 CodeMirror    
本部分内容介绍如何使用 CodeMirror 插件。

1、引入核心文件
```markdown
<script src="lib/codemirror.js"></script>
<link rel="stylesheet" href="lib/codemirror.css">
<script src="mode/javascript/javascript.js"></script>
```
codemirror.js 和 codemirror.css 是 CodeMirror 插件的核心文件，无论要高亮的代码是何种语言，都需要引入这两个文件。

引入 mode/javascript/javascript.js 用于支持对 JavaScript 的语法高亮。

2、创建编辑器
```markdown
<html>
    <body>
        <textarea id="code" name="code"></textarea>
    </body>
</html>
```
创建 HTML 文本框元素，用于存放需要高亮显示的代码。

在 JavaScript 代码中
```markdown
<script>
    var editor = CodeMirror.fromTextArea(
    document.getElementById("code"), // 获取文本框元素
    {
        lineNumbers: true,
        mode: 'text/x-yaml',
        gutters: ['CodeMirror-lint-markers'],
        theme: 'rubyblue',
    });                             //设置选项参数
</script>
```
使用文本框元素和参数对象来创建 CodeMirror 对象，

选项参数含义说明如下：

* lineNumbers：为 true 时在左侧显示行号，为 false 时不显示行号。
* mode：显示模式，也就是需要高亮显示的语言的标示，例如 text/x-yaml 表示将高亮显示 YAML 语言的内容。
* gutters：用来添加额外的 gutter，值为 CSS 名称数组，每一项定义了用于绘制 gutter 背景的宽度。
* theme：显示的主题，详情可参考：https://codemirror.net/demo/theme.html。

3、获取及填充值

使用如下方法获取 CodeMirror 的值
```markdown
editor.getValue() # 获取经过转义的数据
editor.getTextArea().value # 获取未经过转义的数据
```

使用如下方法为 CodeMirror 赋值
```markdown
editor.setValue("Hello, World!")
```

4、设置文本框尺寸及选项

可通过如下方法设置文本框尺寸
```markdown
editor.setSize("600px", "800px");
```

可在代码中通过如下方式设置 CodeMirror 属性
```markdown
editor.setOption("readOnly", true);
```

### Vue 中集成 CodeMirror
当我们使用 Vue 来做我们的前端项目时，可以使用基于 CodeMirror 的 vue-codemirror 来完成 Web 代码编辑器。

1、安装插件
```markdown
# 安装 codemirror 插件
npm install codemirror
# 安装 vue-codemirror 插件
npm install vue-codemirror
```

2、挂载 VueCodeMirror，在 main.js 中加入如下代码：
```markdown
import VueCodemirror from 'vue-codemirror';
import 'codemirror/lib/codemirror.css';

Vue.use(VueCodemirror);

new Vue({
  el: '#app',
  router,
  store,
  i18n,
  render: h => h(App),
});
```

3、在其他页面中使用该组件
```markdown
<template>
    <el-dialog
        :visible.sync="dialogViewVisible"
        :title="CodeMirror"
        :show-close="true"
        :close-on-click-modal="false"
        :close-on-press-escape="false"
        width="620px">
        <codemirror v-model="codeMirrorContent" :options="cmOptions" class="json-editor"></codemirror>
    </el-dialog>
</template>

<script>
import { codemirror } from 'vue-codemirror';
import 'codemirror/addon/lint/lint.css';
import 'codemirror/lib/codemirror.css';
import 'codemirror/theme/rubyblue.css';
require('script-loader!jsonlint');
import 'codemirror/mode/javascript/javascript';
import 'codemirror/addon/lint/lint';
import 'codemirror/addon/lint/json-lint';

export default {
  name: 'CodeMirror',
  data() {
    return {
      codeMirrorContent: '',
      dialogViewVisible: false,
      cmOptions: {
        lineNumbers: true,
        mode: 'text/x-yaml',
        gutters: ['CodeMirror-lint-markers'],
        theme: 'rubyblue',
        lint: true
      }
    };
  },
  methods: {
      // 处理点击事件
      handleView(index, app) {
            this.codeMirrorContent = app.yaml;
            this.dialogViewVisible = true;
      }
  }
</script>
```
注意：

* mode 用来指定显示代码的格式，可以是JSON，YAML，SQL等，详情可参考：https://codemirror.net/mode/index.html。
* codeMirrorContent 是字符串格式的内容，如果后台传递过来的数据不是字符串格式，需要转换为字符串格式，否则会出错。
* theme 是显示主题，可以显示不同的背景色，详细可参考：https://codemirror.net/demo/theme.html。

选项参数含义说明如下：

* lineNumbers：为 true 时在左侧显示行号，为 false 时不显示行号。
* mode：显示模式，也就是需要高亮显示的语言的标示，例如 text/x-yaml 表示将高亮显示 YAML 语言的内容。
* gutters：用来添加额外的 gutter，值为 CSS 名称数组，每一项定义了用于绘制 gutter 背景的宽度。
* theme：显示的主题，详情可参考：https://codemirror.net/demo/theme.html。


### 常见问题及解决
1、页面中报错如下：
```markdown
Error: Parse error on line 1:

^
Expecting 'STRING', 'NUMBER', 'NULL', 'TRUE', 'FALSE', '{', '[', got 'EOF'
```
可能的一种情况是：

字符串内容为 YAML 格式，但是 mode 却为：`text/x-json`，将其改为：`text/x-yaml` 试下。

2、使用多个 CodeMirror 实例时，会发生数据不能及时更新，需要获取到焦点才会更新数据的情况，解决方法如下：

引入 refresh 插件，在处理函数中使用定时任务刷新 CodeMirror 组件，代码示例如下：
```markdown
<template>
   <codemirror ref="jenkinsFileCode" v-model="content" :options="fileOptions" class="json-editor"></codemirror>
</template>

<script>
import 'codemirror/addon/display/autorefresh.js';

export default {
  name: 'Pipeline',
  data() {
    return {
      content: '',
      fileOptions: {
        lineNumbers: true,
        mode: 'text/x-yaml',
        gutters: ['CodeMirror-lint-markers'],
        theme: 'erlang-dark',
        lint: true,
        lineWrapping: true,
        autoRefresh: true // 此属性是 autorefresh 的，需要引入 autorefresh.js
      }
    }
  }
  methods: {
    handle() {
       setTimeout(() => {
              this.$refs.jenkinsFileCode.refresh();
       }, 50);
    }
  }
}
</script>

<style>
  .json-editor {
    height: 100%;
  }
  .CodeMirror {
    border: 1px solid #eee;
    height: 950px;
  }
  .CodeMirror-scroll {
    height: 950px;
    overflow-y: hidden;
    overflow-x: auto;
  }
</style>
```





### 参考资料
https://codemirror.net/

https://www.itread01.com/content/1540634681.html

https://www.cnblogs.com/onlyonely/p/4450029.html
