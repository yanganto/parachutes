#!/usr/bin/env bash
set -e

# Setup script for window manager
echo "===> Angels  6 - WM, IME"
if command -v qtile &> /dev/null; then
    echo "qtile detected"
    cp -r ./qtile ~/.config
fi
if command -v leftwm &> /dev/null; then
    echo "leftwm detected"
    cp -r ./leftwm ~/.config
fi

curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- array
curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- sdadonkey/rime-english
cp rime.default.yaml ~/.config/ibus/rime/default.yaml

mkdir -p ~/.config/rofi
cp config.rasi ~/.config/rofi/
