#!/bin/bash

# Verify if parameters were passed
if [ -z "$1" ]; then
    echo "Usage: $0 <network> [timeout]"
    exit 1
fi

network=$1
timeout=${2:-1}  # If timeout is not provided, use the default value of 1 second

for ip in {1..254}; do
    (
        ping -c 1 -W $timeout $network.$ip > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$network.$ip"
        fi
    ) &
done

wait  # Wait for all parallel processes to finish
