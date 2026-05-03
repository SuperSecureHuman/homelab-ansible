#!/bin/bash

NODES=(
  "truenas   192.168.0.180"
  "node01    192.168.0.104"
  "node02    192.168.0.105"
  "pi-node01 192.168.0.201"
  "pi-node02 192.168.0.202"
  "pi-node03 192.168.0.203"
  "pi-node04 192.168.0.204"
)

declare -A PORT_LABELS=(
  [53]="dns"
  [5335]="unbound"
  [9617]="pihole-exporter"
  [25080]="pihole-web"
)

all_ok=true

for entry in "${NODES[@]}"; do
  name=$(echo "$entry" | awk '{print $1}')
  ip=$(echo "$entry" | awk '{print $2}')
  for port in "${!PORT_LABELS[@]}"; do
    label="${PORT_LABELS[$port]}"
    if nc -z -w 1 "$ip" "$port" 2>/dev/null; then
      echo "OCCUPIED  $name ($ip) :$port ($label)"
      all_ok=false
    else
      echo "FREE      $name ($ip) :$port ($label)"
    fi
  done
done

echo ""
$all_ok && echo "All ports free — good to deploy." || echo "Some ports are in use — check above."
