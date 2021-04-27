# 1. 升级WSL升级内核

[点击此处Windows 10 上安装 WSL2](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package)

# 2. 检查Ubuntu版本

打开cmd或powershell执行下面的命令行查看版本(VERSION是1则继续往下操作，是2就忽略)

```sh
CMD> wsl -l -v
  NAME              STATE           VERSION
* Ubuntu-20.04    Running             1
```

转换为WSL2版本(等待几分钟)

```sh
CMD> wsl --set-version Ubuntu 2
正在进行转换，这可能需要几分钟时间...
有关与 WSL 2 的主要区别的信息，请访问 https://aka.ms/wsl2
转换完成。
```

设置默认版本为2

```sh
CMD> wsl --set-default-version 2
有关与 WSL 2 的主要区别的信息，请访问 https://aka.ms/wsl2
```

# 3. 安装docker

打开WSL2终端

```sh
# 卸载旧版本
$ sudo apt-get remove docker docker-engine docker.io containerd runc

# 安装依赖工具包
$ sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# 添加docker源
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt update  

# 安装docker服务
$ sudo apt install -y docker-ce

# 启动docker服务
$ sudo service docker start

# 测试运行
$ docker run hello-world
```





