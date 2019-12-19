





###
```markdown
import logging as log
log.basicConfig(level=log.INFO,
                filename='dingtalk_callback.log',
                filemode='a',
                datefmt='%Y/%m/%d %H:%M:%S',
                format='%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')
```



### 参考资料

https://cuiqingcai.com/6080.html
