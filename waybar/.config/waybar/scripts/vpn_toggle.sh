#!/bin/bash

IFACE="ProtonVPN-72"

# Check if interface exists
if ip link show "$IFACE" &>/dev/null; then
    # Try to bring it down
    sudo wg-quick down "$IFACE"
else
    # Try to bring it up
    sudo wg-quick up "$IFACE"
fi

