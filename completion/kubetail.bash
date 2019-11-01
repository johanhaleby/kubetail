_findnamespace(){
    local next="0"
    local namespace="";
    for wo in "${COMP_WORDS[@]}"
    do
        if [ "$next" = "0" ]; then
            if [ "$wo" = "-n" ] || [ "$wo" = "--namespace" ]; then
                next="1"
            fi
        else
            namespace="$wo"
            break
        fi
    done
    if [ "$namespace" != "" ]; then
        printf "%s" " --namespace $namespace"
    else
        printf "%s" " --all-namespaces"
    fi
}

_findcontext(){
    local next="0"
    local context="";
    for wo in "${COMP_WORDS[@]}"
    do
        if [ "$next" = "0" ]; then
            if [ "$wo" = "-t" ] || [ "$wo" = "--context" ]; then
                next="1"
            fi
        else
            context="$wo"
            break
        fi
    done
    if [ "$context" != "" ]; then
        printf "%s" " --context=$context"
    fi
}

_kubetail()
{
    local curr_arg;
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    command=${COMP_WORDS[1]}
    case $prev in
        -t|--context)
            COMPREPLY=( $(compgen -W "$(kubectl config get-contexts -o=name | awk '{print $1}')" -- $curr_arg ) );
        ;;
        -n|--namespace)
            COMPREPLY=( $(compgen -W "$(kubectl $(_findcontext) get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}' | awk '{print $1}')" -- $curr_arg ) );
        ;;
        *)
            COMPREPLY=( $(compgen -W "$(kubectl $(_findcontext) get pods $(_findnamespace) -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}' --no-headers | awk '{print $1}')" -- $curr_arg ) );
        ;;
    esac
}

complete -F _kubetail kubetail kt
