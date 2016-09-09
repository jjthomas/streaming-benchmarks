#!/bin/bash

cd /Users/jamesthomas/streaming-benchmarks
echo "STOPPING KAFKA..."
./stream-bench.sh STOP_KAFKA
cd /Users/jamesthomas/streaming-benchmarks/kafka_2.10-0.8.2.1/bin 
echo "REMOVING TOPIC..."
./zookeeper-shell.sh localhost:2181 <<EOF
rmr /brokers/topics
quit
EOF
cd /Users/jamesthomas/streaming-benchmarks
echo "REPLACING PARTITION COUNT WITH $1..."
sed -i .bak 's/PARTITIONS:-[0-9]*/PARTITIONS:-'"$1"'/' stream-bench.sh
echo "STARTING KAFKA..."
./stream-bench.sh START_KAFKA
sleep 10
cd /Users/jamesthomas/spark 
echo "SEEDING KAFKA"
bin/run-example --driver-memory 6g sql.streaming.single.KafkaRedisTestFixed true 0 false false false false 8
echo "DONE!"


