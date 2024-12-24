# Network Discovery Script

This script was developed to discover active hosts on a specific subnet by using the `ping` command to check connectivity with each IP address within the subnet.

## Description

The `network_discovery.sh` script automates the network discovery process by sending an ICMP packet to each IP address in the provided subnet, identifying which hosts are active. This script is a powerful tool for network administrators, pentesters, and anyone needing to map active devices on a network.

## Features

- **Active Hosts Discovery**: Checks each IP address in the subnet to identify which hosts respond to ICMP packets.
- **Parallel Execution**: Performs checks in parallel to speed up the discovery process.
- **Clean Output**: Displays only the IPs of active hosts, along with the word "open".
- **IP Geolocation**: Utilizes the `ipinfo.io` API to provide the approximate location of active IPs.

## Usage

### Prerequisites

- Unix/Linux operating system with bash shell installed.
- Execution permissions for the script.
- Internet connection to install `curl` and `jq`, and to access the `ipinfo.io` API.

### Instructions

1. **Download the Script**: Download and save the script as `network_discovery.sh`.
2. **Make the Script Executable**:
    ```bash
    chmod +x network_discovery.sh
    ```
3. **Run the Script**:
    ```bash
    ./network_discovery.sh <network> [timeout]
    ```
    - `<network>`: The subnet you want to scan (e.g., `192.168.1`).
    - `[timeout]`: (Optional) Timeout for each `ping` (in seconds). The default value is 1 second.

### Example

To scan the `192.168.1.0/24` subnet with a 1-second timeout for each `ping`, run:
```bash
./network_discovery.sh 192.168.1 1
```

### Output

The script will display the IP addresses of active hosts within the specified subnet, followed by "open" and the approximate location (if available). Examples:

```
192.168.0.2 open - São Paulo, São Paulo, BR
192.168.0.10 open - Location unavailable

10.0.0.5 open - New York, New York, US
10.0.0.12 open - Location unavailable
```

## Code

```bash
#!/bin/bash

# Install curl and jq if they are not installed
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt-get update && sudo apt-get install curl -y
fi

if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    sudo apt-get update && sudo apt-get install jq -y
fi

# Check if parameters were passed
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
            ip_address="$network.$ip"
            response=$(curl -s "http://ipinfo.io/$ip_address/geo")
            if [ $? -eq 0 ] && [ -n "$response" ]; then
                location=$(echo "$response" | jq -r '.city, .region, .country | select(. != null)' | paste -sd ", " -)
                if [ -z "$location" ]; then
                    location="Location unavailable"
                fi
            else
                location="Failed to fetch location"
            fi
            echo "$ip_address open - $location"
        fi
    ) &
done

wait  # Wait for all parallel processes to finish
```

## Final Considerations

This script is a simple yet powerful tool for network discovery. By using it, you can quickly identify active devices on your subnet and obtain essential information for network administration and security.

### Future Improvements
This script was created as a personal challenge based on the lesson **Lesson 5 - Network Discovery Tool with Shell Script** and the knowledge acquired so far. In the future, I plan to evolve this script using `nmap` as I gain more knowledge about the tool.

Contributions and suggestions are welcome! Feel free to improve the script and share your ideas.
