
```shell
# 抓取主机192.168.124.110 网卡 enp0s3 端口12345的网络包并保存到telegram.pcap文件(Ctrl+C终止抓包后写入文件)
sudo tcpdump -i enp0s3 -nn "host 192.168.124.110 and port 12345" -w telegram.pcap
```

