k get po -A | grep -v Running | grep -v NAME | \
    awk '{print "kubectl delete po -n " $1 " " $2}' | zsh
