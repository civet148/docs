## 1. 查看WSL分发版本

- 分发版本的名称需要在后面的自启动脚本中对应

```sh
CMD> wsl -l -v
  NAME                   STATE           VERSION
* Ubuntu-20.04           Running         2
  docker-desktop-data    Stopped         2
  docker-desktop         Stopped         2
```



## 2. 添加自启动脚本(Windows)

Win键+R打开启动窗口，输入 shell:startup

在启动目录中添加一个vbs文件(例如: wls-services.vbs)

wls-services.vbs脚本内容如下

```text
Set ws = WScript.CreateObject("WScript.Shell")
ws.run "wsl -d Ubuntu-20.04 -u root /etc/init.wsl start"
```

## 3. 在Ubuntu分发版本中添加启动脚本

打开WSL终端（ubuntu终端）, 在/etc/目录下创建 init.wsl 的文件（赋予执行权限)

文件内容:

```text
#!/bin/sh
service ssh $1
service docker $1
```

保存脚本内容后赋予执行权限

```sh
$ sudo chmod +x /etc/init.wsl
```



## 4. 重启windows