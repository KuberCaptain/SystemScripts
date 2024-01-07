#!/bin/bash

# Функция для получения информации о CPU и памяти
get_cpu_memory_info() {
    top -bn1 | head -5
}

# Функция для получения информации о дисковом пространстве
get_disk_info() {
    df -h | awk 'NR==1; /\/$/'
}

# Функция для получения информации о сети
get_network_info() {
    cat /proc/net/dev | awk '{if(NR>2) print $1,$2,$10}'
}

# Функция для получения последних сообщений ядра
get_kernel_logs() {
    dmesg | tail -5
}

# Основной цикл
while true; do
    clear
    echo "----- CPU и Память -----"
    get_cpu_memory_info

    echo ""
    echo "----- Дисковое Пространство -----"
    get_disk_info

    echo ""
    echo "----- Сетевая Информация -----"
    get_network_info

    echo ""
    echo "----- Ядро -----"
    get_kernel_logs

    # Обновление каждые 5 секунд
    sleep 5
done
