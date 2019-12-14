go-callvis 是github上一个开源项目，可以用来查看golang代码调用关系。

* 安装graphviz

```shell
$ brew install graphviz
```

* 安装go-callvis

```shell
go get -u github.com/TrueFurby/go-callvis
cd $GOPATH/src/github.com/TrueFurby/go-callvis && make
```

* 用法

```shell
$ go-callvis [flags] package
```

* 示例
以orchestrator项目为例，其代码已经下载到本地。

```shell
$ go-callvis github.com/github/orchestrator/go/cmd/orchestrator
```

如果没有focus标识，默认是main。例如，查看github.com/github/orchestrator/go/http 这个package下面的调用关系：

```shell
$ go-callvis -focus github.com/github/orchestrator/go/http  github.com/github/orchestrator/go/cmd/orchestrator
```

————————————————
版权声明：本文为CSDN博主「Mr-Liuqx」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_34857250/article/details/100643339
