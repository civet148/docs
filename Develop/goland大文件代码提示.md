
# 1. Goland大文件代码无法自动补全/跳转提示问题

当go文件大于2.5MB之后，goland无法提供代码提示功能

解决办法：打开Goland -> help(帮助) -> custom settings(自定义设置)  如果当前没有idea.properties文件会提示创建，
点击创建后复制下面的内容[idea.max.intellisense.filesize=25000]到文件中保存再重新打开Goland即可(25000=25MB)

```conf
idea.max.intellisense.filesize=25000
```