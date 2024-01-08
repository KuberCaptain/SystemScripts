#!/bin/bash

# including moduls
source config.sh
source process_monitor.sh
source cpu_monitor.sh
source memory_monitor.sh
source disk_monitor.sh
source network_monitor.sh
source utils.sh


# Function to display information about current processes
display_process_info() {
    # Fetch process information
    # -e for all processes
    # -o for custom format
    process_info=$(ps -e -o pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 10)

    echo "Current Processes (Top 10 by CPU Usage):"
    echo "PID  PPID  CMD  %CPU  %MEM"
    echo "$process_info"
}

# Function to track started and terminated processes (optional)
# This function is more complex, as Bash does not provide a direct way to track process changes in real time.
# However, a basic tracking mechanism can be implemented by storing process snapshots and comparing them.

# Global variables for process tracking
PREV_PROCESS_SNAPSHOT=""

track_processes() {
    # Get current snapshot of processes
    CURRENT_PROCESS_SNAPSHOT=$(ps -e -o pid --no-headers)

    # Compare with the previous snapshot
    if [ -n "$PREV_PROCESS_SNAPSHOT" ]; then
        echo "Process changes since last update:"
        echo "Started processes:"
        comm -13 <(echo "$PREV_PROCESS_SNAPSHOT") <(echo "$CURRENT_PROCESS_SNAPSHOT")

        echo "Terminated processes:"
        comm -23 <(echo "$PREV_PROCESS_SNAPSHOT") <(echo "$CURRENT_PROCESS_SNAPSHOT")
    fi

    # Update the process snapshot
    PREV_PROCESS_SNAPSHOT=$CURRENT_PROCESS_SNAPSHOT
}

# Execute functions if the script is called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    display_process_info
    track_processes
fi

# Функция для отображения общей информации о загрузке CPU
display_cpu_info() {
    # Получение информации о загрузке CPU из /proc/stat
    cpu_info=$(head -n 1 /proc/stat)

    # Извлечение данных о времени работы CPU
    read cpu user nice system idle iowait irq softirq steal guest guest_nice <<< $cpu_info

    # Расчет процентов использования
    total_prev_idle=$prev_idle
    total_prev_total=$prev_total

    idle=$((idle + iowait))
    non_idle=$((user + nice + system + irq + softirq + steal))

    total=$((idle + non_idle))

    # Вычисление разницы во времени
    totald=$((total - total_prev_total))
    idled=$((idle - total_prev_idle))

    # Расчет процентной загрузки CPU
    cpu_percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")

    # Обновление предыдущих значений
    prev_idle=$idle
    prev_total=$total

    # Вывод информации
    echo "CPU Usage: $cpu_percentage%"
}

# Инициализация переменных для расчета загрузки CPU
prev_idle=0
prev_total=0

# При вызове этого скрипта напрямую, выводим информацию о CPU
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    display_cpu_info
fi

# Function to display memory usage information
display_memory_info() {
    # Fetching memory usage data from /proc/meminfo
    mem_info=$(< /proc/meminfo)

    # Extracting information about total and free memory
    read mem_total total_amount <<< $(grep MemTotal /proc/meminfo)
    read mem_free free_amount <<< $(grep MemFree /proc/meminfo)
    read mem_available available_amount <<< $(grep MemAvailable /proc/meminfo)

    # Converting from kB to MB for easier interpretation
    total_mb=$((total_amount / 1024))
    free_mb=$((free_amount / 1024))
    available_mb=$((available_amount / 1024))

    # Calculating used memory
    used_mb=$((total_mb - free_mb))

    # Displaying the information
    echo "Memory Usage:"
    echo "Total Memory: $total_mb MB"
    echo "Used Memory: $used_mb MB"
    echo "Free Memory: $free_mb MB"
    echo "Available Memory: $available_mb MB"
}

# When this script is directly executed, display memory information
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    display_memory_info
fi



# function for monitor
update_display() {
    process_info=$(display_process_info)
    cpu_info=$(display_cpu_info)
    memory_info=$(display_memory_info)
    disk_info=$(display_disk_info)
    network_info=$(display_network_info)

    zenity --info --title="system monitor" --width=500 --height=400 \
           --text="Date and time: $(date)\n\nProcess:\n$process_info\n\nCPU:\n$cpu_info\n\nMemory:\n$memory_info\n\nДDisc:\n$disk_info\n\nNet:\n$network_info"
}

# main loop
while true; do
    update_display
    sleep $REFRESH_INTERVAL
done
