#!/bin/bash

# Bluetooth device battery monitor for Waybar
# Monitors all connected Bluetooth devices (keyboard, mouse, etc.) via upower

# Check if upower is available
if ! command -v upower &>/dev/null; then
  exit 0
fi

# Get all Bluetooth device paths from upower (keyboard, mouse, headset, etc.)
bt_devices=$(upower -e | grep -E '(keyboard|mouse|headset|headphones)_dev_')

# Exit if no Bluetooth devices found
if [ -z "$bt_devices" ]; then
  exit 0
fi

# Arrays to store device info
device_texts=()
tooltip_lines=()

# Process each Bluetooth device
while IFS= read -r device_path; do
  # Get device info
  device_info=$(upower -i "$device_path" 2>/dev/null)

  # Skip if device info not available
  if [ -z "$device_info" ]; then
    continue
  fi

  # Extract device details
  model=$(echo "$device_info" | grep "model:" | awk -F': ' '{print $2}' | xargs)
  percentage=$(echo "$device_info" | grep "percentage:" | awk '{print $2}' | tr -d '%')
  device_type=$(echo "$device_path" | grep -oE '(keyboard|mouse|headset|headphones)')

  # Skip if no battery percentage
  if [ -z "$percentage" ]; then
    continue
  fi

  # Choose icon based on device type and battery level
  if [ "$device_type" = "keyboard" ]; then
    if [ "$percentage" -ge 80 ]; then
      icon="󰥻" # keyboard with full battery
    elif [ "$percentage" -ge 30 ]; then
      icon="󰥻" # keyboard
    else
      icon="󰥻" # keyboard (low)
    fi
  elif [ "$device_type" = "mouse" ]; then
    if [ "$percentage" -ge 80 ]; then
      icon="󰍽" # mouse with full battery
    elif [ "$percentage" -ge 30 ]; then
      icon="󰍽" # mouse
    else
      icon="󰍽" # mouse (low)
    fi
  elif [ "$device_type" = "headset" ] || [ "$device_type" = "headphones" ]; then
    icon="󰋋" # headphones
  else
    icon="󰂯" # generic Bluetooth
  fi

  # Determine battery icon
  if [ "$percentage" -ge 90 ]; then
    battery_icon="󰁹"
  elif [ "$percentage" -ge 70 ]; then
    battery_icon="󰂀"
  elif [ "$percentage" -ge 50 ]; then
    battery_icon="󰁾"
  elif [ "$percentage" -ge 30 ]; then
    battery_icon="󰁼"
  elif [ "$percentage" -ge 10 ]; then
    battery_icon="󰁺"
  else
    battery_icon="󰂃"
  fi

  # Determine color based on battery level
  if [ "$percentage" -le 25 ]; then
    color="#f38ba8" # critical - red
  elif [ "$percentage" -le 40 ]; then
    color="#f9e2af" # warning - yellow
  else
    color="#cdd6f4" # normal - foreground color
  fi

  # Build device text with color: "<span color='#xxx'>icon 100%</span>"
  device_texts+=("<span color='$color'>$icon ${percentage}%</span>")

  # Build tooltip line with full device name
  tooltip_lines+=("$icon $model: ${percentage}% $battery_icon")
done <<<"$bt_devices"

# Exit if no devices with battery info
if [ ${#device_texts[@]} -eq 0 ]; then
  exit 0
fi

# Join device texts with separator
text=$(
  IFS=" | "
  echo "${device_texts[*]}"
)

# Join tooltip lines with newline character
tooltip=""
for i in "${!tooltip_lines[@]}"; do
  if [ $i -eq 0 ]; then
    tooltip="${tooltip_lines[$i]}"
  else
    tooltip="${tooltip}
${tooltip_lines[$i]}"
  fi
done

# Output JSON for waybar using jq for proper escaping (compact output)
# Note: Colors are handled via Pango markup in the text itself
jq -nc \
  --arg text "$text" \
  --arg tooltip "$tooltip" \
  '{text: $text, tooltip: $tooltip}'
