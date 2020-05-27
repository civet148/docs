# 1. 注意事项

* 下载和安装证书所有操作均在需要配置的域名指向的服务器命令行下操作(root用户)

# 2. 环境说明

* 服务器名称
  
 闪聊测试服2 IP 39.108.125.199 域名 test2.longchat.cc

* 操作系统

 CentOS 5.7 

 # 3. 操作步骤

# 3.1 切换到root用户并安装git程序

```shell

# 切换root用户
[dev@iZwz99rw7qikaoz50ptb9uZ ~]# su - root 

# 安装git(如果已安装则跳过此步骤)
[root@iZwz99rw7qikaoz50ptb9uZ ~]# yum install git

# 查看git版本
[root@iZwz99rw7qikaoz50ptb9uZ ~]# git version
git version 1.8.3.1

```

# 3.2 下载letsencrypt源码

```shell
[root@iZwz99rw7qikaoz50ptb9uZ ~]# git clone https://github.com/letsencrypt/letsencrypt 
[root@iZwz99rw7qikaoz50ptb9uZ ~]# cd letsencrypt 
```

# 3.3 获取证书

* 注意事项

（1）执行此命令必须使用 root用户获得文件夹的权限

（2）域名能访问并且有绑定的公网IP

（3）必须在此域名绑定的服务器上通过命令行安装SSL证书

（4）会使用80端口，如果nginx监听80端口，把nginx或其他占用80端口的进程先关掉

 ```shell

# 下载证书，-d参数指定域名,可指定多个-d参数绑定多个域名
[root@iZwz99rw7qikaoz50ptb9uZ ~]# ./letsencrypt-auto certonly --standalone --email 93864947@qq.com -d test2.longchat.cc

# 上面的命令在执行过程中，会有两次确认(第一次输入A 第二次输入Y)。命令执行完成后，如果看到提示信息"Congratulations! Your certificate and chain..."就说明证书创建成功了
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server at
https://acme-v02.api.letsencrypt.org/directory
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(A)gree/(C)ancel: A

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing to share your email address with the Electronic Frontier
Foundation, a founding partner of the Let's Encrypt project and the non-profit
organization that develops Certbot? We'd like to send you email about our work
encrypting the web, EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for test2.longchat.cc
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/test2.longchat.cc/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/test2.longchat.cc/privkey.pem
   Your cert will expire on 2020-08-23. To obtain a new or tweaked
   version of this certificate in the future, simply run
   letsencrypt-auto again. To non-interactively renew *all* of your
   certificates, run "letsencrypt-auto renew"
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le


# 下载的证书放在/etc/letsencrypt/live/test2.longchat.cc目录下(证书实际存储目录为/etc/letsencrypt/archive)
[root@iZwz99rw7qikaoz50ptb9uZ letsencrypt]# ll /etc/letsencrypt/live/test2.longchat.cc/
total 4 
lrwxrwxrwx 1 root root  41 May 25 19:27 cert.pem -> ../../archive/test2.longchat.cc/cert1.pem
lrwxrwxrwx 1 root root  42 May 25 19:27 chain.pem -> ../../archive/test2.longchat.cc/chain1.pem
lrwxrwxrwx 1 root root  46 May 25 19:27 fullchain.pem -> ../../archive/test2.longchat.cc/fullchain1.pem
lrwxrwxrwx 1 root root  44 May 25 19:27 privkey.pem -> ../../archive/test2.longchat.cc/privkey1.pem

```

# 3.4 配置Nginx

*  注意

1. 国内域名未备案不能使用443端口作为SSL访问端口（因域名test2.longchat.cc未备案，HTTPS端口改为444端口）
2. 静态资源打包时必须以转发路径名作为路径前缀（例如 https://test2.longchat.cc/monitor 转发到 http://127.0.0.1:8080/ 时，静态资源/js/xxx.js要改成/monitor/js/xxx.js）

```nginx

server {
  listen 444 ssl; # 通过域名备案后可以改为443端口
  server_name test2.longchat.cc;
  #ssl on;

  ssl_certificate /etc/letsencrypt/live/test2.longchat.cc/fullchain.pem; #2
  ssl_certificate_key /etc/letsencrypt/live/test2.longchat.cc/privkey.pem; #3
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;

location / {
        root html;
        index index.html index.htm;
    }

location /monitor { # 数据转发到monitor监听的HTTP服务端口

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr; # 转发用户访问的真实IP
      proxy_set_header X-Forwarded-Proto https;
      proxy_read_timeout 3600s;
      proxy_redirect off;
      proxy_ssl_server_name on; #转发访问域名
      proxy_pass http://127.0.0.1:8080/;
 }
 
}

```

# 3.5 重启nginx服务

```shell
[root@iZwz99rw7qikaoz50ptb9uZ ~]# service nginx restart
```

# 3.6 测试HTTPS访问

打开浏览器，地址栏输入 https://test2.longchat.cc:444/monitor