# what is this
docker spark cluster(standalone mode) scripts for educational purpose.

# versions
| Component | Version |
|-----------|---------|
| Apache Spark | 3.5.6 |
| Python | 3.12 |
| Java | 17 (Amazon Corretto) |

# components
  - master
    - web-ui: http://localhost:8080
    - spark_master_host: spark://localhost:7077
  - worker-a
  - worker-b
  - history-server
    - web-ui: http://localhost:18080

# quick start
build image
```bash
# gitp/spark-<spark_version>-<jvm_version>-<python_version>
docker build -t gitp/spark-3.5.6-17-3.12 .
```
create spark log directory for history server(in local)
```bash
mkdir /tmp/spark-events
```
launch cluster
```bash
docker compose up -d
```
submit spark-app
```bash
$SPARK_HOME/bin/spark-submit \
    --master spark://localhost:7077 \
    --conf spark.eventLog.enabled=true \
    --conf spark.eventLog.dir=file:/tmp/spark-events \
    <*.jar or *.py>
```
terminate cluster
```bash
docker compose down -v
```
