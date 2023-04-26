#!/bin/bash

USE_SUDO=""

# Parse command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --use_sudo)
    USE_SUDO="sudo "
    shift
    ;;
    *)
    # unknown option
    echo "Unknown option: $key"
    exit 1
    ;;
esac
done

# Get namespace in Terminating state
NS=$($USE_SUDO kubectl get ns | grep Terminating | awk 'NR==1 {print $1}')

# Remove finalizers from namespace
$USE_SUDO kubectl get namespace "$NS" -o json | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" | $USE_SUDO kubectl replace --raw /api/v1/namespaces/$NS/finalize -f -
