#!/bin/bash

# Network statistics
network_stats() {
    echo "Сетевая статистика:"
    cat /proc/net/dev | awk '{if(NR>2) print $1,$2,$10}'
}

# Process
process_stats() {
    echo "Информация о процессах:"
    ps -aux --sort=-%mem | head -5
    echo "Топ 5 процессов по использованию памяти"
    ps -aux --sort=-%cpu | head -5
    echo "Топ 5 процессов по использованию CPU"
}

# Resource of system
resource_stats() {
    echo "info resourse:"
    echo "Memory:"
    cat /proc/meminfo | grep -E 'MemTotal|MemFree|MemAvailable'
    echo "Загрузка CPU:"
    uptime
}

# Disc vol
disk_usage() {
    echo "info about storage:"
    df -h
    echo "discs and vol:"
    sudo fdisk -l
}

# dmesg
kernel_logs() {
    echo "last 20 dmesg:"
    dmesg | tail -20
}

# main loop
while true; do
    echo "choose one:"
    echo "1 - Network statistics"
    echo "2 - info process"
    echo "3 - resource system"
    echo "4 - Disk and vol"
    echo "5 - Last mesages of kernel"
    echo "0 - Exit"
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
            echo "lololol"
    esac
done

echo "Bye."
