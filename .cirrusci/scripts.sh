#!/usr/bin/env bash

lscpu

java -version
mvn -version

echo "Delete ~/.m2/repository/org/apache/zeppelin"
rm -rf ~/.m2/repository/org/apache/zeppelin

echo "install application with some interpreter"
mvn install -Pbuild-distr -DskipRat -DskipTests -pl zeppelin-server,zeppelin-web,spark-submit,spark/spark-dependencies,markdown,angular,shell -am -Phelium-dev -Pexamples -Phadoop3 --batch-mode --no-transfer-progress --fail-never

echo "install application with some interpreter"
mvn install -Pbuild-distr -DskipRat -DskipTests -pl zeppelin-server,zeppelin-web,spark-submit,spark/spark-dependencies,markdown,angular,shell -am -Phelium-dev -Pexamples -Phadoop3 --batch-mode --no-transfer-progress --fail-never

echo "install and test plugins"
mvn package -DskipRat -pl zeppelin-plugins,-org.apache.zeppelin:notebookrepo-mongo -amd -B

echo "run tests with hadoop3"
mvn verify -Pusing-packaged-distr -DskipRat -pl zeppelin-server,zeppelin-web,spark-submit,spark/spark-dependencies,markdown,angular,shell -am -Phelium-dev -Pexamples -Phadoop3 -Dtests.to.exclude=**/org/apache/zeppelin/spark/* -DfailIfNoTests=false
