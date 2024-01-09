# Useful when dealing with broken Kyverno + selection
kubectl get rs -A | awk '$3!=$4 || $4!=$5 {print $0}' | \
  grep -v NAMESPACE | awk '{print "kubectl delete rs -n " $1 " " $2}'| zsh