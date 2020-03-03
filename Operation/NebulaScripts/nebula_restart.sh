#!/bin/sh

if [ $# -eq 0 ];then
  sudo supervisorctl restart all 
else
  sudo supervisorctl restart $* 
fi

echo "----------------------------------------------------------------------"
sudo supervisorctl status
echo "----------------------------------------------------------------------"

