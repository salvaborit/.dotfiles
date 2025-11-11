#!/bin/bash
[ -p /tmp/cava.fifo ] || mkfifo /tmp/cava.fifo
pkill -x cava 2>/dev/null
cava -p ~/.config/cava/config >/dev/null 2>&1 &
sleep 1
while IFS=';' read -r line; do
  [ -z "$line" ] && continue
  out=""
  for v in $(echo "$line" | tr ';' ' '); do
    ((v>7)) && v=7
    char=$(echo "▁▂▃▄▅▆▇█" | cut -c$((v+1)))
    out="${out}${char}"
  done
  echo "{\"text\": \"${out}\", \"class\": \"cava\"}"
done < /tmp/cava.fifo
