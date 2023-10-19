#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Uso: $0 <intervalo_S> <diretorio>"
    exit 1
fi

intervalo=$1
diretorio=$2
file_log="dirSensors.log"

if [ ! -d "$diretorio" ]; then
    echo "Diretório não encontrado: $diretorio"
    exit 1
fi

if [ ! -f "$file_log" ]; then
    touch "$file_log"
fi

monitor_dir() {
    local data_atual
    local arq_antigos=()
    
    while true; do
        data_atual=$(date +"[%d-%m-%Y %H:%M:%S]")
        arq_actual=($(ls "$diretorio"))
        
        added=()
        removed=()
        
        for arquivo in "${arq_antigos[@]}"; do
            if [[ ! " ${arq_actual[@]} " =~ " $arquivo " ]]; then
                removed+=("$arquivo")
            fi
        done
        
        for arquivo in "${arq_actual[@]}"; do
            if [[ ! " ${arq_antigos[@]} " =~ " $arquivo " ]]; then
                added+=("$arquivo")
            fi
        done

        if [ "${#added[@]}" -gt 0 ]; then
            added_str=$(IFS=, ; echo "${added[*]}")
            echo "$data_atual Alteração! ${#arq_antigos[@]}->${#arq_actual[@]}. Adicionados: $added_str" >> "$file_log"
        fi

        if [ "${#removed[@]}" -gt 0 ]; then
            removed_str=$(IFS=, ; echo "${removed[*]}")
            echo "$data_atual Alteração! ${#arq_antigos[@]}->${#arq_actual[@]}. Removidos: $removed_str" >> "$file_log"
        fi

        arq_antigos=("${arq_actual[@]}")
        sleep $intervalo
    done
}

monitor_dir


------------------------------------------------------------------------------------------


#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Uso: $0 <intervalo_em_segundos> <diretorio>"
    exit 1
fi

intervalo=$1
diretorio=$2
log_file="dirSensors.log"

if [ ! -d "$diretorio" ]; then
    echo "Diretório não encontrado: $diretorio"
    exit 1
fi

if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi

# Função para verificar e registrar alterações no diretório
monitorar_diretorio() {
    local data_atual
    local arquivos_anteriores=()
    
    while true; do
        data_atual=$(date +"[%d-%m-%Y %H:%M:%S]")
        arquivos_atual=($(ls "$diretorio"))
        
        adicionados=()
        removidos=()
        
        for arquivo in "${arquivos_anteriores[@]}"; do
            if [[ ! " ${arquivos_atual[@]} " =~ " $arquivo " ]]; then
                removidos+=("$arquivo")
            fi
        done
        
        for arquivo in "${arquivos_atual[@]}"; do
            if [[ ! " ${arquivos_anteriores[@]} " =~ " $arquivo " ]]; then
                adicionados+=("$arquivo")
            fi
        done

        if [ "${#adicionados[@]}" -gt 0 ]; then
            adicionados_str=$(IFS=, ; echo "${adicionados[*]}")
            echo "$data_atual Alteração! ${#arquivos_anteriores[@]}->${#arquivos_atual[@]}. Adicionados: $adicionados_str" >> "$log_file"
        fi

        if [ "${#removidos[@]}" -gt 0 ]; then
            removidos_str=$(IFS=, ; echo "${removidos[*]}")
            echo "$data_atual Alteração! ${#arquivos_anteriores[@]}->${#arquivos_atual[@]}. Removidos: $removidos_str" >> "$log_file"
        fi

        arquivos_anteriores=("${arquivos_atual[@]}")
        sleep $intervalo
    done
}

monitorar_diretorio