
# CentOS 安装FusionPBX

```shell
su root
yum install -y wget

wget -O - https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/centos/pre-install.sh | sh

cd /usr/src/fusionpbx-install.sh/centos && ./install.sh
```

# Ubuntu 18.04 LTS安装手册

注意: Ubuntu 16.04 LTS版本安装以下方式均失败，请使用18.04版本

非Ubuntu系统安装脚本参考官网 https://www.fusionpbx.com/download.php

## 1. FusionPBX管理工具下载并安装FreeSwitch(推荐方式)

* 提醒

安装完成后会自动开启iptables防火墙，后续请自行停止防火墙或添加路由规则

* 参考资料

安装步骤（仅供参考） https://docs.fusionpbx.com/en/latest/getting_started/quick_install.html

```shell

# 切换root用户
su - root

# 下载并执行安装脚本
apt-get install -y wget
wget -O - https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/ubuntu/pre-install.sh | sh;

# 进入下载目录并安装
cd /usr/src/fusionpbx-install.sh/ubuntu && ./install.sh
```

* 关闭防火墙

```shell

# 切换root用户
su root

# 查看防火墙状态
ufw status

# 关闭防火墙
ufw disable

# 更改iptables规则
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables-save > /etc/iptables/rules.v4
```


* 登录FusionPBX浏览器监控

FusionPBX安装完成会输出链接URL和登录账号

```shell
domain name: https://192.168.124.110
username: admin
password: M7NFLfsSyI9uMl912oBYL2FYptE
```

* 启动/停止/重启FreeSwitch

```shell
# 启动
sudo service freeswitch start
# 停止
sudo service freeswitch stop
# 重启
sudo service freeswitch restart
```

* FreeSwitch文件路径

执行文件: /usr/bin
启动配置: /etc/default/freeswitch
配置文件: /etc/freeswitch
进程ID文件: /run/freeswitch
日志文件: /var/log/freeswitch
库文件: /var/lib/freeswitch
其他文件：/usr/share/freeswitch

* FusionPBX文件路径
部署文件路径: /var/www/fusionpbx
Nginx配置:/etc/nginx/sites-available/fusionpbx

## 2. 手动编译安装模式(不推荐)

* freeswitch编译

```shell

# 安装依赖包()
sudo apt-get update
sudo apt-get install -y git-core subversion build-essential autoconf automake libtool libncurses5 libncurses5-dev make libjpeg-dev sqlite3 gcc libtool zlib1g zlib1g-dev
sudo apt-get install -y libcurl4-openssl-dev libexpat1-dev libgnutls28-dev libtiff-dev libx11-dev unixodbc-dev libssl-dev python2.7-dev \
                       zlib1g-dev libbzrtp-dev libasound2-dev libogg-dev libvorbis-dev libperl-dev libgdbm-dev libdb-dev python-dev \
                       uuid-dev cmake
sudo apt-get install -y pkg-config*
sudo apt-get install -y nasm libsqlite3-dev libcurl4-openssl-dev libspeex-dev libspeexdsp-dev libldns-dev libedit-dev libtiff-dev libavformat-dev libswscale-dev \
                        libopus-dev liblua5.2-dev libpq-dev libksba-dev uuid libsndfile-dev
sudo ln -s /usr/include/lua5.2/lua.h /usr/include/lua.h

mkdir ~/src

# 下载并编译安装libks(必须先于signalwire-c安装)
cd ~/src
git clone https://github.com/signalwire/libks.git
cd libks
cmake .
make
sudo make install

# 下载并编译安装signalwire-c
cd ~/src
git clone https://github.com/signalwire/signalwire-c.git
cd signalwire-c
cmake .
make
sudo make install

# 下载freeswitch代码编译
cd ~/src
git clone https://github.com/signalwire/freeswitch.git
./bootstrap.sh
./configure
make
sudo make install
sudo make uhd-sounds-install
sudo make uhd-moh-install
sudo make samples

# 添加freeswitch可执行PATH路径
sudo vi /etc/profile

export PATH=$PATH:/usr/local/freeswitch/bin

source /etc/profile

# 启动freeswitch
freeswitch

```

* 声音资源下载

如果sudo make uhd-sounds-install和sudo make uhd-moh-install执行失败考虑手动下载

https://files.freeswitch.org/releases/sounds

music/sound类型声音文件下载后解压到 /usr/local/freeswitch/sounds

```shell

# 案例
cd /usr/local/freeswitch/sounds
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-cn-sinmei-8000-1.0.51.tar.gz
tar xvfz freeswitch-sounds-zh-cn-sinmei-8000-1.0.51.tar.gz

# 所有下载资源链接
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-ca-june-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-ca-june-16000-1.0.51.tar.gz	
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-ca-june-32000-1.0.51.tar.gz	
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-ca-june-48000-1.0.51.tar.gz		
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-allison-8000-1.0.1.tar.gz	
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-allison-16000-1.0.1.tar.gz		
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-allison-32000-1.0.1.tar.gz		
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-allison-48000-1.0.1.tar.gz	
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-callie-8000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-callie-16000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-callie-32000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-callie-48000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-es-ar-mario-8000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-es-ar-mario-16000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-es-ar-mario-32000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-es-ar-mario-48000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-es-mx-maria-44100.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-fr-ca-june-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-fr-ca-june-16000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-fr-ca-june-32000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-fr-ca-june-48000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-music-8000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-music-16000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-music-32000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-music-48000-1.0.52.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pl-pl-espeak-8000-0.1.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pl-pl-espeak-16000-0.1.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pt-BR-karina-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pt-BR-karina-16000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pt-BR-karina-32000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-pt-BR-karina-48000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-16000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-32000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-48000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-kirill-8000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-kirill-16000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-kirill-32000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-kirill-48000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-vika-8000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-vika-16000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-vika-32000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-vika-48000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-sv-se-jakob-8000-1.0.0.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-sv-se-jakob-8000-1.0.50.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-sv-se-jakob-16000-1.0.50.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-sv-se-jakob-32000-1.0.50.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-sv-se-jakob-48000-1.0.50.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-cn-sinmei-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-cn-sinmei-16000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-cn-sinmei-32000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-cn-sinmei-48000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-hk-sinmei-8000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-hk-sinmei-16000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-hk-sinmei-32000-1.0.51.tar.gz
wget https://files.freeswitch.org/releases/sounds/freeswitch-sounds-zh-hk-sinmei-48000-1.0.51.tar.gz

```

# 2.1 启动和停止FreeSwitch

* 添加环境变量 

```shell

# 编辑环境变量文件
vi ~/.bashrc

# .bashrc文件末尾添加下面一行:x保存退出
export PATH=$PATH:/usr/local/freeswitch/bin

# 环境变量生效
source ~/.bashrc
```

* 启动

```shell
su root
freeswitch -nc
```

* 停止

```shell
su root
freeswitch -stop
```

# 注册RelaySDK project id和token

golang开发需注册project id和token（需翻墙），官网 https://signalwire.com/signin

SPACE URL: civet148.signalwire.com
PROJECT ID: 3e2c1130-9f7a-454b-9e35-1540e280d5bc
TOKEN NAME: voipchat-token 
TOKEN: PTb739db3488953bfd970d066f7e206f78aea302a89eff151f
