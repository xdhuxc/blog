### blog

### 使用 MemE 主题

1、使用
```
git clone --depth 1 https://github.com/reuixiy/hugo-theme-meme.git themes/meme
```

2、更新
```
git submodule update --rebase --remote
```
3、启动，本地预览
```
hugo server -D -t meme --disableFastRender=true
```

参考资料：

https://themes.gohugo.io/hugo-theme-meme/

https://github.com/reuixiy/hugo-theme-meme/


### 启动
```markdown
hugo server -D -w --templateMetrics
```

### 部署

### 注意事项

1、一旦使用 markdown 标题，当仅含二级、三级标题时，生成的页面将会没有底部的站点信息，会无限向下延伸；四级标题及以下不会被作为右侧的文章目录显示。

当不含 markdown 标题和含有一级标题时，会显示底部的站点信息。
