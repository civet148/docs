# 1. 安装kafka

```shell
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y zookeeperd
sudo systemctl status zookeeper # 查看ZK状态
sudo systemctl start zookeeper # 启动ZK
sudo systemctl enable zookeeper # 设置ZK开机自启动
sudo apt-get install -y net-tools # 安装网络工具包
sudo netstat -tulpen | grep 2181 # 查看ZK监听端口2181
wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.1/kafka_2.11-2.3.1.tgz # 下载kafka安装包
sudo mkdir -p /opt/Kafka # 创建kafka安装路径
sudo tar xvzf kafka_2.11-2.3.1.tgz -C /opt/Kafka # 解压kafka到安装路径
```

* ~/.bashrc文件添加环境变量

```conf
export KAFKA_HOME="/opt/Kafka/kafka_2.11-2.3.1"
export PATH="$PATH:$KAFKA_HOME/bin"
alias sudo='sudo env PATH=$PATH'
```

* 环境变量生效
```shell
source ~/.bashrc
```

* 启动Kafka

```shell
sudo kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
```

* 停止Kafka

```shell
sudo kafka-server-stop.sh
```