#!/bin/sh

ZOOKEEPER_HOME=/usr/share/zookeeper
PWD=`pwd`
cd ${ZOOKEEPER_HOME}/bin/
./zkServer.sh start
cd ${PWD}
