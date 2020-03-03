#!/bin/sh

echo "----------------------------------------------------------------------"
if [ $# -eq 0 ];then
  sudo supervisorctl status all 
else
  sudo supervisorctl status $* 
fi
echo "----------------------------------------------------------------------"

