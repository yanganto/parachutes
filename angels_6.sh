#!/usr/bin/env nu

let hostname = $(sys | get host.name)

# Setup script for window manager
format "===> Angels  6 - WM, IME{$(char newline)}"

sys | if $hostname != "Windows" && $hostname != "Darwin" {cp -r ./qtile ~/.config} {}

sys | if $hostname != "Windows" && $hostname != "Darwin" {mkdir ~/.config/fcitx} {}
sys | if $hostname != "Windows" && $hostname != "Darwin" {cp fcitx_config ~/.config/fcitx} {}

sys | if $hostname != "Windows" && $hostname != "Darwin" {mkdir ~/.config/rofi} {}
sys | if $hostname != "Windows" && $hostname != "Darwin" {cp config.rasi ~/.config/rofi/} {}
