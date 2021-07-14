if [ -z "$JAVA_HOME" ]; then
   error_exit "Please set the JAVA_HOME variable in your environment, We need java(x64)! jdk8 or later is better!"
fi
  export JAVA_HOME
  export JRE_HOME=${JAVA_HOME}/jre
  export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
  export SERVER_NAME="demo"
  export JAVA="$JAVA_HOME/bin/java"
  export BASE_DIR=`cd $(dirname $0)/.; pwd`
  export DEFAULT_SEARCH_LOCATIONS="classpath:/"
  export CUSTOM_SEARCH_LOCATIONS=${DEFAULT_SEARCH_LOCATIONS},file:${BASE_DIR}/conf/
    JAVA_OPT="-XX:-OmitStackTraceInFastThrow -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${BASE_DIR}/logs/java_heapdump.hprof"
    JAVA_OPT="${JAVA_OPT} -XX:-UseLargePages" JAVA_OPT="${JAVA_OPT} -jar ${BASE_DIR}/${SERVER_NAME}*.jar"
    JAVA_OPT="${JAVA_OPT} ${JAVA_OPT_EXT}"
    JAVA_OPT="${JAVA_OPT} --spring.config.location=${CUSTOM_SEARCH_LOCATIONS}"
if [ ! -d "${BASE_DIR}/logs" ]; then
mkdir ${BASE_DIR}/logs
fi
echo "$JAVA ${JAVA_OPT}"
if [ ! -f "${BASE_DIR}/logs/${SERVER_NAME}.out" ]; then
touch "${BASE_DIR}/logs/${SERVER_NAME}.out"
fi
echo "$JAVA ${JAVA_OPT}" > ${BASE_DIR}/logs/${SERVER_NAME}.out 2>&1 &nohup $JAVA ${JAVA_OPT} jingnan_web.jingnan_web >> ${BASE_DIR}/logs/${SERVER_NAME}.out 2>&1 &
echo "server is starting，you can check the ${BASE_DIR}/logs/${SERVER_NAME}.out"
sleep 10
pid=`ps ax | grep -i 'demo' | grep java | grep -v grep | awk '{print $1}'`
if [ -z "$pid" ] ; then
    echo "Start fail!."
else
    echo "Start successfully!."
fi
