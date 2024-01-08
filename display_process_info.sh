#!/bin/bash

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
