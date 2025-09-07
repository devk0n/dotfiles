#!/bin/bash

# Get memory stats in kB from /proc/meminfo
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_FREE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_USED=$((MEM_TOTAL - MEM_FREE))

# Convert to GB
USED_GB=$(awk "BEGIN {printf \"%.1f\", $MEM_USED / 1024 / 1024}")
TOTAL_GB=$(awk "BEGIN {printf \"%.1f\", $MEM_TOTAL / 1024 / 1024}")
FREE_GB=$(awk "BEGIN {printf \"%.1f\", $MEM_FREE / 1024 / 1024}")

# Calculate percentage
PERCENT_USED=$(awk "BEGIN {printf \"%.0f\", 100 * $MEM_USED / $MEM_TOTAL}")

# Optional: Cache and Buffers
CACHED=$(grep ^Cached: /proc/meminfo | awk '{print $2}')
BUFFERS=$(grep ^Buffers: /proc/meminfo | awk '{print $2}')
CACHED_MB=$(awk "BEGIN {printf \"%.0f\", $CACHED / 1024}")
BUFFERS_MB=$(awk "BEGIN {printf \"%.0f\", $BUFFERS / 1024}")

# Tooltip
TOOLTIP=$(printf "Used: %s GB\nTotal: %s GB\nFree: %s GB\nUsed: %s%%\nCached: %s MB\nBuffers: %s MB" \
  "$USED_GB" "$TOTAL_GB" "$FREE_GB" "$PERCENT_USED" "$CACHED_MB" "$BUFFERS_MB")

# Color logic
COLOR="#ebdbb2"  # Normal
if [[ "$PERCENT_USED" -ge 90 ]]; then
  COLOR="#fb4934"  # Red
elif [[ "$PERCENT_USED" -ge 75 ]]; then
  COLOR="#fabd2f"  # Yellow
fi

# Output JSON
echo "{\"text\": \" ${USED_GB}G / ${TOTAL_GB}G\", \"tooltip\": \"${TOOLTIP//$'\n'/\\n}\", \"class\": \"memory-group\", \"percentage\": $PERCENT_USED, \"color\": \"$COLOR\"}"

