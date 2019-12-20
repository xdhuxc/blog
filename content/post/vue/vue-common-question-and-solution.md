+++
title = "Vue 常见问题及解决"
date = "2019-08-02"
lastmod = "2019-08-02"
tags = [
    "Vue"
]
categories = [
    "技术"
]
+++

本部分内容记录下 Vue 使用过程中的遇到的一些问题，方便后面再次遇到时解决。

<!--more-->

### 通过父组件向子组件传值时，报错如下
```markdown
vue.runtime.esm.js:587 [Vue warn]: Avoid mutating a prop directly since the value will be overwritten whenever the parent component re-renders. Instead, use a data or computed property based on the prop's value. Prop being mutated: "pods"
```
父组件中引用该组件的方式如下：
```markdown
<instances :pods="pods"></instances>
```

解决方法：在父组件中，改写代码如下：
```markdown
<instances :pods.sync="pods"></instances>
```

在父组件中改变 pods 数据时，就像平时一样直接改变即可。

子组件中，代码改写如下：
```markdown
export default {
  name: 'Instances',
  props: {
    pods: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  data() {
    return {};
  }
}

```
子组件中改变数据的代码部分不能采用直接赋值，而要改为：
```markdown
 this.$emit('update:pods', pods);
```

### Error in nextTick: "TypeError: Cannot read property 'clearValidate' of undefined"
点击编辑按钮时，处理函数代码如下：
```markdown
handleEdit(index, app) {
  this.dialogStatus = 'update';
  this.$nextTick(() => {
    this.$refs['deploymentForm'].clearValidate();
  });
  this.getVolumeTypesData(5);
  this.getURISchemesData(6);
  this.getPortProtocolsData(7);
  this.convertBackend2Deployment(app);
  this.dialogDeploymentVisible = true;
}
```
每次刷新页面后，第一次点击时，总是会报如下错误，而之后的点击事件却没有报错，有点奇怪。
```markdown
vue.runtime.esm.js:587 [Vue warn]: Error in nextTick: "TypeError: Cannot read property 'clearValidate' of undefined"

found in

---> <Deployment> at src/views/kubernetes/application/deployment/index.vue
       <Application> at src/views/kubernetes/application/index.vue
         <AppMain> at src/views/layout/components/AppMain.vue
           <Layout> at src/views/layout/Layout.vue
             <App> at src/App.vue
               <Root>
warn @ vue.runtime.esm.js:587
logError @ vue.runtime.esm.js:1733
globalHandleError @ vue.runtime.esm.js:1728
handleError @ vue.runtime.esm.js:1717
(anonymous) @ vue.runtime.esm.js:1835
flushCallbacks @ vue.runtime.esm.js:1754
vue.runtime.esm.js:1737 TypeError: Cannot read property 'clearValidate' of undefined
    at VueComponent.<anonymous> (index.vue?bb9b:837)
    at Array.<anonymous> (vue.runtime.esm.js:1833)
    at MessagePort.flushCallbacks (vue.runtime.esm.js:1754)
```

将代码修改为如下方式：
```markdown
handleEdit(index, app) {
  this.dialogStatus = 'update';
  this.getVolumeTypesData(5);
  this.getURISchemesData(6);
  this.getPortProtocolsData(7);
  this.dialogDeploymentVisible = true;    
  this.convertBackend2Deployment(app);
  this.$nextTick(() => {
    this.$refs['deploymentForm'].clearValidate();
  });
}
```
原因是，`this.dialogDeploymentVisible = true` 执行后，才会创建表单 deploymentForm，正是因为执行 `this.$refs['deploymentForm'].clearValidate()` 时，`this.dialogDeploymentVisible = true` 还没有执行，表单还没有创建，所以才会抛出上面的错误。


### 使用 compression-webpack-plugin 压缩文件时报错 
```markdown
wanghuans-MacBook-Pro:xdhuxc-ui wanghuan$ npm run build:prod --report

> cloud-manage-platform@2.0.0 build:prod /Users/wanghuan/WebstormProjects/xdhuxc-ui
> cross-env NODE_ENV=production env_config=prod node build/build.js

Browserslist: caniuse-lite is outdated. Please run next command `npm update caniuse-lite browserslist`
/Users/wanghuan/WebstormProjects/xdhuxc-ui/node_modules/compression-webpack-plugin/node_modules/schema-utils/src/validateOptions.js:32
    throw new ValidationError(ajv.errors, name);
    ^

ValidationError: Compression Plugin Invalid Options

options should NOT have additional properties

    at validateOptions (/Users/wanghuan/WebstormProjects/xdhuxc-ui/node_modules/compression-webpack-plugin/node_modules/schema-utils/src/validateOptions.js:32:11)
    at new CompressionPlugin (/Users/wanghuan/WebstormProjects/xdhuxc-ui/node_modules/compression-webpack-plugin/dist/index.js:40:30)
    at Object.<anonymous> (/Users/wanghuan/WebstormProjects/xdhuxc-ui/build/webpack.prod.conf.js:145:9)
    at Module._compile (internal/modules/cjs/loader.js:689:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:700:10)
    at Module.load (internal/modules/cjs/loader.js:599:32)
    at tryModuleLoad (internal/modules/cjs/loader.js:538:12)
    at Function.Module._load (internal/modules/cjs/loader.js:530:3)
    at Module.require (internal/modules/cjs/loader.js:637:17)
    at require (internal/modules/cjs/helpers.js:22:18)
    at Object.<anonymous> (/Users/wanghuan/WebstormProjects/xdhuxc-ui/build/build.js:17:19)
    at Module._compile (internal/modules/cjs/loader.js:689:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:700:10)
    at Module.load (internal/modules/cjs/loader.js:599:32)
    at tryModuleLoad (internal/modules/cjs/loader.js:538:12)
    at Function.Module._load (internal/modules/cjs/loader.js:530:3)
    at Function.Module.runMain (internal/modules/cjs/loader.js:742:12)
    at startup (internal/bootstrap/node.js:282:19)
    at bootstrapNodeJSCore (internal/bootstrap/node.js:743:3)
npm ERR! code ELIFECYCLE
npm ERR! errno 1
npm ERR! cloud-manage-platform@2.0.0 build:prod: `cross-env NODE_ENV=production env_config=prod node build/build.js`
npm ERR! Exit status 1
npm ERR! 
npm ERR! Failed at the cloud-manage-platform@2.0.0 build:prod script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     /Users/wanghuan/.npm/_logs/2019-10-08T07_42_00_941Z-debug.log
```
主要问题在于 webpack 和 compression-webpack-plugin 的版本的适配性问题，在不同的版本搭配下，compression-webpack-plugin 的配置写法不同。

原来默认安装的 compression-webpack-plugin 的版本为 3.0.0，降低版本到 1.1.12，即可正常构建。
