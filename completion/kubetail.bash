_kubetail()
{
  local curr_arg;
  curr_arg=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(kubectl get pods --no-headers | awk '{print $1}')" -- $curr_arg ) );
}

complete -F _kubetail kubetail kt

