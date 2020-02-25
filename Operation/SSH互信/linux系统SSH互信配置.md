# 环境

```conf
node1: 192.168.0.1
node2: 192.168.0.2
```

用到的命令
ssh-keygen:创建公钥和密钥,会生成id_rsa和id_rsa.pub两个文件
ssh-copy-id:把本地的公钥复制到远程主机的authorized_keys文件(不会覆盖文件，是追加到文件末尾)，并且会设置远程主机用户目录的.ssh和.ssh/authorized_keys权限

# 1. 在两台机器上生成各自的key文件

```shell
 [root@192.168.0.1]# ssh-keygen -t rsa       #下面一直按回车就好
 [root@192.168.0.2]# ssh-keygen -t rsa
```

# 2. 用ssh-copy-id 把公钥复制到远程主机上
```shell

# node1免密登录node2执行命令行(需输入对应账号的密码) -p 是SSH端口，默认是22，如果是其他端口则将22改为实际端口号
[root@192.168.0.1]# ssh-copy-id -i  ~/.ssh/id_rsa.pub -p 22 root@192.168.0.2

# node2免密登录node1执行命令行(需输入对应账号的密码) -p 是SSH端口，默认是22，如果是其他端口则将22改为实际端口号
[root@192.168.0.2]# ssh-copy-id -i  ~/.ssh/id_rsa.pub -p 22 root@192.168.0.1
```

* 注：如果不是默认的22端口,可以这样写
ssh-copy-id -i ~/.ssh/id_rsa.pub "-p 2022 root@192.168.0.2"

# 3. 设置权限
```shell
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/authorized_keys
```

# 4. 从node1登录node2

```shell
[root@192.168.0.1]# ssh root@192.168.0.2 #试试吧
```

* 说明
```  
上面是以root用户配置互信，如果想要其它用户，可以切到相应的用户下执行命令即可
如果单纯的只需要单向信任，在一台机器上执行命令就可以了，比如说node1连接node2，不用密码的话，在node1上执行命令就可以了
```