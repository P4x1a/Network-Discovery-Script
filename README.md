# Network Discovery Script

This script was developed to discover active hosts on a specific subnet by using the `ping` command to check connectivity with each IP address within the subnet.

## Description

The `network_discovery.sh` script automates the network discovery process by sending an ICMP packet to each IP address in the provided subnet, identifying which hosts are active. This can be useful for network administrators, pentesters, and anyone needing to map active devices on a network.

## Functionality

- **Active Hosts Discovery**: The script checks each IP address in the specified subnet to identify which hosts respond to ICMP packets.
- **Parallel Execution**: Performs checks in parallel to speed up the discovery process.
- **Clean Output**: Displays only the IPs of active hosts.

## Usage

### Prerequisites

- Unix/Linux operating system with bash shell installed.
- Execution permissions for the script.

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

The script will display the IP addresses of active hosts within the specified subnet.

## Code

```bash
#!/bin/bash

# Verify if parameters were passed
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
            echo "$network.$ip"
        fi
    ) &
done

wait  # Wait for all parallel processes to finish
```

## Final Considerations

This script is a simple yet powerful tool for network discovery. By using it, you can quickly identify active devices on your subnet and gather essential information for network administration and security.

Contributions and suggestions are welcome! Feel free to improve the script and share your ideas.
