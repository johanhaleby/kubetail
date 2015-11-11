#!/bin/bash

# Join function that supports a multi-character seperator (copied from http://stackoverflow.com/a/23673883/398441)
function join() {
    # $1 is return variable name
    # $2 is sep
    # $3... are the elements to join
    local retname=$1 sep=$2 ret=$3
    shift 3 || shift $(($#))
    printf -v "$retname" "%s" "$ret${@/#/$sep}"
}

# Get all pods matching the input and put them in an array. If no input then all pods are matched.
matching_pods=(`kubectl get pods --no-headers | grep "${1}" | sed 's/ .*//'`)
if [ ${#matching_pods[@]} -eq 0 ]; then
    echo "No pods exists that matches ${1}"
    exit 1
else
    echo "Will tail ${#matching_pods[@]} logs..."
fi

# Wrap all pod names in the "kubectl logs <name> -f" command
pod_logs_commands=()
for pod in ${matching_pods[@]}; 
do 
	pod_logs_commands+=("kubectl logs ${pod} -f"); 
done

# Join all log commands into one string seperated by " & "
join command_to_tail " & " "${pod_logs_commands[@]}"

# Aggreate all logs and print to stdout
cat <( eval "${command_to_tail}" ) | grep - --line-buffered