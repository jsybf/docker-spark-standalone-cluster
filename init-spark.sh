#!/bin/bash

if [ "$SPARK_WORKLOAD" == "master" ]; then
    start-master.sh
    tail -f /dev/null

elif [ "$SPARK_WORKLOAD" == "worker" ]; then
    start-worker.sh spark://spark-master:7077
    tail -f /dev/null

elif [ "$SPARK_WORKLOAD" == "history" ]; then
    mkdir /tmp/spark-events
    start-history-server.sh
    tail -f /dev/null
else
    echo "undefined SPARK_WORKLOAD: $SPARK_WORKLOAD. available: master, worker, history"
fi
