#!/bin/bash

# Get junction temperature
TEMP_RAW=$(sensors 2>/dev/null | grep -m 1 'junction:' | awk '{print $2}' | sed 's/+//')
TEMP_VAL=$(printf "%.0f" "$(echo "$TEMP_RAW" | sed 's/[^0-9.]//g')")

# Get radeontop output
RADEON_RAW=$(radeontop -d - -l 1)

# Extract fields
USAGE=$(echo "$RADEON_RAW" | grep -oP 'gpu \K[0-9.]+' | head -n 1)
VRAM_USED=$(echo "$RADEON_RAW" | grep -oP 'vram \K[0-9.]+' | head -n 1)
VRAM_MB=$(echo "$RADEON_RAW" | grep -oP 'vram [^%]*% \K[0-9.]+' | head -n 1)
GTT_USED=$(echo "$RADEON_RAW" | grep -oP 'gtt \K[0-9.]+' | head -n 1)
GTT_MB=$(echo "$RADEON_RAW" | grep -oP 'gtt [^%]*% \K[0-9.]+' | head -n 1)
SCLK=$(echo "$RADEON_RAW" | grep -oP 'sclk \K[0-9.]+' | head -n 1)
MCLK=$(echo "$RADEON_RAW" | grep -oP 'mclk \K[0-9.]+' | head -n 1)
SMX=$(echo "$RADEON_RAW" | grep -oP 'smx \K[0-9.]+' | head -n 1)
DB=$(echo "$RADEON_RAW" | grep -oP 'db \K[0-9.]+' | head -n 1)
CB=$(echo "$RADEON_RAW" | grep -oP 'cb \K[0-9.]+' | head -n 1)

# Fallbacks
USAGE=${USAGE:-"--"}
TEMP_RAW=${TEMP_RAW:-"??.°C"}
VRAM_USED=${VRAM_USED:-"--"}
VRAM_MB=${VRAM_MB:-"--"}
GTT_USED=${GTT_USED:-"--"}
GTT_MB=${GTT_MB:-"--"}
SCLK=${SCLK:-"--"}
MCLK=${MCLK:-"--"}
SMX=${SMX:-"--"}
DB=${DB:-"--"}
CB=${CB:-"--"}

# Tooltip (escaped newlines)
TOOLTIP=$(printf "GPU Usage: %s%%\nTemp: %s\nVRAM: %s%% (%sMB)\nGTT: %s%% (%sMB)\nCore Clock: %s%%\nMemory Clock: %s%%\nSMX: %s%%\nDepth Buffer: %s%%\nColor Buffer: %s%%" \
  "$USAGE" "$TEMP_RAW" "$VRAM_USED" "$VRAM_MB" "$GTT_USED" "$GTT_MB" "$SCLK" "$MCLK" "$SMX" "$DB" "$CB")

# 🔥 Color warning logic
ICON="󰢮"
COLOR="#ebdbb2" # normal Gruvbox fg

if [[ "$TEMP_VAL" -gt 80 ]]; then
  COLOR="#fb4934"  # red
elif [[ "$TEMP_VAL" -gt 70 ]]; then
  COLOR="#fabd2f"  # yellow
fi

USAGE_INT=$(printf "%.0f" "$USAGE" 2>/dev/null)
if [[ "$USAGE_INT" -gt 95 ]]; then
  COLOR="#fb4934"  # red
elif [[ "$USAGE_INT" -gt 85 ]]; then
  COLOR="#fe8019"  # orange
fi

# Final JSON output
echo "{\"text\": \"$ICON ${USAGE}%  $TEMP_RAW\", \"tooltip\": \"${TOOLTIP//$'\n'/\\n}\", \"class\": \"gpu-group\", \"alt\": \"gpu\", \"percentage\": $USAGE_INT, \"color\": \"$COLOR\"}"

