#!/usr/bin/env bash
set -euo pipefail
 
usage() {
  cat << 'EOF'
Usage:
  varying_mtu <IFACE> 
 
Arguments:
  IFACE      Network interface to apply
 
Example:
  varying_mtu wlan0
 
Requires: ip -- must be run as root.
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
ORIG_MTU=$(ip link show dev $IFACE | head -n 1 | awk '{print $5}')

cleanup() {
    echo
    echo -n "Cleaning up... "

    ip link set dev $IFACE mtu $ORIG_MTU

    echo "done"
}

trap cleanup EXIT INT TERM

MTU_VALUES=(350 600 800 1000 1200 1400 1500)

while true; do
  for mtu in "${MTU_VALUES[@]}"; do
    echo "Set MTU: $mtu on $IFACE"
    ip link set dev $IFACE mtu $mtu
    sleep 10
  done
done
