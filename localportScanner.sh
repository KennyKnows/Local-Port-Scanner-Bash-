#!/bin/bash

#Save script to a file and make it executable using chmod +x [yourfilename.sh], and run with the target host and port range as arguments. 
#Example: ./[yourfilename.sh] 192.168.1.1 80-443
# Check if a target host and port range are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <target_host> <port_range>"
    echo "Example: $0 192.168.1.100 1-100"
    exit 1
fi

target_host="$1"
port_range="$2"

# Split the port range into start and end ports
IFS='-' read -r start_port end_port <<< "$port_range"

# Check if the end port is provided, or set it to the start port if not
if [ -z "$end_port" ]; then
    end_port="$start_port"
fi

# Perform the port scan
for ((port = start_port; port <= end_port; port++)); do
    nc -z -v -w1 "$target_host" "$port" 2>&1 | grep -E "succeeded|open" >/dev/null
    if [ $? -eq 0 ]; then
        echo "Port $port is open on $target_host"
    fi
done
