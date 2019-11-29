
# 1. Ubuntu18安装ProxySQL

ProxySQL监听6032和6033端口，其中6032是管理端口(内置迷你MySQL数据库)，6033是用户接入端口

ProxySQL更多版本下载地址见: https://github.com/sysown/proxysql/releases
ProxySQL配置参考资料：https://www.linuxidc.com/Linux/2019-05/158644.htm

* Ubuntu 18

```shell
ubuntu@ubuntu-db-master:~$ wget https://github.com/sysown/proxysql/releases/download/v2.0.8/proxysql_2.0.8-clickhouse-ubuntu18_amd64.deb # Ubuntu v18.04TLS
ubuntu@ubuntu-db-master:~$ sudo dpkg -i proxysql_2.0.8-clickhouse-ubuntu18_amd64.deb # 安装proxysql v2.0.x
ubuntu@ubuntu-db-master:~$ proxysql --version # 查看安装版本
ubuntu@ubuntu-db-master:~$ sudo service proxysql start # 启动 proxysql
```

* Ubuntu 16

```shell
ubuntu@ubuntu-db-master:~$ wget https://github.com/sysown/proxysql/releases/download/v2.0.8/proxysql_2.0.8-clickhouse-ubuntu16_amd64.deb # Ubuntu v16.04TLS
ubuntu@ubuntu-db-master:~$ sudo dpkg -i proxysql_2.0.8-clickhouse-ubuntu16_amd64.deb # 安装proxysql v2.0.x
ubuntu@ubuntu-db-master:~$ proxysql --version # 查看安装版本
ubuntu@ubuntu-db-master:~$ sudo service proxysql start # 启动 proxysql
```

# 2. 配置主从节点信息

* 使用命令行登录ProxySQL

```shell
ubuntu@ubuntu-db-master:~$ mysql -h127.0.0.1 -P6032 -uadmin -padmin --prompt='ProxySQL> ' # proxysql管理数据库登录
```

* 在ProxySQL会话中插入主从节点配置

```sql

ProxySQL> INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (10,'192.168.124.110',3306); # master节点  server_id=110
ProxySQL> INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (10,'192.168.124.111',3306); # slave01节点 server_id=111
ProxySQL> INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (10,'192.168.124.118',3306); # slave02节点 server_id=118
ProxySQL> SELECT * FROM mysql_servers;

+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
| hostgroup_id | hostname        | port | gtid_port | status | weight | compression | max_connections | max_replication_lag | use_ssl | max_latency_ms | comment |
+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
| 10           | 192.168.124.110 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
| 10           | 192.168.124.111 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
| 10           | 192.168.124.118 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
3 rows in set (0.00 sec)

```

* 在数据库master主机登录MySQL终端创建ProxySQL监控账号

```sql
mysql> set sql_log_bin=0; # 暂停logbin同步
mysql> CREATE USER 'monitor'@'%' IDENTIFIED WITH mysql_native_password BY '123456'; # 监控账户名monitor和密码123456根据环境重新设定
mysql> GRANT REPLICATION SLAVE ON *.* TO 'monitor'@'%'; 
mysql> flush privileges;
mysql> set sql_log_bin=1; # 开启logbin同步
```

* 在ProxySQL终端会话设置监控账户

```sql
ProxySQL> SET mysql-monitor_username='monitor'; # MySQL监控账户名
ProxySQL> SET mysql-monitor_password='123456';  # MySQL监控账户密码
ProxySQL> LOAD MYSQL VARIABLES TO RUNTIME; # 保存运行时参数
ProxySQL> SAVE MYSQL VARIABLES TO DISK;  # 存盘
ProxySQL> select * from mysql_server_connect_log; # 查看连接状态（出现连接拒绝错误表示可以连通）

+-----------------+------+------------------+-------------------------+--------------------------------------------------------------------------+
| hostname        | port | time_start_us    | connect_success_time_us | connect_error                                                            |
+-----------------+------+------------------+-------------------------+--------------------------------------------------------------------------+
| 192.168.124.110 | 3306 | 1575009898721349 | 0                       | Access denied for user 'monitor'@'192.168.124.110' (using password: YES) |
| 192.168.124.110 | 3306 | 1575009958722033 | 0                       | Access denied for user 'monitor'@'192.168.124.110' (using password: YES) |
| 192.168.124.110 | 3306 | 1575010018722310 | 0                       | Access denied for user 'monitor'@'192.168.124.110' (using password: YES) |
| 192.168.124.110 | 3306 | 1575010078722901 | 0                       | Access denied for user 'monitor'@'192.168.124.110' (using password: YES) |
| 192.168.124.110 | 3306 | 1575010134409861 | 1777                    | NULL                                                                     |
| 192.168.124.110 | 3306 | 1575010194409727 | 661                     | NULL                                                                     |
| 192.168.124.110 | 3306 | 1575010254409766 | 544                     | NULL                                                                     |
+-----------------+------+------------------+-------------------------+--------------------------------------------------------------------------+
7 rows in set (0.00 sec)

```

* 设置读写分离

```sql
ProxySQL> INSERT INTO mysql_replication_hostgroups VALUES(10, 20, "read_only", "");
ProxySQL> select * from mysql_replication_hostgroups;

+------------------+------------------+------------+---------+
| writer_hostgroup | reader_hostgroup | check_type | comment |
+------------------+------------------+------------+---------+
| 10               | 20               | read_only  |         |
+------------------+------------------+------------+---------+
1 row in set (0.00 sec)

ProxySQL> LOAD MYSQL SERVERS TO RUNTIME;
ProxySQL> SELECT * FROM mysql_servers; #查看服务器分组(hostgroup_id 10=读/写 20=只读)

+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
| hostgroup_id | hostname        | port | gtid_port | status | weight | compression | max_connections | max_replication_lag | use_ssl | max_latency_ms | comment |
+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
| 10           | 192.168.124.110 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
| 20           | 192.168.124.111 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
| 20           | 192.168.124.118 | 3306 | 0         | ONLINE | 1      | 0           | 1000            | 0                   | 0       | 0              |         |
+--------------+-----------------+------+-----------+--------+--------+-------------+-----------------+---------------------+---------+----------------+---------+
3 rows in set (0.00 sec)

ProxySQL> SAVE MYSQL SERVERS TO DISK; # 存盘
ProxySQL> INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ('root','123456',10); # 将客户端连接数据库的账户和密码写入ProxySQL表中
ProxySQL> SELECT username, password, active, use_ssl, default_hostgroup, transaction_persistent, max_connections FROM mysql_users; # 查看连接MySQL主/从库的用户信息

+----------+----------+--------+---------+-------------------+------------------------+-----------------+
| username | password | active | use_ssl | default_hostgroup | transaction_persistent | max_connections |
+----------+----------+--------+---------+-------------------+------------------------+-----------------+
| root     | 123456   | 1      | 0       | 10                | 1                      | 10000           |
+----------+----------+--------+---------+-------------------+------------------------+-----------------+
1 row in set (0.00 sec)

ProxySQL> load mysql users to runtime; # 保存到运行时参数表
ProxySQL> SAVE MYSQL USERS TO DISK; # 存盘
```

# 3. 测试ProxySQL代理

```shell
ubuntu@ubuntu-db-master:~$ mysql -uroot -p123456 -h192.168.124.110 -P6033 -e "SELECT @@server_id;" # 因未配置路由规则，默认全部转发给主节点(server_id=110)

mysql: [Warning] Using a password on the command line interface can be insecure.
+-------------+
| @@server_id |
+-------------+
|         110 |
+-------------+

```

# 4. 配置ProxySQL路由规则

```sql

ProxySQL> INSERT INTO mysql_query_rules(rule_id,active,match_digest,destination_hostgroup,apply) VALUES (1,1,'^SELECT.*FOR UPDATE$',10,1),(2,1,'^SELECT',20,1); # 配置读写路由规则
ProxySQL> SELECT * FROM mysql_query_rules\G; # 查看路由规则表
ProxySQL> LOAD MYSQL QUERY RULES TO RUNTIME; # 保存运行时参数
ProxySQL> SAVE MYSQL QUERY RULES TO DISK; # 存盘

************************** 1. row ***************************
              rule_id: 1
               active: 1
             username: NULL
           schemaname: NULL
               flagIN: 0
          client_addr: NULL
           proxy_addr: NULL
           proxy_port: NULL
               digest: NULL
         match_digest: ^SELECT.*FOR UPDATE$
        match_pattern: NULL
 negate_match_pattern: 0
         re_modifiers: CASELESS
              flagOUT: NULL
      replace_pattern: NULL
destination_hostgroup: 10
.
.
.
                apply: 1
              comment: NULL
*************************** 2. row ***************************
              rule_id: 2
               active: 1
             username: NULL
           schemaname: NULL
               flagIN: 0
          client_addr: NULL
           proxy_addr: NULL
           proxy_port: NULL
               digest: NULL
         match_digest: ^SELECT
        match_pattern: NULL
 negate_match_pattern: 0
         re_modifiers: CASELESS
              flagOUT: NULL
      replace_pattern: NULL
destination_hostgroup: 20
.
.
.
                  log: NULL
                apply: 1
              comment: NULL
2 rows in set (0.00 sec)

```



* 测试ProxySQL路由规则

测试读

```shell
ubuntu@ubuntu-db-master:~$ mysql -uroot -p123456 -h192.168.124.110 -P6033 -e "SELECT @@server_id;" # 已配置路由规则,SELECT语句会被路由到从节点(server_id=111或118)

mysql: [Warning] Using a password on the command line interface can be insecure.
+-------------+
| @@server_id |
+-------------+
|         111 |
+-------------+

```

测试写(返回server_id必须是master节点服务ID 110)

```shell
ubuntu@ubuntu-db-master:~$ mysql -uroot -p123456 -h192.168.124.110 -P6033 -e "BEGIN;INSERT INTO test.user(user_name, phone, create_time) VALUE('tester','18232552932','2019-11-29 15:50:50');SELECT @@server_id;commit;"

+-------------+
| @@server_id |
+-------------+
|         110 |
+-------------+


```
