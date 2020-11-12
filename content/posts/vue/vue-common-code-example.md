+++
title = "Vue 开发常用代码"
date = "2019-07-24"
lastmod = "2019-07-24"
tags = [
    "JavaScript",
    "Vue"
]
categories = [
    "技术"
]
+++

在使用 Vue 和 Element-UI 进行开发时的常用代码，方便后续使用。

<!--more-->


### 获取当前语言
```
this.$i18n.locale;
```

### 刷新当前页面
```
this.$router.go(0);
```
router.go(n)

此方法的参数是一个整数，表示在 history 记录中向前或者后退多少步，类似 window.history.go(n)。

### 键值对数组增删
一个可以动态删减的键值对数组，可以用于各种键值对类型的数据的动态删减，比如环境变量，标签等。
```markdown
<template>
  <div class="app-container">
    <el-form>
      <el-form-item
        v-for="(label, labelIndex) in labels"
        :key="'label' + labelIndex">
        <span>
          <el-input v-model="label.key" :clearable="true" style="width: 199px"></el-input>
          <el-input v-model="label.value" :clearable="true" style="width: 199px"></el-input>
          <el-button
            v-if="labels.length !== 1"
            type="danger"
            size="mini"
            icon="el-icon-delete"
            circle
            @click.prevent="removeLabel(labelIndex)"/>
          <el-button
            v-if="argIndex === labels.length - 1"
            type="primary"
            size="mini"
            icon="el-icon-plus"
            circle
            @click.prevent="addLabel()"/>
        </span>
      </el-form-item>
    </el-form>
    <el-button @click="onSubmit"> Submit </el-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      labels: [{
        key: '',
        value: ''
      }]
    }
  },
  methods: {
    addLabel() {
      this.labels.push({
         key: '',
         value: ''
       })
    },
    removeLabel(index) {
      this.labels.splice(index, 1)
    },
    onSubmit() {
      console.log(this.labels)
    }
  }
}
</script>
```

### 动态数组增删
一个可以动态增减的字符串数组，可用于一些场景下的参数增删，比如 kubernetes 中容器的命令和其参数的前端表单的开发
```markdown
<template>
  <div class="app-container">
    <el-form>
      <el-form-item
        v-for="(arg, argIndex) in args"
        :key="'arg' + argIndex">
        <span>
          <el-input v-model="args[argIndex]" :clearable="true" style="width: 199px"></el-input>
          <el-button
            v-if="args.length !== 1"
            type="danger"
            size="mini"
            icon="el-icon-delete"
            circle
            @click.prevent="removeArg(argIndex)"/>
          <el-button
            v-if="argIndex === args.length - 1"
            type="primary"
            size="mini"
            icon="el-icon-plus"
            circle
            @click.prevent="addArg()"/>
        </span>
      </el-form-item>
    </el-form>
    <el-button @click="onSubmit"> Submit </el-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      args: ['']
    }
  },
  methods: {
    addArg() {
      this.args.push('')
    },
    removeArg(index) {
      this.args.splice(index, 1)
    },
    onSubmit() {
      console.log(this.args)
    }
  }
}
</script>
```

### 响应式数组

由于 JavaScript 的限制，Vue 不能检测以下数组的变动：

1、当利用索引直接设置一个数组项时，例如：`vm.items[3] = 'a'`

2、修改数组的长度时，例如，`vm.items.length = 10`

比如：
```markdown
var vm = new Vue({
    data: {
        items: ['a', 'b', 'c']
    }
})
vm.items[3] = 'a' // 不是响应式的
vm.items.length = 20 // 不是响应式的
```

以上两种改变不是响应式的，因此无法直接在视图上显示出来。

解决第一类问题的两种方法如下所示：
```markdown
// Vue.set
Vue.set(vm.items, 3, 'a')
// Array.prototype.splice
vm.items.splice(3, 1, 'a')
```

以上两种方法都可以实现和 `vm.items[3] = 'a'` 相同的效果，同时也将在响应式系统内触发状态更新。

也可以使用 `vm.$set` 实例方法，该方法是全局方法 Vue.set 的一个别名：
```markdown
vm.$set(vm.items, 3, 'a')
```

可以使用 `splice` 方法可以解决第二类问题
```markdown
vm.items.splice(10)
```

使用如上所示的方法更新数组后，视图将会和数组同步变化。

参考资料：

https://cn.vuejs.org/v2/guide/list.html#%E6%9B%BF%E6%8D%A2%E6%95%B0%E7%BB%84

https://cn.vuejs.org/v2/guide/reactivity.html
