ll | grep -vE 'backend|frontend|run.sh|config|reqs.txt' | \
    awk '{print $NF}' | tail -n +2; echo '.*'
