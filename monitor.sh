#!/bin/bash

# Функция для отображения сетевой статистики
network_stats() {
    echo "Сетевая статистика:"
    cat /proc/net/dev | awk '{if(NR>2) print $1,$2,$10}'
}

# Функция для отображения информации о процессах
process_stats() {
    echo "Информация о процессах:"
    ps -aux --sort=-%mem | head -5
    echo "Топ 5 процессов по использованию памяти"
    ps -aux --sort=-%cpu | head -5
    echo "Топ 5 процессов по использованию CPU"
}

# Функция для отображения информации о ресурсах системы
resource_stats() {
    echo "Информация о ресурсах системы:"
    echo "Память:"
    cat /proc/meminfo | grep -E 'MemTotal|MemFree|MemAvailable'
    echo "Загрузка CPU:"
    uptime
}

# Функция для отображения использования дискового пространства
disk_usage() {
    echo "Информация о дисковом пространстве:"
    df -h
    echo "Список дисков и разделов:"
    sudo fdisk -l
}

# Функция для отображения последних сообщений ядра
kernel_logs() {
    echo "Последние сообщения ядра:"
    dmesg | tail -20
}

# Основной цикл
while true; do
    echo "Выберите действие:"
    echo "1 - Сетевая статистика"
    echo "2 - Информация о процессах"
    echo "3 - Ресурсы системы"
    echo "4 - Информация о дисковом пространстве"
    echo "5 - Последние сообщения ядра"
    echo "0 - Выход"
    read -r -n 1 key

    case $key in
        '1')
            clear
            network_stats
            ;;
        '2')
            clear
            process_stats
            ;;
        '3')
            clear
            resource_stats
            ;;
        '4')
            clear
            disk_usage
            ;;
        '5')
            clear
            kernel_logs
            ;;
        '0')
            break
            ;;
        *)
            echo "Неверный выбор"
    esac
done

echo "Мониторинг завершен."
