# 安装MySQL8



## 1. 安装MySQL服务

```sh
$ sudo apt update && sudo apt install mysql-server
```

## 2. 检查安装后是否启动成功

```sh
$ ps -ef | grep mysqld
mysql    65492     1  0 17:46 ?        00:00:00 /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid
```

## 3. 修改MySQL监听地址和端口

```sh
$ sudo netstat -alnt | grep 3306
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN

# 编辑mysqld.cnf文件将bind-address对应的值由127.0.0.1改成0.0.0.0或局域网IP地址(端口视情况决定是否修改)
$ sudo vi mysql.conf.d/mysqld.cnf
$ sudo service mysql restart
```

## 5. 创建stos用户和权限

```sh
# MySQL安装完会在/etc/mysql目录下有一个debian.cnf文件可用于本地登录并修改root密码或创建用户
$ sudo cat /etc/mysql/debian.cnf 

[client]
host     = localhost
user     = debian-sys-maint
password = xgf1OdcBzRy0LaEP
socket   = /var/run/mysqld/mysqld.sock

# 本地登录MySQL，执行下面的命令行
$ mysql -udebian-sys-maint -pxgf1OdcBzRy0LaEP mysql

mysql> select host,user,plugin,authentication_string from user;
+-----------+------------------+-----------------------+-------------------------------------------+
| host      | user             | plugin                | authentication_string                     |
+-----------+------------------+-----------------------+-------------------------------------------+
| localhost | root             | auth_socket           |                                           |
| localhost | mysql.session    | mysql_native_password | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost | mysql.sys        | mysql_native_password | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost | debian-sys-maint | mysql_native_password | *22CC5F671040F19FF9FB1E5A9B94D2576C4A1A24 |
| %         | stos             | mysql_native_password | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 |
+-----------+------------------+-----------------------+-------------------------------------------+

4 rows in set (0.00 sec)

# 创建一个stos账户并允许远程登录, 密码是123456(生产环境请设置复杂密码)
mysql> create user 'stos'@'%' identified by '123456';
Query OK, 0 rows affected (0.00 sec)

# 赋予stos所有权限
mysql> grant all on *.*  to 'stos'@'%';
mysql> flush privileges;

# 修改root密码和口令加密方式并开启远程登录(视实际情况而定，如果无必要可以只修改密码不开启远程登录)
# host='%'表示开启远程访问，如果不开启就不要这个SQL字句
mysql> update user set plugin='mysql_native_password', host='%' where user='root';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

# 先将root原有密码清理一下
mysql> update user set authentication_string='' where user='root' and host='%';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

# 重置root账户登录密码并刷新权限
mysql> update user set authentication_string=PASSWORD('123456') where user='root';
mysql> flush privileges;

# 查看账户信息
mysql> select host,user,plugin,authentication_string from user;
+-----------+------------------+-----------------------+-------------------------------------------+
| host      | user             | plugin                | authentication_string                     |
+-----------+------------------+-----------------------+-------------------------------------------+
| %         | root             | mysql_native_password | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 |
| localhost | mysql.session    | mysql_native_password | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost | mysql.sys        | mysql_native_password | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost | debian-sys-maint | mysql_native_password | *22CC5F671040F19FF9FB1E5A9B94D2576C4A1A24 |
| %         | stos             | mysql_native_password | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 |
+-----------+------------------+-----------------------+-------------------------------------------+
5 rows in set (0.00 sec)

```

