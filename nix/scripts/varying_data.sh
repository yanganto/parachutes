#!/usr/bin/env bash
set -euo pipefail
 
usage() {
  cat << 'EOF'
Usage:
  varying_data <IFACE> 
 
Arguments:
  IFACE      Network interface to apply
 
Example:
  varying_data wlan0
 
Requires: tc -- must be run as root.
EOF
}
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || "$#" -eq 0 ]]; then
  usage
  exit 0
fi
 
if [[ "$#" -lt 1 ]]; then
  echo "Error: expected 1 arguments, got $#." >&2
  echo >&2
  usage >&2
  exit 1
fi

IFACE=$1

cleanup() {
    echo
    echo -n "Cleaning up... "

    tc qdisc del dev $IFACE root 2>/dev/null

    echo "done"
}

trap cleanup EXIT INT TERM

RATES=("1mbit" "5mbit" "10mbit" "50mbit" "100mbit" "200mbit")

while true; do
  for rate in "${RATES[@]}"; do
    echo "Set rate: $rate on $IFACE"
    tc qdisc del dev $IFACE root 2>/dev/null
    tc qdisc add dev $IFACE root tbf rate $rate burst 32kbit latency 400ms
    sleep 10
  done
done

