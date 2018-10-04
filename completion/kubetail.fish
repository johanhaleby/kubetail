# kubetail
complete -f -c kubetail -a "(kubectl get pods --no-headers | awk '{print \$1}')"
