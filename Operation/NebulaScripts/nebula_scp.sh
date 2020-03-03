#!/bin/bash
source /etc/profile
source ~/.bashrc

DATETIME=`date "+%Y%m%d_%H%M%S"`
SRC_DEPLOY_DIR="/root/nebula_deploy"
SRC_DEPLOY_BIN=$SRC_DEPLOY_DIR/bin
DEST_DEPLOY_DIR="/root/nebula_deploy"
DEST_DEPLOY_BIN=$DEST_DEPLOY_DIR/bin

for arg in $*
  do
    scp $SRC_DEPLOY_BIN/$arg root@120.76.136.34:$DEST_DEPLOY_BIN/$arg.$DATETIME
done
