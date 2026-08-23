#!/usr/bin/env bash
# simple scripts to publish Rust crates
# Requires: cargo

set -euo pipefail

usage() {
  cat << 'EOF'
Usage:
  publish-crate <TOKEN> <CRATE_NAME> [CRATE_NAME...]

Arguments:
  TOKEN         crates.io API token
  CRATE_NAME    one or more crate names to publish (published in order with 10s interval)

Example:
  publish-crate XXXXX my_crate
  publish-crate XXXXX crate_a crate_b crate_c

Requires: cargo
EOF
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

TOKEN="$1"
shift
CRATES=("$@")

cargo -V
cargo login "$TOKEN"

for i in "${!CRATES[@]}"; do
  CRATE="${CRATES[$i]}"
  echo "Publishing $CRATE..."
  cargo publish -p "$CRATE" || echo "publish $CRATE failed"
  if [[ $i -lt $(( ${#CRATES[@]} - 1 )) ]]; then
    echo "Waiting 10 seconds before next publish..."
    sleep 10
  fi
done
