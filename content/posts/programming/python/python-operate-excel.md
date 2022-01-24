+++
title = "使用 Python 操作 excel 文档"
date = "2021-09-18"
lastmod = "2021-09-18"
tags = [
    "Python",
    "excel"
]
categories = [
    "Python"
]
+++

本篇博客介绍下使用 Python 操作 excel 表格的方法。

<!--more-->

### 代码示例
以下是使用 python 操作 excel 表格的示例代码：
```markdown
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: wanghuan
# date: 9/4/21
# description:

import os
import xlrd
import copy
import xlwt

def convert(value):
    if not value:
        return 0.00

    if isinstance(value, float):
        return value
    else:
        return float(value)

def write(table):
    book = xlwt.Workbook()
    sheet = book.add_sheet('汇总表')
    # 写入表头
    headers = ['日期', '销售金额', '回款金额', '库存金额（含税）',	'应收账款余额', '应付账款',	'预付账款余额', '占用资金总额']
    for i in range(len(headers)):
        sheet.write(0, i, headers[i])

    for i in range(len(table)):
        for j in range(len(table[i])):
            sheet.write(i+1, j, table[i][j])

    book.save('result.xlsx')



if __name__ == '__main__':
    table = list()
    rows = [''] + [0.00] * 7
    for i in range(31):
        table.append(rows)
    count = 0
    current_date = ''
    for item in os.listdir():
        if item.endswith('.xlsx') or item.endswith('.xls'):
            print('current xlsx: ', item)
            count = count + 1
            # 打开 excel 表格
            data = xlrd.open_workbook(item)
            # 根据 sheet 索引获取 sheet
            sheet = data.sheet_by_index(0)
            for i in range(sheet.nrows):
                if i == 0 or i == 1:
                    continue
                # print(sheet.row_values(i))
                if sheet.cell(i, 0).ctype == 3: # 日期类型
                    print('current rows: ', sheet.row_values(i))
                    # 处理第一列的日期
                    cdate = xlrd.xldate.xldate_as_datetime(sheet.cell(i, 0).value, 0)
                    current_date = cdate.strftime("%Y/%m/%d")
                    # rows in table
                    for idx in range(len(table)):
                        if i-2 == idx:
                            rit = copy.deepcopy(table[idx])
                            if count == 1: # 直接填充数据
                                rit[0] = current_date
                                rit[1] = convert(sheet.cell(i, 1).value)
                                rit[2] = convert(sheet.cell(i, 2).value)
                                rit[3] = convert(sheet.cell(i, 3).value)
                                rit[4] = convert(sheet.cell(i, 4).value)
                                rit[5] = convert(sheet.cell(i, 5).value)
                                rit[6] = convert(sheet.cell(i, 6).value)
                                rit[7] = convert(sheet.cell(i, 7).value)
                            else:
                                if current_date == rit[0]:
                                    rit[1] = rit[1] + convert(sheet.cell(i, 1).value)
                                    rit[2] = rit[2] + convert(sheet.cell(i, 2).value)
                                    rit[3] = rit[3] + convert(sheet.cell(i, 3).value)
                                    rit[4] = rit[4] + convert(sheet.cell(i, 4).value)
                                    rit[5] = rit[5] + convert(sheet.cell(i, 5).value)
                                    rit[6] = rit[6] + convert(sheet.cell(i, 6).value)
                                    rit[7] = rit[7] + convert(sheet.cell(i, 7).value)
                            print('current rows in table index {} -> {}', idx, rit)
                            table[idx] = rit
                else:
                    print('the current cell type: {}, break'.format(sheet.cell(i, 0)))
                    break
    print('the final data: {}'.format(table))
    write(table)
```

