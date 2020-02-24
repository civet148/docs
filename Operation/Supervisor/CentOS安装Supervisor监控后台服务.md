
# 1. 安装supervisor

```shell
 sudo yum install -y supervisor
```

# 2. 新建配置文件

* 在/etc/supervisord.d目录下新建文件nebula_chat.ini (ubuntu下是.conf后缀名)，将下面的配置内容拷贝到文件中保存退出

```shell
# sudo vi /etc/supervisord.d/nebula_chat.ini
```

```conf

[program:auth_session]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/auth_session
user=root
directory=/root/nebula_deploy/bin

[program:biz_server]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/biz_server
user=root
directory=/root/nebula_deploy/bin

[program:egate]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/egate
user=root
directory=/root/nebula_deploy/bin

[program:media]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/media
user=root
directory=/root/nebula_deploy/bin

[program:msg]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/msg
user=root
directory=/root/nebula_deploy/bin

[program:npns]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/npns
user=root
directory=/root/nebula_deploy/bin

[program:session]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/session
user=root
directory=/root/nebula_deploy/bin

[program:sync]
autorestart=True
autostart=True        
redirect_stderr=True  
command=/root/nebula_deploy/bin/sync
user=root
directory=/root/nebula_deploy/bin

```
# 3. 加载supervisor配置

```shell

# 重新加载配置
sudo supervisorctl reload

```

# 4. 启动/停止/重启supervisord

```shell

# 启动
sudo systemctl start supervisord

# 停止
sudo systemctl stop supervisord

# 重启
sudo systemctl restart supervisord

```


# 5. 启动/停止/重启应用，查看应用状态

* 提示：已打包成脚本文件方便操作(supervisor-scripts-138.tar.gz)

```shell

# 启动应用(启动指定应用时把all改成应用名称)
sudo supervisorctl start all

# 停止应用(停止指定应用时把all改成应用名称)
sudo supervisorctl stop all

# 重启应用(重启指定应用时把all改成应用名称)
sudo supervisorctl restart all

# 查看应用状态(查看指定应用时把all改成应用名称)
sudo supervisorctl status all

```


# 6. 脚本使用说明

## 6.1 start.sh 

启动应用，不添加参数表示启动所有应用，具体使用方式如下

```shell

# 启动所有应用
./start.sh

# 启动某个应用
./start.sh auth_session

# 启动多个应用
./start.sh auth_session biz_server npns

```

## 6.2 stop.sh

停止应用，使用方式跟start.sh保持一致

## 6.3 restart.sh 

重启应用，使用方式跟start.sh保持一致

## 6.4 status.sh 

查看应用状态，使用方式跟start.sh保持一致

## 6.5 update.sh

编译并更新指定文件到/root/nebula_deploy/bin目录，使用方式跟start.sh保持一致(脚本内部会自动停止服务并重启)

# 7. supervisord日志路径

所有监管的应用启动/停止/异常日志都在 /var/log/supervisor/supervisord.log 中