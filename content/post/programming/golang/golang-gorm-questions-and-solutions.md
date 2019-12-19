+++
title = "使用 GORM 操作 MySQL 常见问题及解决"
date = "2019-06-11"
lastmod = "2019-06-11"
description = ""
tags = [
    "MySQL",
    "Golang",
    "GORM"
]
categories = [
    "MySQL",
    "Golang",
    "GORM"
]
+++

本篇博客记录了一些使用 GORM 操作 MySQL 数据库时常见的问题及解决方法，可以给其他人遇到同样问题解决时提供参考。

<!--more-->

### Error 1062: Duplicate entry 'viewer' for key 'name'
为数据模型中的 name 字段加上了 unique 修饰，
```markdown
# create the table role
CREATE TABLE IF NOT EXISTS `role` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `description` varchar(125) DEFAULT NULL,
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;
```
但是更新该字段的值时，却报错如下：
```markdown
{
 "code": 50002,
 "result": "Error 1062: Duplicate entry 'viewer' for key 'name'"
}
```
后台代码使用 Golang 编写，数据模型为：
```markdown
type Role struct {
	ID          int       `json:"id" gorm:"id"`
	Name        string    `json:"name" gorm:"name"`
	Description string    `json:"description" gorm:"description"`
	CreateTime  time.Time `json:"create_time" gorm:"create_time"`
	UpdateTime  time.Time `json:"update_time" gorm:"update_time"`
}
```
更新代码的方法为：
```markdown
// Update updates the information of specified role
func (rs *roleService) Update(role model.Role) (*model.Role, error) {
	if err := role.Validate(); err != nil {
		return &role, err
	}

	role.UpdateTime = time.Now()

	if err := rs.db.Model(&models.Role{}).Update(map[string]interface{}{
		"name":        role.Name,
		"description": role.Description,
		"update_time": role.UpdateTime,
	}).Error; err != nil {
		return &role, err
	}

	return &role, nil
}
```
修改为如下方式时，却可以更新成功
```markdown
// Update updates the information of specified role
func (rs *roleService) Update(role model.Role) (*model.Role, error) {
	if err := role.Validate(); err != nil {
		return &role, err
	}

	role.UpdateTime = time.Now()

	if err := rs.db.Model(&role).Update(map[string]interface{}{
		"name":        role.Name,
		"description": role.Description,
		"update_time": role.UpdateTime,
	}).Error; err != nil {
		return &role, err
	}

	return &role, nil
}
```
将 db.Model(value interface{}) 中的接口类型参数由 &models.Role{} 修改为 &role，居然就可以更新成功了。

查看该方法的[源代码](https://github.com/jinzhu/gorm/main.go)，如下：
```markdown
// Model specify the model you would like to run db operations
//    // update all users's name to `hello`
//    db.Model(&User{}).Update("name", "hello")
//    // if user's primary key is non-blank, will use it as condition, then will only update the user's name to `hello`
//    db.Model(&user).Update("name", "hello")
func (s *DB) Model(value interface{}) *DB {
	c := s.clone()
	c.Value = value
	return c
}
```
从该方法的注释来看，如果使用 &User{}，那么将会更新数据库的所有记录的相同字段为同样的值，如果设置某个字段为 unique，那么当记录数超过一条时，肯定会产生重复的字段值从而导致错误。而实际上，我们的目的是第二种，使用 &user，以主键作为条件更新一条记录。所以，使用 GORM 的 Update 方法时，不要传入指向结构体的指针，而应该传入指向结构体变量的指针。

### desc 是 MySQL 关键字
更新数据时，后台 API 返回的错误为：
```markdown
 "result": "Error 1064: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'desc = ?, cloud = ?, update_time = ? WHERE id = ?' at line 1"
```
实际上使用的 SQL 语句为：
```markdown
UPDATE `xdhuxc_aksk` SET iam = ?, desc = ?, cloud = ?, update_time = ? WHERE id = ?", g.Iam, g.Desc, g.Cloud, g.UpdateTime, g.ID
```
之所以出现上面的错误，是因为 desc 为 MySQL 数据库关键字，导致该 SQL 语句错误。

改为如下形式即可：
```markdown
UPDATE `xdhuxc_aksk` SET iam = ?, `desc` = ?, cloud = ?, update_time = ? WHERE id = ?", g.Iam, g.Desc, g.Cloud, g.UpdateTime, g.ID
```

当然，设计数据库字段名称时，最好不要和 MySQL 数据库关键字冲突，但是如果已经使用了 MySQL 数据库关键字，可以使用反引号将该字段名称括起来，这样也可以操作成功。

### Count 方法的使用

Count() 方法一般用于分页时统计总记录数，但是和 Where() 方法连用时，情况会有些不同。对于如下代码：
```markdown
if err := rs.db.Model(&models.User{}).
    Where("tags->'$.group' = ?", group).
    Count(&count).
    Offset(page.Offset).
    Limit(page.PageSize).
    Order("update_time desc").
    Find(&users).Error; err != nil {
        return count, users, err
    }
}
```
需要注意：

1、实际上是运行了两条 sql 语句，并非运行了一条 sql 语句。也因此，考虑到注意事项 2 ，在 Where 条件不复杂的时候，把 Count() 单独出来也可以，代码稍有冗余但更清晰。

2、Count() 方法写在 Where() 方法之前，等同于无条件的统计所有记录，如下 sql 日志所示：
```markdown
(/Users/wanghuan/GolandProjects/GoPath/src/gitlab.xdhuxc.me/devops/xdhuxc/src/service/user.go:38) 
[2019-11-12 11:28:26]  [87.37ms]  SELECT count(*) FROM `user`    
[0 rows affected or returned ] 

(/Users/wanghuan/GolandProjects/GoPath/src/gitlab.xdhuxc.me/devops/xdhuxc/src/service/user.go:43) 
[2019-11-12 11:28:27]  [175.49ms]  SELECT * FROM `user`  WHERE (tags->'$.group' = 'Math') ORDER BY update_time desc LIMIT 10 OFFSET 0  
[4 rows affected or returned ] 
``` 
Count() 方法写在 Where() 方法之前，是在仅附加 where 条件之后的统计记录数，不包含 offset 等，如下图 sql 日志所示：
```markdown
(/Users/wanghuan/GolandProjects/GoPath/src/gitlab.xdhuxc.me/devops/xdhuxc/src/service/user.go:39) 
[2019-11-12 11:26:52]  [179.90ms]  SELECT count(*) FROM `user`  WHERE (tags->'$.group' = 'Math')  
[0 rows affected or returned ] 

(/Users/wanghuan/GolandProjects/GoPath/src/gitlab.xdhuxc.me/devops/xdhuxc/src/service/user.go:43)
[2019-11-12 11:26:53]  [176.48ms]  SELECT * FROM `user`  WHERE (tags->'$.group' = 'Math') ORDER BY update_time desc LIMIT 10 OFFSET 0  
[4 rows affected or returned ] 
```
