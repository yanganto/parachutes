#!/usr/bin/env bash
set -e

# Setup script for window manager
echo "===> Angels  6 - WM, IME"
if command -v swaylock &> /dev/null; then
    echo "swaylock detected"
    ln -s `pwd`/swaylock ~/.config/
fi
if command -v fuzzel &> /dev/null; then
    echo "fuzzel detected"
    ln -s `pwd`/fuzzel ~/.config/
fi
if command -v waybar &> /dev/null; then
    echo "waybar detected"
    ln -s `pwd`/waybar ~/.config/
fi
if command -v niri &> /dev/null; then
    echo "niri detected"
    ln -s `pwd`/niri ~/.config/
    ln -s `pwd`/bar-rs ~/.config/
fi
if command -v qtile &> /dev/null; then
    echo "qtile detected"
    ln -s `pwd`/qtile ~/.config/
fi
if command -v leftwm &> /dev/null; then
    echo "leftwm detected"
    ln -s `pwd`/leftwm ~/.config/
    echo "leftwm > /tmp/leftwm.log 2> /tmp/leftwm.err.log" > ~/.xinitrc
fi

curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- array
curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- sdadonkey/rime-english
mkdir -p ~/.config/ibus/rime/
ln rime.default.yaml ~/.config/ibus/rime/default.yaml
mkdir -p ~/.config/fcitx5/rime/
ln rime.default.yaml ~/.config/fcitx5/rime/default.yaml
ln fcitx5_profile ~/.config/fcitx5/profile

mkdir -p ~/.config/rofi
ln config.rasi ~/.config/rofi/config.rasi
