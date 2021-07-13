# ----------------------------------------------------
# Start script for the Socekt Server
# ----------------------------------------------------
#!/bin/sh
ps -ef |grep demo.jar |grep -v grep
if [ $? -eq 0 ];then
  echo 'Socket server is running!'
else
    netstat -apn |grep 1024
    if [ $? -eq 0 ];then
         PID_1024 = $(echo `netstat -apn |grep 1024 | awk '{print $NF}'|awk -F '/' '{print $1}'`)
         kill  $PID_1024
    fi
    echo "startup socket server:"
    nohup java -jar demo.jar &
fi
