#!/bin/sh

iface=$(ip route get 1.1.1.1 2>/dev/null | awk '/dev/ {for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}')
ipaddr=$(ip route get 1.1.1.1 2>/dev/null | awk '/src/ {for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')

if echo "$iface" | grep -q '^wl'; then
  icon="󰤨 "
elif echo "$iface" | grep -q '^en'; then
  icon="󰀂 "
else
  icon="󰤮 "
fi

echo " $icon $ipaddr "

