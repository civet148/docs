#!/bin/sh

if [ $# -eq 0 ];then
  sudo supervisorctl stop all 
else
  sudo supervisorctl stop $* 
fi

echo "----------------------------------------------------------------------"
sudo supervisorctl status
echo "----------------------------------------------------------------------"

