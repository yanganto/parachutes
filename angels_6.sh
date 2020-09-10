#!/usr/bin/env nu

# Setup script for window manager
format "===> Angels  6 - WM, IME{$(char newline)}"

sys | if $it.host.name == "Linux" {cp -r ./qtile ~/.config} {}

sys | if $it.host.name == "Linux" {mkdir ~/.config/fcitx} {}
sys | if $it.host.name == "Linux" {cp fcitx_config ~/.config/fcitx} {}
