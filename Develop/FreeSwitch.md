* Ubuntu 18.04 LTS

```shell

# 安装依赖包
sudo apt-get install -y git-core subversion build-essential autoconf automake libtool libncurses5 libncurses5-dev make libjpeg-dev sqlite3 gcc-7 libtool zlib1g zlib1g-dev
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
```
