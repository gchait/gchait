curl -sL registry.k8s.io/v2/xxxxx/yyyyy/tags/list | \
    jq | grep "XXX" | awk '{print $1}' | tr -d '",' | sort -h
