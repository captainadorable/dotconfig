#!/bin/bash

state=$(cat /sys/class/power_supply/BAT0/status)
capacity=$(cat /sys/class/power_supply/BAT0/capacity)

# Remove any leading/trailing space and convert to int
capacity=${capacity//%/}

icon=""
base_class=""
level_class=""

# Main state class
case "$state" in
  "Charging")
    icon=""
    base_class="charging"
    ;;
  "Discharging")
    icon="󰁹"
    base_class="discharging"
      if [ "$capacity" -lt 20 ]; then
        level_class="low"
      elif [ "$capacity" -lt 40 ]; then
        level_class="medium-low"
      elif [ "$capacity" -lt 60 ]; then
        level_class="medium"
      else
        level_class="high"
      fi
    ;;
  "Not charging")
    icon=""
    base_class="not-charging"
    ;;
  "Full")
    icon=""
    base_class="full"
    ;;
  *)
    icon="󰂑"
    base_class="unknown"
    ;;
esac

# Add level class (based on percentage)

# Output JSON
printf '{"text": "%s %s", "class": ["%s", "%s"]}\n' "$icon" "$capacity" "$base_class" "$level_class"
