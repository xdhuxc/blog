+++
title = "Vue + Element-UI 子组件表单校验功能"
date = "2012-03-26"
lastmod = "2020-03-26"
tags = [
    "Vue",
    "表单校验"
]
categories = [
    "技术"
]
+++

在使用 vue 和 element-ui 时，当项目比较复杂或某个功能经常使用时，我们会将其封装为组件，然后在其他组件中引用。这时，提交数据到后端 API 时，需要校验数据格式时，就需要从父组件中校验子组件的表单，本篇文章详细演示如何完成这项工作。

<!--more-->

1、子组件代码如下：
```markdown
<template>
  <div>
    <el-form>
      <el-form-item v-for="(parameter, index) in choiceParameters" :key="'parameter' + index">
        <el-card class="box-card" style="width: 80%">
          <div slot="header" class="clearfix">
            <span>{{ $t('pipeline.choiceParameter') }}</span>
            <el-button
              v-if="choiceParameters.length > 0"
              type="danger"
              size="mini"
              icon="el-icon-delete"
              circle
              style="float: right"
              @click.prevent="removeParameter(index)"/>
          </div>
          <div>
            <el-form ref="choiceParameterForm" :model="parameter" :rules="choiceParameterFormRules" label-position="left" size="mini">
              <el-form-item :label="$t('pipeline.parameterName')" size="mini" prop="name">
                <el-input v-model="parameter.name" :clearable="true"/>
              </el-form-item>
              <el-form-item :label="$t('pipeline.parameterValue')" size="mini" prop="defaultValue">
                <el-input v-model="parameter.defaultValue" :placeholder="$t('pipeline.choiceParameterOptions')" :clearable="true"/>
              </el-form-item>
              <el-form-item :label="$t('pipeline.parameterDescription')" size="mini">
                <el-input v-model="parameter.description" :clearable="true" type="textarea"/>
              </el-form-item>
            </el-form>
          </div>
        </el-card>
      </el-form-item>
      <!--
      <span style="margin-left: 450px;">
        <el-button
          type="primary"
          size="mini"
          icon="el-icon-plus"
          circle
          @click.prevent="addParameter()"/>
      </span>
      -->
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'ChoiceParameters',
  props: {
    choiceParameters: {
      type: Array,
      required: false,
      default() {
        return [];
      }
    }
  },
  data() {
    const validateChoiceParameters = (rule, value, callback) => {
      if (value) {
        if (value.indexOf(',') === -1) {
          return callback(new Error(this.$t('pipeline.validateChoiceParameter')));
        }
        return callback();
      } else {
        return callback(new Error(this.$t('pipeline.nullWarning')));
      }
    };
    return {
      choiceParameterFormRules: {
        name: [{
          required: true, message: this.$t('pipeline.nullWarning'), trigger: ['change', 'blur']
        }],
        defaultValue: [
          {
            required: true, message: this.$t('pipeline.nullWarning'), trigger: ['change', 'blur']
          },
          {
            validator: validateChoiceParameters, required: true, trigger: ['change', 'blur']
          }
        ]
      },
    };
  },
  methods: {
    validateForm() {
      let flag = true;
      for (let i = 0; i < this.choiceParameters.length; i++) {
        this.$refs.choiceParameterForm[i].validate((valid) => {
          if (!valid) {
            flag = false;
          }
        });
      }
      return flag;
    },
    addParameter() {
      this.choiceParameters.push({
        name: '',
        description: '',
        defaultValue: ''
      });
    },
    removeParameter(index) {
      this.choiceParameters.splice(index, 1);
    }
  }
};
</script>

<style scoped>

</style>
```

一个数组 choiceParameters 中包含了多个 choiceParameter，每个 choiceParameter 是个对象，在页面上是一个表单，我们需要校验每个表单。

其他地方都是普通的单表单校验常规的代码，特殊之处在于 `validateForm()` 函数，我们需要在该函数中遍历每个表单，分别校验之，如果有一个校验未通过，返回 false，这样设计的目的是为了能够在父组件中获取到子组件中的表单校验结果。

2、父组件中代码如下：
```markdown
<template>
    <el-form-item>
      <choice-parameters ref="choice-parameters" :choice-parameters="properties.choiceParameters"></choice-parameters>
    </el-form-item>
</template>

<script>
export default {
  name: 'Pipeline',
  components: {
    'choice-parameters': ChoiceParameters
  },
  data() {
    return {}
  }
  methods: {
    handle() {
      if (this.$refs['choice-parameters'].validateForm()) {
          // do something     
      }
    }
  }
}
</script>
```
以上代码中有两个地方需要特别注意，一是为了在代码中引用子组件而添加的 `ref` 属性，二是使用 `this.$refs['choice-parameters'].validateForm()` 获取子组件校验的结果，获得子组件校验的结果后，就可以进行相应的判断和操作了。
