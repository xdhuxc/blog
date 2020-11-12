+++
title = "使用 golang 操作 excel 表格"
date = "2019-10-22"
lastmod = "2019-10-22"
tags = [
    "Golang",
    "Excel"
]
categories = [
    "技术"
]
+++

使用 golang 操作 excel 表格，写了些示例代码，封装了几个常用的函数，特此记录，以备后查。

<!--more-->

使用 excelize 库 来进行 excel 的操作，项目地址为：https://github.com/360EntSecGroup-Skylar/excelize

### 示例代码
以下代码演示了创建 excel 表格并向其中添加数据的方法，其中用到的函数见下文。
```markdown
package main

import (
	"fmt"
	"strconv"
    "time"
	
	"github.com/360EntSecGroup-Skylar/excelize"
	log "github.com/sirupsen/logrus"
)

type User struct {
	ID int `json:"id"`
	Name string `json:"name"`
	Address string `json:"address"`
}

func main() {
	users := []User{
		{
			ID: 1,
			Name: "孔子",
			Address: "山东曲阜",
		},
		{
			ID: 2,
			Name: "牛顿",
			Address: "英国伦敦",
		},
		{
			ID: 3,
			Name: "凯撒",
			Address: "罗马",
		},
	}

	f := excelize.NewFile()
	sheetName := "人物信息"
	sheet := f.NewSheet(sheetName)
	f.SetActiveSheet(sheet)

	// 合并单元格
	err := f.MergeCell(sheetName, "A1", "A5")

	header := map[string]interface{}{"A1": "编号", "B1": "姓名", "C1":"地址"}
	data := GenerateData(users, header)
	err = Write2File("历史人物", sheetName, data, true)
	if err != nil {
		log.Errorln(err)
	}
	
	Read("/Users/wanghuan/GolandProjects/GoPath/src/github.com/xdhuxc/go-study-notes/历史人物_2019-10-22_.xlsx")
}
```

### 读取 excel 文件
以下代码为读取 excel 表格的代码，要求：文件路径需要是绝对路径，excel 表格中不包含合并的单元格
```markdown
func Read(fileFullPath string) {
	f, err := excelize.OpenFile(fileFullPath)
	if err != nil {
		log.Fatal(err)
	}

	for sheetIndex, sheetName := range f.GetSheetMap() {
		fmt.Println(sheetIndex, "--->", sheetName)
		rows, err := f.Rows(sheetName)
		if err != nil {
			log.Errorln(err)
			continue
		}
		for rows.Next() {
			// 获取一行
			cols, err := rows.Columns()
			if err != nil {
				log.Errorln(err)
				continue
			}
			// 获取行数组中的值
			for _, colCell := range cols {
				fmt.Println(colCell)
			}
		}
	}
}
```

### 组织数据
我们将数据组织成 map 数组格式，每个数组元素为 excel 表格中的一行，map 中的每个键表示 excel 中的一个位置，比如A1，B2，C3等，其值为需要填充到该单元格中的值，如下所示：
```markdown
func GenerateData(users []User, header map[string]interface{}) []map[string]interface{} {
	var maps []map[string]interface{}
	var m map[string]interface{}

	maps = append(maps, header)
	rowCount := 1
	for _, user := range users {
		index := strconv.Itoa(rowCount)
		m = map[string]interface{}{
			"A"+index: user.ID,
			"B"+index: user.Name,
			"C"+index: user.Address,
		}

		maps = append(maps, m)
		rowCount = rowCount + 1
	}

	return maps
}
```

### 写 excel 文件
将组织好的 map 数组写入文件中
```markdown
// 写数据到 excel 中，每个 map[string]interface{} 为一行数据，键为A1，B2，C3等等
func Write2File(fileName string, sheetName string, data []map[string]interface{}, dateContaining bool) error {
	f := excelize.NewFile()

	sheet := f.NewSheet(sheetName)
	f.SetActiveSheet(sheet)

	for _, item := range data {
		for k, v := range item {
			err := f.SetCellValue(sheetName, k, v)
			if err != nil {
				log.Errorln(err)
				continue
			}
		}
	}

	// 删除 Sheet1
	f.DeleteSheet("Sheet1")

	if dateContaining {
		return f.SaveAs(fileName + "_" + time.Now().Format("2006-01-02") + "_" + ".xlsx")
	} else {
		return f.SaveAs(fileName + ".xlsx")
	}
}
```

### 合并单元格
使用 MergeCell 方法可以合并单元格
```markdown
err := f.MergeCell(sheetName, "A1", "A5")
if err != nil {
    log.Errorln(err)
}
```
以上代码将合并 A1~A5 的单元格，并以单元格 A5 的内容填充合并后的单元格。

### 参考资料
https://github.com/360EntSecGroup-Skylar/excelize
