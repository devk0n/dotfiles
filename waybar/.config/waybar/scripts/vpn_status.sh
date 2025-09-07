#!/bin/bash

IFACE="ProtonVPN-72"
WG_OUTPUT=$(sudo /usr/bin/wg show "$IFACE" 2>/dev/null)

if ip link show "$IFACE" &>/dev/null && [ -n "$WG_OUTPUT" ]; then
    STATUS="VPN: Connected"

    ENDPOINT=$(echo "$WG_OUTPUT" | grep -m1 'endpoint:' | awk '{print $2}')
    
    # Extract both RX and TX from the same line
    TRANSFER_LINE=$(echo "$WG_OUTPUT" | grep -m1 'transfer:')
    RX=$(echo "$TRANSFER_LINE" | awk '{print $2 " " $3}')
    TX=$(echo "$TRANSFER_LINE" | awk '{print $5 " " $6}')

    echo "{\"text\": \"$STATUS\", \"tooltip\": \"Interface: $IFACE\nEndpoint: $ENDPOINT\nReceived: $RX\nSent: $TX\"}"
else
    echo "{\"text\": \"VPN: Disconnected\", \"tooltip\": \"Not connected to any VPN\"}"
fi

