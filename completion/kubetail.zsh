#compdef kubetail kt=kubetail
_arguments "1: :($(kubectl get pods --no-headers | awk '{print $1}'))"
