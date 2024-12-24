#!/bin/bash

# Verifica se os parâmetros foram passados
if [ -z "$1" ]; then
    echo "Usage: $0 <network> [timeout]"
    exit 1
fi

# Instala curl e jq se não estiverem instalados
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt-get update && sudo apt-get install curl -y
fi

if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    sudo apt-get update && sudo apt-get install jq -y
fi

rede=$1
timeout=${2:-1}  # Se o timeout não for fornecido, usa o valor padrão de 1 segundo

for ip in {1..254}; do
    (
        ping -c 1 -W $timeout $rede.$ip > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ip_address="$rede.$ip"
            location=$(curl -s "http://ipinfo.io/$ip_address/geo" | jq -r '.city, .region, .country')
            echo "$ip_address open - $location"
        fi
    ) &
done

wait  # Aguarda todos os processos paralelos terminarem
