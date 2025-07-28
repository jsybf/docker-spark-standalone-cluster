ARG SPARK_VERSION=3.5.6
ARG PYTHON_VERSION=3.12

# separate stage to prevent build cache invalidation when other dependencies change
FROM alpine:latest AS spark-downloader
ARG SPARK_VERSION
RUN apk add --no-cache curl tar \
    && curl -L -o spark.tgz "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz" \
    && mkdir -p /opt/spark \
    && tar -xf spark.tgz -C /opt/spark --strip-components=1 \
    && rm spark.tgz

FROM python:${PYTHON_VERSION}

# install java17
RUN curl -L -o /tmp/amazon-corretto-17.tar.gz "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz" \
    && mkdir -p /opt/java \
    && tar -xzf /tmp/amazon-corretto-17.tar.gz -C /opt/java \
    && rm /tmp/amazon-corretto-17.tar.gz

# Copy Spark from the previous stage
COPY --from=spark-downloader /opt/spark /opt/spark

# set ENV
ENV JAVA_HOME=/opt/java/amazon-corretto-17.0.16.8.1-linux-x64
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"
ENV PYSPRK_PYTHON=/usr/local/bin/python3
COPY init-spark.sh /

ENTRYPOINT ["/bin/bash", "/init-spark.sh"]
