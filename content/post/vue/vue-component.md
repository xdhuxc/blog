+++
title = "Vue 组件封装"
date = "2019-07-30"
lastmod = "2019-07-30"
tags = [
    "Vue"
]
categories = [
    "Vue"
]
+++

本部分内容记录下 Vue 中组件封装的使用方法，可以使用一些组件，实现代码和逻辑抽象。

<!--more-->

### 动态数组组件
这是一个动态数组组件，从父组件传入一个字符串数组，通过在页面点击按钮，实现对数组元素的动态增删，可用于类似 Kubernetes Deployment 的容器启动参数和启动命令这样的数组结构。
```markdown
<template>
  <div>
    <el-form>
      <el-form-item :label="label"/>
      <el-form-item
        v-for="(item, index) in items"           // 数据渲染
        :key="'item' + index">
        <span>
          <el-input v-model="items[index]" :clearable="true" style="width: 199px"/>
          <el-button
            v-if="items.length > 0"
            type="danger"
            size="mini"
            icon="el-icon-delete"
            circle
            @click.prevent="removeItem(index)"/> // 删除按钮，在每一个数组元素显示的输入框之后，用于删除当前元素。
        </span>
      </el-form-item>
      <span style="margin-left: 203px">
        <el-button
          type="primary"
          size="mini"
          icon="el-icon-plus"
          circle
          @click.prevent="addItem()"/>           // 增加按钮，单独设置在底部，可以从 0 开始增加，用于增加一个元素。
      </span>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'DunamicArrays',  // 组件名称
  props: {
    items: {              // 从父组件传递过来的数据名称，在父组件中为这个名称赋予数据
      type: Array,        // 数据类型，可以为 Array，Number，String，Object等，如果传递过来的数据类型不对，直接报错
      required: true,     // 是否必须
      default() {         // 数据默认值
        return [];
      }
    },
    label: {              // 标签，可选项，用于表明数组含义
      type: String,
      default() {
        return '';
      }
    }
  },
  data() {
    return {};
  },
  methods: {             // 定义对数据的操作函数 
    addItem() {
      this.items.push('');
    },
    removeItem(index) {
      this.items.splice(index, 1);
    }
  }
};
</script>

<style scoped>

</style>
```

### 动态键值数组组件
这是一个动态键值对数组组件，从父组件传入一个键值对数组，通过在页面点击按钮，实现对键值对的动态增删，可用于类似 Kubernetes Deployment 的标签、环境变量等键值对数组结构。
```markdown
<template>
  <div>
    <div v-if="arrayType === 'key-value'"> // 数组类型，表示键值对数组中的键值是 key-value 类型的还是 name-value 类型的
      <el-form>
        <el-form-item :label="label"/>     // 标签，可选项，用于表明数组含义
        <el-form-item
          v-for="(item, index) in items"   // 数据渲染
          :key="'item' + index">
          <span>
            <el-input v-model="item.key" :clearable="true" style="width: 199px"></el-input>
            <el-input v-model="item.value" :clearable="true" style="width: 199px"></el-input>
            <el-button
              v-if="items.length > 0"
              type="danger"
              size="mini"
              icon="el-icon-delete"
              circle
              @click.prevent="removeItem(index)"/>
          </span>
        </el-form-item>
        <span style="margin-left: 406px">
          <el-button
            type="primary"
            size="mini"
            icon="el-icon-plus"
            circle
            @click.prevent="addItem(arrayType)"/>
        </span>
      </el-form>
    </div>
    <div v-else>
      <el-form>
        <el-form-item :label="label"/>
        <el-form-item
          v-for="(item, index) in items"
          :key="'item' + index">
          <span>
            <el-input v-model="item.name" :clearable="true" style="width: 199px"></el-input>
            <el-input v-model="item.value" :clearable="true" style="width: 199px"></el-input>
            <el-button
              v-if="items.length > 0"
              type="danger"
              size="mini"
              icon="el-icon-delete"
              circle
              @click.prevent="removeItem(index)"/>
          </span>
        </el-form-item>
        <span style="margin-left: 406px">
          <el-button
            type="primary"
            size="mini"
            icon="el-icon-plus"
            circle
            @click.prevent="addItem(arrayType)"/>
        </span>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DynamicKeyValueArrays',    // 组件名称 
  props: {
    items: {                        // 从父组件传递过来的数据名称，在父组件中为这个名称赋予数据 
      type: Array,                  // 数据类型，可以为 Array，Number，String，Object等，如果传递过来的数据类型不对，直接报错
      required: true,               // 是否必须，如果为 true，而实际没有传值，则会报错
      default() {                   // 数据默认值
        return [];
      }
    },
    label: {
      type: String,
      default() {
        return '';
      }
    },
    arrayType: {
      type: String,
      required: true,
      default() {
        return 'key-value'; // also support name-value
      }
    }
  },
  data() {
    return {};
  },
  methods: {                // 定义对数据的操作函数 
    addItem(arrayType) {
      if (arrayType === 'key-value') {
        this.items.push({
          key: '',
          value: ''
        });
      } else if (arrayType === 'name-value') {
        this.items.push({
          name: '',
          value: ''
        });
      }
    },
    removeItem(index) {
      this.items.splice(index, 1);
    }
  }
};
</script>

<style scoped>

</style>
```

### 使用组件
```markdown
<template>
  <div>
    <el-form ref="arrayForm" :rules="arrayVerifyRules">
      <el-form-item prop="items">
        <dynamic-arrays :items="command"></dynamic-arrays> // 通过 :items 定义响应式属性
      </el-form-item>
      <span>
        ------------华丽丽的的分割线-------------
      </span>
      <el-form-item>
        <dynamic-key-value-arrays :items="labels" array-type="name-value"></dynamic-key-value-arrays>  // 在父组件中使用自定义组件
      </el-form-item>

      <el-button @click="onSubmit"> Submit </el-button>
    </el-form>
  </div>
</template>

<script>

import DynamicArrays from '@/components/DynamicArrays/index'                  // 导入自定义组件

import DynamicKeyValueArrays from '@/components/DynamicKeyValueArrays/index'  // 导入自定义组件

export default {
  components: {                                                               // 在父组件中引用子组件
    'dynamic-arrays': DynamicArrays,
    'dynamic-key-value-arrays': DynamicKeyValueArrays
  },
  data() {
    return {
      command: [],
      labels: [],
      keyValueType: 'name-value',
    }
  },
  mounted() {},
  methods: {
    onSubmit() {
      console.log('call component')
      console.log(this.command)
      console.log(this.labels)
    }
  }
}
</script>

<style scoped>

</style>
```

对于数组和对象这种引用类型的数据，在子组件中改变值后，其父组件中对应的数据也将改变。

