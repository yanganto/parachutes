#!/usr/bin/env bash
set -e

# Setup script for window manager
echo "===> Angels  6 - WM, IME"
if command -v qtile &> /dev/null; then
    echo "qtile detected"
    ln -s ./qtile ~/.config/qtile
fi
if command -v leftwm &> /dev/null; then
    echo "leftwm detected"
    ln -s ./leftwm ~/.config/leftwm
fi

curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- array
curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- sdadonkey/rime-english
mkdir -p ~/.config/ibus/rime/
ln rime.default.yaml ~/.config/ibus/rime/default.yaml

mkdir -p ~/.config/rofi
ln config.rasi ~/.config/rofi/config.rasi
