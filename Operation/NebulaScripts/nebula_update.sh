#!/bin/bash
source /etc/profile
source ~/.bashrc

echo "GOPATH=$GOPATH"

DEPLOY_DIR="/root/nebula_deploy"
NEBULA_CHAT="$GOPATH/src/nebula.chat/enterprise"

cd $NEBULA_CHAT
git status
git pull

if [  $? -ne 0 ];then
            echo "git pull 失败"
            exit 1
        else
            echo "git pull 成功"
        fi

echo "update at time"

date

build_egate(){
	cd $NEBULA_CHAT/egate
	go build
	if [  $? -ne 0 ];then
	    echo "egate 编译失败"
	    exit 1   
	else
	    echo "egate 编译成功"
	fi
}

build_biz_server(){
	cd $NEBULA_CHAT/messenger/biz_server
	go build
        if [  $? -ne 0 ];then
            echo "biz_server 编译失败"
	    exit 1   
        else
            echo "biz_server 编译成功"
        fi
}

build_msg(){
	cd $NEBULA_CHAT/messenger/msg
	go build
        if [  $? -ne 0 ];then
            echo "msg 编译失败"
	    exit 1   
        else
            echo "msg 编译成功"
        fi
}

build_npns(){
	cd $NEBULA_CHAT/messenger/npns
	go build
        if [  $? -ne 0 ];then
            echo "npns 编译失败"
	    exit 1   
        else
            echo "npns 编译成功"
        fi
}

build_sync(){
	cd $NEBULA_CHAT/messenger/sync
	go build
        if [  $? -ne 0 ];then
            echo "sync 编译失败"
	    exit 1   
        else
            echo "sync 编译成功"
        fi
}

build_upload(){
	cd $NEBULA_CHAT/messenger/upload
	go build
        if [  $? -ne 0 ];then
            echo "upload 编译失败"
	    exit 1   
        else
            echo "upload 编译成功"
        fi
}

build_auth_session(){
	cd $NEBULA_CHAT/service/auth_session
	go build
        if [  $? -ne 0 ];then
            echo "auth_session 编译失败"
	    exit 1   
        else
            echo "auth_session 编译成功"
        fi
}

build_media(){
	cd $NEBULA_CHAT/service/media
	go build
        if [  $? -ne 0 ];then
            echo "media 编译失败"
	    exit 1   
        else
            echo "media 编译成功"
        fi
}

build_status(){
	cd $NEBULA_CHAT/service/status
	go build
        if [  $? -ne 0 ];then
            echo "status 编译失败"
	    exit 1   
        else
            echo "status 编译成功"
        fi
}

build_session(){
	cd $NEBULA_CHAT/session
	go build
        if [  $? -ne 0 ];then
            echo "session 编译失败"
	    exit 1   
        else
            echo "session 编译成功"
        fi
}

update_egate(){
cd $NEBULA_CHAT/egate
sudo supervisorctl stop egate
cp egate $DEPLOY_DIR/bin
}

update_biz_server(){
cd $NEBULA_CHAT/messenger/biz_server
sudo supervisorctl stop biz_server
cp biz_server $DEPLOY_DIR/bin
}

update_msg(){
cd $NEBULA_CHAT/messenger/msg
sudo supervisorctl stop msg
cp msg $DEPLOY_DIR/bin
}

update_npns(){
cd $NEBULA_CHAT/messenger/npns
sudo supervisorctl stop npns
cp npns $DEPLOY_DIR/bin
}

update_sync(){
cd $NEBULA_CHAT/messenger/sync
sudo supervisorctl stop sync
cp sync $DEPLOY_DIR/bin
}

update_upload(){
cd $NEBULA_CHAT/messenger/upload
sudo supervisorctl stop upload
cp upload $DEPLOY_DIR/bin
}

update_auth_session(){
cd $NEBULA_CHAT/service/auth_session
sudo supervisorctl stop auth_session
cp auth_session $DEPLOY_DIR/bin
}

update_media(){
cd $NEBULA_CHAT/service/media
sudo supervisorctl stop media
cp media $DEPLOY_DIR/bin
}

update_status(){
cd $NEBULA_CHAT/service/status
#sudo supervisorctl stop status
cp status $DEPLOY_DIR/bin
}

update_session(){
cd $NEBULA_CHAT/session
sudo supervisorctl stop session
cp session $DEPLOY_DIR/bin
}


if [ $# == 0 ];then
        build_egate
	build_biz_server
	build_session
	build_auth_session
	build_msg
	build_npns
	build_sync
	build_upload
	build_media
	build_status
	update_egate
	update_biz_server
	update_session
	update_auth_session
	update_msg
	update_npns
	update_sync
	update_upload
	update_media
	update_status
	sudo supervisorctl restart all
else
        for arg in $*                     
	do
         build_$arg
	 update_$arg
        done
	sudo supervisorctl start $*
fi

cd $DEPLOY_DIR
echo "----------------------------------------------------------------------"
sudo supervisorctl status
echo "----------------------------------------------------------------------"
