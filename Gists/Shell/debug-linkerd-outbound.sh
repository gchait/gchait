k logs -n xxx yyy linkerd-proxy | grep -e unmeshed -e "timed out" -e WARN \
  | grep -Eo "outbound:proxy{addr=.+:.+}" | sed -E 's/:rescue{client.addr=.+:.+}//' \
  | sort -u | tee /dev/tty | grep -Eo "=.+:" | tr -d '=:' | xargs -I {} zsh -c "kubectl get po -A -o wide | grep {}"
