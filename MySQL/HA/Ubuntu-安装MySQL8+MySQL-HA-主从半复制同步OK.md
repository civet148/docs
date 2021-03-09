# 1. Ubuntu apt-get安装MySQL8.0

## 1.1 下载mysql最新apt配置包

```shell
wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.14-1_all.deb
```
* 注意：dpkg安装时选择确保选择如下
```
MySQL Server & Cluster (Currently selected: mysql-8.0)                                                         
MySQL Tools & Connectors (Currently selected: Enabled)                                                          
MySQL Preview Packages (Currently selected: Enabled)  
```

## 1.2 安装mysql8.0 (mysql-router 可根据是否搭建集群自行安装)
```shell
sudo apt-get update
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-router # 可根据是否搭建集群选装（仅master节点）
```

- 安装MySQL8时密码加密方式选择MySQL5.x兼容方式 [Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)]

## 1.3 配置mysqld.cnf文件

```
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

-  将配置文件 bind-address 设置为 0.0.0.0 保存后退出(没有则自己加一行 bind-address = 0.0.0.0)，重启mysql服务

```
sudo service mysql restart
sudo netstat -ant|grep 3306|grep -i listen
```

* 测试root账户登录(MySQL8安装时要求设置root密码)

```
mysql -uroot -p
```

## 1.4 配置mysql远程访问(注意MySQL5.x和8.x版本差异)

* 如果5.x版本没有设置root密码则通过debian.cnf找到本地登录mysql的账号和密码
```
sudo cat /etc/mysql/debian.cnf
sudo mysql -udebian-sys-maint -pnSojYaOJU461B0ay
```

* 在mysql命令行中执行如下SQL语句更改root用户密码、密码加密方式以及允许所有主机访问
```sql

mysql> select host,user,plugin from mysql.user; # 如果root用户对应的host是localhost则需要修改为'%' 或指定IP

+-----------+------------------+-----------------------+
| host      | user             | plugin                |
+-----------+------------------+-----------------------+
| localhost | root             | auth_socket           |
| localhost | mysql.session    | mysql_native_password |
| localhost | mysql.sys        | mysql_native_password |
| localhost | debian-sys-maint | mysql_native_password |
+-----------+------------------+-----------------------+
4 rows in set (0.00 sec)

mysql> update mysql.user set plugin='mysql_native_password', host='%' where user='root'; #修改root密码加密方式和允许访问主机IP
mysql> update mysql.user set authentication_string=PASSWORD('123456') where user='root'; #适用于5.7之前版本修改密码
mysql> alter user 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';  #适用于8.x版本修改密码(修改失败请将authentication_string字段的内容置空)
mysql> flush privileges;
mysql> quit;
```

* 验证新修改的root密码123456登录mysql

```shell
mysql -uroot -p
```

# 2. 安装MySQL-HA

* 参考资料

Ubuntu系统MHA+MySQL主从配置实现MySQL高可用 https://www.jianshu.com/p/41f0774226df

* 概要

 MHA由Node和Manager组成，Node运行在每一台MySQL服务器上，也就是说，不管是MySQL主服务器，还是MySQL从服务器，都要安装Node，而Manager通常运行在独立的服务器上，但如果硬件资源吃紧，也可以用一台MySQL从服务器来兼职Manager的角色。

* 安装条件
 要搭建MHA，要求集群至少要有三个节点，即一主二从。MHA分为MHA-Manager（管理节点）和MHA-Node（数据节点）应先配置MySQL复制，开启半同步复制，并设置SSH公钥免密码登录（Manager节点和Node节点相互设置，实践发现需要使用同一个私钥证书）。

 * 安装示例拓扑结构
 一台MySQL master两台slave从节点，其中MHA manager安装在其中一台MySQL从节点上

 MHA node + MySQL master 192.168.124.110  
 MHA manager + node + MySQL slave01 + 192.168.124.111
 MHA node + MySQL slave02 192.168.124.118


## 2.1 下载MHA-Manager和MHA-Node
[https://pan.baidu.com/s/1fhIV2XGLgM9tVrKKm6Uexw](https://pan.baidu.com/s/1fhIV2XGLgM9tVrKKm6Uexw "MHA-Manager")
密码：yoed

[https://pan.baidu.com/s/1onD8YY5P-DaV9BNObISgFQ](https://pan.baidu.com/s/1onD8YY5P-DaV9BNObISgFQ "MHA-Node")
密码：y5ml

## 2.2 安装依赖包

```shell
sudo apt-get install -y libdbd-mysql-perl
sudo apt-get install -y libconfig-tiny-perl
sudo apt-get install -y liblog-dispatch-perl
sudo apt-get install -y libparallel-forkmanager-perl
```

## 2.3 先安装MHA Node

由于MHA Manager会用到MHA Node提供的模块，不先安装MHA Node直接安装MHA Manager会报错，将下载的MHA-Node安装包上传到Linux指定目录并进入改目录执行下面的命令行

```shell
sudo dpkg -i mha4mysql-node_0.54-0_all.deb
sudo apt-get update
sudo apt-get install mha4mysql-node
```

## 2.4 在某台从数据库机器上安装MHA Manager
```shell
sudo dpkg -i mha4mysql-manager_0.55-0_all.deb
sudo apt-get update
sudo apt-get install mha4mysql-node
sudo apt-get install mha4mysql-manager
```

## 2.5 MHA环境配置(后续操作均使用root账户操作)

 MHA 集群中的各节点彼此之间均需要基于 ssh 互信通信，以实现远程控制及数据管理功能，所以MHA环境中的三台主机需要相互信任：实现三台主机之间相互免密钥登录。登录MHA Manager机器，建议直接使用root用户。


### 2.5.1 配置SSH信任连接

在MHA manager (MySQL slave01) 机器SSH终端会话切换root用户
```
# 切换root用户
sudo -i

#设置root密码
passwd

# 开放所有机器root用户SSH远程登录权限(设置/etc/ssh/sshd_config文件PermitRootLogin=yes)
vi /etc/ssh/sshd_config
service ssh restart

# 生成公钥
ssh-keygen -t rsa

# 生成私钥
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.124.111

# 将生成的公私钥传给MHA Node机器
scp -p ~/.ssh/authorized_keys .ssh/id_rsa{,.pub} root@192.168.124.110:/root/.ssh/
scp -p ~/.ssh/authorized_keys .ssh/id_rsa{,.pub} root@192.168.124.118:/root/.ssh/

# 测试本机SSH无密码执行命令ifconfig(提示输入密码的需要重新做一次SSH信任配置)
ssh root@192.168.124.110  'ifconfig'
ssh root@192.168.124.111  'ifconfig'
ssh root@192.168.124.118  'ifconfig'
```

### 2.5.2 修改MySQL同步配置

编辑mysqld.cnf文件，添加对应配置内容

```
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

* MySQL master mysqld.cnf配置添加

```conf
log_bin = master-bin  # 启动二进制日志
log_bin_index = master-bin.index
relay-log = slave-relay-bin
relay-log-purge = 0  # 禁用或启用不再需要中继日志时是否自动清空它们
```

* MySQL slave mysqld.cnf配置添加
```conf
log_bin = master-bin
relay-log = slave-relay-bin
relay-log-index = slave-relay-bin.index
relay-log-purge = 0
read_only = 1
```

### 2.5.3 配置MHA Manager

* 数据库同步权限，为简单起见使用root账户，也可以创建一个专门的同步账户并赋权限(如果新建用户必须在所有节点上同时创建保持用户名和密码一致)
  Super,select,create,insert,update,delete,drop,reload

* 创建相关目录

```shell
mkdir -p /usr/local/masterha/app1  # MHA manager主机创建数据文件目录
mkdir /etc/masterha  # 创建配置文件目录
```

* 创建配置文件
```shell
vi /etc/masterha/app1.cnf
```
* app1.cnf 配置文件内容

```conf
[server default]
# mysql用戶名
user=root
# mysql密码
password=123456
# ssh免密钥登录的帐号名
ssh_user=root
# mysql复制帐号，主从配置里配的
repl_user=root
# mysql复制账号密码
repl_password=123456
# ping间隔，用来检测master是否正常，默认是3秒，尝试三次没有回应的时候自动进行failover
ping_interval=3
 # 数据目录
manager_workdir=/usr/local/masterha/app1
# 日志文件
manager_log=/usr/local/masterha/manager.log
# 另外2台机子在运行时候需要创建的目录，注意ssh-keygen帐号的权限问题
remote_workdir=/usr/local/masterha/app1
# binlog目录，不指定会报错     
master_binlog_dir=/var/log/mysql

[server1] 
hostname=192.168.124.110
#port=3306  # port默认是3306，如果是其他的，需要在这里指定，否则会报错  
# master机宕掉后,优先启用这台作为新master
candidate_master=1
# 默认情况下如果一个slave落后master 100M的relay logs的话，MHA将不会选择该slave作为一个新的master，因为对于这个slave的恢复需要花费很长时间，通过设置check_repl_delay=0，MHA触发切换在选择一个新的master的时候将会忽略复制延时，这个参数对于设置了candidate_master=1的主机非常有用，因为这个候选主在切换的过程中一定是新的master
check_repl_delay=0

[server2] 
hostname=192.168.124.111
# port默认是3306，如果是其他的，需要在这里指定，否则会报错  
#port=3306
 # 一定不会选这个机器为master，根据情况设置 
no_master=1 

[server3]
hostname=192.168.124.118
# port默认是3306，如果是其他的，需要在这里指定，否则会报错 
#port=3306
candidate_master=1
```

### 2.5.4 配置MHA Node

* 创建相关目录

```shell
mkdir -p /usr/local/masterha/app1 # MHA node 主机创建数据文件目录
```

## 2.6 设置MySQL数据库主从同步

### 2.6.1 设置MySQL半同步

* 检查是否支持
```sql
mysql> select @@have_dynamic_loading; # 结果中YES表示支持

+------------------------+
| @@have_dynamic_loading |
+------------------------+
| YES                    |
+------------------------+
1 row in set (0.00 sec)

```

* MySQL主/从安装半同步插件

```sql
mysql> INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
mysql> INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
mysql> SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS  WHERE PLUGIN_NAME LIKE '%semi%';
+----------------------+---------------+
| PLUGIN_NAME          | PLUGIN_STATUS |
+----------------------+---------------+
| rpl_semi_sync_master | ACTIVE        |
| rpl_semi_sync_slave  | ACTIVE        |
+----------------------+---------------+
2 rows in set (0.00 sec)

```

* 修改主/备数据库mysqld.cnf配置文件

```shell
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

在[mysqld]区域添加下列内容
```conf
# 半复制同步配置
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
rpl_semi_sync_slave_enabled=1
```


* 重启MySQL master服务
```
sudo service mysql restart
```


* 在master库上查看binlog信息

```sql
mysql> show master status; 

+-------------------+----------+--------------+------------------+-------------------+
| File              | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+-------------------+----------+--------------+------------------+-------------------+
| master-bin.000001 |      155 |              |                  |                   |
+-------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

```

* 在slave库上设置master信息
```sql
mysql> CHANGE MASTER TO  MASTER_HOST='192.168.124.110',MASTER_USER='root',MASTER_PASSWORD='123456',MASTER_LOG_FILE='master-bin.000001',MASTER_LOG_POS=155; # master-bin.000001和155是主库的binlog信息
```

* 重启MySQL slave服务
```shell
sudo service mysql restart
```

* 开启slave同步
```sql
mysql> start slave; # 启动slave同步，如果报错请看文章末尾FAQ
```

* MySQL查看半复制同步参数
```sql
mysql> show variables like '%rpl_semi%'; #查看半同步复制相关的参数

```

* MySQL查看半复制同步状态
```sql
mysql> show status like "%rpl_semi%";
```

## 2.7 启动MHA Manger

MHA提供了脚本测试服务是否能正常启动

* SSH检查
```shell
masterha_check_ssh --conf=/etc/masterha/app1.cnf
```

* REPLICATION检查
```shell
masterha_check_repl --conf=/etc/masterha/app1.cnf
```





# 3. 常见问题(FAQ)

## 3.1 MySQL主从复制，启动slave时，出现下面报错

```sql
mysql> start slave;
ERROR 1872 (HY000): Slave failed to initialize relay log info structure from the repository1
```

解决办法：
```sql
mysql> reset slave;
mysql> start slave;
mysql> show slave status\G; #查看slave状态(Slave_IO_Running和Slave_SQL_Running都是YES表示正常)

*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.124.110
                  Master_User: root
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: master-bin.000002
          Read_Master_Log_Pos: 155
               Relay_Log_File: slave-relay-bin.000004
                Relay_Log_Pos: 371
        Relay_Master_Log_File: master-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 155
              Relay_Log_Space: 1181
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 110
                  Master_UUID: c52699a7-1179-11ea-849d-0800274132d8
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
            Network_Namespace: 
1 row in set (0.00 sec)

```


## 3.2 同步复制健康检查脚本报错
```shell
root@ubuntu-db-slave01:~# masterha_check_repl --conf=/etc/masterha/app1.cnf
Thu Nov 28 19:54:05 2019 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Thu Nov 28 19:54:05 2019 - [info] Reading application default configurations from /etc/masterha/app1.cnf..
Thu Nov 28 19:54:05 2019 - [info] Reading server configurations from /etc/masterha/app1.cnf..
Thu Nov 28 19:54:05 2019 - [info] MHA::MasterMonitor version 0.55.
Thu Nov 28 19:54:06 2019 - [error][/usr/share/perl5/MHA/MasterMonitor.pm, ln386] Error happend on checking configurations. Redundant argument in sprintf at /usr/share/perl5/MHA/NodeUtil.pm line 190.
Thu Nov 28 19:54:06 2019 - [error][/usr/share/perl5/MHA/MasterMonitor.pm, ln482] Error happened on monitoring servers.
Thu Nov 28 19:54:06 2019 - [info] Got exit code 1 (Not master dead).
```
