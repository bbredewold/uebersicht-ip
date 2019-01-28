#!/bin/bash

# Array of interfaces
interfaces=()

# Get WAN address
WAN=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null);
[[ -z $IP ]] && interfaces+=("{\"iface\":\"WAN\",\"address\":\"$WAN\"}")

# Get Local interfaces
while read line; do 
    # Interface name
    iname=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $2}')
    # Interface reference
    iface=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $4}')
	# If interface has a valid ref, check if it's active.
    if [ -n "$iface" ]; then
        ifconfig $iface 2>/dev/null | grep 'status: active' > /dev/null 2>&1
        # If exitcode is zero, get IP and add to interfaces array.
        if [ $? -eq 0 ]; then
            ip=$(ipconfig getifaddr $iface)
            interfaces+=("{\"iface\":\"$iname\",\"address\":\"$ip\"}")
        fi
    fi
done <<< "$(networksetup -listnetworkserviceorder | grep 'Hardware Port')"

# Output interfaces in JSON format
echo "{\"interfaces\":[$(printf '%s\n' $(IFS=,; echo "${interfaces[*]}"))]}"