+++
title = "Vue + Element-UI 表单校验功能的总结"
date = "2019-06-02"
lastmod = "2019-06-02"
description = ""
tags = [
    "Vue",
    "表单校验"
]
categories = [
    "技术"
]
+++

使用 vue 和 element-ui 开发的前端工程，进行资源创建时，需要在前端页面对表单进行校验，特此记录，以备后需。

<!--more-->

### 普通输入框的校验
普通输入框的校验，可以直接使用默认的校验器进行校验，示例如下：

1）对数据模型添加 rules 规则
```
<template>
  <div class="app-container">
    <el-dialog
      :visible.sync="dialogFormVisible"
      :title="$t('business.businessApplicationMonitor')"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="620px">
      <el-form ref="businessForm" :model="temp" :rules="businessVerifyRules" label-width="120px" label-position="left">
          <el-form-item :label="$t('business.regionName')" prop="region_name">
            <el-select v-model="temp.region_name" :placeholder="$t('business.placeholder')">
              <el-option v-for="region in regions" :key="region.value" :label="region.label" :value="region.value"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item :label="$t('business.name')" prop="name">
            <el-input v-model="temp.name" :clearable="true" style="width: 400px"/>
          </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
          <el-button @click="onCancel"> {{ $t('business.cancel') }} </el-button>
          <el-button type="primary" @click="onSubmit"> {{ $t('business.confirm') }} </el-button>
      </div>
    </el-dialog>
  </div>
</template>
```
`:rules="businessVerifyRules"` 为该表单添加验证规则，每一个表单项的 prop 属性将作为表单校验的属性名称，需要指定。

2）编写 rules 规则
```
export default {
  name: 'Business',
  data() {
    return {
      businessVerifyRules: {
        region_name: [{
          required: true, trigger: ['blur', 'change'], message: this.$t('confirm.nullWarning')
        }],
        name: [{
          required: true, trigger: 'blur', message: this.$t('confirm.nullWarning')
        }]
      }
    };
  }
```
在数据部分编写校验规则，name，port等表示被校验属性，需要和表单项中的 prop 属性指定的属性名称保持一致，否则无法完成校验功能。

其内置的校验器类型还包括：

* string：必须是字符串类型，这也是默认的类型。
* number：必须是数值类型。
* boolean：必须是布尔类型。
* method：必须是函数类型。
* regexp: 必须是 RegExp 的实例或者一个可以无异常地创建 RegExp 实例的字符串。
* integer：必须是数值类型和整数。
* float：必须是数值类型和一个浮点数。
* array：必须是由 Array.isArray 确定的数组。
* object：必须是一个对象类型，并且不是 Array.isArray。
* enum：值必须存在于 enum 中。
* date：值必须由 Date 确定有效。
* url：必须是一个 url 类型。
* hex：必须是一个 hex 类型。
* email：必须是一个 email 类型。

#### 数值类型的校验
对于数值类型的校验，可以使用默认的 `number` 类型校验，但是我们的数值在业务逻辑上有其特殊性，其实是个端口号，所以就有以下要求：

* 用户必须输入数值，不能提交空字符串。
* 用户的输入必须是可解析为数值的字符串，不能是其他的字符串。
* 用户输入的数值必须在 1024~65535 之间，不能超出这个范围。

为了同时满足以上要求，我们可以编写自定义的校验函数，将校验逻辑写在校验函数中，校验通过则放行，不通过则返回明确的错误提示。
```markdown
<template>
  <div class="app-container">
    <el-dialog
      :visible.sync="dialogFormVisible"
      :title="$t('business.businessApplicationMonitor')"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="620px">
      <el-form ref="businessForm" :model="temp" :rules="businessVerifyRules" label-width="80px">
        <el-form-item :label="$t('business.port')" prop="port">
          <el-input v-model="temp.port" :clearable="true" style="width: 400px"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="onCancel"> {{ $t('business.cancel') }}</el-button>
        <el-button type="primary" @click="onSubmit"> {{ $t('business.confirm') }}</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: 'Business',
  data() {
    const validatePort = (rule, value, callback) => {
      this.$refs['businessForm'].clearValidate();
      if (value) {
        const port = parseInt(value);
        // 判断是否为数字
        if (isNaN(port)) {
          return callback(new Error(this.$t('business.validateNumber')));
        }
        if (port <= 1024 || port > 65535) {
          return callback(new Error(this.$t('business.validateRange')));
        }
        return callback();
      } else {
        return callback(new Error(this.$t('business.nullWarning')));
      }
    };
    return {
      businesses: [],
      temp: {
        id: 0,
        gid: 0,
        name: '',
        prome_id: 0,
        labels: [],
        port: 10106
      },
      businessVerifyRules: {
        port: [{
          required: true, trigger: 'blur', message: this.$t('confirm.nullWarning')
        }, {
          validator: validatePort, trigger: 'blur'
        }]
      }
    };
  }
}
</script>
```
在 businessVerifyRules 中添加自定义校验器
```markdown
businessVerifyRules: {
    port: [{
      validator: validatePort, trigger: 'blur'
    }]
}
```
通过 validator 字段指定自定义校验函数 validatePort，触发条件为：blur。


#### 复杂数据结构的校验
对于复杂数据结构的校验，采取的方式是编写自定义的校验函数，将校验逻辑封装到校验函数中，校验通过则放行，不通过则返回错误提示，但是需要注意的是，每次执行校验函数时，需要先清除上次的校验结果，否则校验效果就比较滑稽了。

比如我们的项目中，需要校验键值对，采用了如下的方式：
```markdown
<template>
  <div class="app-container">
    <el-dialog
      :visible.sync="dialogFormVisible"
      :title="$t('business.businessApplicationMonitor')"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="620px">
      <el-form ref="businessForm" :model="temp" :rules="businessVerifyRules" label-width="80px">
        <el-form-item :label="$t('business.label')" prop="label">
          <span>
            <el-input value="" style="width: 400px" type="hidden"/>
          </span>
        </el-form-item>
        <el-form-item
          v-for="(label, index) in temp.labels"
          :key="'label' + index"
          prop="labels">
          <span>
            <el-input v-model="label.key" :clearable="true" style="width: 199px"></el-input>
            <el-input v-model="label.value" :clearable="true" style="width: 199px"></el-input>
            <el-button
              v-if="temp.labels.length !== 1"
              type="danger"
              size="mini"
              icon="el-icon-delete"
              circle
              @click.prevent="removeLabel(index)"/>
            <el-button
              v-if="index === temp.labels.length - 1"
              type="primary"
              size="mini"
              icon="el-icon-plus"
              circle
              @click.prevent="addLabel"/>
          </span>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="onCancel"> {{ $t('business.cancel') }}</el-button>
        <el-button type="primary" @click="onSubmit"> {{ $t('business.confirm') }}</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: 'Business',
  data() {
    const validateLabels = (rule, value, callback) => {
      this.$refs['businessForm'].clearValidate();
      if (value) {
        if (value.length > 0) {
          for (let i = 0; i < value.length; i++) {
            if (value[i].key === '' || value[i].value === '') {
              return callback(new Error(this.$t('business.validateLabel')));
            }
          }
          return callback();
        } else {
          return callback(new Error(this.$t('business.nullWarning')));
        }
      } else {
        return callback(new Error(this.$t('business.nullWarning')));
      }
    };
    return {
      businesses: [],
      temp: {
        id: 0,
        gid: 0,
        name: '',
        prome_id: 0,
        labels: [],
        port: 10106
      },
      label: {
        key: '',
        value: ''
      },
      businessVerifyRules: {
        labels: [{
          validator: validateLabels, trigger: ['blur', 'change']
        }]
      }
    };
  }
}
</script>
```
弹出框中是一个表单，表单中有个标签项，每项均是键值对，需要每项同时都配置键值对，如果没有同时配置，需要在页面给出提示，可以在并列显示的标签后面点击按钮删除当前标签。我们将校验逻辑写在自定义校验函数中，然后加入到校验规则里，就可以起作用了。

需要注意的是，每次校验前，需要使用表单的 clearValidate() 函数清理上次的校验结果，如果没有这一步，表单校验的结果就会显得错乱。


### 参考资料

https://github.com/yiminghe/async-validator
