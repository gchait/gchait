seq 1 <n of brokers> | xargs -I {} wget \
  -q b-{}.<rest of broker fqdn>:<jmx exporter port>/metrics -O /dev/stdout | \
  grep kafka_consumer_group_ConsumerLagMetrics_Value | \
  grep -v "^#" | grep -Eo 'topic=".+",' | sort -u | \
  cut -d'"' -f2 | sort | uniq -c
