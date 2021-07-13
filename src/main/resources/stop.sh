jar_name=demo.jar
echo "Stopping" ${jar_name}
pid=`ps -ef | grep ${jar_name} | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
   echo "stop" ${jar_name} $pid
   kill -9 $pid
fi
