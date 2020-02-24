# Ubuntu18.04 科学上网

* ss服务端

```shell

sudo apt install python-pip
sudo apt-get install libsodium23 libsodium-dev
sudo pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U

# 后台启动ss服务
sudo ssserver -p 443 -k password -m aes-256-cfb --user nobody -d start

```


* Linux下全局代理ProxyChains

```shell

# 安装
sudo apt-get install -y proxychains

# 编辑配置文件
sudo vi /etc/proxychains.conf

```
