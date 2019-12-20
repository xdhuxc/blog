+++
title = "Go Set 的使用"
date = "2019-08-09"
lastmod = "2019-08-09"
description = ""
tags = [
    "Golang"
]
categories = [
    "技术"
]
+++

本篇博客记录下在 golang 中进行集合操作的方式，在一些项目中可能会用到。

<!--more-->

我们使用 `golang-set` 这个包来进行集合操作。

```markdown
package main

import (
	"fmt"
	mapset "github.com/deckarep/golang-set"
)

func main() {
    // 初始化集合 envs
	envs := mapset.NewSet()
	// 向集合 envs 中添加元素
	envs.Add("prod")
	envs.Add("test")
	envs.Add("pre")

	env := "alpha"
	// 判断集合 envs 中是否包含指定元素
	if envs.Contains(env) {
		fmt.Println("包含")
	} else {
		fmt.Println("不包含")
	}
}
```

1、从 interface 数组生成新的集合
```markdown
currentEnvs := mapset.NewSetFromSlice([]interface{}{"prod", "test", "alpha"})
```

2、差集计算
```markdown
differenceSet := envs.Difference(currentEnvs) // envs 对 currentEnvs 的差集
```

3、判断父集合子集
```markdown
isSuperSet := envs.IsSuperset(currentEnvs)
isSubSet := currentEnvs.IsSubset(envs)
```
`IsProperSubset(other Set) bool` 和 `IsProperSuperset(other Set) bool` 与这两个方法的区别在于：这两者不包括两个集合相等的情况

4、并集计算
```markdown
unionSet := envs.Union(currentEnvs)
```

5、交集计算
```markdown
intersection := envs.Intersect(currentEnvs)
```

6、集合相等判断
```markdown
isEqual := envs.Equal(currentEnvs)
```

7、获取集合元素个数
```markdown
envs.Cardinality()
```

8、删除集合元素
```markdown
envs.Remove("pre")
```
如果删除的元素不存在，不会出现错误。


### 参考资料

https://github.com/deckarep/golang-set


