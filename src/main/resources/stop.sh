pid=`ps ax | grep -i 'demo' | grep java | grep -v grep | awk '{print $1}'`
if [ -z "$pid" ] ; then
    echo "No demoServer running."
else
    echo "The demoServer(${pid}) is running..." kill -9 ${pid}
    echo "Send shutdown request to demoServer(${pid}) OK"
fi
