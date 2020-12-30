# 1. Grafana图形监控

Grafana是一个跨平台的开源的度量分析和可视化工具，可以通过将采集的数据查询然后可视化的展示，并及时通知。它主要有以下六大特点：

1、展示方式：快速灵活的客户端图表，面板插件有许多不同方式的可视化指标和日志，官方库中具有丰富的仪表盘插件，比如热图、折线图、图表等多种展示方式；

2、数据源：Graphite，InfluxDB，OpenTSDB，Prometheus，Elasticsearch，CloudWatch和KairosDB等；

3、通知提醒：以可视方式定义最重要指标的警报规则，Grafana将不断计算并发送通知，在数据达到阈值时通过Slack、PagerDuty等获得通知；

4、混合展示：在同一图表中混合使用不同的数据源，可以基于每个查询指定数据源，甚至自定义数据源；

5、注释：使用来自不同数据源的丰富事件注释图表，将鼠标悬停在事件上会显示完整的事件元数据和标记；

6、过滤器：Ad-hoc过滤器允许动态创建新的键/值过滤器，这些过滤器会自动应用于使用该数据源的所有查询。

# 2. FileCoin

## 2.1 主要概念

- 状态机（FileCoin State Machine）

```
FileCoin的状态机，主要是维护如下一些状态信息：支付情况，存储市场情况，各个节点的Power（算力）等等。
```

- 封装（Packing）

- 账户（Actor）

```
Filecoin网络中的Actor可以类比以太坊网络中的账户（一般账户或者智能合约账户）。每个Actor有自己的地址，余额，也可以维护自己的状态，同时Actor提供一些函数调用（也正是这些函数调用触发Actor的状态变化）。Filecoin的状态机，包括所有Actor的状态。Actor的状态，包括：账户信息（Balance），类型（Code），以及序号（Nonce）。
```

- 消息/交易（Message)

```
Filecoin网络中的区块是由一个个的Message组成。你可以把Message想象成以太坊的交易。一个Message由发起地址，目标地址，金额，调用的函数以及参数组成。所有Message的执行的结果就是状态机的全局状态。Filecoin网络的全局状态就是映射表：Actor的地址和Actor的状态/信息。以太坊的全局信息是通过leveldb数据库存储。Filecoin的全局状态是使用IPLD HAMT(Hash-Array Mapped Trie) 存储。
```

- FIL&AttoFIL

```
是Filecoin项目的代币。AttoFIL是FIL代币的最小单位，1 AttoFIL = 10^(-18) FIL
```

- GAS费用

```
和以太坊网络类似，执行Actor的函数需要消耗GAS。Actor的函数调用有两种方式：
  1. 用户发起签名后的Message（指定调用某个Actor的某个函数），并支付矿工Gas费用（类似以太坊的Gas费用）
  2. Actor之间调用。Actor之间调用也必须是用户发起
```

- 区块（Block & TipSet）

```
一个区块的信息主要包括：

1. 打包者的地址信息
2. 区块的高度/权重信息
3. 区块中包括的交易信息/更新后新的Root信息
4. Ticket信息以及Ticket的PoSt的证明信息

一个Tip，就是一个区块。一个TipSet，就是多个区块信息的集合，这些区块拥有同一个父亲区块。所谓的TipSet，就是一个区块的多个子区块
```

## 2.2 FileCoin挖矿主要阶段

- AP 添加(AddPiece)
- PreCommit1 简称PC1，磁盘写入要求高（耗CPU - AMD)  -  **超过8小时还未执行完可视为有问题**
- PreCommit2 简称PC2，磁盘读取要求高（耗GPU)
- Commit1 简称C1 很快，一般几十秒左右完成，基本无性能瓶颈
- Commit2 简称C2，一般30分钟~2小时左右完成(耗GPU)
- Verify/Fin
- Unseal

## 2.3 FileCoin集群运维

### 2.3.1 查看运行的容器

```shell
$ docker ps

CONTAINER ID   IMAGE                     COMMAND                  CREATED        STATUS        PORTS                                                                      NAMES
92da36cc9921   filestorer/lotus          "bash -c 'while true…"   33 hours ago   Up 33 hours   1234/tcp, 2345/tcp, 3456/tcp, 4567/tcp, 5678/tcp, 6789/tcp                 lotus-jobs
0e82508e2888   google/cadvisor:latest    "/usr/bin/cadvisor -…"   7 days ago     Up 7 days     0.0.0.0:8080->8080/tcp                                                     docker_monitor
2bd49eb13611   prom/node-exporter        "/bin/node_exporter"     7 days ago     Up 7 days                                                                                system_monitor
c1770d121703   filestorer/lotus:latest   "lotus-ctrl stats me…"   7 days ago     Up 18 hours   1234/tcp, 2345/tcp, 3456/tcp, 5678/tcp, 6789/tcp, 0.0.0.0:4567->4567/tcp   ops_lotus_1
6eb019ed3c98   grafana/grafana:6.5.0     "/run.sh"                7 days ago     Up 4 days     0.0.0.0:3000->3000/tcp                                                     ops_grafana_1
28a55b3c75e2   prom/prometheus:latest    "/bin/prometheus --c…"   7 days ago     Up 5 days     0.0.0.0:9090->9090/tcp                                                     ops_prometheus_1
```
### 2.3.1 容器日志跟踪

```shell
$ docker logs -f 92da36cc9921

Sun Dec 20 19:52:11 UTC 2020
ID        Sector  Worker    Hostname               Task  State    Time
9debe5b2  8254    dfdf1432  10.10.7.1-CPU2-PC1-4   PC1   running  3h52m16.3s
f71a5910  8404    a991fde9  10.10.7.1-CPU2-PC1-2   PC1   running  3h52m16.3s
afe2339f  7943    50ab26f8  10.10.7.2-CPU2-PC1-1   PC1   running  3h52m16.3s
0bee9e09  8298    33414e3d  10.10.7.1-CPU2-PC1-5   PC1   running  3h52m16.3s
88556ea8  8183    70a297f7  10.10.7.1-CPU2-PC1-6   PC1   running  3h52m16.3s
1e886f0e  7986    35323bd2  10.10.7.1-CPU2-PC1-3   PC1   running  3h52m16.3s
bd9b3ecf  8187    8c1b1d6c  10.10.7.2-CPU2-PC1-2   PC1   running  3h52m16.3s
54a1c530  8312    3651a408  10.10.7.2-CPU2-PC1-6   PC1   running  3h52m16.3s
64111938  8701    dbe93ef7  10.10.7.2-CPU2-PC1-5   PC1   running  3h52m16.3s
9cdaf776  8368    114d74cd  10.10.7.2-CPU2-PC1-4   PC1   running  3h52m16.3s
9ee1674f  8700    91d12225  10.10.7.1-CPU2-PC1-1   PC1   running  3h52m16.3s
cbb3b2f8  8240    1859eadf  10.10.7.2-CPU2-PC1-3   PC1   running  3h52m16.3s
695caa53  8870    adcfbbba  10.10.4.4-CPU2-PC1-2   PC1   running  2h59m48.4s
9d74b1ac  9028    9552e3b2  10.10.7.5-CPU2-PC1-5   PC1   running  2h51m0.8s
```

### 2.3.2 查看容器存储扇区

```shell
$ docker exec lotus-miner lotus-miner storage list

00ea4e79-895f-46e9-8f83-f1e48fa562cd:
        [###                                               ] 11.09 TiB/178.3 TiB 6%
        Unsealed: 0; Sealed: 348; Caches: 350; Reserved: 0 B
        Weight: 10; Use: Store
        Local: /data/10.10.13.1-data2
        URL: http://10.10.12.5:2345/remote
        URL: http://10.10.13.1:34562/remote

294a8922-a638-45e1-8ad6-6a9871ddf920:
        [####                                              ] 17.66 TiB/178.3 TiB 9%
        Unsealed: 0; Sealed: 555; Caches: 556; Reserved: 0 B
        Weight: 10; Use: Store
        Local: /data/10.10.12.1-data1
        URL: http://10.10.12.5:2345/remote
        URL: http://10.10.12.1:34561/remote
        
6647bba9-8b71-44a2-9857-389623054b35:
        [#####################                             ] 6.032 TiB/13.97 TiB 43%
        Unsealed: 30; Sealed: 14; Caches: 14; Reserved: 0 B
        Weight: 10; Use: Seal 
        URL: http://10.10.8.1:34561/remote (latency: 1.3ms)
        URL: http://10.10.8.1:34563/remote
        URL: http://10.10.8.1:34571/remote
        URL: http://10.10.8.1:34573/remote
        URL: http://10.10.8.1:34574/remote
        URL: http://10.10.8.1:34575/remote

674b4284-ff58-4ff9-acab-5565f7cf1132:
        [###                                               ] 979 GiB/13.97 TiB 6%
        Unsealed: 4; Sealed: 1; Caches: 1; Reserved: 0 B
        Weight: 10; Use: Seal 
        URL: http://10.10.5.3:34561/remote (latency: 2.9ms)
        URL: http://10.10.5.3:34563/remote
        URL: http://10.10.5.3:34571/remote
        URL: http://10.10.5.3:34573/remote
        URL: http://10.10.5.3:34574/remote
        URL: http://10.10.5.3:34575/remote
```



### 2.3.3 查看worker主机状态

```shell
$ docker exec lotus-miner lotus-miner sealing worker

```

 

### 2.3.4 查看worker任务状态

```shell
$ docker exec lotus-miner lotus-miner sealing jobs

```



### 2.3.5 查看扇区状态和日志

```shell
# 查看扇区7468状态
$ docker exec lotus-miner lotus-miner sectors status --log 7468

SectorID:       7468
Status:         FinalizeSector
CIDcommD:       baga6ea4seaqao7s73y24kcutaosvacpdjgfe5pw76ooefnyqw4ynr3d2y6x2mpq
CIDcommR:       bagboea4b5abcbr7qzf67onvswwtlcliuegyc7fn35cj6x356g7gq7pjofouejgc5
Ticket:         4764bc805c23ac07665f88b494180c397b19e1d2ff7e89a484d7ebe0f726f0e2
TicketH:        348281
Seed:           b77c7ee7d30b07c335f5724533522d6e3dc38bb59b757d818eb02fede422b86b
SeedH:          351583
Precommit:      bafy2bzaceb5d5d6lhbgmxwhhkw3sshc4zy64h2rv52bqzcx3d5k5xlubq3naw
Commit:         bafy2bzacednctgtf7flsnwnnxheqmpmoich6oqc4hy7fjgg3rvlqd3y4immks
Proof:          879cf0ae1cd169d1a160533b4986f667391844e72c358ac8310b900c57ebd7d05cb996c6aeb6c625c385da12934629e989f611759a190ba58e682ada9fb6fdbc70f84f73ca4b9169831b7d1d485eb0377dce898cb92261db3a55c588b202ac7e0454fb7f23addbd4621b670f22369e3781e032b552e9e7409da92796e1866bcd06d9222646d23a8ab71ca6096a3424bd95f5ea444eacdc72b4247c6b2e8884995782f54e1cc5afd3a472436508eb8d0f835eba9ab55b05dc6b72baaccc894a27ac1f779321f6588e53e73de45ae8057b55c17ee496dee4c0ec71ade942acc57b2a6be738a319ded7e894421c0908f970a7d914d2ae6b9a1689562f6bd012e3964eaf1a44d9bbf31d0248ae3d496756a9eddf3449fc4c4430de327e82ea232b010ca741cf99c7675eba038efb796402e78491bd081eafd7c254c1dea2453595ba73352de30958f80626a7ec21f021e20cad451cccfa2d7a4140f05ff08d88e6a5b0eee05ccfd8db7cb3c5f2f515dce9cd59c97f2071aadc6c14247e5f74ab9617b4957672d3942a5cb69cf8e15a8c98a24a5c1cd2ee472c7fc9a88bdb7bc30194097299da2b444c802eca332acac82e9cb4a3412746469cc55dd4ae67b4e8b75e93025f9f8127b053715770a82fb34eda0ec265cc6a79f0bcba7472b93c1d907006ff427428f20732634c82a7853e93b211e4704b55486adc959e4da40f469b929c3a068827bdab9cb25aa6aebdfca23bb534399f66b634161ca2b7293d669dd40723b076841c0316ea0461634334111e4c6bec4f45d12e760992eb6840656bf09083116a32aff86baa7e1ced5991ab3b8109062cf02917a67d5ac0472464e0553f27c056fe7aa2550b1b0d717e0c088dad6510404fa7067077644511130357fdde0297ed05b62e44d517704d6d992846adb57d89b1acd4466122edf04628cf1011918405a139741e7e79066441571167a47ebd8a4b68e626763786549351f48966021d8951143e2d1f48d7c54e4e62c9b7f6a23647bb46f29ae28b30b25eb4a6e76b90529313d35d93cff8b513eb2ec9a31d8fdc04b56d415782d53df79938fea673addfeebbee7e36e5f57a78dc831ef8d07a3ebe1b80dd57187e670c9e432f92045e6f965c7689dd4613be056a7fa2b52459e2cee7c56dfd5272292b763ca5fe6d68f1fc77bdd16591d58d2f4ac5b949e958ddbbbd7c4fa815b9fecceaa45a0fd469a4108517c570165b54d52339c9c230594048fbafbea8e1ebecd44114809a30dd2dbf4e2ab1da936676878e6c4091109c47958b2fd978ca41289174a28a843448b1b559dcc36f122d356d153abcfb809d7af33dc3c0eb907ed01a081aa8aaf4c85883dec6468e47a396707b568ae23c5b23ee665ed7215d5eb781af1fe688ae2c519bc1df8749f01ff9106e9dcbb89aff56f9c4e8294a72a429f3d4af4ac9c861071a53f0a5e29ce575cd1b9aaf2154f916e42c5e272f47eab2cb3bb365099a37947407943ed87810e899765e6a0a3978c0d8c63130680fa27ea44808b41d8745f2bf28f76de43ed69a85c23bd592a2308dd4664f429b56cb0eb308cd5bc9110b089b5834ca87b8c58aad09dfbe605b3fea5bc977cb0c24a48187ef5aee868994ba01d966917ac5b53a2bf1c08049196b1bb18e81da2458b8e8cb6982699d765434fb8676189288d91d808cf0e4acd44a328a61bf7d6ddee8de8714131fc21cb186dd3d37210ceb5ef35aea504cba5b88c57d58dd8760f13d617fd692b90bc0883438ef4021fe1025ace949e52107b5e03824591ef3993b8cbaba910d6931fd76fb402d623514270ef04acbf84596b9f4f0d754e3084e7070e8108bf01a23c1e8a23a1724d3fdb2afa271923f716a8a34908580a6beea834fd3fe9734e0ab105a83ef38285eef48b620ee818ffde215fc58bf41961cdada339d4c71ea2a28d1817a158002a61744a6f15830c2edb961fdde264f0d7cc1ffe3c736c5f15581296951b4983990f022f333356a8fbe52d8597a65cda9d17021b172947927170025552215e9d2d9eb33796655f5a52396c475b752dbd7cd8b0c9c4157ad367c7b25f4fa3e21c76148dbb0054f3179faa68e168523630f4517a7d3585f075c74e5d1ff49fce6ec7e3abb73b4d39603836b01c1373f3e1ea01768e412be3fee31b698f512c5c74206a92965813d018cd4d079a89a4bc3dd752a947516493095d4a4df95e9b8396c3e7395c69b10774f46abf605dc9985d143ce0556ab99a57378b3e708dd7a22cfb0c2f5b05b72c3fd97988dc2823a4ec9745d53b9d7dbe8ca7711bf60b29da35829cd16dcd3d45100fd9682021d0c6dcd73cd8d560e1339af8e2e6adeabbd0a1198eddf7e58f7d8c6afa19ffc1eabc483084585249dedfc947c2b5febc4775aaa572719257f3672e03a8f19d7cbd8836d16b8ffff0600a4275faf1cc394311fb8de2348cc621b6e988dbd62a00357915e9bf4ad9199d210a74598230a63a3cac3f03b5941e44bb29dc4a384a01f9951a2fba84375b630b5c396ac0642f38951f98e1cbc9458e6a001b591cdb31d89354c16292da87eb6ae9ee504a7f4029640f9738524b9bfa0d735ab179f00c7bf233a0afdc0e633b1b21a1fa0e1fb384cb906360cfb0e4f8cbd7c5bb1eeb6c6d01df6e9044919c0bb3e41bee0467da0eb23eb6f4c870e6b978ce74177788e21cc10257b6a37fe55d2f11861
Deals:          [0]
Retries:        0
--------
Event Log:
0.      2020-12-16 16:27:10 +0000 UTC:  [event;sealing.SectorStartCC]   {"User":{"ID":7468,"SectorType":8,"Pieces":[{"Piece":{"Size":34359738368,"PieceCID":{"/":"baga6ea4seaqao7s73y24kcutaosvacpdjgfe5pw76ooefnyqw4ynr3d2y6x2mpq"}},"DealInfo":null}]}}
1.      2020-12-16 16:27:10 +0000 UTC:  [event;sealing.SectorPacked]    {"User":{"FillerPieces":null}}
2.      2020-12-16 16:27:10 +0000 UTC:  [event;sealing.SectorTicket]    {"User":{"TicketValue":"wc8K/MPInelXqoLWGQfM3PQ7zETzIUFkqOv93DfZ0Ew=","TicketEpoch":326754}}
3.      2020-12-17 03:09:10 +0000 UTC:  [event;sealing.SectorRestart]   {"User":{}}
......
......
......
```



### 2.3.6 查看存储扇区详情

```shell
$ docker exec lotus-miner lotus-miner  storage find 7468
In c3fd9963-bfb9-486a-8e2d-1742576c72f8 (Sealed)
        Sealing: false; Storage: true
        Local (/data/10.10.13.4-data1)
        URL: http://10.10.12.5:2345/remote/sealed/s-t07749-7468
        URL: http://10.10.13.4:34561/remote/sealed/s-t07749-7468
In e82dfea2-cb4a-4b20-a267-c8516db52bca (Sealed)
        Sealing: false; Storage: true
        Local (/data/10.10.13.1-data1)
        URL: http://10.10.12.5:2345/remote/sealed/s-t07749-7468
        URL: http://10.10.13.1:34561/remote/sealed/s-t07749-7468
```



### 2.3.7 存储/缓存路径

- worker主机缓存路径

/data1/lotusworker/cache

 /data2/lotusworker/cache

- miner主机存储路径

挂载目录 /data

```shell
$ ll -h /data/10.10.13.1-data1/sealed
total 18T
drwxr-xr-x 3 root root 20K Dec 25 09:36 ./
drwxr-xr-x 7 root root 202 Dec 24 21:20 ../
drwxr-xr-x 2 root root   6 Dec 25 09:36 fetching/
-rw-r--r-- 1 root root 32G Dec 22 05:02 s-t07749-10009
-rw-r--r-- 1 root root 32G Dec 22 15:47 s-t07749-10018
-rw-r--r-- 1 root root 32G Dec 24 07:11 s-t07749-10026
-rw-r--r-- 1 root root 32G Dec 22 09:59 s-t07749-10031
-rw-r--r-- 1 root root 32G Dec 22 04:47 s-t07749-10039
-rw-r--r-- 1 root root 32G Dec 22 09:28 s-t07749-10051
-rw-r--r-- 1 root root 32G Dec 22 07:04 s-t07749-10057
-rw-r--r-- 1 root root 32G Dec 22 09:07 s-t07749-10060
-rw-r--r-- 1 root root 32G Dec 22 05:51 s-t07749-10066
```



### 2.3.8 查看时空证明失败扇区



```shell
$ docker exec lotus-miner lotus-miner proving faults
Miner: f07749
deadline  partition  sectors
3         0          12952
3         0          13057
4         0          13005
4         0          13007
4         0          13039
```



# 3. FileCoin扇区状态机

**Empty** - 空状态

**Packing** - 打包状态，多个 Piece 填充到一个 Sector 中

**PreCommit1** - PreCommit1 计算

**PreCommit2** - PreCommit2 计算

**PreCommitting** - 提交 Precommit2 的结果到链上

**WaitSeed** - 等待随机种子（给定 n个区块的时间，让随机数种子不可提前预测）

**Committing** - 计算 Commit1/Commit2，并将证明提交到链上

**CommitWait** - 等待链上确认 **FinalizeSector** - Sector 状态确定

**Proving** - 时空证明

```
				*   Empty <- incoming deals
				|   |
				|   v
			    *<- WaitDeals <- incoming deals
				|   |
				|   v
				*<- Packing <- incoming committed capacity
				|   |
				|   v
				|   GetTicket
				|   |   ^
				|   v   |
				*<- PreCommit1 <--> SealPreCommit1Failed
				|   |       ^          ^^
				|   |       *----------++----\
				|   v       v          ||    |
				*<- PreCommit2 --------++--> SealPreCommit2Failed
				|   |                  ||
				|   v          /-------/|
				*   PreCommitting <-----+---> PreCommitFailed
				|   |                   |     ^
				|   v                   |     |
				*<- WaitSeed -----------+-----/
				|   |||  ^              |
				|   |||  \--------*-----/
				|   |||           |
				|   vvv      v----+----> ComputeProofFailed
				*<- Committing    |
				|   |        ^--> CommitFailed
				|   v             ^
		        |   SubmitCommit  |
		        |   |             |
		        |   v             |
				*<- CommitWait ---/
				|   |
				|   v
				|   FinalizeSector <--> FinalizeFailed
				|   |
				|   v
				*<- Proving
				|
				v
				FailedUnrecoverable

				UndefinedSectorState <- ¯\_(ツ)_/¯
					|                     ^
					*---------------------/

```

# 4. Filecoin费用架构

**专有名词：**

**Gas Used** 每一笔交易实际消耗的 Gas 值。

**Gas Limit** 对一笔交易 Gas 消耗的预估限制值，意味着该交易可消耗的上限值。

**Base Fee** 即基础费，这个值由链上的交易拥堵情况决定，会根据实际网络状况上下波动，用户无法手动调节。Base Fee 越高代表区块利用率越高，也就是单个区块内包含的交易数据越多。

**Gas Premium** 即小费汇率值，在网络拥堵的情况下，可以通过支付小费，激励交易被尽快打包。

- **销毁超额燃油费。**Filecoin网络不支持用户支付过高的费用进行优选“插队”，所以在Filecoin网络中，超过基本费用+小费gas费的部分会被直接销毁，而ETH网络则会返还该部分；
- **三倍惩罚矿工的“不该打包交易”。**“不该打包交易”即是发出交易的人无法顺利支付矿工费，而矿工已完成打包交易，针对该部分Filecoin网络会针对矿工进行三倍该费用的惩罚。通过该措施，让矿工来监督“不该打包交易”，而这也是Filecoin网络独创的。
- **对于Filecoin网络，失败的交易也需要扣除失败费用。**



## 4.1 **超额燃油费（EstimateMessage Gas）**

我们都知道ETH中的 Gas Limit 可以设置的非常大，当过大的时候，ETH上多余的Gas费用会全数返还，但Filecoin 并不是这样。因为Filecoin的 Gas Limit 参与了 Base Fee 和 Gas Premium 的计算，Gas Limit参考真实转账情况变得尤为重要。如果一个交易，设置了不合理的 Gas Limit，Filecoin 采取了一种惩罚机制。对此Filecoin为gas设定了一个指标over，主要是为了避免使用过大的燃烧，其中Over=Gas Limit-(1.1*Gas Used)。

当Over＜0时，Gas Limit/Gas Used＜1.1，需要扣除手续费：（Gas Limit-Gas Used）*Base Fee。

当Over＞Gas Used时，Gas Limit/Gas Used＜2.1，Over=Gas Used，那么Base Fee为（（Gas Limit-Gas Used）*over）/Gas Used*Base Fee=（Gas Limit-Gas Used）*Base Fee。

当0≤Over≦Gas Used时，1.1≤Gas Limit/Gas Used≤2.1，基本费用计算公式为（（Gas Limit-Gas Used）*over）/Gas Used*Base Fee。

**由上可知1.1 ≤ Gas Limit/Gas Used) ≤ 2.1较为合理，即Over是1.1-2.1倍较为合理的**

总的来说，因为手续费过于高昂，直接导致矿工在一定程度上难以实现算力顺利增长。目前矿工可以选择在低gas费期间进行算力增长或者自行打包信息交易，但不适合长期发展。不过对于技术层面，三点可改进算法：

- 允许成批提交 PreCommitSector 消息，通过合并消息，减少Gas消耗；
- 增大Sector Size（挖矿设备可能会受影响）
- 提升Gas Limit和计算的上限（要求大家有更好的设备和网络）

- **lotus/chain/vm/burn.go**

```
// ComputeGasOverestimationBurn computes amount of gas to be refunded and amount of gas to be burned
// Result is (refund, burn)
func ComputeGasOverestimationBurn(gasUsed, gasLimit int64) (int64, int64) {
	if gasUsed == 0 {
		return 0, gasLimit
	}

	// over = gasLimit/gasUsed - 1 - 0.1
	// over = min(over, 1)
	// gasToBurn = (gasLimit - gasUsed) * over

	// so to factor out division from `over`
	// over*gasUsed = min(gasLimit - (11*gasUsed)/10, gasUsed)
	// gasToBurn = ((gasLimit - gasUsed)*over*gasUsed) / gasUsed
	over := gasLimit - (gasOveruseNum*gasUsed)/gasOveruseDenom
	if over < 0 {
		return gasLimit - gasUsed, 0
	}

	// if we want sharper scaling it goes here:
	// over *= 2

	if over > gasUsed {
		over = gasUsed
	}

	// needs bigint, as it overflows in pathological case gasLimit > 2^32 gasUsed = gasLimit / 2
	gasToBurn := big.NewInt(gasLimit - gasUsed)
	gasToBurn = big.Mul(gasToBurn, big.NewInt(over))
	gasToBurn = big.Div(gasToBurn, big.NewInt(gasUsed))

	return gasLimit - gasUsed - gasToBurn.Int64(), gasToBurn.Int64()
}
```



# 5. 编译官方代码

## 5.1 开发环境安装(私链)

编译**lotus+miner+worker**

- 英文官方资料

https://docs.filecoin.io/build/local-devnet/#devnet-with-vanilla-lotus-binaries

- ubuntu虚拟机软件安装

**需手动安装golang-v1.15.5以上版本并配置相关环境变量(~/.bashrc)**

```shell
# ~/.bashrc文件golang环境变量参考

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOROOT=/usr/local/go
export GOPATH=/home/lory/code
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```

```shell
### ubuntu使用apt安装依赖包(苹果Mac系统使用brew安装并且可能需要自行安装rust环境)
$ sudo apt update && sudo apt-get install -y curl ca-certificates llvm clang mesa-opencl-icd ocl-icd-opencl-dev jq hwloc libhwloc-dev
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ source $HOME/.cargo/env
$ mkdir -p $GOPATH/src/github.com/filecoin-project && cd $GOPATH/src/github.com/filecoin-project
$ git clone https://github.com/filecoin-project/lotus.git
```



- 配置开发环境变量(~/.bashrc)

```sh
# If you are building Lotus >= 0.7.1 and have an older Intel or AMD processor (MacOS)
export CGO_CFLAGS_ALLOW="-D__BLST_PORTABLE__"
export CGO_CFLAGS="-D__BLST_PORTABLE__"
# If you have a running installation of Lotus, make sure that configuration paths do not conflict by setting custom ones
export LOTUS_PATH=~/.lotusDevnet
export LOTUS_MINER_PATH=~/.lotusminerDevnet
export LOTUS_SKIP_GENESIS_CHECK=_yes_
```

```sh
$ source ~/.bashrc
$ cd $GOPATH/src/github.com/filecoin-project/lotus
$ make 2k
$ ./lotus fetch-params 204
$ ./lotus-seed pre-seal --sector-size 2KiB --num-sectors 2

# Create the genesis block and start up the first node
$ ./lotus-seed genesis new localnet.json
$ ./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json
$ ./lotus daemon --lotus-make-genesis=devgen.car --genesis-template=localnet.json --bootstrap=false

# Open a new console（打开一个新终端）
$ ./lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key
imported key t3qtptryovfcrlekc64oazk54pq7idvqvbjf5ubnsjnndic2sql4qqveauebbjobh2sofjoklue5c4xeo6cjha successfully!

# Set up the genesis miner
$ ./lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
# Set up miner 
$ ./lotus-miner run --nosync
```

# 6. 惩罚条件

- **共识攻击惩罚**

当一个节点在一个出块周期内发布两个或以上区块，且满足预期共识所定义的处罚条件时，任何其他节点都可以报告，网络通过检验属实后，会罚没涉嫌攻击网络的节点的所有抵押，并且扣除所有现有算力，因为对网络的攻击行为被视为不可接受的。这基本上是最严重的处罚了。

- **时空证明出错惩罚**

迟交时空证明：每一个节点需要在每一个证明周期（Proving Period）内提交证明，否则，就会被罚。这里所说的迟交，不是没交，而是提交时间超过了一个证明周期，但仍然在一个生成攻击阈值（Generation Attack Threshold，超过这个时间，则可能不能鉴别生成攻击）范围内提交了。在这种情况下，节点应当知晓自己未在规定的时间内提交证明，此时仍可按照常规提交时空证明（PoSt），但此时要主动附上迟交罚金。罚金的计算与延迟的时间长度相关，节点可以自行计算。

- **未提交时空证明**

如果一个节点不仅没有在一个证明周期内提交证明，而其延迟的时间甚至超过了生成攻击阈值。这种情况下，就被视为没有提交时空证明。在这种情况下，任何其他节点都可以报告这种情况，网络通过检查属实后，采取严厉的惩罚措施。目前计划的实现是：罚没所有质押物；算力清零。

- **违背合约惩罚**

如果一个节点未能按照合约在规定的时间内存储用户数据。比如用户要求存储半年，而节点存储3月就把数据删了。这种情况下，用户可以马上报告给网络，附上当初签订的合约，在网络确认属实（即节点在其证明中不再包含此数据所在扇区）后，将对节点进行处罚。处罚来自节点的承诺质押，同时用户的未支付费用将被返还，节点的相应存储质押将被自然地没收掉。

# 7. 惩罚细节

- 代码 

**github.com/filecoin-project/specs-actors/actors/builtin/miner/miner_actor.go**
|
|- **1753**行 **OnDeferredCronEvent** //定时器任务处理
|
|- **1868**行 **handleProvingDeadline** //处理PreCommt超时+时空证明deadline方法

## 7.1 PreCommit超时

## 7.2 持续WPoSt证明出错

## 7.3 未声明扇区出错

## 7.4 上报错误扇区

- 会比未上报要罚得少一些

## 7.5 提前终止扇区

- 数据丢失或硬盘挂了

## 7.6  共识机制错误

