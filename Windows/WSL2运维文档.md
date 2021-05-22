# 1. WSL2服务自启动配置

## 1.1 查看WSL分发版本

- 分发版本的名称需要在后面的自启动脚本中对应

```sh
CMD> wsl -l -v
  NAME                   STATE           VERSION
* Ubuntu-20.04           Running         2
  docker-desktop-data    Stopped         2
  docker-desktop         Stopped         2
```



## 1.2 添加自启动脚本(Windows)

Win键+R打开启动窗口，输入 shell:startup

在启动目录中添加一个vbs文件(例如: wls-services.vbs)

wls-services.vbs脚本内容如下

```text
Set ws = WScript.CreateObject("WScript.Shell")
ws.run "wsl -d Ubuntu-20.04 -u root /etc/init.wsl start"
```

## 1.3 在Ubuntu分发版本中添加启动脚本

打开WSL终端（ubuntu终端）, 在/etc/目录下创建 init.wsl 的文件（赋予执行权限)
```sh
# 查看IP（eth0）后续设置固定IP地址
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether d6:52:e2:8c:13:91 brd ff:ff:ff:ff:ff:ff
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 6a:e7:a0:2d:91:dc brd ff:ff:ff:ff:ff:ff
4: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:fb:37:d9 brd ff:ff:ff:ff:ff:ff
    inet 172.21.35.55/20 brd 172.21.47.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fefb:37d9/64 scope link
       valid_lft forever preferred_lft forever
       
$ sudo vi /etc/init.wsl
```


文件内容:

```sh
#! /bin/sh
/etc/init.d/ssh $1
/etc/init.d/docker $1

### 固定IP命令行尚未验证
# ip addr add 172.21.35.55/20 broadcast 172.21.47.255 dev eth0 label eth0:1
```

保存脚本内容后赋予执行权限

```sh
$ sudo chmod +x /etc/init.wsl
```



## 1.4 重启windows



# 2. WSL端口映射到Win10主机

## 2.1 查看WSL主机IP地址

打开CMD窗口执行命令行

```bash
CMD> wsl -- ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.24.248.223  netmask 255.255.240.0  broadcast 172.24.255.255
        inet6 fe80::215:5dff:fe34:f617  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:34:f6:17  txqueuelen 1000  (Ethernet)
        RX packets 13969973  bytes 16334463396 (16.3 GB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8937947  bytes 1751059990 (1.7 GB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

映射Win10端口80到WSL端口80

```bash
CMD> netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=172.24.248.223
```

检测是否设置成功

```bash
CMD> netsh interface portproxy show all
```



