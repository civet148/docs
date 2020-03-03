#!/bin/sh

if [ $# -eq 0 ];then
  sudo supervisorctl start all 
else
  sudo supervisorctl start $* 
fi

echo "----------------------------------------------------------------------"
sudo supervisorctl status
echo "----------------------------------------------------------------------"

