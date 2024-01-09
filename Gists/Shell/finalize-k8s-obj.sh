kubectl patch KIND -n NAMESPACE NAME -p '{"metadata":{"finalizers":[]}}' --type='merge'

# Many:
kubectl get flinkdeployment,flinksessionjob -n ${k8s_namespace} | \
    grep flink | awk '{print $1}' | xargs -I {} kubectl patch \
    -n ${k8s_namespace} {} -p '{"metadata":{"finalizers":[]}}' --type='merge' || true
