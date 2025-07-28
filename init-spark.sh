#!/bin/bash

if [ "$SPARK_WORKLOAD" == "master" ]; then
    echo "starting spark master"
    spark-class org.apache.spark.deploy.master.Master

elif [ "$SPARK_WORKLOAD" == "worker" ]; then
    echo "starting spark worker"
    spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077

elif [ "$SPARK_WORKLOAD" == "history" ]; then
    echo "starting spark history server"
    mkdir -p /tmp/spark-events
    spark-class org.apache.spark.deploy.history.HistoryServer

else
    echo "Error: undefined SPARK_WORKLOAD: $SPARK_WORKLOAD"
    echo "Available options: master, worker, history"
    exit 1
fi
