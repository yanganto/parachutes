#!/usr/bin/env bash

set -euo pipefail
 
usage() {
  cat << 'EOF'
Usage:
  dump <WIFI_IFACE> <FILE>
 
Arguments:
  WIFI_IFACE      Wireless interface to use as the AP (e.g. wlan0)
  FILE            File to store
 
Example:
  dump wlan0 /tmp/dump.pcap
 
Requires: ip, tcpdump -- must be run as root.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || "$#" -eq 0 ]]; then
  usage
  exit 0
fi
 
if [[ "$#" -lt 2 ]]; then
  echo "Error: expected 2 arguments, got $#." >&2
  echo >&2
  usage >&2
  exit 1
fi

WIFI_IFACE=$1
FILE="$2"

targetIP=$(ip neigh show dev $1 | awk '{print $1}')

echo "Dump $targetIP from $1 to $2"
tcpdump -i $1 -n host $targetIP -w $2

