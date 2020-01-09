# Ubuntu 18 Linux编译环境

```shell
# protobuf编译下载依赖包
go get github.com/gogo/protobuf/protoc-gen-gogo
go get github.com/gogo/protobuf/proto
go get github.com/gogo/protobuf/gogoproto 

vi ~/.bashrc # 编辑 ~/.bashrc文件，把 $GOPATH/bin路径添加到PATH环境变量(确保能正确找到protoc-gen-gogo可执行文件)
source ~/.bashrc

# 创建编译指定路径并将gogo文件夹拷贝到该目录下
mkdir -p $GOPATH/src/nebula.chat/vendor/github.com
cp -r $GOPATH/src/github.com/gogo $GOPATH/src/nebula.chat/vendor/github.com
cd $GOPATH/pkg/mod/nebula.chat/enterprise/mtproto

# 转换build2.sh脚本为UNIX格式
dos2unix build2.sh
sudo chmod +x build2.sh
./build2.sh
```
