# <exec into prometheus>
wget <broker_fqdn>:<jmx_exporter_port>/metrics -O /dev/stdout | grep -v "^#" | cut -d"{" -f1 | cut -d" " -f1 | sort -u