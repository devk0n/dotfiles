#!/bin/bash

TEMP=$(sensors 2>/dev/null | grep -m 1 'Tctl:' | awk '{print $2}' | sed 's/+//')
CPU_LINE=$(top -bn1 | grep '%Cpu')
USAGE=$(echo "$CPU_LINE" | awk '{print 100 - $8}')
USAGE_INT=${USAGE%%.*}
IDLE=$(echo "$CPU_LINE" | awk '{print $8}')
SYS=$(echo "$CPU_LINE" | awk '{print $4}')
USR=$(echo "$CPU_LINE" | awk '{print $2}')

TOOLTIP=$(printf "CPU Usage: %s%%\nTemp: %s\nUser: %s%%\nSystem: %s%%\nIdle: %s%%" "$USAGE_INT" "$TEMP" "$USR" "$SYS" "$IDLE")

# Output valid JSON with escaped newlines
echo "{\"text\": \"󰍛 ${USAGE_INT}%  $TEMP\", \"tooltip\": \"${TOOLTIP//$'\n'/\\n}\"}"

