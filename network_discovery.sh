#!/bin/bash

# Verifica se os parâmetros foram passados
if [ -z "$1" ]; then
    echo "Uso: $0 <rede> [timeout]"
    exit 1
fi

rede=$1
timeout=${2:-1}  # Se o timeout não for fornecido, usa o valor padrão de 1 segundo

for ip in {1..254}; do
    (
        ping -c 1 -W $timeout $rede.$ip > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$rede.$ip open"
        fi
    ) &
done

wait  # Aguarda todos os processos paralelos terminarem
